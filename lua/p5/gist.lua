-- GitHub Gist integration for p5.nvim
local G = {}
local core = require("p5.core")
local notify = core.notify

local function step_runner(steps)
	local i = 1
	local function next()
		if i <= #steps then
			local s = steps[i]
			i = i + 1
			s(next)
		end
	end
	next()
end

if not core.is_cmd("gh") then
	notify("GitHub CLI (gh) not found", "warn")
	return nil
else
	G.includes = function(config)
		local includes = config.includes or { "sketch.js" }

		local filtered = {}
		for _, file in ipairs(includes) do
			if type(file) ~= "string" then
				notify("Skipping non-string include: " .. tostring(file), "warn")
			else
				local is_unsafe = false

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

		table.insert(filtered, "p5.json")

		return filtered
	end

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
			local gist_temp_dir = (vim.fn.stdpath("cache") or vim.uv.os_tmpdir()) .. "/p5_gist"
			core.mkdir(gist_temp_dir)

			local dir = gist_temp_dir .. "/" .. os.time() .. "_" .. vim.fn.getpid()
			core.mkdir(dir)

			local gist_files = {}
			local gist_id, gist_url

			local steps = {
				function(next_step)
					local pending = #files
					local had_error = false
					for _, file_name in ipairs(files) do
						local target_path = dir .. "/" .. file_name
						local source_path = vim.fn.fnamemodify(proj_dir .. "/" .. file_name, ":p")

						local parent_dir = vim.fn.fnamemodify(target_path, ":h")
						if parent_dir ~= dir then
							core.mkdir(parent_dir)
						end

						vim.system({ "cp", source_path, target_path }, nil, function(out)
							pending = pending - 1
							if out.code ~= 0 and not had_error then
								had_error = true
								core.notify("Failed to copy file: " .. file_name, "warn")
								core.rmtree(dir)
							elseif out.code == 0 then
								table.insert(gist_files, target_path)
							end
							if pending == 0 then
								next_step()
							end
						end)
					end
				end,
				function(next_step)
					local cmd = { "gh", "gist", "create", "--public", "--desc", desc }
					for _, file_path in ipairs(gist_files) do
						table.insert(cmd, file_path)
					end

					vim.system(cmd, nil, function(out)
						if out.code ~= 0 then
							core.rmtree(dir)
							core.notify("Gist creation failed. Run :checkhealth p5.nvim to find the problem.", "warn")
							return next_step()
						end
						core.rmtree(dir)
						local url_full = out.stdout:match("https://gist%.github%.com/%S+")
						if not url_full then
							core.notify("Gist created but could not parse URL. Check your gist list on GitHub.", "warn")
							return next_step()
						end
						gist_url = url_full:match("gist%.github%.com/(.+)")
						gist_id = url_full:match("/([a-fA-F0-9]+)$")
						if not gist_id then
							core.notify("Gist created but could not extract ID. Check your gist list on GitHub.", "warn")
							return next_step()
						end
						next_step()
					end)
				end,
				function(next_step)
					vim.system({ "gh", "api", "/gists/" .. gist_id, "--jq", ".description" }, nil, function(out)
						local title = out.code == 0 and vim.trim(out.stdout) or desc
						G.get_comment(gist_id, function(cm)
							local description = cm and cm.body or ""
							proj_config.gist = {
								url = gist_url,
								title = title,
								description = description,
							}
							core.write_workspace_config(proj_config, proj_dir)

							local p5_json_path = proj_dir .. "/p5.json"
							vim.system({ "gh", "gist", "edit", gist_id, "--filename", "p5.json", p5_json_path }, nil, function(_)
								next_step()
							end)
						end)
					end)
				end,
			}
			step_runner(steps)
		end

		if description ~= "" then
			proceed(description, project_dir, config)
		else
			vim.ui.input({
				prompt = "What do you call this (master)piece ?",
				default = "sketchspace",
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

		local remote_title, remote_desc, remote_files, cm
		local diffs, auto_push, auto_pull, use_remote, local_title, local_desc
		local gist_obj, sync_errors, sync_temp_dir

		local steps = {
			function(next_step)
				vim.system({ "gh", "api", "/gists/" .. gist_info.id }, nil, function(out)
					if out.code ~= 0 then
						notify("Failed to fetch remote gist", "warn")
						return next_step()
					end
					local ok, parsed = pcall(vim.json.decode, out.stdout)
					if not ok or not parsed then
						notify("Failed to parse remote gist data", "warn")
						return next_step()
					end
					remote_title = parsed.description or ""
					remote_files = parsed.files or {}
					next_step()
				end)
			end,
			function(next_step)
				G.get_comment(gist_info.id, function(c)
					cm = c
					remote_desc = cm and cm.body or ""
					next_step()
				end)
			end,
			function(next_step)
				local_title = gist_info.title or ""
				local_desc = gist_info.description or ""

				diffs = {}
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
					return next_step()
				end

				local summary_parts = {}
				auto_push, auto_pull = {}, {}
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

				local label = "Gist sync — " .. #diffs .. " difference" .. (#diffs > 1 and "s" or "")
					.. (#summary_parts > 0 and (": " .. summary) or "")
				vim.ui.select({ "Apply all remote changes", "Apply all local changes", "Skip all" }, {
					prompt = label,
				}, function(choice)
					if not choice or choice == "Skip all" then
						notify("Gist sync cancelled", "info")
						return next_step()
					end
					use_remote = choice:match("remote") and true or false
					next_step()
				end)
			end,
			function(next_step)
				gist_obj = {
					url = gist_info.url,
					title = use_remote and remote_title or local_title,
					description = use_remote and remote_desc or local_desc,
				}
				cfg.gist = gist_obj
				core.write_workspace_config(cfg, project_dir)

				local temp_base = vim.fn.stdpath("cache") or (vim.uv.os_tmpdir() or "/tmp")
				sync_temp_dir = temp_base .. "/p5_gist_sync"
				core.mkdir(sync_temp_dir)
				sync_errors = {}

				local pull_list = use_remote and vim.tbl_map(function(d) return d.name end, vim.tbl_filter(function(d)
					return d.type == "file" and d.has_remote
				end, diffs)) or auto_pull

				for _, fn in ipairs(pull_list) do
					local rf = remote_files[fn]
					if rf then
						vim.fn.writefile(vim.split(rf.content or "", "\n"), project_dir .. "/" .. fn)
					end
				end

				local push_list = (not use_remote) and vim.tbl_map(function(d) return d.name end, vim.tbl_filter(function(d)
					return d.type == "file" and d.has_local
				end, diffs)) or auto_push

				if #push_list == 0 then
					next_step()
					return
				end

				local push_pending = #push_list
				for _, fn in ipairs(push_list) do
					local temp_file = sync_temp_dir .. "/" .. os.time() .. "_" .. vim.fn.fnamemodify(fn, ":t")
					vim.system({ "cp", project_dir .. "/" .. fn, temp_file }, nil, function()
						vim.system({ "gh", "gist", "edit", gist_info.id, "--filename", fn, temp_file }, nil, function(uout)
							push_pending = push_pending - 1
							if uout.code ~= 0 then
								table.insert(sync_errors, "Failed to upload: " .. fn)
							end
							vim.uv.fs_unlink(temp_file)
							if push_pending == 0 then
								next_step()
							end
						end)
					end)
				end
			end,
			function(next_step)
				if not use_remote then
					vim.system({ "gh", "gist", "edit", gist_info.id, "--filename", "p5.json", project_dir .. "/p5.json" }, nil, function()
						vim.system({ "gh", "api", "-X", "PATCH", "/gists/" .. gist_info.id, "-f", "description=" .. gist_obj.title }, nil, function()
							next_step()
						end)
					end)
				else
					next_step()
				end
			end,
			function(next_step)
				cm = cm or {}
				local function on_done()
					if #sync_errors > 0 then
						core.notify("Sync completed with errors: " .. table.concat(sync_errors, ", "), "warn")
					else
						core.notify("Gist synced successfully", "ok")
					end
					next_step()
				end
				if cm.id then
					G.update_comment(gist_info.id, cm.id, gist_obj.description, on_done)
				elseif gist_obj.description ~= "" then
					G.create_comment(gist_info.id, gist_obj.description, on_done)
				else
					on_done()
				end
			end,
		}

		step_runner(steps)
	end

	local list_user_gists = function(username, callback)
		vim.system({ "gh", "api", "/users/" .. username .. "/gists", "--paginate" }, nil, function(out)
			if out.code ~= 0 then
				notify("Failed to list gists for user: " .. username, "warn")
				callback(nil)
				return
			end
			local ok, gists = pcall(vim.json.decode, out.stdout)
			if not ok or type(gists) ~= "table" then
				notify("Failed to parse gist list", "warn")
				callback(nil)
				return
			end
			callback(gists)
		end)
	end

	local clone_gist = function(id, target, gist_title, callback)
		vim.system({ "gh", "api", "/gists/" .. id }, nil, function(out)
			if out.code ~= 0 then
				callback(false)
				return
			end
			local ok, gd = pcall(vim.json.decode, out.stdout)
			if not ok or not gd.files then
				callback(false)
				return
			end
			core.mkdir(target)
			for fn, fd in pairs(gd.files) do
				local fp = io.open(target .. "/" .. fn, "w")
				if fp then fp:write(fd.content or ""); fp:close() end
			end
			G.get_comment(id, function(cm)
				local desc = cm and cm.body or ""
				if desc ~= "" then
					local fp = io.open(target .. "/README.md", "w")
					if fp then fp:write(desc); fp:close() end
				end
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
				callback(true)
			end)
		end)
	end

	G.clone = function(username, skchbk_dir, mode)
		list_user_gists(username, function(gists)
			if not gists then return end

			if #gists == 0 then
				notify("No gists found for user: " .. username, "info")
				return
			end

			if mode == "all" then
				core.mkdir(skchbk_dir)
				local results = { cloned = 0, skipped = 0, errors = 0 }
				local pending = #gists
				if pending == 0 then return end
				for _, gist in ipairs(gists) do
					local slug = core.slugify(gist.description or gist.id)
					local target = skchbk_dir .. "/" .. slug
					if core.is_dir(target) then
						results.skipped = results.skipped + 1
						pending = pending - 1
						if pending == 0 then
							notify("Cloned: " .. results.cloned .. " | Skipped: " .. results.skipped .. " | Errors: " .. results.errors, "info")
						end
					else
						clone_gist(gist.id, target, gist.description, function(ok)
							pending = pending - 1
							if ok then
								results.cloned = results.cloned + 1
							else
								results.errors = results.errors + 1
							end
							if pending == 0 then
								local msg = {}
								if results.cloned > 0 then table.insert(msg, "Cloned: " .. results.cloned) end
								if results.skipped > 0 then table.insert(msg, "Skipped: " .. results.skipped) end
								if results.errors > 0 then table.insert(msg, "Errors: " .. results.errors) end
								if #msg > 0 then notify(table.concat(msg, " | "), "info") end
							end
						end)
					end
				end
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
					clone_gist(map[sel], target, desc_map[sel], function(ok)
						if ok then
							notify("Cloned: " .. sel, "ok")
							vim.api.nvim_set_current_dir(target)
							if core.is_file(target .. "/sketch.js") then vim.cmd("edit sketch.js") end
						else
							notify("Failed to clone: " .. sel, "warn")
						end
					end)
				end)
			end
		end)
	end

	G.get_comment = function(gist_id, callback)
		callback = callback or function() end
		vim.system({ "gh", "api", "/gists/" .. gist_id .. "/comments" }, nil, function(out)
			if out.code ~= 0 then
				callback(nil)
				return
			end
			local ok, comments = pcall(vim.json.decode, out.stdout)
			if not ok or type(comments) ~= "table" or #comments == 0 then
				callback(nil)
				return
			end
			callback(comments[1])
		end)
	end

	G.create_comment = function(gist_id, body, callback)
		callback = callback or function() end
		local tmp = vim.fn.stdpath("cache") .. "/p5_gist_comment_" .. os.time()
		local json_body = vim.fn.json_encode({ body = body })
		vim.fn.writefile(vim.split(json_body, "\n"), tmp)
		vim.system({ "gh", "api", "/gists/" .. gist_id .. "/comments", "--input", tmp }, nil, function(out)
			vim.uv.fs_unlink(tmp)
			callback(out.code == 0, out.stdout)
		end)
	end

	G.update_comment = function(gist_id, comment_id, body, callback)
		callback = callback or function() end
		local tmp = vim.fn.stdpath("cache") .. "/p5_gist_comment_upd_" .. os.time()
		local json_body = vim.fn.json_encode({ body = body })
		vim.fn.writefile(vim.split(json_body, "\n"), tmp)
		vim.system({
			"gh", "api",
			"/gists/" .. gist_id .. "/comments/" .. comment_id,
			"-X", "PATCH", "--input", tmp,
		}, nil, function(out)
			vim.uv.fs_unlink(tmp)
			callback(out.code == 0, out.stdout)
		end)
	end

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
				vim.system({ "gh", "api", "/gists/" .. gist_info.id, "--jq", ".description" }, nil, function(out)
					local current = out.code == 0 and vim.trim(out.stdout) or ""
					vim.ui.input({ prompt = "New description: ", default = current or "" }, function(input)
						if not input or input == "" then
							notify("Edit cancelled", "info")
							return
						end
						vim.system({ "gh", "api", "-X", "PATCH", "/gists/" .. gist_info.id, "-f", "description=" .. input }, nil, function(out2)
							if out2.code == 0 then
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
					end)
				end)
			elseif choice == "First comment (sketch details)" then
				G.get_comment(gist_info.id, function(comment)
					local body = comment and comment.body or ""
					local comment_id = comment and comment.id or nil

					local buf = vim.api.nvim_create_buf(false, true)
					vim.api.nvim_buf_set_option(buf, "buftype", "acwrite")
					vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
					vim.api.nvim_buf_set_name(buf, "gist-comment.md")

					local lines = vim.split(body, "\n")
					vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

		vim.api.nvim_create_autocmd("BufWriteCmd", {
					buffer = buf,
					callback = function()
						local new_body = table.concat(vim.api.nvim_buf_get_lines(buf, 0, -1), "\n")
						vim.api.nvim_buf_set_option(buf, "modified", false)
						local function on_done(api_ok)
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
								end
							end
							if comment_id then
								G.update_comment(gist_info.id, comment_id, new_body, on_done)
							else
								G.create_comment(gist_info.id, new_body, on_done)
							end
						end,
					})

					vim.api.nvim_win_set_buf(0, buf)
					vim.api.nvim_buf_set_option(buf, "modified", false)
					notify("Edit the comment and :w to save", "info")
				end)
			end
		end)
	end

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

	G.fetch = function(id, project, callback)
		callback = callback or function() end
		project = vim.fs.normalize(project or vim.fn.getcwd())

		if not id then
			callback(false, "👀 No gist ID provided")
			return
		end

		vim.system({ "gh", "api", "/gists/" .. id }, nil, function(out)
			if out.code ~= 0 then
				callback(false, "Gist not found or no longer exists: " .. out.stderr)
				return
			end

			local ok, gist = pcall(vim.json.decode, out.stdout)
			if not ok or not gist.files then
				callback(false, "Failed to parse gist data")
				return
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
					local fp = io.open(target_path, "w")
					if fp then fp:write(content); fp:close() end
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

			callback(true, nil)
		end)
	end
end
return G
