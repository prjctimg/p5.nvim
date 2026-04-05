-- Core utilities and functions for p5.nvim
local C = {}
-- Split commands for window positioning
C.split_cmd = {
	below = "belowright split",
	above = "aboveleft split",
	left = "aboveleft vsplit",
	right = "belowright vsplit",
}

-- Server configurations for runtime environments
C.server_cfg = {
	check = "python3",
	script = "server.py",
	cmd = "python3",
}

-- Aliases for commonly used vim.fn calls
local fn = vim.fn

-- Check if command exists
C.is_cmd = function(cmd)
	return fn.executable(cmd) ~= 0
end

-- Check if file exists (returns boolean)
C.is_file = function(path)
	return fn.filereadable(path) == 1
end

-- Check if directory exists (returns boolean)
C.is_dir = function(path)
	return fn.isdirectory(path) == 1
end

C.mkdir = function(path)
	fn.mkdir(path, "p")
end

-- Read JSON file safely
C.read_json = function(path)
	if not C.is_file(path) then
		return nil, "File not found"
	end
	local content = fn.readfile(path)
	if not content then
		return nil, "Failed to read file"
	end
	local ok, data = pcall(fn.json_decode, table.concat(content, "\n"))
	if not ok then
		return nil, "Invalid JSON"
	end
	return data, nil
end

-- Write JSON file with formatting
C.write_json = function(path, data)
	local content = fn.json_encode(data)
	fn.writefile(fn.split(content, "\n"), path)
end

-- Get cache file path
C.cache_path = function(filename)
	local dir = C.cache_dir()
	return dir .. "/" .. filename
end

-- Read recent sketchspaces from cache
C.read_ss = function()
	local cache_file = C.cache_path("recent_sketchspaces.json")
	if not C.is_file(cache_file) then
		return {}
	end
	local data, err = C.read_json(cache_file)
	return data or {}, err
end

-- Write recent sketchspaces to cache
C.write_ss = function(data)
	local cache_file = C.cache_path("recent_sketchspaces.json")
	C.write_json(cache_file, data)
end

-- Get plugin root directory
C.plugin_root = function()
	return fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h:h:h")
end

-- Get asset directory
C.asset_dir = function()
	return C.plugin_root() .. "/assets"
end

-- Lazy dependency management
C.require_snacks = function()
	local ok, lazy_module = pcall(require, "p5.lazy")
	if ok then
		return lazy_module.require("snacks")
	end
	return nil
end

-- Validate file exists
C.validate_file = function(path, name, required)
	if C.is_file(path) then
		return true
	elseif required then
		C.notify(name .. " not found: " .. path, "error")
	end
	return false
end

C.validate_dir = function(path, name, required)
	if C.is_dir(path) then
		return true
	elseif required then
		C.notify(name .. " not found: " .. path, "error")
	end
	return false
end

-- Read workspace configuration
C.find_project_root = function()
	local search_dir = fn.getcwd()

	while #search_dir > 1 do
		local config_file = search_dir .. "/p5.json"
		if C.is_file(config_file) then
			local config, _ = C.read_json(config_file)
			return search_dir, config
		end

		local parent_dir = fn.fnamemodify(search_dir, ":h")
		if parent_dir == search_dir then
			break
		end
		search_dir = parent_dir
	end

	return nil, nil
end

-- Read workspace configuration (alias for find_project_root's config)
C.read_workspace_config = function()
	local _, config = C.find_project_root()
	return config
end

-- Write workspace configuration with formatting
C.write_workspace_config = function(config, project_dir)
	local dir = project_dir or C.find_project_root() or fn.getcwd()
	local config_file = dir .. "/p5.json"
	C.write_json(config_file, config)
end

-- Show notification
C.notify = function(msg, level)
	local level_map = {
		ok = vim.log.levels.INFO,
		info = vim.log.levels.INFO,
		warn = vim.log.levels.WARN,
		error = vim.log.levels.ERROR,
	}

	vim.notify(msg, level_map[level] or vim.log.levels.INFO, { title = "p5.nvim 🌸" })
end

-- Get cache directory for host system
C.cache_dir = function()
	local cache_home = os.getenv("XDG_CACHE_HOME") or fn.expand("~/.cache")
	local dir = cache_home .. "/p5.nvim"
	fn.mkdir(dir, "p")
	return dir
end

-- Generate cache key for URL
C.cache_keygen = function(url)
	return fn.sha256(url):sub(1, 16)
end

-- Check if cached file is valid
C.is_cache = function(cache_file, _)
	return C.is_file(cache_file)
end

-- Download file with caching support (async version)
C.fetch = function(url, dest, callback, options)
	options = options or {}
	local use_cache = options.cache ~= false
	local cache_file = nil

	if use_cache then
		local cache_dir = C.cache_dir()
		local cache_key = C.cache_keygen(url)
		cache_file = cache_dir .. "/" .. cache_key

		if C.is_file(cache_file) then
			local ok, err = vim.uv.fs_copyfile(cache_file, dest)
			if ok then
				if callback then
					callback(true)
				end
				return true
			else
				C.notify("Cache copy failed: " .. tostring(err), "warn")
			end
		end
	end

	local cmd
	if C.is_cmd("curl") then
		cmd = { "curl", "-sL", "--max-time", "30", url, "-o", dest }
	elseif C.is_cmd("wget") then
		cmd = { "wget", "-q", "-T", "30", "-O", dest, url }
	else
		C.notify("Neither curl nor wget found. Cannot download: " .. url, "error")
		if callback then
			callback(false)
		end
		return false
	end

	local id = fn.jobstart(cmd, {
		on_exit = function(_, exit_code)
			local ok = exit_code == 0

			if ok and use_cache and cache_file then
				local content = fn.readfile(dest)
				if content then
					fn.writefile(content, cache_file)
				end
			end

			if callback then
				callback(ok)
			end
		end,
	})

	if not id or id == 0 or id < 0 then
		C.notify("Failed to start download job for: " .. url, "error")
		if callback then
			callback(false)
		end
		return false
	end

	return true
end

-- Get p5 version from bundled library
C.p5_version = function(major)
	major = major or 2
	local p5_file = major == 1 and "p5.js" or "p5-v2.js"
	local p5 = C.asset_dir() .. "/libs/" .. p5_file
	if C.is_file(p5) then
		local lines = fn.readfile(p5)
		if lines and #lines > 0 then
			local version = lines[1]:match("p5%.js v([%d%.]+)")
			return version or (major == 2 and "2.0.0" or "1.9.0")
		end
	end
	return major == 2 and "2.0.0" or "1.9.0"
end

-- Add recent sketchspaces
C.add_ss = function(path)
	local recent = C.read_ss()
	for i, v in ipairs(recent) do
		if v == path then
			table.remove(recent, i)
			break
		end
	end
	table.insert(recent, 1, path)
	while #recent > 10 do
		table.remove(recent)
	end
	C.write_ss(recent)
end

-- Clean recent sketchspaces
C.purge_ss = function()
	local recent = C.read_ss()
	local cleaned = {}
	for _, v in ipairs(recent) do
		if C.is_dir(v) and C.is_file(v .. "/p5.json") then
			table.insert(cleaned, v)
		end
	end
	C.write_ss(cleaned)
	return cleaned
end

return C
