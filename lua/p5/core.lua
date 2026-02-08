-- Core utilities and functions for p5.nvim
local M = {}

-- Server configurations for different runtime environments
M.server_configs = {
  python = {
    check = "python3",
    script = "python.py",
    cmd = "python3"
  },
  bun = {
    check = "bun",
    script = "bun.js",
    cmd = "bun"
  },
  deno = {
    check = "deno",
    script = "deno.js",
    cmd = "deno"
  },
  node = {
    check = "node",
    script = "node.js", 
    cmd = "node"
  }
}

-- Split commands for window positioning
M.split_commands = {
  below = "belowright split",
  above = "aboveleft split",
  left = "aboveleft vsplit",
  right = "belowright vsplit"
}

-- Check if command exists
M.command_exists = function(cmd)
  return vim.fn.executable(cmd) ~= 0
end

-- Get plugin root directory
M.get_plugin_root = function()
  return vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h:h:h")
end

-- Get asset directory
M.get_asset_dir = function()
  return M.get_plugin_root() .. "/assets"
end

-- Get template directory
M.get_template_dir = function()
  return M.get_plugin_root() .. "/templates"
end

-- Get project root directory (deprecated, kept for compatibility)
M.get_project_root = function()
  return vim.fn.getcwd()
end

-- Lazy dependency management
M.require_snacks = function()
  local ok, lazy_module = pcall(require, "p5.lazy")
  if ok then
    return lazy_module.require("snacks")
  end
  return nil
end

M.require_websocket = function()
  local ok, websocket = pcall(require, "websocket")
  if ok then
    return websocket
  end
  return nil
end

-- Unified notification with snacks fallback
M.notify_fallback = function(msg, level)
  local snacks = M.require_snacks()
  if snacks then
    vim.notify("[p5.nvim] " .. msg, level)
  else
    M.notify(msg, level)
  end
end

-- Validate file exists
M.validate_file = function(path, name, required)
  if vim.fn.filereadable(path) == 1 then
    return true
  elseif required then
    M.notify_fallback(name .. " not found: " .. path, "error")
  end
  return false
end

M.validate_dir = function(path, name, required)
  if vim.fn.isdirectory(path) == 1 then
    return true
  elseif required then
    M.notify_fallback(name .. " not found: " .. path, "error")
  end
  return false
end

-- Check if p5 assets are available
M.assets_available = function()
  local version_file = M.get_asset_dir() .. "/version.json"
  local has_p5 = vim.fn.filereadable(M.get_asset_dir() .. "/core/p5.js")
  local has_types = vim.fn.filereadable(M.get_asset_dir() .. "/types/p5.d.ts")
  return has_p5 and has_types
end

-- Read workspace configuration
M.read_workspace_config = function()
  local config_file = vim.fn.getcwd() .. "/p5.json"
  if vim.fn.filereadable(config_file) == 1 then
    local content = vim.fn.readfile(config_file)
    return vim.fn.json_decode(table.concat(content, "\n"))
  end
  return nil
end

-- Write workspace configuration
M.write_workspace_config = function(config)
  local config_file = vim.fn.getcwd() .. "/p5.json"
  local content = vim.fn.json_encode(config)
  vim.fn.writefile(vim.split(content, "\n"), config_file)
end

-- Show notification
M.notify = function(msg, level)
  local vim_level = vim.log.levels.INFO
  if level == "error" then
    vim_level = vim.log.levels.ERROR
  elseif level == "warn" then
    vim_level = vim.log.levels.WARN
  end
  
  vim.notify("[p5.nvim] " .. msg, vim_level)
end

-- Get cache directory for host system
M.get_cache_dir = function()
  local cache_home = os.getenv("XDG_CACHE_HOME") or vim.fn.expand("~/.cache")
  local cache_dir = cache_home .. "/p5.nvim"
  vim.fn.mkdir(cache_dir, "p")
  return cache_dir
end

-- Generate cache key for URL
M.generate_cache_key = function(url)
  return vim.fn.sha256(url):sub(1, 16)
end

-- Check if cached file is valid
M.is_cache_valid = function(cache_file, checksum)
  if vim.fn.filereadable(cache_file) == 0 then
    return false
  end
  
  -- Simple file existence check for now
  -- TODO: Add checksum validation if needed
  return true
end

-- Download file with progress tracking and caching
M.download_file_with_progress = function(url, dest, callback, options)
  options = options or {}
  local use_cache = options.cache ~= false
  local on_progress = options.on_progress
  local cache_file = nil
  
  if use_cache then
    local cache_dir = M.get_cache_dir()
    local cache_key = M.generate_cache_key(url)
    cache_file = cache_dir .. "/" .. cache_key
    
    -- Check if we have a valid cached version
    if M.is_cache_valid(cache_file) then
      vim.fn.system("cp '" .. cache_file .. "' '" .. dest .. "'")
      if callback then callback(true) end
      return true
    end
  end
  
  -- Get file size first for progress tracking
  M.get_remote_file_size(url, function(total_size)
    local cmd
    if M.command_exists("curl") then
      cmd = string.format("curl -L --progress-bar '%s' -o '%s'", url, dest)
    elseif M.command_exists("wget") then
      cmd = string.format("wget --progress=bar:force -O '%s' '%s'", dest, url)
    else
      M.notify("Neither curl nor wget found. Cannot download: " .. url, "error")
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
          vim.fn.system("cp '" .. dest .. "' '" .. cache_file .. "'")
        end
        
        if callback then callback(success) end
      end
    })
  end)
  
  return true
end

-- Download file with caching support (simplified version)
M.download_file = function(url, dest, callback, options)
  options = options or {}
  local use_cache = options.cache ~= false
  local cache_file = nil
  
  if use_cache then
    local cache_dir = M.get_cache_dir()
    local cache_key = M.generate_cache_key(url)
    cache_file = cache_dir .. "/" .. cache_key
    
    -- Check if we have a valid cached version
    if M.is_cache_valid(cache_file) then
      vim.fn.system("cp '" .. cache_file .. "' '" .. dest .. "'")
      if callback then callback(true) end
      return true
    end
  end
  
  local cmd
  if M.command_exists("curl") then
    cmd = string.format("curl -sL '%s' -o '%s'", url, dest)
  elseif M.command_exists("wget") then
    cmd = string.format("wget -q -O '%s' '%s'", url, dest)
  else
    M.notify("Neither curl nor wget found. Cannot download: " .. url, "error")
    if callback then callback(false) end
    return false
  end
  
  vim.fn.jobstart(cmd, {
    on_exit = function(_, exit_code)
      local success = exit_code == 0
      
      -- Cache the downloaded file if successful and caching enabled
      if success and use_cache and cache_file then
        vim.fn.system("cp '" .. dest .. "' '" .. cache_file .. "'")
      end
      
      if callback then callback(success) end
    end
  })
  
  return true
end

-- Get remote file size for progress tracking
M.get_remote_file_size = function(url, callback)
  local cmd
  if M.command_exists("curl") then
    cmd = string.format("curl -sI '%s' | grep -i content-length | cut -d' ' -f2 | tr -d '\\r'", url)
  elseif M.command_exists("wget") then
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
M.get_github_release_asset = function(repo, release, pattern, callback)
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

-- Get p5 version info
M.get_p5_version = function()
  local version_file = M.get_asset_dir() .. "/version.json"
  if vim.fn.filereadable(version_file) == 1 then
    local content = vim.fn.readfile(version_file)
    local info = vim.fn.json_decode(table.concat(content, "\n"))
    return {
      version = info.p5js_version or "unknown",
      semver = info.p5js_semver or "unknown"
    }
  end
  return nil
end

-- WebSocket initialization
M.init_websocket = function(error_msg)
  local ok, websocket = pcall(require, "websocket")
  if not ok then
    M.notify(error_msg or "WebSocket library not available", "error")
    return false
  end
  
  -- Initialize websocket library if setup function exists
  if websocket.setup then
    websocket.setup()
  end
  
  return true
end

-- Setup function
M.setup = function(config)
  M.config = config
end

-- Setup environment
M.setup_environment = function()
  local root = M.get_plugin_root()
  local asset_dir = M.get_asset_dir()
  
  -- Create necessary directories
  vim.fn.mkdir(asset_dir .. "/core", "p")
  vim.fn.mkdir(asset_dir .. "/types", "p")
  vim.fn.mkdir(asset_dir .. "/contrib", "p")
  
  -- Create servers directory
  vim.fn.mkdir(root .. "/servers", "p")
  
  -- Copy example configs
  if vim.fn.filereadable(root .. "/servers/python.js.example") and vim.fn.filereadable(root .. "/scripts/python.py.example") then
    vim.fn.system("cp " .. root .. "/scripts/python.py.example " .. root .. "/servers/python.py")
  end
  
  -- Create user configs
  vim.fn.writefile(vim.split([[
{
  "name": "p5.js Live Server",
    "version": "1.0.0",
    "default_port": 8000,
    "auto_port_start": 8001,
    "auto_port_end": 9000
  }
  ]], "\n"), root .. "/servers/config.default.json")
  
  vim.fn.writefile(vim.split([[
{
  "name": "p5.js Live Server (Python)",
    "version": "1.0.0",
    "default_port": 8000,
    "auto_port_start": 8001,
    "auto_port_end": 9000,
    "service": "python"
  }
  ]], "\n"), root .. "/servers/config.python.json")
  
  -- Create editor configs
  vim.fn.writefile(vim.split([[
{
  "name": "p5.js Live Server (Deno)",
    "version": "1.0.0",
    "default_port": 8000,
    "auto_port_start": 8001,
    "auto_port_end": 9000,
    "service": "deno"
  }
  ]], "\n"), root .. "/servers/config.deno.json")
  
  vim.fn.writefile(vim.split([[
{
  "name": "p5.js Live Server (Node)",
    "version": "1.0.0",
    "default_port": 8000,
    "auto_port_start": 8001,
    "auto_port_end": 9000,
    "service": "node"
  }
  ]], "\n"), root .. "/servers/config.node.json")
  
  vim.fn.writefile(vim.split([[
{
  "name": "p5.js Live Server (Bun)",
    "version": "1.0.0",
    "default_port": 8000,
    "auto_port_start": 8001,
    "auto_port_end": 9000,
    "service": "bun"
  }
  ]], "\n"), root .. "/servers/config.bun.json")
  
  -- Create editor configs
  vim.fn.writefile(root .. "/servers/config.deno.json", [[{
  "name": "p5.js Live Server (Deno)",
    "version": "1.0.0",
    "default_port": 8000,
    "auto_port_start": 8001,
    "auto_port_end": 9000,
    "service": "deno"
  }]])
  vim.fn.writefile(root .. "/servers/config.node.json", [[{
  "name": "p5.js Live Server (Node)",
    "version": "1.0.0",
    "default_port": 8000,
    "auto_port_start": 8001,
    "auto_port_end": 9000,
    "service": "node"
  }]])
  vim.fn.writefile(root .. "/servers/config.bun.json", [[{
  "name": "p5.js Live Server (Bun)",
    "version": "1.0.0",
    "default_port": 8000,
    "auto_port_start": 8001,
    "auto_port_end": 9000,
    "service": "bun"
  }]])
  
  -- Update version.json with current p5.js version if available
  if M.assets_available() then
    local info = M.get_p5_version()
    if info and info.version ~= "unknown" then
      local updated_at = vim.fn.strftime("%Y-%m-%dT%H:%M:%S")
      local version_json = {
        p5js = info.version,
        p5js_semver = info.semver,
        updated_at = updated_at
      }
      vim.fn.writefile(vim.split(vim.fn.json_encode(version_json), "\n"), M.get_asset_dir() .. "/version.json")
    end
  end
  
  -- Show setup completion message
  if M.assets_available() then
    M.notify_fallback("P5 environment setup complete", "info")
  end
end

return M