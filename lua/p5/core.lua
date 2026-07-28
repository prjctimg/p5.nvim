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
	if vim.uv.fs_stat(path) then
		return
	end
	local parent = vim.fs.dirname(path)
	if parent and parent ~= path then
		C.mkdir(parent)
	end
	vim.uv.fs_mkdir(path, tonumber("755", 8))
end

C.rmtree = function(path)
	local stat = vim.uv.fs_stat(path)
	if not stat then
		return
	end
	if stat.type == "directory" then
		local dir = vim.uv.fs_scandir(path)
		if dir then
			while true do
				local name = vim.uv.fs_scandir_next(dir)
				if not name then
					break
				end
				C.rmtree(path .. "/" .. name)
			end
		end
		vim.uv.fs_rmdir(path)
	else
		vim.uv.fs_unlink(path)
	end
end

C.read_json = function(path)
	if not path or not C.is_file(path) then
		return nil, "File not found"
	end
	local fp = io.open(path, "r")
	if not fp then
		return nil, "Cannot open file"
	end
	local content = fp:read("*a")
	fp:close()
	if not content or content == "" then
		return nil, "Empty file"
	end
	local ok, data = pcall(vim.json.decode, content)
	if not ok or type(data) ~= "table" then
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

C.cached_p5_version_path = function()
	return C.cache_path("p5_version")
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

C.DEFAULT_P5_VERSION = "2.3.1"
C.CDN = "https://cdn.jsdelivr.net/npm/p5"

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

C.versions_dir = function()
	local dir = C.cache_dir() .. "/versions"
	fn.mkdir(dir, "p")
	return dir
end

C.versioned_p5_path = function(version)
	return C.versions_dir() .. "/" .. version .. "/p5.js"
end

C.meta_path = function()
	return C.cache_path("meta.json")
end

C.read_meta = function()
	local data = C.read_json(C.meta_path())
	if type(data) == "table" then
		return data
	end
	-- migrate legacy plain-string / invalid cache
	local legacy = C.cached_p5_version_path()
	if C.is_file(legacy) then
		local fp = io.open(legacy, "r")
		if fp then
			local raw = fp:read("*a")
			fp:close()
			if raw then
				local ok, decoded = pcall(vim.json.decode, raw)
				if ok and type(decoded) == "string" and decoded ~= "" then
					local meta = { latest = decoded, checked_at = 0 }
					C.write_meta(meta)
					return meta
				elseif ok and type(decoded) == "table" and decoded.version then
					local meta = { latest = decoded.version, checked_at = decoded.checked_at or 0 }
					C.write_meta(meta)
					return meta
				end
			end
		end
	end
	return {}
end

C.write_meta = function(meta)
	C.write_json(C.meta_path(), meta or {})
end

-- Generate cache key for URL
C.cache_keygen = function(url)
	return fn.sha256(url):sub(1, 16)
end

-- Download file with caching
C.fetch = function(url, dest, callback, options)
	options = options or {}
	local use_cache = options.cache ~= false
	local timeout = tostring(options.timeout or 30)
	local cache_file = nil

	local function do_fetch()
		local cmd
		if C.is_cmd("curl") then
			cmd = { "curl", "-sL", "--max-time", timeout, url, "-o", dest }
		elseif C.is_cmd("wget") then
			cmd = { "wget", "-q", "-T", timeout, "-O", dest, url }
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
					pcall(vim.uv.fs_copyfile, dest, cache_file)
				end

				if callback then
					callback(ok)
				end
			end,
		})
	end

	if use_cache then
		local cache_key = C.cache_keygen(url)
		cache_file = C.cache_dir() .. "/" .. cache_key

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

-- Compare semver-ish strings; returns -1, 0, 1
C.cmp_version = function(a, b)
	if not a or not b then
		return 0
	end
	local function parts(v)
		local t = {}
		for n in tostring(v):gmatch("%d+") do
			table.insert(t, tonumber(n) or 0)
		end
		return t
	end
	local pa, pb = parts(a), parts(b)
	local n = math.max(#pa, #pb)
	for i = 1, n do
		local x, y = pa[i] or 0, pb[i] or 0
		if x < y then
			return -1
		end
		if x > y then
			return 1
		end
	end
	return 0
end

-- Fetch latest p5.js version from npm registry, with local cache fallback
C.fetch_latest_p5_version = function(callback)
	local url = "https://registry.npmjs.org/p5/latest"
	local tmp = fn.tempname()
	C.fetch(url, tmp, function(ok)
		if ok then
			local data, _ = C.read_json(tmp)
			pcall(fn.delete, tmp)
			if data and data.version then
				local meta = C.read_meta()
				meta.latest = data.version
				meta.checked_at = os.time()
				C.write_meta(meta)
				if callback then
					callback(data.version, true)
				end
			else
				if callback then
					callback(C.read_meta().latest, false)
				end
			end
		else
			pcall(fn.delete, tmp)
			if callback then
				callback(C.read_meta().latest, false)
			end
		end
	end, { cache = false, timeout = 8 })
end

-- Get p5 version (from override, project config, plugin config, or fallback)
C.p5_version = function(override_version)
	if override_version then
		return override_version
	end
	local config = C.read_workspace_config()
	if config and config.version then
		return config.version
	end
	if C.config and C.config.p5 and C.config.p5.version then
		return C.config.p5.version
	end
	local meta = C.read_meta()
	if meta.latest then
		return meta.latest
	end
	return C.DEFAULT_P5_VERSION
end

-- Resolve version for create/setup. opts: { preferred, prompt, on_done(version, online) }
C.resolve_p5_version = function(opts)
	opts = opts or {}
	local preferred = opts.preferred or C.p5_version()
	local do_prompt = opts.prompt
	if do_prompt == nil then
		do_prompt = not (C.config and C.config.p5 and C.config.p5.check_update == false)
	end
	local on_done = opts.on_done or function() end

	local function finish(version, online)
		on_done(version or preferred or C.DEFAULT_P5_VERSION, online)
	end

	C.fetch_latest_p5_version(function(latest, online)
		if not online or not latest then
			finish(preferred, false)
			return
		end
		if do_prompt and C.cmp_version(latest, preferred) > 0 then
			vim.schedule(function()
				vim.ui.select({
					"Keep " .. preferred,
					"Upgrade to " .. latest,
				}, { prompt = "Newer p5.js available:" }, function(choice)
					if choice and choice:find("Upgrade", 1, true) then
						finish(latest, true)
					else
						finish(preferred, true)
					end
				end)
			end)
		else
			finish(preferred, true)
		end
	end)
end

-- Ensure versioned p5.js is in cache and copied to dest. callback(ok, from_cache)
C.ensure_cached_p5 = function(version, dest, callback)
	version = version or C.DEFAULT_P5_VERSION
	local cached = C.versioned_p5_path(version)
	C.mkdir(vim.fs.dirname(cached))

	local function copy_to_dest(ok)
		if not ok then
			if callback then
				callback(false, false)
			end
			return
		end
		if dest then
			C.mkdir(vim.fs.dirname(dest))
			local coped = vim.uv.fs_copyfile(cached, dest)
			if callback then
				callback(coped and true or false, true)
			end
		else
			if callback then
				callback(true, true)
			end
		end
	end

	if C.is_file(cached) then
		copy_to_dest(true)
		return
	end

	local url = C.CDN .. "@" .. version .. "/lib/p5.min.js"
	C.fetch(url, cached, function(ok)
		if ok then
			local libraries = require("p5.libraries")
			if not libraries.validate_download(cached) then
				pcall(fn.delete, cached)
				if callback then
					callback(false, false)
				end
				return
			end
			copy_to_dest(true)
		else
			if callback then
				callback(false, false)
			end
		end
	end, { cache = true })
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

-- Find Chrome/Chromium browser in PATH
C.find_chrome = function()
	local candidates = { "chromium", "chromium-browser", "google-chrome", "chrome" }
	for _, c in ipairs(candidates) do
		if C.is_cmd(c) then
			return c
		end
	end
	return nil
end

-- Execute steps sequentially, each receiving a next() callback
C.step_runner = function(steps, cb)
	local i = 1
	local function next_fn()
		if i <= #steps then
			local s = steps[i]
			i = i + 1
			s(next_fn)
		elseif cb then
			cb()
		end
	end
	next_fn()
end

return C
