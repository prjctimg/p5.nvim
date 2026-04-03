vim.opt.runtimepath:append(".")
vim.opt.runtimepath:append("..")
vim.opt.runtimepath:append(vim.fn.expand("~/.local/share/nvim/lazy/plenary.nvim"))

package.path = "./lua/?.lua;./lua/?/init.lua;~/.local/share/nvim/lazy/plenary.nvim/lua/?.lua;~/.local/share/nvim/lazy/plenary.nvim/lua/?/init.lua;" .. package.path
