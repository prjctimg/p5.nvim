local C = require("p5.core")
local project = require("p5.project")
local orig_is_cmd = C.is_cmd
local orig_is_file = C.is_file
local orig_is_dir = C.is_dir
local orig_plugin_root = C.plugin_root
local orig_is_p5 = project.is_p5_project
local orig_select = vim.ui.select

describe("server.start", function()
  local S = require("p5.server")
  local tmp = vim.fn.tempname()
  local orig_cwd = vim.fn.getcwd()

  before_each(function()
    vim.fn.mkdir(tmp, "p")
    vim.fn.chdir(tmp)
    S.server_job = nil
    S.port = nil
    S.type = nil
    C.is_cmd = function(cmd)
      if cmd == "python3" then return true end
      if cmd == "lsof" then return true end
      return orig_is_cmd(cmd)
    end
    C.is_file = function(_) return true end
    C.is_dir = function(_) return true end
    C.plugin_root = function() return tmp end
    project.is_p5_project = function(_) return true end
    vim.ui.select = function(_, _, cb) if cb then cb() end end
  end)

  after_each(function()
    vim.fn.chdir(orig_cwd)
    vim.fn.delete(tmp, "rf")
    C.is_cmd = orig_is_cmd
    C.is_file = orig_is_file
    C.is_dir = orig_is_dir
    C.plugin_root = orig_plugin_root
    project.is_p5_project = orig_is_p5
    vim.ui.select = orig_select
    S.server_job = nil
  end)

  it("does not crash when not in a sketchspace", function()
    project.is_p5_project = function(_) return false, "No p5.json" end
    local ok, err = pcall(S.start, 8000)
    assert.is_true(ok, "start should not crash: " .. tostring(err))
  end)

  it("does not crash when python3 is missing", function()
    C.is_cmd = function(cmd)
      if cmd == "python3" then return false end
      return false
    end
    local ok, err = pcall(S.start, 8000)
    assert.is_true(ok, "start should not crash: " .. tostring(err))
  end)

  it("does not crash with invalid port", function()
    local ok, err = pcall(S.start, 0)
    assert.is_true(ok, "port 0 should not crash: " .. tostring(err))
    local ok2, err2 = pcall(S.start, 70000)
    assert.is_true(ok2, "port 70000 should not crash: " .. tostring(err2))
  end)
end)

describe("server.stop_server", function()
  local S = require("p5.server")

  after_each(function()
    S.server_job = nil
  end)

  it("does not crash when no server running", function()
    S.server_job = nil
    local ok, err = pcall(S.stop_server)
    assert.is_true(ok, "stop should not crash when no server: " .. tostring(err))
  end)
end)
