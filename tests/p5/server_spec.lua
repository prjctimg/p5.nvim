local C = require("p5.core")
local project = require("p5.project")
local orig_is_cmd = C.is_cmd
local orig_is_file = C.is_file
local orig_is_dir = C.is_dir
local orig_plugin_root = C.plugin_root
local orig_is_p5 = project.is_p5_project
local orig_select = vim.ui.select
local orig_jobstart = vim.fn.jobstart

local function mock_jobstart(S, captured_cmd)
  vim.fn.jobstart = function(cmd, opts)
    if type(cmd) == "table" and type(cmd[1]) == "string" and cmd[1]:match("p5d") then
      captured_cmd[1] = cmd
      S.server_job = 1
      if opts and opts.on_exit then opts.on_exit(0, 0, "exit") end
    elseif opts and opts.on_exit then
      opts.on_exit(0, 0)
    end
    return 1
  end
end

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
    C.is_cmd = orig_is_cmd
    C.is_file = function(p)
      if type(p) == "string" and p:match("p5d$") then return true end
      return orig_is_file(p)
    end
    C.is_dir = function(p) return orig_is_dir(p) end
    C.plugin_root = function() return tmp end
    project.is_p5_project = function(_) return true end
    vim.ui.select = function(_, _, cb) if cb then cb() end end
    mock_jobstart(S, {})
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
    vim.fn.jobstart = orig_jobstart
    S.server_job = nil
  end)

  it("does not crash when not in a sketchspace", function()
    project.is_p5_project = function(_) return false, "No p5.json" end
    local ok, err = pcall(S.start, 8000)
    assert.is_true(ok, "start should not crash: " .. tostring(err))
  end)

  it("does not crash when server binary is missing", function()
    C.is_file = function(_) return false end
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

describe("server.start CLI args", function()
  local S = require("p5.server")
  local tmp = vim.fn.tempname()
  local orig_cwd = vim.fn.getcwd()
  local captured_cmd = {}

  before_each(function()
    vim.fn.mkdir(tmp, "p")
    vim.fn.chdir(tmp)
    S.server_job = nil
    S.port = nil
    S.type = nil
    C.is_file = function(p)
      if type(p) == "string" and p:match("p5d$") then return true end
      return orig_is_file(p)
    end
    C.is_dir = function(p) return orig_is_dir(p) end
    C.plugin_root = function() return tmp end
    project.is_p5_project = function(_) return true end
    vim.ui.select = function(_, _, cb) if cb then cb() end end
    captured_cmd = {}
    mock_jobstart(S, captured_cmd)
  end)

  after_each(function()
    vim.fn.chdir(orig_cwd)
    vim.fn.delete(tmp, "rf")
    C.is_file = orig_is_file
    C.is_dir = orig_is_dir
    C.plugin_root = orig_plugin_root
    project.is_p5_project = orig_is_p5
    vim.ui.select = orig_select
    vim.fn.jobstart = orig_jobstart
    S.server_job = nil
  end)

  it("forwards --lr-port and --lr-debounce flags", function()
    S.start(8000)
    assert.truthy(captured_cmd[1], "captured_cmd should be set")
    local joined = table.concat(captured_cmd[1], " ")
    assert.truthy(joined:match("%-%-lr%-port"))
    assert.truthy(joined:match("%-%-lr%-debounce"))
  end)

  it("includes --lr-extensions with default extensions", function()
    S.start(8000)
    assert.truthy(captured_cmd[1])
    local joined = table.concat(captured_cmd[1], " ")
    assert.truthy(joined:match("%-%-lr%-extensions"))
    assert.truthy(joined:match("%.js"))
    assert.truthy(joined:match("%.css"))
  end)

  it("includes --lr-exclude with default exclude dirs", function()
    S.start(8000)
    assert.truthy(captured_cmd[1])
    local joined = table.concat(captured_cmd[1], " ")
    assert.truthy(joined:match("%-%-lr%-exclude"))
    assert.truthy(joined:match("%.git"))
    assert.truthy(joined:match("node_modules"))
  end)

  it("does not pass --lr-disabled when enabled is true", function()
    S.start(8000)
    assert.truthy(captured_cmd[1])
    local joined = table.concat(captured_cmd[1], " ")
    assert.falsy(joined:match("%-%-lr%-disabled"))
  end)

  it("passes --lr-disabled when enabled is false", function()
    S.config.live_reload.enabled = false
    S.start(8000)
    assert.truthy(captured_cmd[1])
    local joined = table.concat(captured_cmd[1], " ")
    assert.truthy(joined:match("%-%-lr%-disabled"))
    S.config.live_reload.enabled = true
  end)

  it("forwards custom port from config", function()
    S.config.live_reload.port = 9999
    S.start(8000)
    assert.truthy(captured_cmd[1])
    local joined = table.concat(captured_cmd[1], " ")
    assert.truthy(joined:match("%-%-lr%-port"))
    assert.truthy(joined:match("9999"))
    S.config.live_reload.port = 12002
  end)

  it("forwards --cdp-port from config", function()
    S.config.cdp = { remote_debugging_port = 9333, enabled = true }
    S.start(8000)
    assert.truthy(captured_cmd[1])
    local joined = table.concat(captured_cmd[1], " ")
    assert.truthy(joined:match("%-%-cdp%-port"))
    assert.truthy(joined:match("9333"))
    S.config.cdp = nil
  end)

  it("does not pass --cdp-port when cdp config is absent", function()
    S.config.cdp = nil
    S.start(8000)
    assert.truthy(captured_cmd[1])
    local joined = table.concat(captured_cmd[1], " ")
    assert.falsy(joined:match("%-%-cdp%-port"))
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
