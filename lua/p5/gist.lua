-- GitHub Gist integration for p5.nvim
local G = {}
local core = require("p5.core")
local notify = core.notify
if not core.is_cmd("gh") then
	notify("GitHub CLI (gh) not found", "error")
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
			vim.fn.mkdir(gist_temp_dir, "p")

			local dir = gist_temp_dir .. "/" .. os.time() .. "_" .. vim.fn.getpid()
			vim.fn.mkdir(dir, "p")

			for _, file_name in ipairs(files) do
				local target_path = dir .. "/" .. file_name
				local source_path = vim.fn.fnamemodify(proj_dir .. "/" .. file_name, ":p")

				local parent_dir = vim.fn.fnamemodify(target_path, ":h")
				if parent_dir ~= dir then
					vim.fn.mkdir(parent_dir, "p")
				end

				vim.fn.system({ "cp", source_path, target_path })
				if vim.v.shell_error ~= 0 then
					core.notify("Failed to copy file: " .. file_name, "error")
					vim.fn.delete(dir, "rf")
					return
				end

				table.insert(temp_files, target_path)
				table.insert(gist_files, target_path)
			end

			local cmd = { "gh", "gist", "create" }

			if desc and desc ~= "" then
				table.insert(cmd, "--desc")
				table.insert(cmd, desc)
			else
				table.insert(cmd, "--desc")
				table.insert(cmd, "p5.js sketch from " .. (proj_config.name or "sketchspace"))
			end

			table.insert(cmd, "--public")
			for _, file_path in ipairs(gist_files) do
				table.insert(cmd, file_path)
			end

			local result = vim.fn.system(cmd)
			local exit_code = vim.v.shell_error

			vim.fn.delete(dir, "rf")

			if exit_code ~= 0 then
				core.notify("Failed to create gist: " .. result, "error")
				return
			end

			local url = result:match("https://gist%.github%.com/%S+")

			if url then
				proj_config.gist = url
				core.write_workspace_config(proj_config, proj_dir)

				local gist_id = url:match("/([a-fA-F0-9]+)$")
				if gist_id then
					local p5_json_path = proj_dir .. "/p5.json"
					local edit_cmd = { "gh", "gist", "edit", gist_id, "--filename", "p5.json", p5_json_path }
					vim.fn.system(edit_cmd)
				end

				core.notify("Gist created: " .. url, "ok")
			else
				core.notify("Failed to extract gist URL: " .. result, "error")
			end
		end

		-- If description provided, proceed directly
		if description and description ~= "" then
			proceed(description, project_dir, config)
		else
			-- Prompt for description
			vim.ui.input({
				prompt = "Gist description: ",
				default = "p5.js sketch from " .. (config.name or "sketchspace"),
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

	-- Update existing gist
	-- List gists
	G.list_gists = function()
		local result = vim.fn.system({ "gh", "gist", "list", "--limit", "20" })
		local code = vim.v.shell_error

		if code == 0 then
			-- Create a new buffer to display gists
			local buf = vim.api.nvim_create_buf(false, true)
			vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(result, "\n"))
			vim.api.nvim_buf_set_name(buf, "p5-gists")
			vim.api.nvim_set_option_value("filetype", "text", { buf = buf })

			-- Show in new window
			vim.cmd("split")
			local win = vim.api.nvim_get_current_win()
			vim.api.nvim_win_set_buf(win, buf)

			-- Set up keymaps to open gist
			vim.api.nvim_buf_set_keymap(buf, "n", "<CR>", "", {
				callback = function()
					local line = vim.api.nvim_get_current_line()
					local gist_id = line:match("(%w+)")
					if gist_id then
						vim.cmd("bdelete")
						G.open(gist_id)
					end
				end,
				desc = "Open p5 gist",
			})
		else
			notify("We couldn't find any Gists on your GitHub account 🍂 " .. result, "info")
		end
	end

	-- Open gist in browser
	G.open = function(gist_id)
		local result = vim.fn.system({ "gh", "gist", "view", gist_id, "--web" })
		local code = vim.v.shell_error

		if code ~= 0 then
			notify("😢 Failed to open gist: " .. result, "error")
		end
	end

	-- Clone gist as new p5 project
	G.clone = function(id)
		if not id then
			notify("🧐 Gist ID required", "error")
			return
		end

		-- Get gist info
		local result = vim.fn.system({ "gh", "gist", "view", id })

		if vim.v.shell_error ~= 0 then
			notify("🏃 Failed to get gist info: " .. result, "info")
			return
		end

		-- Extract description for project name
		local desc = result:match("# ([^\n]+)") or "p5-sketch-from-gist"
		local project = desc:gsub("%s+", "-"):lower()

		-- Create project directory
		if vim.fn.isdirectory(project) ~= 0 then
			notify("😅 Directory '" .. project .. "' already exists", "error")
			return
		end

		vim.fn.mkdir(project, "p")
		local project_path = vim.fn.fnamemodify(project, ":p")

		-- Clone gist files
		result = vim.fn.system({ "gh", "gist", "clone", id, project_path })

		if vim.v.shell_error == 0 then
			-- Create p5.json if doesn't exist
			if vim.fn.filereadable(project_path .. "/p5.json") == 0 then
				local p5_config = {
					version = "1.9.0",
					libs = {},
					includes = { "sketch.js" },
					gist = {
						id = id,
						cloned_at = os.date("%Y-%m-%d"),
					},
				}

				vim.fn.writefile(vim.split(vim.fn.json_encode(p5_config), "\n"), project_path .. "/p5.json")
			end

			-- Open project
			vim.cmd("edit " .. project_path .. "/sketch.js")
			notify("🎊 Cloned gist as sketchspace: " .. project, "ok")
		else
			-- Clean up failed clone
			vim.fn.delete(project_path, "rf")
			notify("🤕 Failed to clone gist: " .. result, "error")
		end
	end

	-- Get current gist info from project
	G.current = function()
		local _, config = core.find_project_root()
		if not config or not config.gist then
			return nil
		end

		-- Handle both string (URL only) and object (legacy) formats
		local url = config.gist
		if type(url) == "table" then
			url = config.gist.url or config.gist.id
		end

		if not url then
			return nil
		end

		-- Extract gist ID from URL if needed
		local id = url
		if url:match("gist.github.com/") then
			id = url:match("gist.github.com/[^/]+/([a-fA-F0-9]+)$")
			if not id then
				id = url:match("gist.github.com/([a-fA-F0-9]+)$")
			end
		end

		return {
			id = id,
			url = url,
		}
	end

	-- Update current project's gist
	G.update = function()
		local gist_info = G.current()
		if not gist_info or not gist_info.id then
			notify("🤦 No gist associated with current sketchspace", "warn")
			return
		end
		local project_dir, cfg = core.find_project_root()
		if not cfg then
			core.notify("Not in a sketchspace", "error")
			return
		end

		if not gist_info.id then
			if cfg.gist then
				if type(cfg.gist) == "table" then
					gist_info.id = cfg.gist.id
				else
					gist_info.id = cfg.gist:match("/([a-fA-F0-9]+)$")
				end
			end

			if not gist_info.id then
				core.notify("No gist associated with this sketchspace. Run :P5Gist to create one.", "error")
				return
			end
		end

		local files_to_update = G.includes(cfg)

		local temp_base = vim.fn.stdpath("cache") or (vim.uv.os_tmpdir() or "/tmp")
		local gist_temp_dir = temp_base .. "/p5_gist_update"
		vim.fn.mkdir(gist_temp_dir, "p")

		local update_errors = {}
		for _, file_name in ipairs(files_to_update) do
			if file_name ~= "p5.json" then
				local temp_file = gist_temp_dir
					.. "/"
					.. os.time()
					.. "_"
					.. vim.fn.getpid()
					.. "_"
					.. vim.fn.fnamemodify(file_name, ":t")
				local source_path = project_dir .. "/" .. file_name

				vim.fn.system({ "cp", source_path, temp_file })
				if vim.v.shell_error ~= 0 then
					table.insert(update_errors, "Failed to copy: " .. file_name)
				else
					local cmd = { "gh", "gist", "edit", gist_info.id, "--filename", file_name, temp_file }
					vim.fn.system(cmd)
					if vim.v.shell_error ~= 0 then
						table.insert(update_errors, "Failed to update: " .. file_name)
					end

					vim.fn.delete(temp_file)
				end
			end
		end

		if #update_errors > 0 then
			core.notify("Gist update partially failed: " .. table.concat(update_errors, ", "), "error")
			return
		end

		core.notify("Gist updated successfully", "ok")

		if cfg.gist then
			local url = type(cfg.gist) == "string" and cfg.gist or cfg.gist.url
			if url then
				vim.ui.open(url)
			end
		end
	end

	-- Download gist files to current project
	G.fetch = function(id, project)
		project = vim.fs.normalize(project or vim.fn.getcwd())

		if not id then
			return false, "👀 No gist ID provided"
		end

		-- Get gist files in JSON format
		local result = vim.fn.system({ "gh", "gist", "view", id, "--json", "files" })

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

	G.setup = function(config)
		G.config = config
	end
end
return G
