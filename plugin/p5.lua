-- vim: ts=2 sw=2 et

-- Plugin registration for p5.nvim
if vim.fn.has('nvim-0.9.0') == 0 then
  vim.api.nvim_err_writeln('p5.nvim requires Neovim >= 0.9.0')
  return
end

-- Load the plugin
require('p5')