vim.g.mapleader = " "
local repo = vim.fn.fnamemodify(vim.fn.expand("<sfile>"), ":p:h:h")
vim.opt.rtp:prepend(repo)
vim.opt.termguicolors = true
require("tokyonight").setup({ style = "night" })
vim.cmd.colorscheme("tokyonight")
require("snacks").setup({ terminal = {}, picker = {}, toggle = {} })
require("p5").setup({})
