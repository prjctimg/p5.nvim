-- GitHub Gist integration for p5.nvim

local core = require("p5.core")

local function chkgh()
	return core.is_cmd("gh")
end

if not chkgh() then
	return
else
	local G = {}
	-- Get files to include in gist from p5.json config
	G.includes = function(config)
		local files = config.includes or { "sketch.js" }

		local filtered = {}
		local has_assets = false
		for _, file in ipairs(files) do
			if type(file) ~= "string" then
				core.notify("Skipping non-string include: " .. tostring(file), "warn")
			else
				local is_unsafe = file:match("%.%.") or file:match("^/") or
				                  file:match("^~") or file:match("^[A-Za-z]:") or
				                  file:match("%z")

				if is_unsafe then
					core.notify("Skipping unsafe path: " .. file, "warn")
				elseif file:match("^assets/") or file:match("^assets$") then
					has_assets = true
				else
					table.insert(filtered, file)
				end
			end
		end

		if has_assets then
			core.notify("assets/ excluded from gist", "info")
		end

		table.insert(filtered, "p5.json")

		return filtered
	end

	-- Create gist from current project
	G.mkgist = function(desc)
		local dir, config = core.ssroot()
		if not config then
			core.notify("⚠️ not in a sketchspace (p5.json required)", "info")
			return
		end

		local files = G.includes(config)

		local missing_files = {}
		for _, file_name in ipairs(files) do
			if not core.is_file(dir .. "/" .. file_name) then
				table.insert(missing_files, file_name)
			end
		end

		if #missing_files > 0 then
			core.notify("missing files: " .. table.concat(missing_files, ", "), "info")
			return
		end

		local function proceed(desc, proj_dir, proj_config)
			local gist_files = {}

			local gist_dir = (vim.fn.stdpath("cache") or vim.uv.os_tmpdir() or "/tmp") .. "/p5_gist"
			vim.fn.mkdir(gist_dir, "p")

			local unique_dir = gist_dir .. "/" .. os.time() .. "_" .. vim.fn.getpid()
			vim.fn.mkdir(unique_dir, "p")

			for _, file in ipairs(files) do
				local target = unique_dir .. "/" .. file
				local src_path = vim.fn.fnamemodify(proj_dir .. "/" .. file, ":p")

				local parent_dir = vim.fn.fnamemodify(target, ":h")
				if parent_dir ~= unique_dir then
					vim.fn.mkdir(parent_dir, "p")
				end

				vim.fn.system({ "cp", src_path, target })
				if vim.v.shell_error ~= 0 then
					core.notify("Failed to copy file: " .. file, "error")
					vim.fn.delete(unique_dir, "rf")
					return
				end

				table.insert(gist_files, target)
			end

			local cmd = { "gh", "gist", "create" }

			if desc and desc ~= "" then
				table.insert(cmd, "--desc")
				table.insert(cmd, desc)
			else
				table.insert(cmd, "--desc")
				table.insert(cmd, "p5.js sketch from " .. (proj_config.name or "sketchspace"))
			end

			table.insert(cmd, "--private")
			for _, file_path in ipairs(gist_files) do
				table.insert(cmd, file_path)
			end

			local result = vim.fn.system(cmd)
			local exit_code = vim.v.shell_error

			vim.fn.delete(unique_dir, "rf")

			if exit_code ~= 0 then
				core.notify("Failed to create gist: " .. result, "error")
				return
			end

			local url = result:match("https://gist%.github%.com/%S+")

			if url then
				proj_config.gist = url
				core.w_ss_cfg(proj_config, proj_dir)

				local gist_id = url:match("/([a-fA-F0-9]+)$")
				if gist_id then
					local p5_json_path = proj_dir .. "/p5.json"
					local edit_cmd = { "gh", "gist", "edit", gist_id, "--filename", "p5.json", p5_json_path }
					vim.fn.system(edit_cmd)
				end

				core.notify("✅ gist created: " .. url, "ok")
			else
				core.notify("💔 failed to extract gist URL: " .. result, "info")
			end
		end

		-- If description provided, proceed directly
		if desc and desc ~= "" then
			proceed(desc, dir, config)
		else
			-- Prompt for description
			vim.ui.input({
				prompt = "Description: ",
				default = "sketchspace " .. (config.name or "sketchspace"),
				completion = "file",
			}, function(input)
				if input and input ~= "" then
					proceed(input, dir, config)
				else
					core.notify("gist creation cancelled", "info")
				end
			end)
		end
	end

	-- Update existing gist
	G.sync = function(gist_id)
		local dir, config = core.ssroot()
		if not config then
			core.notify("🖼️ not in a sketchspace", "info")
			return
		end

		if not gist_id then
			if config.gist then
				if type(config.gist) == "table" then
					gist_id = config.gist.id
				else
					gist_id = config.gist:match("/([a-fA-F0-9]+)$")
				end
			end

			if not gist_id then
				core.notify("No gist associated with this sketchspace. Run :P5Gist to create one.", "info")
				return
			end
		end

		local files_to_update = G.includes(config)

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
				local source_path = dir .. "/" .. file_name

				vim.fn.system({ "cp", source_path, temp_file })
				if vim.v.shell_error ~= 0 then
					table.insert(update_errors, "Failed to copy: " .. file_name)
				else
					local cmd = { "gh", "gist", "edit", gist_id, "--filename", file_name, temp_file }
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

		if config.gist then
			local url = type(config.gist) == "string" and config.gist or config.gist.url
			if url then
				if vim.ui and vim.ui.open then
					vim.ui.open(url)
				else
					local open_cmd
					if vim.fn.has("mac") == 1 then
						open_cmd = { "open", url }
					elseif vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
						open_cmd = { "cmd", "/c", "start", "", url }
					else
						open_cmd = { "xdg-open", url }
					end
					vim.fn.system(open_cmd)
				end
			end
		end
	end

	-- List gists
	G.ls_gists = function()
		local cmd = { "gh", "gist", "list", "--limit", "20" }
		local result = vim.fn.system(cmd)
		local exit_code = vim.v.shell_error

		if exit_code == 0 then
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
			core.notify("Failed to list gists: " .. result, "error")
		end
	end

	-- Open gist in browser
	G.open = function(gist_id)
		if not gist_id then
			core.notify("Gist ID required", "error")
			return
		end

		local cmd = { "gh", "gist", "view", gist_id, "--web" }
		local result = vim.fn.system(cmd)
		local exit_code = vim.v.shell_error

		if exit_code ~= 0 then
			core.notify("Failed to open gist: " .. result, "error")
		end
	end

	-- Clone gist as new p5 project
	G.clone = function(gist_id)
		if not gist_id then
			core.notify("Gist ID required", "error")
			return
		end

		-- Get gist info
		local cmd = { "gh", "gist", "view", gist_id }
		local result = vim.fn.system(cmd)
		local exit_code = vim.v.shell_error

		if exit_code ~= 0 then
			core.notify("Failed to get gist info: " .. result, "error")
			return
		end

		-- Extract description for project name
		local description = result:match("# ([^\n]+)") or "p5-sketch-from-gist"
		local project_name = description:gsub("%s+", "-"):lower()

		-- Create project directory
		if vim.fn.isdirectory(project_name) ~= 0 then
			core.notify("Directory '" .. project_name .. "' already exists", "error")
			return
		end

		vim.fn.mkdir(project_name, "p")
		local project_path = vim.fn.fnamemodify(project_name, ":p")

		-- Clone gist files
		cmd = { "gh", "gist", "clone", gist_id, project_path }
		result = vim.fn.system(cmd)
		exit_code = vim.v.shell_error

		if exit_code == 0 then
			-- Create p5.json if not exists
			if vim.fn.filereadable(project_path .. "/p5.json") == 0 then
				local p5_config = {
					version = "1.9.0",
					libs = {},
					includes = { "sketch.js" },
					gist = {
						id = gist_id,
					},
				}

				vim.fn.writefile(vim.split(vim.fn.json_encode(p5_config), "\n"), project_path .. "/p5.json")
			end

			-- Open project
			vim.cmd("edit " .. project_path .. "/sketch.js")
			core.notify("Cloned gist as sketchspace: " .. project_name, "ok")
		else
			-- Clean up failed clone
			vim.fn.delete(project_path, "rf")
			core.notify("Failed to clone gist: " .. result, "error")
		end
	end

	-- Get current gist info from project
	G.get_project_gist = function()
		local _, config = core.ssroot()
		if not config or not config.gist then
			return nil
		end

		-- Handle both string (URL only) and object (legacy) formats
		local gist_url = config.gist
		if type(gist_url) == "table" then
			gist_url = config.gist.url or config.gist.id
		end

		if not gist_url then
			return nil
		end

		-- Extract gist ID from URL if needed
		local gist_id = gist_url
		if gist_url:match("gist.github.com/") then
			gist_id = gist_url:match("gist.github.com/[^/]+/([a-fA-F0-9]+)$")
			if not gist_id then
				gist_id = gist_url:match("gist.github.com/([a-fA-F0-9]+)$")
			end
		end

		return {
			id = gist_id,
			url = gist_url,
		}
	end

	-- Update current project's gist
	G.update_current_gist = function()
		local gist_info = G.get_project_gist()
		if not gist_info or not gist_info.id then
			core.notify("No gist associated with current sketchspace", "warn")
			return
		end

		G.sync(gist_info.id)
	end

	-- Download gist files to current project
	G.download_gist = function(gist_id, project_dir)
		project_dir = vim.fs.normalize(project_dir or vim.fn.getcwd())

		if not gist_id then
			return false, "No gist ID provided"
		end

		-- Get gist files in JSON format
		local cmd = { "gh", "gist", "view", gist_id, "--json", "files" }
		local result = vim.fn.system(cmd)
		local exit_code = vim.v.shell_error

		if exit_code ~= 0 then
			return false, "Gist not found or no longer exists: " .. result
		end

		-- Parse JSON response
		local ok, gist_data = pcall(vim.fn.json_decode, result)
		if not ok or not gist_data.files then
			return false, "Failed to parse gist data"
		end

		local files = gist_data.files
		local downloaded = {}
		local skipped = {}

		for filename, filedata in pairs(files) do
			local target_path = project_dir .. "/" .. filename

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
			core.notify(table.concat(msg, " | "), "info")
		end

		return true, nil
	end

	return G
end
