vim.g.mapleader = " "
vim.g.lazy_dashboard_disable = 1
vim.opt.termguicolors = true

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { "nvim-lua/plenary.nvim" },
  { "folke/tokyonight.nvim", lazy = false, priority = 1000, opts = { style = "night" } },
  { "folke/snacks.nvim", priority = 1001, opts = { terminal = {}, picker = {}, toggle = {} } },
  { "prjctimg/p5.nvim", opts = {} },
  defaults = { lazy = false },
  install = { colorscheme = { "tokyonight" } },
})

vim.cmd.colorscheme("tokyonight")
