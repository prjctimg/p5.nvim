-- GitHub Gist integration for p5.nvim
local G = {}
local core = require("p5.core")
local notify = core.notify
if not core.is_cmd("gh") then
	notify("GitHub CLI (gh) not found", "warn")
	return nil
else
	-- Get files to include in gist from p5.json config
	G.includes = function(config)
		local includes = config.includes or { "sketch.js" }

		-- Filter out assets/ directory with warning and validate paths
		local filtered = {}
		for _, file in ipairs(includes) do
			-- Ensure file is a string
			if type(file) ~= "string" then
				notify("Skipping non-string include: " .. tostring(file), "warn")
			else
				-- Validate path for security (prevent path traversal)
				local is_unsafe = false

				-- Check for path traversal patterns
				local patterns = { "%z", "^[A-Za-z]:", "^~", "%.%.", "^/" }
				for _, p in pairs(patterns) do
					if file:match(p) then
						is_unsafe = true
						break
					end
				end
				if is_unsafe then
					notify("We skipped a sketchy looking path. Check your p5.json 🕵️ ")
				elseif file:match("^assets/") or file:match("^assets$") then
					core.notify("🗄️ assets/ directory excluded from gist (not needed for sketchspace)", "info")
				elseif file:match("^skchbk/") then
					core.notify("🗄️ skchbk/ directory excluded from gist", "info")
				else
					table.insert(filtered, file)
				end
			end
		end

		-- Always include p5.json
		table.insert(filtered, "p5.json")

		return filtered
	end

	-- Create gist from current project
	G.create = function(description)
		local project_dir, config = core.find_project_root()
		if not config then
			notify(
				"We're not in a sketchspace (a directory with a p5.json file)\nRun `:P5 list` to see recent sketchspaces",
				"info"
			)
			return
		end
		local files = G.includes(config)
		local missing = {}
		for _, file_name in ipairs(files) do
			if not core.is_file(project_dir .. "/" .. file_name) then
				table.insert(missing, file_name)
			end
		end

		if #missing > 0 then
			core.notify(
				"It looks like these files are missing: "
					.. table.concat(missing, ", ")
					.. "\nCheck your sketchspace to ensure they exist.",
				"info"
			)
			return
		end

		local function proceed(desc, proj_dir, proj_config)
			local temp_files = {}
			local gist_files = {}

			local gist_temp_dir = vim.fn.stdpath("cache") or (vim.uv.os_tmpdir()) .. "/p5_gist"
			core.mkdir(gist_temp_dir)

			local dir = gist_temp_dir .. "/" .. os.time() .. "_" .. vim.fn.getpid()
			core.mkdir(dir)

			for _, file_name in ipairs(files) do
				local target_path = dir .. "/" .. file_name
				local source_path = vim.fn.fnamemodify(proj_dir .. "/" .. file_name, ":p")

				local parent_dir = vim.fn.fnamemodify(target_path, ":h")
				if parent_dir ~= dir then
					core.mkdir(parent_dir)
				end

				vim.fn.system({ "cp", source_path, target_path })
				if vim.v.shell_error ~= 0 then
					core.notify("Failed to copy file: " .. file_name, "warn")
					vim.fn.delete(dir, "rf")
					return
				end

				table.insert(temp_files, target_path)
				table.insert(gist_files, target_path)
			end

			local cmd = { "gh", "gist", "create", "--public", "--desc" }

			if desc ~= "" then
				table.insert(cmd, desc)

				for _, file_path in ipairs(gist_files) do
					table.insert(cmd, file_path)
				end

				vim.system(cmd, function(out)
					local result = out.stdout
					if out.code == 0 and result ~= nil then
						vim.fn.delete(dir, "rf")

						local url_full = result:match("https://gist%.github%.com/%S+")

						if url_full then
							local url = url_full:match("gist%.github%.com/(.+)")
							local gist_id = url_full:match("/([a-fA-F0-9]+)$")
							if gist_id then
								local title_res = vim.fn.system({ "gh", "api", "/gists/" .. gist_id, "--jq", ".description" })
								local title = vim.v.shell_error == 0 and vim.trim(title_res) or desc
								local cm = G.get_comment(gist_id)
								local description = cm and cm.body or ""
								proj_config.gist = {
									url = url,
									title = title,
									description = description,
								}
								core.write_workspace_config(proj_config, proj_dir)

								local p5_json_path = proj_dir .. "/p5.json"
								vim.system({ "gh", "gist", "edit", gist_id, "--filename", "p5.json", p5_json_path }, function(res)
									if res.code == 0 then
										core.notify("🎊 Sketchspace uploaded!", "ok")
									end
								end)
							end
						end
					else
						core.notify("Something went wrong, run :checkhealth p5.nvim to find the problem.", "warn")
					end
				end)
			else
				core.notify("A sketchspace needs a description to be created.", "warn")
				return
			end
		end

		-- If description provided, proceed directly
		if description ~= "" then
			proceed(description, project_dir, config)
		else
			-- Prompt for description
			vim.ui.input({
				prompt = "What do you call this (master)piece ?",
				default = "sketch from " .. (config.name or "sketchspace"),
				completion = "file",
			}, function(input)
				if input and input ~= "" then
					proceed(input, project_dir, config)
				else
					core.notify("Gist creation cancelled", "info")
				end
			end)
		end
	end

	-- Get current gist info from project
	G.current = function()
		local _, config = core.find_project_root()
		if not config or not config.gist then
			return nil
		end

		local g = config.gist
		local url, title, description

		if type(g) == "table" then
			url = g.url or g.id
			title = g.title
			description = g.description
		else
			url = g
		end

		if not url then
			return nil
		end

		local id
		if url:match("gist.github.com/") then
			id = url:match("gist.github.com/[^/]+/([a-fA-F0-9]+)$")
			if not id then
				id = url:match("gist.github.com/([a-fA-F0-9]+)$")
			end
		else
			id = url:match("/([a-fA-F0-9]+)$") or url
		end

		return {
			id = id,
			url = url,
			title = title or "",
			description = description or "",
		}
	end

	-- Sync gist: compare remote with local, prompt per difference, apply
	G.sync = function()
		local gist_info = G.current()
		if not gist_info or not gist_info.id then
			notify("🤦 No gist associated with current sketchspace", "warn")
			return
		end
		local project_dir, cfg = core.find_project_root()
		if not cfg then
			core.notify("Not in a sketchspace", "warn")
			return
		end

		local res = vim.fn.system({ "gh", "api", "/gists/" .. gist_info.id })
		if vim.v.shell_error ~= 0 then
			notify("Failed to fetch remote gist", "warn")
			return
		end
		local ok, remote = pcall(vim.fn.json_decode, res)
		if not ok or not remote then
			notify("Failed to parse remote gist data", "warn")
			return
		end

		local cm = G.get_comment(gist_info.id)
		local remote_title = remote.description or ""
		local remote_desc = cm and cm.body or ""
		local remote_files = remote.files or {}
		local local_title = gist_info.title or ""
		local local_desc = gist_info.description or ""

		-- Build diff list
		local diffs = {}
		if local_title ~= remote_title then
			table.insert(diffs, { type = "title", local_val = local_title, remote_val = remote_title })
		end
		if local_desc ~= remote_desc then
			table.insert(diffs, { type = "desc", local_val = local_desc, remote_val = remote_desc })
		end
		for _, fn in ipairs(G.includes(cfg)) do
			if fn ~= "p5.json" then
				local local_path = project_dir .. "/" .. fn
				local rf = remote_files[fn]
				local has_local = core.is_file(local_path)
				local has_remote = rf ~= nil
				if has_local and has_remote then
					local local_content = table.concat(vim.fn.readfile(local_path) or {}, "\n")
					if local_content ~= (rf.content or "") then
						table.insert(diffs, { type = "file", name = fn, has_local = true, has_remote = true })
					end
				elseif has_local and not has_remote then
					table.insert(diffs, { type = "file", name = fn, has_local = true, has_remote = false })
				elseif has_remote and not has_local then
					table.insert(diffs, { type = "file", name = fn, has_local = false, has_remote = true })
				end
			end
		end

		if #diffs == 0 then
			notify("Gist is up to date", "ok")
			return
		end

		-- Build summary for single prompt
		local summary_parts = {}
		local auto_push, auto_pull = {}, {}
		for _, d in ipairs(diffs) do
			if d.type == "file" and not (d.has_local and d.has_remote) then
				if d.has_local then table.insert(auto_push, d.name) end
				if d.has_remote then table.insert(auto_pull, d.name) end
			else
				table.insert(summary_parts, d.type == "title" and "title" or d.type == "desc" and "description"
					or d.name)
			end
		end
		local summary = table.concat(summary_parts, ", ")

		local function apply(dir)
			local use_remote = dir == "remote"
			local gist_obj = {
				url = gist_info.url,
				title = use_remote and remote_title or local_title,
				description = use_remote and remote_desc or local_desc,
			}
			cfg.gist = gist_obj
			core.write_workspace_config(cfg, project_dir)

			local temp_base = vim.fn.stdpath("cache") or (vim.uv.os_tmpdir() or "/tmp")
			local gist_temp_dir = temp_base .. "/p5_gist_sync"
			core.mkdir(gist_temp_dir)
			local errors = {}

			-- Pull remote files (when direction is remote, or auto-pull)
			local pull_list = use_remote and vim.tbl_map(function(d) return d.name end, vim.tbl_filter(function(d)
				return d.type == "file" and d.has_remote
			end, diffs)) or auto_pull
			for _, fn in ipairs(pull_list) do
				local rf = remote_files[fn]
				if rf then
					vim.fn.writefile(vim.split(rf.content or "", "\n"), project_dir .. "/" .. fn)
				end
			end

			-- Upload files to remote gist
			local push_list = (not use_remote) and vim.tbl_map(function(d) return d.name end, vim.tbl_filter(function(d)
				return d.type == "file" and d.has_local
			end, diffs)) or auto_push

			local function upload_file(fns, uidx)
				if uidx > #fns then
					vim.system({ "gh", "gist", "edit", gist_info.id, "--filename", "p5.json", project_dir .. "/p5.json" }, function(_)
						if #errors > 0 then
							core.notify("Sync completed with errors: " .. table.concat(errors, ", "), "warn")
						else
							core.notify("Gist synced successfully", "ok")
						end
					end)
					return
				end
				local fn = fns[uidx]
				local temp_file = gist_temp_dir .. "/" .. os.time() .. "_" .. vim.fn.fnamemodify(fn, ":t")
				vim.fn.system({ "cp", project_dir .. "/" .. fn, temp_file })
				vim.system({ "gh", "gist", "edit", gist_info.id, "--filename", fn, temp_file }, function(uout)
					if uout.code ~= 0 then
						table.insert(errors, "Failed to upload: " .. fn)
					end
					vim.fn.delete(temp_file)
					upload_file(fns, uidx + 1)
				end)
			end
			upload_file(push_list, 1)

			-- Update title on remote
			if not use_remote then
				vim.fn.system({ "gh", "gist", "edit", gist_info.id, "--desc", gist_obj.title })
			end

			-- Update description comment on remote
			if not use_remote then
				if cm then
					G.update_comment(gist_info.id, cm.id, gist_obj.description)
				elseif gist_obj.description ~= "" then
					G.create_comment(gist_info.id, gist_obj.description)
				end
			end
		end

		-- Single batch prompt
		local label = "Gist sync — " .. #diffs .. " difference" .. (#diffs > 1 and "s" or "")
			.. (#summary_parts > 0 and (": " .. summary) or "")
		vim.ui.select({ "Apply all remote changes", "Apply all local changes", "Skip all" }, {
			prompt = label,
		}, function(choice)
			if not choice or choice == "Skip all" then
				notify("Gist sync cancelled", "info")
				return
			end
			apply(choice:match("remote") and "remote" or "local")
		end)
	end

	-- List gists for a user
	local list_user_gists = function(username)
		local res = vim.fn.system({ "gh", "api", "/users/" .. username .. "/gists", "--paginate" })
		if vim.v.shell_error ~= 0 then
			notify("Failed to list gists for user: " .. username, "warn")
			return nil
		end
		local ok, gists = pcall(vim.fn.json_decode, res)
		if not ok or type(gists) ~= "table" then
			notify("Failed to parse gist list", "warn")
			return nil
		end
		return gists
	end

	-- Clone a single gist by ID to a target directory
	local clone_gist = function(id, target, gist_title)
		local res = vim.fn.system({ "gh", "api", "/gists/" .. id })
		if vim.v.shell_error ~= 0 then return false end
		local ok, gd = pcall(vim.fn.json_decode, res)
		if not ok or not gd.files then return false end
		core.mkdir(target)
		for fn, fd in pairs(gd.files) do
			vim.fn.writefile(vim.split(fd.content or "", "\n"), target .. "/" .. fn)
		end
		local cm = G.get_comment(id)
		local desc = cm and cm.body or ""
		if desc ~= "" then
			vim.fn.writefile(vim.split(desc, "\n"), target .. "/README.md")
		end
		-- Write gist metadata into p5.json
		local p5_path = target .. "/p5.json"
		if core.is_file(p5_path) then
			local p5_data, _ = core.read_json(p5_path)
			if p5_data then
				local owner = gd.owner and gd.owner.login or "unknown"
				p5_data.gist = {
					url = owner .. "/" .. id,
					title = gist_title or "",
					description = desc,
				}
				core.write_json(p5_path, p5_data)
			end
		end
		return true
	end

	-- Clone gists into sketchbook directory
	G.clone = function(username, skchbk_dir, mode)
		local gists = list_user_gists(username)
		if not gists then return end

		if #gists == 0 then
			notify("No gists found for user: " .. username, "info")
			return
		end

		if mode == "all" then
			core.mkdir(skchbk_dir)
			local cloned, skipped, errors = 0, 0, 0
			for _, gist in ipairs(gists) do
				local slug = core.slugify(gist.description or gist.id)
				local target = skchbk_dir .. "/" .. slug
				if core.is_dir(target) then
					skipped = skipped + 1
				elseif clone_gist(gist.id, target, gist.description) then
					cloned = cloned + 1
				else
					errors = errors + 1
				end
			end
			local msg = {}
			if cloned > 0 then table.insert(msg, "Cloned: " .. cloned) end
			if skipped > 0 then table.insert(msg, "Skipped: " .. skipped) end
			if errors > 0 then table.insert(msg, "Errors: " .. errors) end
			if #msg > 0 then notify(table.concat(msg, " | "), "info") end
		else
			local items, map, desc_map = {}, {}, {}
			for _, gist in ipairs(gists) do
				local label = gist.description or ("untitled-" .. gist.id:sub(1, 7))
				table.insert(items, label)
				map[label] = gist.id
				desc_map[label] = gist.description
			end
			table.sort(items)

			vim.ui.select(items, { prompt = "Select a remote sketch to clone:" }, function(sel)
				if not sel or not map[sel] then return end
				core.mkdir(skchbk_dir)
				local slug = core.slugify(sel)
				local target = skchbk_dir .. "/" .. slug
				if clone_gist(map[sel], target, desc_map[sel]) then
					notify("Cloned: " .. sel, "ok")
					vim.api.nvim_set_current_dir(target)
					if core.is_file(target .. "/sketch.js") then vim.cmd("edit sketch.js") end
				else
					notify("Failed to clone: " .. sel, "warn")
				end
			end)
		end
	end

	-- Fetch the first comment body for a gist
	G.get_comment = function(gist_id)
		local res = vim.fn.system({ "gh", "api", "/gists/" .. gist_id .. "/comments" })
		if vim.v.shell_error ~= 0 then
			return nil
		end
		local ok, comments = pcall(vim.fn.json_decode, res)
		if not ok or type(comments) ~= "table" or #comments == 0 then
			return nil
		end
		return comments[1]
	end

	-- Create a new comment on a gist
	G.create_comment = function(gist_id, body)
		local tmp = vim.fn.stdpath("cache") .. "/p5_gist_comment_" .. os.time()
		vim.fn.writefile(vim.split(body, "\n"), tmp)
		local res =
			vim.fn.system({ "gh", "api", "/gists/" .. gist_id .. "/comments", "--input", tmp, "-f", "body=" .. body })
		vim.fn.delete(tmp)
		return vim.v.shell_error == 0, res
	end

	-- Update an existing comment on a gist
	G.update_comment = function(gist_id, comment_id, body)
		local res = vim.fn.system({
			"gh",
			"api",
			"/gists/" .. gist_id .. "/comments/" .. comment_id,
			"-X",
			"PATCH",
			"-f",
			"body=" .. body,
		})
		return vim.v.shell_error == 0, res
	end

	-- Edit gist description or first comment
	G.edit = function()
		local gist_info = G.current()
		if not gist_info or not gist_info.id then
			notify("No gist associated with current sketchspace", "warn")
			return
		end

		local items = { "Description", "First comment (sketch details)" }
		vim.ui.select(items, { prompt = "What to edit on the gist?" }, function(choice)
			if not choice then
				return
			end

			if choice == "Description" then
				local res = vim.fn.system({ "gh", "api", "/gists/" .. gist_info.id, "--jq", ".description" })
				local current = vim.v.shell_error == 0 and vim.trim(res) or ""
				vim.ui.input({ prompt = "New description: ", default = current or "" }, function(input)
					if not input or input == "" then
						notify("Edit cancelled", "info")
						return
					end
					vim.fn.system({ "gh", "gist", "edit", gist_info.id, "--desc", input })
					if vim.v.shell_error == 0 then
						local _, cfg = core.find_project_root()
						if cfg then
							local g = type(cfg.gist) == "table" and cfg.gist or { url = cfg.gist }
							g.title = input
							cfg.gist = g
							core.write_workspace_config(cfg)
						end
						notify("Description updated", "ok")
					else
						notify("Failed to update description", "warn")
					end
				end)
			elseif choice == "First comment (sketch details)" then
				local comment = G.get_comment(gist_info.id)
				local body = comment and comment.body or ""
				local comment_id = comment and comment.id or nil

				-- Open a scratch buffer for editing
				local buf = vim.api.nvim_create_buf(false, true)
				vim.api.nvim_buf_set_option(buf, "buftype", "acwrite")
				vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
				vim.api.nvim_buf_set_name(buf, "gist-comment.md")

				local lines = vim.split(body, "\n")
				vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

				vim.api.nvim_create_autocmd("BufWriteCmd", {
					buffer = buf,
					once = true,
					callback = function()
						local new_body = table.concat(vim.api.nvim_buf_get_lines(buf, 0, -1), "\n")
						local api_ok
						if comment_id then
							api_ok = G.update_comment(gist_info.id, comment_id, new_body)
						else
							api_ok = G.create_comment(gist_info.id, new_body)
						end
						if api_ok then
							local _, cfg = core.find_project_root()
							if cfg then
								local g = type(cfg.gist) == "table" and cfg.gist or { url = cfg.gist }
								g.description = new_body
								cfg.gist = g
								core.write_workspace_config(cfg)
							end
							notify("Sketch details " .. (comment_id and "updated" or "created"), "ok")
						else
							notify("Failed to update sketch details", "warn")
							return
						end
						vim.api.nvim_buf_set_option(buf, "modified", false)
					end,
				})

				vim.api.nvim_win_set_buf(0, buf)
				vim.api.nvim_buf_set_option(buf, "modified", false)
				notify("Edit the comment and :w to save", "info")
			end
		end)
	end

	-- List local skchbk entries or offer remote browse
	G.skchbk_list = function(username, skchbk_dir)
		local prompt_action = function()
			vim.ui.select({ "Clone all gists", "Pick a gist to clone" }, {
				prompt = "No local sketches found. What would you like to do?",
			}, function(choice)
				if choice == "Clone all gists" then
					G.clone(username, skchbk_dir, "all")
				elseif choice == "Pick a gist to clone" then
					G.clone(username, skchbk_dir)
				end
			end)
		end

		local has_local = false
		local entries = {}
		if core.is_dir(skchbk_dir) then
			for entry, type in vim.fs.dir(skchbk_dir) do
				if type == "directory" then
					has_local = true
					table.insert(entries, {
						display = core.deslugify(entry),
						path = skchbk_dir .. "/" .. entry,
					})
				end
			end
		end

		if not has_local then
			prompt_action()
			return
		end

		table.sort(entries, function(a, b)
			return a.display < b.display
		end)
		local items = vim.tbl_map(function(e)
			return e.display
		end, entries)
		local item_map = {}
		for _, e in ipairs(entries) do
			item_map[e.display] = e.path
		end

		vim.ui.select(items, { prompt = "Select a sketch:" }, function(sel)
			if not sel or not item_map[sel] then
				return
			end
			vim.api.nvim_set_current_dir(item_map[sel])
			if core.is_file(item_map[sel] .. "/sketch.js") then
				vim.cmd("edit sketch.js")
			end
		end)
	end

	-- Download gist files to current project
	G.fetch = function(id, project)
		project = vim.fs.normalize(project or vim.fn.getcwd())

		if not id then
			return false, "👀 No gist ID provided"
		end

		-- Get gist files in JSON format
		local result = vim.fn.system({ "gh", "api", "/gists/" .. id })

		if vim.v.shell_error ~= 0 then
			return false, "Gist not found or no longer exists: " .. result
		end

		-- Parse JSON response
		local ok, gist = pcall(vim.fn.json_decode, result)
		if not ok or not gist.files then
			return false, "Failed to parse gist data"
		end

		local files = gist.files
		local downloaded = {}
		local skipped = {}

		for filename, filedata in pairs(files) do
			local target_path = project .. "/" .. filename

			if core.is_file(target_path) then
				table.insert(skipped, filename)
			else
				local content = filedata.content or ""
				vim.fn.writefile(vim.split(content, "\n"), target_path)
				table.insert(downloaded, filename)
			end
		end

		local msg = {}
		if #downloaded > 0 then
			table.insert(msg, "Downloaded: " .. table.concat(downloaded, ", "))
		end
		if #skipped > 0 then
			table.insert(msg, "Skipped (exists): " .. table.concat(skipped, ", "))
		end

		if #msg > 0 then
			notify(table.concat(msg, " | "), "info")
		end

		return true, nil
	end
end
return G
