-- Minimal init for plenary test harness
vim.g.mapleader = " "

local root = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h:h")
vim.opt.rtp:prepend(root)
