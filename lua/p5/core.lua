-- Wrappers and helpers
-- Some lingo:
-- r_ - means the function reads, w_ means the function writes
-- ss - sketchspace
-- chk - check, followed by what to check
--
local C = {}

-- Split commands for window positioning
C.split = {
	below = "belowright split",
	above = "aboveleft split",
	left = "aboveleft vsplit",
	right = "belowright vsplit",
}

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

-- Read JSON file safely
C.r_json = function(path)
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
C.w_json = function(path, data)
	local content = fn.json_encode(data)
	fn.writefile(fn.split(content, "\n"), path)
end

C.cache_file = function(file)
	local dir = C.cache_dir()
	return dir .. "/" .. file
end

-- Write recent sketchspaces to cache
C.sync_ss = function(data)
	local cache_file = C.cache_file("sketchspaces.json")
	C.w_json(cache_file, data)
end

-- Get plugin root directory
C.plugin_root = function()
	return vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h:h:h")
end

-- Get asset directory
C.asset_dir = function()
	return C.plugin_root() .. "/assets"
end

-- Get snacks module if available
C.snacks = function()
	local ok, s = pcall(require, "snacks")
	return ok and s or nil
end

-- Validate file exists
C.chkfile = function(path, name, required)
	if C.is_file(path) then
		return true
	elseif required then
		C.notify(name .. " not found: " .. path, "error")
	end
	return false
end

C.chkdir = function(path, name, required)
	if C.is_dir(path) then
		return true
	elseif required then
		C.notify(name .. " not found: " .. path, "error")
	end
	return false
end

-- Read workspace configuration
C.ssroot = function()
	local search_dir = fn.getcwd()

	while #search_dir > 1 do
		local config_file = search_dir .. "/p5.json"
		if C.is_file(config_file) then
			local config, _ = C.r_json(config_file)
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
C.r_ss_cfg = function()
	local _, config = C.ssroot()
	return config
end

-- Write workspace configuration with formatting
C.w_ss_cfg = function(config, project_dir)
	local dir = project_dir or C.ssroot() or fn.getcwd()
	local cfg = dir .. "/p5.json"
	C.w_json(cfg, config)
end

-- Show notification
C.notify = function(msg, level)
	local level_map = {
		ok = vim.log.levels.INFO,
		info = vim.log.levels.INFO,
		warn = vim.log.levels.WARN,
		error = vim.log.levels.ERROR,
	}
	local vim_level = level_map[level] or vim.log.levels.INFO

	vim.notify(msg, vim_level, { title = "p5.nvim" })
end

-- Get cache directory for host system
C.cache_dir = function()
	local home = os.getenv("XDG_CACHE_HOME") or fn.expand("~/.cache")
	local dir = home .. "/p5.nvim"
	fn.mkdir(dir, "p")
	return dir
end

-- Generate cache key for URL
C.generate_cache_key = function(url)
	return vim.fn.sha256(url):sub(1, 16)
end

-- Download file with caching support (async version)
C.fetch = function(url, dest, cb, options)
	options = options or {}
	local cache = options.cache ~= false
	local file = nil

	if cache then
		local dir = C.cache_dir()
		local cache_key = C.generate_cache_key(url)
		file = dir .. "/" .. cache_key

		if C.is_file(file) then
			local ok, err = vim.uv.fs_copyfile(file, dest)
			if ok then
				if cb then
					cb(true)
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
		if cb then
			cb(false)
		end
		return false
	end

	local job_id = fn.jobstart(cmd, {
		on_exit = function(_, exit_code)
			local ok = exit_code == 0

			if ok and cache and file then
				local content = fn.readfile(dest)
				if content then
					fn.writefile(content, file)
				end
			end

			if cb then
				cb(ok)
			end
		end,
	})

	if not job_id or job_id == 0 or job_id < 0 then
		C.notify("😥 failed to start download job for: " .. url, "warn")
		if cb then
			cb(false)
		end
		return false
	end

	return true
end

-- Get p5 version from bundled library
C.get_p5_version = function()
	local p5_file = C.asset_dir() .. "/libs/p5.js"
	if C.is_file(p5_file) then
		local lines = fn.readfile(p5_file)
		if lines and #lines > 0 then
			local version = lines[1]:match("p5%.js v([%d%.]+)")
			return version or "unknown"
		end
	end
	return "unknown"
end

C.ls_ss = function()
	local cache_file = C.cache_file("sketchspaces.json")
	if not C.is_file(cache_file) then
		return {}
	end
	local data, err = C.r_json(cache_file)
	return data or {}, err
end

C.add_recent_sketchspace = function(path)
	local recent = C.ls_ss()
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
	C.sync_ss(recent)
end

-- Cleanup the sketchspaces
C.prune_ss = function()
	local recent = C.ls_ss()
	local cleaned = {}
	for _, v in ipairs(recent) do
		if C.is_dir(v) and C.is_file(v .. "/p5.json") then
			table.insert(cleaned, v)
		end
	end
	C.sync_ss(cleaned)
	return cleaned
end

return C

