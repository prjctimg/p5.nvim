#!/usr/bin/env nvim
-- Run tests using Neovim's built-in test harness
-- Usage: nvim --headless -l tests/run.lua

local plenary_path = vim.fn.expand("~/.local/share/nvim/lazy/plenary.nvim")
vim.opt.runtimepath:append(".")
vim.opt.runtimepath:append("..")
vim.opt.runtimepath:append(plenary_path)

package.path = "./lua/?.lua;./lua/?/init.lua;" .. plenary_path .. "/lua/?.lua;" .. plenary_path .. "/lua/?/init.lua;" .. package.path

local plenary = require("plenary.test_harness")
plenary.test_directory("tests/spec/", {
  minimal_init = "tests/minimal_init.lua",
  sequential = true,
})
