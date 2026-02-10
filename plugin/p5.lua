-- vim: ts=2 sw=2 et

-- Plugin registration for p5.nvim
if vim.fn.has('nvim-0.9.0') == 0 then
  vim.api.nvim_err_writeln('p5.nvim requires Neovim >= 0.9.0')
  return
end

-- User commands
vim.api.nvim_create_user_command('P5CreateProject', function(opts)
  local project = require("p5.project")
  local name = opts.args and opts.args ~= "" and opts.args or "p5-sketch"
  project.create_project(name)
end, {
  nargs = '?',
  complete = 'file',
  desc = 'Create a new p5.js project'
})

-- Load the plugin
require('p5')