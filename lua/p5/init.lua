--- p5.nvim - Better editor support for p5.js in Neovim.
--- (c) 2026 Dean Tarisai.
--- Released under the GPL-3.0 license.
local I = {}
local templates = require("p5.templates")

-- Logging level constants for DRY principle
local INFO, ERROR, WARN = vim.log.levels.INFO, vim.log.levels.WARN, vim.log.levels.ERROR
local concat, insert = table.concat, table.insert
local fmt = string.format
local isfile = vim.fn.filereadable
local usrcmd = vim.api.nvim_create_user_command
-- Utility functions for common operations
local write_file, read, ensure_dir, notify =
	function(content, filename)
		vim.fn.writefile(vim.split(content, "\n"), filename)
	end, function(filename)
		if isfile(filename) == 1 then
			return concat(vim.fn.readfile(filename), "\n")
		end
		return nil
	end, function(dir)
		if vim.fn.isdirectory(dir) == 0 then
			vim.fn.mkdir(dir, "p")
		end
	end, function(message, level)
		vim.notify(message, level or INFO)
	end
-- Default config
local cfg = {
	port = 8000,
	default_version = "2.0.5",
	versions = {
		"1.9.0",
		"2.0.5",
	},
	server_type = "auto", -- auto, live-server, python, static
	libraries = {
		sound = false,
		dom = false,
		ml5 = false,
		collide2d = false,
	},
	auto_open = true,
	browser = "default",
}
-- Internal state
local _cfg = {}
local job = nil
local current_port = nil
local download = {
	total = 0,
	completed = 0,
	failed = 0,
	items = {},
}

function I.setup(opts)
	_cfg = vim.tbl_deep_extend("force", cfg, opts or {})
	usrcmd("P5Create", function()
		I.create_new_project()
	end, { desc = "Create new p5.js project" })
	usrcmd("P5Server", function()
		I.start_server()
	end, { desc = "Start p5.js development server" })
	usrcmd("P5Stop", function()
		I.stop_server()
	end, { desc = "Stop p5.js development server" })
	usrcmd("P5Download", function()
		I.fetch()
	end, { desc = "Download p5.js libraries" })
	-- Auto-stop server on exit
	vim.api.nvim_create_autocmd("VimLeavePre", {
		callback = I.stop_server,
	})
end
-- Create new p5.js project
function I.create_new_project()
	-- Destination folder selection
	vim.ui.input({
		prompt = "Enter project folder name: ",
		default = "p5-sketch",
	}, function(folder_name)
		if not folder_name or folder_name == "" then
			notify("Project creation cancelled", WARN)
			return
		end

		-- Check if folder already exists
		if vim.fn.isdirectory(folder_name) == 1 then
			vim.ui.select({ "Yes", "No" }, {
				prompt = "Folder '" .. folder_name .. "' already exists. Continue?",
			}, function(choice)
				if choice == "Yes" then
					I.proceed_with_project_creation(folder_name)
				end
			end)
		else
			I.proceed_with_project_creation(folder_name)
		end
	end)
end

function I.proceed_with_project_creation(folder_name)
	-- Change to project directory
	ensure_dir(folder_name)
	vim.cmd("cd " .. folder_name)

	-- Version selection UI
	for _, version in ipairs(_cfg.versions) do
		local version_desc = version
		if version:find("2%.") then
			version_desc = version_desc .. " (latest, includes p5.strands)"
		else
			version_desc = version_desc .. " (legacy, compatible)"
		end
	end
	vim.ui.select(_cfg.versions, {
		prompt = "Select p5.js version:",
		format_item = function(item)
			local desc = item
			if item:find("2%.") then
				desc = desc .. " (latest, includes p5.strands)"
			else
				desc = desc .. " (legacy, compatible)"
			end
			return desc
		end,
	}, function(version)
		if not version then
			return
		end
		-- Library selection
		local lib_choices = {}
		for _, lib in ipairs(templates.library_catalog) do
			insert(lib_choices, {
				name = lib.name,
				description = lib.description,
			})
		end
		vim.ui.select(lib_choices, {
			prompt = "Select libraries (Ctrl+D for multiple):",
			format_item = function(item)
				return item.name .. " - " .. item.description
			end,
		}, function(selected_libs)
			local selected = selected_libs or {}
			-- Extract library names from selected objects for downloading
			local library_names = {}
			for _, lib in ipairs(selected) do
				insert(library_names, lib.name)
			end
			-- Reset download progress for new project
			download.total = 0
			download.completed = 0
			download.failed = 0
			download.items = {}

			-- Create project structure
			I.create_project_structure(version, selected)
			-- Download libraries
			vim.defer_fn(function()
				I.fetch(version, library_names)
			end, 100)
			notify("p5.js project created successfully!", INFO)
		end)
	end)
end
-- Create project directory structure
function I.create_project_structure(version, libraries)
	-- Create directories
	ensure_dir("lib")
	ensure_dir("lib/types")
	-- Write files
	local html_content = templates.get_html_template(version, libraries)
	write_file(html_content, "index.html")
	write_file(templates.css_template, "style.css")
	write_file(templates.js_template, "sketch.js")
	-- Write jsconfig.json for TypeScript support (in root directory)
	local jsconfig_content = templates.get_jsconfig_template()
	write_file(jsconfig_content, "jsconfig.json")
	-- Write global p5 type declarations for better LSP support
	local global_types_content = templates.get_global_types_template()
	write_file(global_types_content, "p5.global.d.ts")
end
-- Download referenced type files from p5.d.ts
function I.download_referenced_types(on_complete)
	if not isfile("lib/types/p5.d.ts") then
		if on_complete then
			on_complete()
		end
		return
	end

	local content = read("lib/types/p5.d.ts"):gmatch('<reference path="([^"]*)"')
	local refs = {}

	-- Extract all reference paths
	for ref_path in content do
		-- Remove leading "./" if present
		ref_path = ref_path:gsub("^%./", "")
		-- Only include files in subdirectories, not root level files
		if ref_path:find("^src/") or ref_path == "literals.d.ts" or ref_path == "constants.d.ts" then
			insert(refs, ref_path)
		end
	end

	local total = #refs
	if total == 0 then
		if on_complete then
			on_complete()
		end
		return
	end

	local completed = 0

	local function download_next()
		if completed >= total then
			if on_complete then
				on_complete()
			end
			return
		end

		completed = completed + 1
		local ref_path = refs[completed]
		local dest_path = "lib/types/" .. ref_path
		local dest_dir = vim.fn.fnamemodify(dest_path, ":h")

		-- Create directory if it doesn't exist
		ensure_dir(dest_dir)

		local url = "https://cdn.jsdelivr.net/npm/@types/p5/" .. ref_path
		I.download(url, dest_path, "type: " .. ref_path, function()
			-- Continue with next file regardless of success/failure
			vim.schedule(download_next)
		end)
	end

	download_next()
end
-- Download p5.js libraries and types
function I.fetch(version, libraries)
	version = version or _cfg.default_version
	libraries = libraries or {}
	-- Download core p5.js
	local base_url = templates.build_library_url(version, "core_template")
	if base_url then
		I.download(base_url, "lib/p5.js", "p5.js core")
	end
	-- Download selected libraries
	for _, choice in ipairs(libraries) do
		for _, lib in ipairs(templates.library_catalog) do
			if lib.name == (choice.name or choice) then
				local lib_url = templates.build_library_url(version, lib.url_key)
				if lib_url then
					I.download(lib_url, "lib/" .. lib.filename, lib.name)
				end
				-- Download type definitions
				if lib.types_key then
					local type_url = templates.type_url(lib.types_key)
					if type_url then
						I.download(type_url, "lib/types/" .. lib.types_filename, lib.name .. " types")
					end
				end
				break
			end
		end
	end
	-- Download core p5.js types
	I.download(templates.type_url("p5"), "lib/types/p5.d.ts", "p5.js core types", function(ok)
		if ok then
			-- Download all referenced type files
			I.download_referenced_types(function()
				-- Bundle comprehensive types after all downloads complete
				vim.defer_fn(function()
					I.bundle_types(version)
				end, 500)
			end)
		end
	end)
end
-- Bundle TypeScript definitions
function I.bundle_types(version)
	local output = [[// Bundled p5.js type definitions
// Auto-generated by p5.nvim ]] .. version .. [[
/// <reference path="p5.d.ts" />
]]
	-- Find all type files recursively using a simpler approach
	local all_type_files = vim.fn.glob("lib/types/**/*.d.ts", false, true)
	local type_files = {}

	for _, type_file in ipairs(all_type_files) do
		local filename = vim.fn.fnamemodify(type_file, ":t")
		if filename ~= "index.d.ts" and filename ~= "jsconfig.json" then
			insert(type_files, type_file)
		end
	end

	-- Sort files to ensure consistent order
	table.sort(type_files)

	-- Add type references
	for _, type_file in ipairs(type_files) do
		local relative_path = type_file:gsub("^lib/types/", "")
		output = output .. fmt('/// <reference path="%s" />\n', relative_path)
	end

	-- Add actual type content
	for _, types in ipairs(type_files) do
		if isfile(types) == 1 then
			local relative_path = types:gsub("^lib/types/", "")
			local content = read(types)
			if content then
				output = output .. "\n// Content from " .. relative_path .. "\n" .. content .. "\n"
			end
		end
	end

	-- Write bundled types
	write_file(output, "lib/types/index.d.ts")
	-- Write global type declarations for improved LSP support
	local global_types_content = templates.get_global_types_template()
	write_file(global_types_content, "p5.global.d.ts")
	-- Update jsconfig.json with dynamic references
	I.update_jsconfig()
end
-- Update jsconfig.json with discovered types
function I.update_jsconfig()
	-- Write jsconfig.json to root directory for proper LSP configuration
	local jsconfig_content = templates.get_jsconfig_template()
	write_file(jsconfig_content, "jsconfig.json")
end
-- Start development server
function I.start_server()
	if job then
		notify("Server is already running", WARN)
		return
	end
	-- Find available port
	current_port = I.find_available_port(_cfg.port)
	-- Detect server type
	local server_cmd, server_args = I.detect_server_command(current_port)
	-- Start server job
	job = vim.fn.jobstart(vim.list_extend({ server_cmd }, server_args), {
		on_stdout = function(_, data)
			if data and #data > 0 then
				for _, line in ipairs(data) do
					if line:find("Server running") or line:find("listening") then
						notify(line, INFO)
						-- Auto-open browser
						if _cfg.auto_open then
							vim.defer_fn(function()
								I.preview(current_port)
							end, 500)
						end
					end
				end
			end
		end,
		on_stderr = function(_, data)
			if data and #data > 0 then
				notify(concat(data, "\n"), ERROR)
			end
		end,
		on_exit = function()
			job = nil
			notify("Server stopped", INFO)
		end,
	})
	notify("Starting p5.js server on port " .. current_port, INFO)
end
-- Stop development server
function I.stop_server()
	if job then
		vim.fn.jobstop(job)
		job = nil
		current_port = nil
		notify("p5.js server stopped", INFO)
	else
		notify("No server is running", WARN)
	end
end
-- Detect available server command
function I.detect_server_command(port)
	local server_type = _cfg.server_type
	if server_type == "auto" then
		-- Try live-server first
		if vim.fn.executable("live-server") == 1 then
			return "live-server", { "--port=" .. port, "--quiet", "--open=/" }
		end
		-- Fall back to Python
		if vim.fn.executable("python3") == 1 then
			-- Create Python reload script
			local reload_script_path = vim.fn.stdpath("cache") .. "/p5_reload_server.py"
			write_file(templates.python_reload_script, reload_script_path)
			return "python3", { reload_script_path, tostring(port) }
		end
		-- Static fallback
		return "python3", { "-m", "http.server", tostring(port) }
	end
	if server_type == "live-server" and vim.fn.executable("live-server") == 1 then
		return "live-server", { "--port=" .. port, "--quiet", "--open=/" }
	end
	if server_type == "python" and vim.fn.executable("python3") == 1 then
		local reload_script_path = vim.fn.stdpath("cache") .. "/p5_reload_server.py"
		write_file(templates.python_reload_script, reload_script_path)
		return "python3", { reload_script_path, tostring(port) }
	end
	-- Default to static Python server
	return "python3", { "-m", "http.server", tostring(port) }
end
-- Find available port
function I.find_available_port(start_port)
	local port = start_port
	while port < start_port + 100 do
		local cmd = fmt("netstat -tuln 2>/dev/null | grep ':%d ' || true", port)
		local result = vim.fn.system(cmd)
		if result == "" then
			return port
		end
		port = port + 1
	end
	return start_port -- fallback
end
-- Download file with progress indication
function I.download(url, dest_path, description, on_complete)
	description = description or dest_path
	local temp_path = dest_path .. ".tmp"

	-- Initialize progress tracking if this is the first download
	if download.total == 0 then
		download.items = {}
	end

	insert(download.items, {
		description = description,
		success = nil,
	})
	download.total = #download.items

	local cmd = {
		"curl",
		"-sL",
		"-o",
		temp_path,
		url,
	}
	vim.fn.jobstart(concat(cmd, " "), {
		detach = true,
		on_exit = function(_, exit_code)
			local success = exit_code == 0
			if success then
				vim.fn.rename(temp_path, dest_path)
				download.completed = download.completed + 1
			else
				download.failed = download.failed + 1
				if isfile(temp_path) then
					vim.fn.delete(temp_path)
				end
			end

			-- Mark this item as completed
			for _, item in ipairs(download.items) do
				if item.description == description then
					item.success = success
					break
				end
			end

			-- Show progress notification
			I.show_download_progress()

			if on_complete then
				on_complete(success)
			end
		end,
	})
end

-- Show download progress
function I.show_download_progress()
	if download.total == 0 then
		return
	end

	local completed = download.completed
	local failed = download.failed
	local total = download.total
	local remaining = total - completed - failed

	if remaining == 0 then
		-- Final summary
		local message = fmt("Downloads complete: %d succeeded, %d failed", completed, failed)
		local level = failed > 0 and WARN or INFO
		notify(message, level)

		-- Reset progress for next batch
		download.total = 0
		download.completed = 0
		download.failed = 0
		download.items = {}
	else
		-- Progress update (only show significant changes to avoid spam)
		if completed % 3 == 0 or remaining <= 3 then
			-- Check if we're downloading types, libraries, or both
			local has_types = false
			local has_libs = false
			for _, item in ipairs(download.items) do
				if item.description then
					if item.description:find("types") then
						has_types = true
					else
						has_libs = true
					end
				end
			end

			local msg
			if has_types and has_libs then
				msg = fmt("Downloading p5 libraries and types: %d/%d completed", completed, total)
			elseif has_types then
				msg = fmt("Downloading p5 types: %d/%d completed", completed, total)
			else
				msg = fmt("Downloading p5 libraries: %d/%d completed", completed, total)
			end
			notify(msg, INFO)
		end
	end
end

-- Open browser
function I.preview(port)
	local url = fmt("http://localhost:%d", port)
	local open_cmd
	if vim.fn.has("mac") == 1 then
		open_cmd = "open"
	elseif vim.fn.has("unix") == 1 then
		open_cmd = "xdg-open"
	else
		open_cmd = "start"
	end
	vim.fn.system(open_cmd .. " " .. url)
end
return I
