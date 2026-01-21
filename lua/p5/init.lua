local M = {}

-- Default configuration
local default_config = {
  port = 8000,
  default_version = "2.2.0",
  server_type = "auto",
  libraries = {
    sound = true,
    dom = false,
    ml5 = false,
    collide2d = false
  },
  auto_open = true,
  cache_dir = "~/.local/share/nvim/p5.nvim",
  console_log = true,
  statusline = {
    enabled = true,
    component = "p5"
  }
}

-- Setup function
function M.setup(opts)
  local user_config = vim.tbl_deep_extend("force", default_config, opts or {})

  -- Expand cache directory
  user_config.cache_dir = vim.fn.expand(user_config.cache_dir)

  -- Create cache directory
  vim.fn.mkdir(user_config.cache_dir, "p")

  -- Initialize config module
  require("p5.config").init(user_config)

  vim.notify("p5.nvim setup complete", vim.log.levels.INFO)
end

return M