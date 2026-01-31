-- Dependency management module for p5.nvim
local M = {}

-- Require a plugin with error handling
M.require = function(plugin_name)
  local ok, plugin = pcall(require, plugin_name)
  if ok then
    return plugin
  end
  return nil
end

-- Require an optional plugin with warning
M.require_opt = function(plugin_name, warning_msg)
  local ok, plugin = pcall(require, plugin_name)
  if not ok and warning_msg then
    if vim and vim.notify then
      vim.notify(warning_msg, vim.log.levels.WARN)
    end
  end
  return ok and plugin or nil
end

-- Export dependency management functions
local dependency_api = {
  require = M.require,
  require_opt = M.require_opt
}

-- Lazy.nvim plugin spec that also exports the API
local plugin_spec = {
  "Your Name/p5.nvim",
  dir = vim.fn.stdpath("config") .. "/lazy/p5.nvim",
  name = "p5.nvim",
  version = "1.0.0",
  lazy = false,
  dependencies = {
    "folke/snacks.nvim",
    "samuelcolvin/websocket.nvim",
  }
}

-- Copy dependency API functions to the plugin spec
for k, v in pairs(dependency_api) do
  plugin_spec[k] = v
end

return plugin_spec