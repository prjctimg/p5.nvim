local C = {}
-- window positioning
C.split_cmd = {
	below = "belowright split",
	above = "aboveleft split",
	left = "aboveleft vsplit",
	right = "belowright vsplit",
}

C.server_cfg = {
	check = "python3",
	script = "server.py",
	cmd = "python3",
}

local fn = vim.fn

C.is_cmd = function(cmd)
	return fn.executable(cmd) ~= 0
end

C.is_file = function(path)
	return fn.filereadable(path) == 1
end

C.is_dir = function(path)
	return fn.isdirectory(path) == 1
end

C.mkdir = function(path)
	if vim.uv.fs_stat(path) then return end
	local parent = vim.fs.dirname(path)
	if parent and parent ~= path then
		C.mkdir(parent)
	end
	vim.uv.fs_mkdir(path, tonumber("755", 8))
end

C.rmtree = function(path)
	local stat = vim.uv.fs_stat(path)
	if not stat then return end
	if stat.type == "directory" then
		local dir = vim.uv.fs_scandir(path)
		if dir then
			while true do
				local name = vim.uv.fs_scandir_next(dir)
				if not name then break end
				C.rmtree(path .. "/" .. name)
			end
		end
		vim.uv.fs_rmdir(path)
	else
		vim.uv.fs_unlink(path)
	end
end

C.read_json = function(path)
	if not C.is_file(path) then
		return nil, "File not found"
	end
	local fp = io.open(path, "r")
	if not fp then return nil, "Cannot open file" end
	local content = fp:read("*a")
	fp:close()
	local ok, data = pcall(vim.json.decode, content)
	if not ok then
		return nil, "Invalid JSON"
	end
	return data, nil
end

C.write_json = function(path, data)
	local fp = io.open(path, "w")
	if fp then
		fp:write(vim.json.encode(data))
		fp:write("\n")
		fp:close()
	end
end

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

C.asset_dir = function()
	return C.plugin_root() .. "/assets"
end

-- Validate file exists
C.validate_file = function(path, name, required)
	if C.is_file(path) then
		return true
	elseif required then
		C.notify(name .. " not found: " .. path, "warn")
	end
	return false
end

C.validate_dir = function(path, name, required)
	if C.is_dir(path) then
		return true
	elseif required then
		C.notify(name .. " not found: " .. path, "warn")
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

C.notify = function(msg, level)
	local level_map = {
		ok = vim.log.levels.INFO,
		info = vim.log.levels.INFO,
		warn = vim.log.levels.WARN,
		error = vim.log.levels.ERROR,
	}
	vim.schedule(function()
		vim.notify(msg, level_map[level], { title = "p5.nvim 🌸" })
	end)
end

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

-- Download file with caching
C.fetch = function(url, dest, callback, options)
	options = options or {}
	local use_cache = options.cache ~= false
	local cache_file = nil

	local function do_fetch()
		local cmd
		if C.is_cmd("curl") then
			cmd = { "curl", "-sL", "--max-time", "30", url, "-o", dest }
		elseif C.is_cmd("wget") then
			cmd = { "wget", "-q", "-T", "30", "-O", dest, url }
		else
			C.notify("Neither curl nor wget found. Cannot download: " .. url, "warn")
			if callback then
				callback(false)
			end
			return
		end

		fn.jobstart(cmd, {
			on_exit = function(_, exit_code)
				local ok = exit_code == 0

				if ok and use_cache and cache_file then
					local content = fn.readfile(dest)
					if content then
						local fp = io.open(cache_file, "w")
						if fp then
							fp:write(table.concat(content, "\n"))
							fp:write("\n")
							fp:close()
						end
					end
				end

				if callback then
					callback(ok)
				end
			end,
		})
	end

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

	do_fetch()
	return true
end

-- Fetch latest p5.js version from npm registry
C.fetch_latest_p5_version = function(callback)
	local url = "https://registry.npmjs.org/p5/latest"
	local tmp = fn.tempname()
	C.fetch(url, tmp, function(ok)
		if ok then
			local data, _ = C.read_json(tmp)
			pcall(fn.delete, tmp)
			if data and data.version then
				if callback then callback(data.version) end
			else
				if callback then callback(nil) end
			end
		else
			pcall(fn.delete, tmp)
			if callback then callback(nil) end
		end
	end, { cache = false })
end

-- Get p5 version (from override, project config, or fallback default)
C.p5_version = function(major, override_version)
	if override_version then return override_version end
	local config = C.read_workspace_config()
	if config and config.version then
		return config.version
	end
	return major == 2 and "2.0.5" or "1.11.3"
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

-- Encode a string to a filesystem-safe slug
C.slugify = function(str)
	if type(str) ~= "string" then
		return "untitled"
	end
	str = str:lower():gsub("[^a-z0-9]+", "-"):gsub("^-+", ""):gsub("-+$", "")
	return str ~= "" and str or "untitled"
end

-- Decode a slug back to a human-readable title
C.deslugify = function(str)
	str = str:gsub("-", " "):gsub("%s+", " "):gsub("(%a)([%w]*)", function(f, r)
		return f:upper() .. r:lower()
	end)
	return str
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
