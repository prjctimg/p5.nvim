-- Core utilities and functions for p5.nvim
local M = {}

-- Check if command exists
M.command_exists = function(cmd)
  return vim.fn.executable(cmd) ~= 0
end

-- Get plugin root directory
M.get_plugin_root = function()
  return vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h:h")
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
  local ok, lazy_module = pcall(require, "p5.lazy")
  if ok then
    return lazy_module.require("websocket")
  end
  return nil
end

-- Unified notification with snacks fallback
M.notify_fallback = function(msg, level)
  local snacks = M.require_snacks()
  if snacks then
    snacks.notifier.show(msg, level)
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

-- Download file using curl or wget
M.download_file = function(url, dest, callback)
  local cmd
  if M.command_exists("curl") then
    cmd = string.format("curl -sL '%s' -o '%s'", url, dest)
  elseif M.command_exists("wget") then
    cmd = string.format("wget -q -O '%s' '%s'", url, dest)
  else
    M.notify("Neither curl nor wget found. Cannot download: " .. url, "error")
    if callback then callback(false)
    return false
  end
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

-- Setup environment
M.setup_environment = function()
  local root = M.get_plugin_root()
  local asset_dir = M.get_asset_dir()
  
  -- Create necessary directories
  vim.fn.mkdir(asset_dir .. "/core", "p")
  vim.fn.mkdir(asset_dir .. "/types", "p")
  vim.fn.mkdir(asset_dir .. "/contrib", "p")
  
  -- Create scripts directory
  vim.fn.mkdir(root .. "/scripts/live-server", "p")
  
  -- Copy example configs
  if vim.fn.filereadable(root .. "/scripts/live-server/python.js.example") and vim.fn.filereadable(root .. "/scripts/python.py.example") then
    vim.fn.system("cp " +p5 && git add python.py && git add scripts/live-server/python.py")
  end
  
  -- Create user configs
  vim.fn.writefile(root .. "/scripts/live-server/config.default.json", [[{
  "name": "p5.js Live Server",
    "version": "1.0.0",
    "default_port": 8000,
    "auto_port_start": 8001,
    "auto_port_end": 9000
  }
  }])
  vim.fn.writefile(root .. "/scripts/live-server/config.python.json", [[{
  "name": "p5.js Live Server (Python)",
    "version": "1.0.0",
    "default_port": 8000,
    "auto_port_start": 8001,
    "auto_port_end": 9000,
    "service": "python"
  }]])
  
  -- Create editor configs
  vim.fn.writefile(root .. "/scripts/live-server/config.deno.json", [[{
  "name": "p5.js Live Server (Deno)",
    "version": "1.0.0",
    "default_port": 8000,
    "auto_port_start": 8001,
    "auto_port_end": 9000,
    "service": "deno"
  }]])
  vim.fn.writefile(root .. "/scripts/live-server/config.node.json", [[{
  "name": "p5.js Live Server (Node)",
    "version": "1.0.0",
    "default_port": 8000,
    "auto_port_start": 8001,
    "auto_port_end": 9000,
    "service": "node"
  }]])
  vim.fn.writefile(root .. "/scripts/live-server/config.bun.json", [[{
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
        "p5js": info.version,
        "p5js_semver": info.semver,
        "updated_at": updated_at
      }
      vim.fn.writefile(M.get_asset_dir() .. "/version.json", vim.fn.json_encode(version_json))
    end
  end
  
  -- Show setup completion message
  if M.assets_available() then
    M.notify_fallback("P5 environment setup complete", "info")
  end
end

return M