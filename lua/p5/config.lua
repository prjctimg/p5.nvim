local M = {}

-- Store configuration
local config = {}

-- Initialize configuration
function M.init(user_config)
  config = user_config or {}
end

-- Get configuration value
function M.get(key)
  if key then
    return config[key]
  end
  return config
end

-- Get cache directory
function M.get_cache_dir()
  return config.cache_dir or vim.fn.expand("~/.local/share/nvim/p5.nvim")
end

-- Get port
function M.get_port()
  return config.port or 8000
end

-- Get server type
function M.get_server_type()
  return config.server_type or "auto"
end

-- Get default version
function M.get_default_version()
  return config.default_version or "2.2.0"
end

-- Check if auto-open is enabled
function M.auto_open_enabled()
  return config.auto_open ~= false
end

-- Get library configuration
function M.get_libraries()
  return config.libraries or {}
end

return M