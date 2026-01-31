-- Core utilities and functions for p5.nvim
local M = {}

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

  -- Lazy dependency management
  M.require_snacks = function()
    local ok, lazy_module = pcall(require, "p5.lazy")
    if ok then
      return lazy_module.require("snacks")
    end
    return nil
  end
  
  M.require_websocket = function()
    local ok, lazy_module = pcall(require, "p5.lazy")
    if ok then
      return lazy_module.require("websocket")
    end
    return nil
  end

  -- Setup environment
  M.setup_environment = function()
    local root = M.get_plugin_root()
    local asset_dir = M.get_asset_dir()
    
    -- Create necessary directories
    vim.fn.mkdir(asset_dir .. "/core", "p")
    vim.fn.mkdir(asset_dir .. "/types", "p")
    vim.fn.mkdir(asset_dir .. "/contrib", "p")
    vim.fn.mkdir(root .. "/scripts/live-server", "p")
    
    local snacks = M.require_snacks()
    if snacks then
      snacks.notifier.show("P5 environment setup ok", "info")
    else
      vim.notify("P5 environment setup ok", "info")
    end
  end

-- Read p5.json configuration
M.read_workspace_config = function()
  local config_file = vim.fn.getcwd() .. "/p5.json"
  if vim.fn.filereadable(config_file) == 0 then
    return nil
  end
  
  local content = vim.fn.readfile(config_file)
  return vim.fn.json_decode(table.concat(content, "\n"))
end

-- Write p5.json configuration
M.write_workspace_config = function(config)
  local config_file = vim.fn.getcwd() .. "/p5.json"
  local content = vim.fn.json_encode(config)
  vim.fn.writefile(vim.split(content, "\n"), config_file)
end

-- Download file using curl or wget
M.download_file = function(url, dest, callback)
  local cmd
  if M.command_exists("curl") then
    cmd = string.format("curl -sL '%s' -o '%s'", url, dest)
  elseif M.command_exists("wget") then
    cmd = string.format("wget -q -O '%s' '%s'", dest, url)
  else
    M.notify_fallback("Neither curl nor wget found", "error")
  return false
  end

  vim.fn.jobstart(cmd, {
    on_exit = function(_, exit_code)
      if callback then
        callback(exit_code == 0)
      end
    end
  })
  
  return true
end

-- Server command lookup tables
M.server_configs = {
  python = {cmd = "python3", check = "python3", script = "python.py"},
  bun = {cmd = "bun", check = "bun", script = "bun.js"},
  deno = {cmd = "deno", check = "deno", script = "deno.js"},
  node = {cmd = "node", check = "node", script = "node.js"}
}

M.split_commands = {
  below = "botright %d new",
  above = "topleft %d new", 
  left = "topleft vertical %d new",
  right = "botright vertical %d new"
}

-- WebSocket initialization helper
M.init_websocket = function(error_msg)
  local websocket = M.require_websocket()
  if not websocket then
    M.notify_fallback(error_msg or "WebSocket library not available", "error")
    return false
  end
  websocket.setup({})
  return true
end

-- Show notification
M.notify = function(msg, level)
  level = level or "info"
  local vim_level = vim.log.levels.INFO
  if level == "error" then
    vim_level = vim.log.levels.ERROR
  elseif level == "warn" then
    vim_level = vim.log.levels.WARN
  end
  
  vim.notify("[p5.nvim] " .. msg, vim_level)
end

-- Unified notification with snacks fallback
M.notify_fallback = function(msg, level)
  local snacks = M.require_snacks()
  if snacks then
    snacks.notify.info(msg, {title = "p5.nvim"})
  else
    M.notify(msg, level)
  end
end

-- File validation helpers
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

-- Validate p5 project directory
M.is_p5_project = function()
  local config = M.read_workspace_config()
  return config ~= nil
end

-- Get p5 version info
M.get_p5_version = function()
  local version_file = M.get_asset_dir() .. "/version.json"
  if vim.fn.filereadable(version_file) == 0 then
    return nil
  end
  
  local content = vim.fn.readfile(version_file)
  return vim.fn.json_decode(table.concat(content, "\n"))
end

-- Check if assets are available
M.assets_available = function()
  local version_file = M.get_asset_dir() .. "/version.json"
  local has_core = vim.fn.filewritable(M.get_asset_dir() .. "/core/p5.js")
  local has_types = vim.fn.filewritable(M.get_asset_dir() .. "/types/p5.d.ts")
  
  return vim.fn.filereadable(version_file) and has_core and has_types
end

-- Download core assets (p5.js, types, etc)
M.download_core_assets = function()
  local asset_dir = M.get_asset_dir()
  local version_info = M.get_p5_version()
  if not version_info then
    M.notify("Unable to get version info", "warn")
    return
  end
  
  local p5_version = version_info.p5js_semver or "latest"
  local types_version = version_info.types or "latest"
  
  M.notify("Downloading p5.js core assets v" .. p5_version, "info")
  
  -- Download core libraries
  local core_urls = {
    ["https://cdn.jsdelivr.net/npm/p5@" .. p5_version .. "/lib/p5.js"] = asset_dir .. "/core/p5.js",
    ["https://cdn.jsdelivr.net/npm/p5@" .. p5_version .. "/lib/p5.min.js"] = asset_dir .. "/core/p5.min.js",
    ["https://cdn.jsdelivr.net/npm/p5@" .. p5_version .. "/lib/addons/p5.sound.js"] = asset_dir .. "/core/p5.sound.js",
    ["https://cdn.jsdelivr.net/npm/p5@" .. p5_version .. "/lib/addons/p5.sound.min.js"] = asset_dir .. "/core/p5.sound.min.js"
  }
  
  -- Download TypeScript definitions
  local types_urls = {
    ["https://cdn.jsdelivr.net/npm/@types/p5@" .. types_version .. "/index.d.ts"] = asset_dir .. "/types/p5.d.ts",
    ["https://cdn.jsdelivr.net/npm/@types/p5@" .. types_version .. "/constants.d.ts"] = asset_dir .. "/types/constants.d.ts",
    ["https://cdn.jsdelivr.net/npm/@types/p5@" .. types_version .. "/literals.d.ts"] = asset_dir .. "/types/literals.d.ts"
  }
  
  local total_downloads = 0
  local completed_downloads = 0
  
  -- Download all core assets
  for url, dest in pairs(core_urls) do
    total_downloads = total_downloads + 1
    M.download_file(url, dest, function(success)
      if success then
        completed_downloads = completed_downloads + 1
        M.notify("Downloaded " .. vim.fn.fnamemodify(dest, ":t"), "ok")
      else
        M.notify("Failed to download " .. url, "error")
      end
    end)
  end
  
  -- Download all type definitions
  for url, dest in pairs(types_urls) do
    total_downloads = total_downloads + 1
    M.download_file(url, dest, function(success)
      if success then
        completed_downloads = completed_downloads + 1
        M.notify("Downloaded " .. vim.fn.fnamemodify(dest, ":t"), "ok")
      else
        M.notify("Failed to download " .. url, "error")
      end
    end)
  end
  
  M.notify("Core assets download complete: " .. completed_downloads .. "/" .. total_downloads, "ok")
  
  -- Create consolidated global types file for better global mode support
  M.create_consolidated_types = function()
    local types_dir = M.get_asset_dir() .. "/types"
    local output_file = types_dir .. "/p5-global.d.ts"
    
    -- Create header
    local header = [[// Consolidated p5.js global types for p5.nvim
// Generated by p5.nvim asset management
// Version: ]] .. os.date("%Y-%m-%dT%H:%M:%SZ") .. [[

// Footer
declare module 'p5';

// Re-export everything for global access
export * from './p5.d.ts';
]]
    
    -- Write consolidated file
    vim.fn.writefile(vim.split(header, "\n"), output_file)
    M.notify("Created consolidated p5-global.d.ts", "ok")
  end
end

-- Setup core module
M.setup = function(config)
  M.config = config
  
  -- Auto-download assets on first use if not available
  if not M.assets_available() then
    M.download_core_assets()
  end
end

return M