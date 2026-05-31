local C = require("p5.core")
local project = require("p5.project")
local server = require("p5.server")
local orig_is_win = vim.api.nvim_win_is_valid
local orig_is_p5 = project.is_p5_project
local orig_is_dir = C.is_dir
local orig_is_cmd = C.is_cmd
local orig_is_file = C.is_file
local orig_plugin_root = C.plugin_root
local orig_select = vim.ui.select

describe("console", function()
  local console = require("p5.console")
  local tmp = vim.fn.tempname()
  local orig_cwd = vim.fn.getcwd()

  before_each(function()
    vim.fn.mkdir(tmp, "p")
    vim.fn.chdir(tmp)
    console.win = nil
    console.buf = nil
    console.job = nil
    console.term = nil
    console.port = nil
    console.attempts = 0
    console.config = { console = { position = "below", height = 10 } }
    server.server_job = 1
    server.port = 9999
    project.is_p5_project = function(_) return true end
    vim.api.nvim_win_is_valid = function(_) return false end
    C.is_dir = function(_) return true end
    C.is_cmd = function(_) return true end
    C.is_file = function(_) return true end
    C.plugin_root = function() return tmp end
    vim.ui.select = function(_, _, cb) if cb then cb() end end
  end)

  after_each(function()
    vim.fn.chdir(orig_cwd)
    vim.fn.delete(tmp, "rf")
    vim.api.nvim_win_is_valid = orig_is_win
    project.is_p5_project = orig_is_p5
    C.is_dir = orig_is_dir
    C.is_cmd = orig_is_cmd
    C.is_file = orig_is_file
    C.plugin_root = orig_plugin_root
    vim.ui.select = orig_select
    server.server_job = nil
    server.port = nil
  end)

  describe("show", function()
    it("warns when not in a p5 project", function()
      project.is_p5_project = function(_) return false end
      local ok, err = pcall(console.show, { enter = false })
      assert.is_true(ok, "show not in project should not crash: " .. tostring(err))
    end)
  end)

  describe("hide", function()
    it("does not crash when no window open", function()
      console.win = nil
      local ok, err = pcall(console.hide)
      assert.is_true(ok, "hide with no win should not crash: " .. tostring(err))
    end)
  end)

  describe("toggle", function()
    it("does not crash when nothing is open", function()
      local ok, err = pcall(console.toggle)
      assert.is_true(ok, "toggle from closed should not crash: " .. tostring(err))
    end)
  end)

  describe("clear", function()
    it("does not crash when no buffer", function()
      console.buf = nil
      local ok, err = pcall(console.clear)
      assert.is_true(ok, "clear with no buf should not crash: " .. tostring(err))
    end)
  end)

  describe("mark_error", function()
    it("sets last_error timestamp", function()
      console.last_error = 0
      console.mark_error()
      assert.is_true(console.last_error > 0)
    end)
  end)
end)
