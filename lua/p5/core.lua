-- Core utilities and functions for p5.nvim
local C = {}

-- Split commands for window positioning
C.split_commands = {
  below = "belowright split",
  above = "aboveleft split",
  left = "aboveleft vsplit",
  right = "belowright vsplit"
}

-- Server configurations for runtime environments
C.server_configs = {
  python = {
    check = "python3",
    script = "server.py",
    cmd = "python3"
  }
}

-- Aliases for commonly used vim.fn calls
local fn = vim.fn
local api = vim.api

-- Check if command exists
C.command_exists = function(cmd)
  return fn.executable(cmd) ~= 0
end

-- Check if file exists (returns boolean)
C.file_exists = function(path)
  return fn.filereadable(path) == 1
end

-- Check if directory exists (returns boolean)
C.dir_exists = function(path)
  return fn.isdirectory(path) == 1
end

-- Read JSON file safely
C.read_json_file = function(path)
  if not C.file_exists(path) then
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
C.write_json_file = function(path, data)
  local content = fn.json_encode(data)
  fn.writefile(fn.split(content, "\n"), path)
end

-- Get cache file path
C.get_cache_file = function(filename)
  local cache_dir = C.get_cache_dir()
  return cache_dir .. "/" .. filename
end

-- Read recent sketchspaces from cache
C.read_recent_sketchspaces = function()
  local cache_file = C.get_cache_file("recent_sketchspaces.json")
  if not C.file_exists(cache_file) then
    return {}
  end
  local data, err = C.read_json_file(cache_file)
  return data or {}, err
end

-- Write recent sketchspaces to cache
C.write_recent_sketchspaces = function(data)
  local cache_file = C.get_cache_file("recent_sketchspaces.json")
  C.write_json_file(cache_file, data)
end

-- Get plugin root directory
C.get_plugin_root = function()
  return vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h:h:h")
end

-- Get asset directory
C.get_asset_dir = function()
  return C.get_plugin_root() .. "/assets"
end

-- Lazy dependency management
C.require_snacks = function()
  local ok, lazy_module = pcall(require, "p5.lazy")
  if ok then
    return lazy_module.require("snacks")
  end
  return nil
end

C.require_chrome_remote = function()
  local ok, chrome_remote = pcall(require, "chrome-remote")
  if ok then
    return chrome_remote
  end
  return nil
end

-- Unified notification with snacks fallback
C.notify_fallback = function(msg, level)
  local snacks = C.require_snacks()
  if snacks then
    vim.notify("[p5.nvim] " .. msg, level)
  else
    C.notify(msg, level)
  end
end

-- Validate file exists
C.validate_file = function(path, name, required)
  if C.file_exists(path) then
    return true
  elseif required then
    C.notify_fallback(name .. " not found: " .. path, "error")
  end
  return false
end

C.validate_dir = function(path, name, required)
  if C.dir_exists(path) then
    return true
  elseif required then
    C.notify_fallback(name .. " not found: " .. path, "error")
  end
  return false
end

-- Read workspace configuration
C.find_project_root = function()
  local search_dir = fn.getcwd()

  while #search_dir > 1 do
    local config_file = search_dir .. "/p5.json"
    if C.file_exists(config_file) then
      local config, err = C.read_json_file(config_file)
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
  local dir = project_dir or fn.getcwd()
  local config_file = dir .. "/p5.json"
  C.write_json_file(config_file, config)
end

-- Show notification
C.notify = function(msg, level)
  local level_map = {
    ok = vim.log.levels.INFO,
    info = vim.log.levels.INFO,
    warn = vim.log.levels.WARN,
    error = vim.log.levels.ERROR
  }
  local vim_level = level_map[level] or vim.log.levels.INFO

  vim.notify(msg, vim_level, { title = "p5.nvim" })
end

-- Get cache directory for host system
C.get_cache_dir = function()
  local cache_home = os.getenv("XDG_CACHE_HOME") or fn.expand("~/.cache")
  local cache_dir = cache_home .. "/p5.nvim"
  fn.mkdir(cache_dir, "p")
  return cache_dir
end

-- Generate cache key for URL
C.generate_cache_key = function(url)
  return vim.fn.sha256(url):sub(1, 16)
end

-- Check if cached file is valid
C.is_cache_valid = function(cache_file, _)
  return C.file_exists(cache_file)
end

-- Download file with caching support (async version)
C.download_file = function(url, dest, callback, options)
  options = options or {}
  local use_cache = options.cache ~= false
  local cache_file = nil

  if use_cache then
    local cache_dir = C.get_cache_dir()
    local cache_key = C.generate_cache_key(url)
    cache_file = cache_dir .. "/" .. cache_key

    if C.is_cache_valid(cache_file) then
      fn.system({"cp", cache_file, dest})
      if callback then callback(true) end
      return true
    end
  end

  local cmd
  if C.command_exists("curl") then
    cmd = {"curl", "-sL", "--max-time", "30", url, "-o", dest}
  elseif C.command_exists("wget") then
    cmd = {"wget", "-q", "-T", "30", "-O", dest, url}
  else
    C.notify("Neither curl nor wget found. Cannot download: " .. url, "error")
    if callback then callback(false) end
    return false
  end

  local job_id = fn.jobstart(cmd, {
    on_exit = function(_, exit_code)
      local success = exit_code == 0

      if success and use_cache and cache_file then
        local content = fn.readfile(dest)
        if content then
          fn.writefile(content, cache_file)
        end
      end

      if callback then callback(success) end
    end
  })

  if not job_id or job_id == 0 or job_id < 0 then
    C.notify("Failed to start download job for: " .. url, "error")
    if callback then callback(false) end
    return false
  end

  return true
end

-- Get p5 version from bundled library
C.get_p5_version = function()
  local p5_file = C.get_asset_dir() .. "/libs/p5.js"
  if C.file_exists(p5_file) then
    local lines = fn.readfile(p5_file)
    if lines and #lines > 0 then
      local version = lines[1]:match("p5%.js v([%d%.]+)")
      return version or "unknown"
    end
  end
  return "unknown"
end

C.get_recent_sketchspaces = function()
  return C.read_recent_sketchspaces()
end

C.add_recent_sketchspace = function(path)
  local recent = C.get_recent_sketchspaces()
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
  C.write_recent_sketchspaces(recent)
end

C.cleanup_recent_sketchspaces = function()
  local recent = C.get_recent_sketchspaces()
  local cleaned = {}
  for _, v in ipairs(recent) do
    if C.dir_exists(v) and C.file_exists(v .. "/p5.json") then
      table.insert(cleaned, v)
    end
  end
  C.write_recent_sketchspaces(cleaned)
  return cleaned
end

-- Setup function
C.setup = function(config)
  C.config = config
end

return C