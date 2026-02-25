-- Core utilities and functions for p5.nvim
local C = {}

-- Server configurations for different runtime environments
C.server_configs = {
  python = {
    check = "python3",
    script = "python.py",
    cmd = "python3"
  }
}

-- Split commands for window positioning
C.split_commands = {
  below = "belowright split",
  above = "aboveleft split",
  left = "aboveleft vsplit",
  right = "belowright vsplit"
}

-- Check if command exists
C.command_exists = function(cmd)
  return vim.fn.executable(cmd) ~= 0
end

-- Get plugin root directory
C.get_plugin_root = function()
  return vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h:h:h")
end

-- Get asset directory
C.get_asset_dir = function()
  return C.get_plugin_root() .. "/assets"
end

-- Get template directory
C.get_template_dir = function()
  return C.get_plugin_root() .. "/templates"
end

-- Get project root directory (deprecated, kept for compatibility)
C.get_project_root = function()
  return vim.fn.getcwd()
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
  if vim.fn.filereadable(path) == 1 then
    return true
  elseif required then
    C.notify_fallback(name .. " not found: " .. path, "error")
  end
  return false
end

C.validate_dir = function(path, name, required)
  if vim.fn.isdirectory(path) == 1 then
    return true
  elseif required then
    C.notify_fallback(name .. " not found: " .. path, "error")
  end
  return false
end

-- Check if p5 assets are available
C.assets_available = function()
  local version_file = C.get_asset_dir() .. "/version.json"
  local has_p5 = vim.fn.filereadable(C.get_asset_dir() .. "/core/p5.js")
  local has_types = vim.fn.filereadable(C.get_asset_dir() .. "/types/p5.d.ts")
  return has_p5 and has_types
end

-- Read workspace configuration
C.find_project_root = function()
  local current_dir = vim.fn.getcwd()
  local search_dir = current_dir
  
  while #search_dir > 1 do
    local config_file = search_dir .. "/p5.json"
    if vim.fn.filereadable(config_file) == 1 then
      local content = vim.fn.readfile(config_file)
      local config = vim.fn.json_decode(table.concat(content, "\n"))
      return search_dir, config
    end
    
    -- Move up one directory level
    local parent_dir = vim.fn.fnamemodify(search_dir, ":h")
    if parent_dir == search_dir then
      break
    end
    search_dir = parent_dir
  end
  
  return nil, nil
end

-- Keep original function for backward compatibility
C.find_nearest_p5_config = function()
  local current_dir = vim.fn.getcwd()
  local search_dir = current_dir
  
  while #search_dir > 1 do
    local config_file = search_dir .. "/p5.json"
    if vim.fn.filereadable(config_file) == 1 then
      local content = vim.fn.readfile(config_file)
      return vim.fn.json_decode(table.concat(content, "\n"))
    end
    
    -- Move up one directory level
    local parent_dir = vim.fn.fnamemodify(search_dir, ":h")
    if parent_dir == search_dir then
      break
    end
    search_dir = parent_dir
  end
  
  return nil
end

-- Write workspace configuration with formatting
C.write_workspace_config = function(config, project_dir)
  local dir = project_dir or vim.fn.getcwd()
  local config_file = dir .. "/p5.json"
  local content = vim.fn.json_encode(config)
  -- Format JSON with 2-space indentation
  local formatted = {}
  local indent = 0
  local in_string = false
  local i = 1
  while i <= #content do
    local c = content:sub(i, i)
    if c == '"' and (i == 1 or content:sub(i-1, i-1) ~= '\\') then
      in_string = not in_string
    end
    if not in_string then
      if c == '{' or c == '[' then
        table.insert(formatted, c)
        indent = indent + 2
        table.insert(formatted, '\n' .. string.rep(' ', indent))
        i = i + 1
      elseif c == '}' or c == ']' then
        indent = indent - 2
        table.insert(formatted, '\n' .. string.rep(' ', indent))
        table.insert(formatted, c)
        i = i + 1
      elseif c == ',' then
        table.insert(formatted, ',\n' .. string.rep(' ', indent))
        i = i + 1
      elseif c == ':' then
        table.insert(formatted, ': ')
        i = i + 1
      else
        table.insert(formatted, c)
        i = i + 1
      end
    else
      table.insert(formatted, c)
      i = i + 1
    end
  end
  local pretty = table.concat(formatted)
  vim.fn.writefile(vim.split(pretty, "\n"), config_file)
end

-- Show notification
C.notify = function(msg, level)
  local vim_level = vim.log.levels.INFO
  if level == "error" then
    vim_level = vim.log.levels.ERROR
  elseif level == "warn" then
    vim_level = vim.log.levels.WARN
  end
  
  vim.notify(msg, vim_level, { title = "p5.nvim" })
end

-- Get cache directory for host system
C.get_cache_dir = function()
  local cache_home = os.getenv("XDG_CACHE_HOCE") or vim.fn.expand("~/.cache")
  local cache_dir = cache_home .. "/p5.nvim"
  vim.fn.mkdir(cache_dir, "p")
  return cache_dir
end

-- Generate cache key for URL
C.generate_cache_key = function(url)
  return vim.fn.sha256(url):sub(1, 16)
end

-- Check if cached file is valid
C.is_cache_valid = function(cache_file, checksum)
  if vim.fn.filereadable(cache_file) == 0 then
    return false
  end
  
  -- Simple file existence check for now
  -- TODO: Add checksum validation if needed
  return true
end

-- Download file with progress tracking and caching
C.download_file_with_progress = function(url, dest, callback, options)
  options = options or {}
  local use_cache = options.cache ~= false
  local on_progress = options.on_progress
  local cache_file = nil
  
  if use_cache then
    local cache_dir = C.get_cache_dir()
    local cache_key = C.generate_cache_key(url)
    cache_file = cache_dir .. "/" .. cache_key
    
    -- Check if we have a valid cached version
    if C.is_cache_valid(cache_file) then
      vim.fn.system({"cp", cache_file, dest})
      if callback then callback(true) end
      return true
    end
  end
  
  -- Get file size first for progress tracking
  C.get_remote_file_size(url, function(total_size)
    local cmd
    if C.command_exists("curl") then
      cmd = {"curl", "-L", "--progress-bar", url, "-o", dest}
    elseif C.command_exists("wget") then
      cmd = {"wget", "--progress=bar:force", "-O", dest, url}
    else
      C.notify("Neither curl nor wget found. Cannot download: " .. url, "error")
      if callback then callback(false) end
      return
    end
    
    local job_id = vim.fn.jobstart(cmd, {
      on_stdout = function(_, data)
        -- Parse progress output if available
        if on_progress and data and total_size then
          -- Simple progress parsing (curl/wget progress output)
          for _, line in ipairs(data) do
            local percent = line:match("(%d+)%%")
            if percent then
              local downloaded = math.floor((tonumber(percent) / 100) * total_size)
              on_progress(downloaded, total_size, url)
            end
          end
        end
      end,
      on_stderr = function(_, data)
        -- Parse progress from stderr (curl sends progress there)
        if on_progress and data and total_size then
          for _, line in ipairs(data) do
            local percent = line:match("(%d+)%%")
            if percent then
              local downloaded = math.floor((tonumber(percent) / 100) * total_size)
              on_progress(downloaded, total_size, url)
            end
          end
        end
      end,
      on_exit = function(_, exit_code)
        local success = exit_code == 0
        
        -- Cache the downloaded file if successful and caching enabled
        if success and use_cache and cache_file then
          vim.fn.system({"cp", dest, cache_file})
        end
        
        if callback then callback(success) end
      end
    })
  end)
  
  return true
end

-- Download file with caching support (simplified version)
C.download_file = function(url, dest, callback, options)
  options = options or {}
  local use_cache = options.cache ~= false
  local cache_file = nil
  
  if use_cache then
    local cache_dir = C.get_cache_dir()
    local cache_key = C.generate_cache_key(url)
    cache_file = cache_dir .. "/" .. cache_key
    
    -- Check if we have a valid cached version
    if C.is_cache_valid(cache_file) then
      vim.fn.system({"cp", cache_file, dest})
      if callback then callback(true) end
      return true
    end
  end
  
  -- Use vim.fn.system for synchronous download (more reliable)
  local cmd
  if C.command_exists("curl") then
    cmd = string.format("curl -sL --max-time 30 --insecure '%s' -o '%s'", url, dest)
  elseif C.command_exists("wget") then
    cmd = string.format("wget -q -T 30 -O '%s' '%s'", dest, url)
  else
    C.notify("Neither curl nor wget found. Cannot download: " .. url, "error")
    if callback then callback(false) end
    return false
  end
  
  local result = vim.fn.system(cmd)
  local success = vim.v.shell_error == 0
  
  -- Cache the downloaded file if successful and caching enabled
  if success and use_cache and cache_file then
    vim.fn.system({"cp", dest, cache_file})
  end
  
  if callback then callback(success) end
  return success
end

-- Get remote file size for progress tracking
C.get_remote_file_size = function(url, callback)
  local cmd
  if C.command_exists("curl") then
    cmd = string.format("curl -sI '%s' | grep -i content-length | cut -d' ' -f2 | tr -d '\\r'", url)
  elseif C.command_exists("wget") then
    cmd = string.format("wget --spider '%s' 2>&1 | grep -i length | cut -d' ' -f2", url)
  else
    if callback then callback(nil) end
    return
  end
  
  vim.fn.jobstart(cmd, {
    on_stdout = function(_, data)
      if data and #data > 0 and data[1] ~= "" then
        local size = tonumber(data[1])
        if callback then callback(size) end
      else
        if callback then callback(nil) end
      end
    end
  })
end

-- GitHub API integration
C.get_github_release_asset = function(repo, release, pattern, callback)
  local api_url = string.format("https://api.github.com/repos/%s/releases/%s", repo, release)
  
  local cmd = string.format("curl -s '%s'", api_url)
  vim.fn.jobstart(cmd, {
    on_stdout = function(_, data)
      if not data or #data == 0 then
        if callback then callback(nil, "Failed to fetch release info") end
        return
      end
      
      local content = table.concat(data, "\n")
      local ok, release_info = pcall(vim.fn.json_decode, content)
      
      if not ok or not release_info or not release_info.assets then
        if callback then callback(nil, "Invalid release info") end
        return
      end
      
      -- Find matching asset
      for _, asset in ipairs(release_info.assets) do
        if asset.name:match(pattern) then
          if callback then callback(asset.browser_download_url, nil) end
          return
        end
      end
      
      if callback then callback(nil, "No matching asset found") end
    end,
    on_stderr = function(_, data)
      local error_msg = data and table.concat(data, "\n") or "Unknown error"
      if callback then callback(nil, error_msg) end
    end
  })
end

-- Get p5 version from bundled library
C.get_p5_version = function()
  local p5_file = C.get_asset_dir() .. "/libs/p5.js"
  if vim.fn.filereadable(p5_file) == 1 then
    local lines = vim.fn.readfile(p5_file)
    if lines and #lines > 0 then
      local version = lines[1]:match("p5%.js v([%d%.]+)")
      return version or "unknown"
    end
  end
  return "unknown"
end

-- Chrome Remote initialization
C.init_chrome_remote = function(error_msg)
  local ok, chrome_remote = pcall(require, "chrome-remote")
  if not ok then
    C.notify(error_msg or "Chrome Remote library not available", "error")
    return false
  end
  
  return true
end

-- Setup function
C.setup = function(config)
  C.config = config
end

-- Setup environment
C.setup_environment = function()
  local root = C.get_plugin_root()
  local asset_dir = C.get_asset_dir()
  
  vim.fn.mkdir(asset_dir .. "/core", "p")
  vim.fn.mkdir(asset_dir .. "/types", "p")

  if C.assets_available() then
    local info = C.get_p5_version()
    if info and info.version ~= "unknown" then
      local updated_at = vim.fn.strftime("%Y-%m-%dT%H:%C:%S")
      local version_json = {
        p5js = info.version,
        p5js_semver = info.semver,
        updated_at = updated_at
      }
      vim.fn.writefile(vim.split(vim.fn.json_encode(version_json), "\n"), C.get_asset_dir() .. "/version.json")
    end
  end
  
  if C.assets_available() then
    C.notify_fallback("P5 environment setup complete", "info")
  end
end

return C