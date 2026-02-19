-- Dependency management module for p5.nvim
local L = {}

-- Require a plugin with error handling
L.require = function(plugin_name)
  local ok, plugin = pcall(require, plugin_name)
  if ok then
    return plugin
  end
  return nil
end

-- Require an optional plugin with warning
L.require_opt = function(plugin_name, warning_msg)
  local ok, plugin = pcall(require, plugin_name)
  if not ok and warning_msg then
    if vim and vim.notify then
      vim.notify(warning_msg, vim.log.levels.WARN)
    end
  end
  return ok and plugin or nil
end

-- Setup function
L.setup = function(config)
  L.config = config
end

return L