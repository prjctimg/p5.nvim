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

-- Setup environment
M.setup_environment = function()
  local root = M.get_plugin_root()
  local asset_dir = M.get_asset_dir()
  
  -- Create necessary directories
  vim.fn.mkdir(asset_dir .. "/core", "p")
  vim.fn.mkdir(asset_dir .. "/types", "p")
  vim.fn.mkdir(asset_dir .. "/contrib", "p")
  vim.fn.mkdir(root .. "/scripts/live-server", "p")
  
  M.notify("P5 environment setup ok", "info")
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
    local snacks = require("snacks")
    snacks.notifier.show("Neither curl nor wget found", "error")
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

-- Show notification
M.notify = function(msg, level)
  level = level or "info"
  vim.notify("[p5.nvim] " .. msg, vim.log.levels.INFO)
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

M.setup = function(config)
  M.config = config
end

return M