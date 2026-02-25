-- P5 command picker tests
-- Test that the P5 command picker includes all the new options

-- Test P5 command picker functionality
local function test_p5_command_picker_options()
  local init = require("p5.init")
  local project = require("p5.project")
  local core = require("p5.core")
  
  -- Mock project as not being a sketchspace
  local original_is_p5 = project.is_p5_project
  project.is_p5_project = function()
    return true, "Valid p5.js sketchspace detected", {has_sketch = true}
  end
  
  -- Mock server status
  local server = require("p5.server")
  local original_server_job = server.server_job
  server.server_job = nil
  
  -- Test that picker shows correct options (without args)
  local select_options = nil
  local original_select = vim.ui.select
  vim.ui.select = function(options, opts, callback)
    select_options = options
    callback(nil)  -- Cancel the selection
  end
  
  -- Call P5 command picker
  local success, err = pcall(function()
    vim.cmd("P5")
  end)
  
  -- Verify options
  assert(success, "P5 command should execute: " .. tostring(err))
  assert(select_options ~= nil, "vim.ui.select should be called")
  
  -- Check all expected options are present
  local expected = {
    "Create new sketchspace",
    "Setup sketchspace",
    "Install library",
    "Uninstall library",
    "Start server",
    "Toggle console",
    "Open docs",
    "Sync",
    "Create/update Gist",
  }
  
  for _, opt in ipairs(expected) do
    local found = false
    for _, o in ipairs(select_options) do
      if o == opt then
        found = true
        break
      end
    end
    assert(found, "Option '" .. opt .. "' should be in picker")
  end
  
  -- Restore mocks
  vim.ui.select = original_select
  project.is_p5_project = original_is_p5
  server.server_job = original_server_job
end

-- Test P5 install requires sketchspace
local function test_install_requires_sketchspace()
  local project = require("p5.project")
  local core = require("p5.core")
  
  -- Mock not in sketchspace
  local original_is_p5 = project.is_p5_project
  project.is_p5_project = function()
    return false, "No p5.json found"
  end
  
  local notify_called = false
  local original_notify = core.notify
  core.notify = function(msg, level)
    notify_called = true
    assert(level == "error", "Should be error level")
    assert(msg:match("requires a sketchspace"), "Message should mention sketchspace requirement")
  end
  
  vim.cmd("P5Install")
  
  assert(notify_called, "Notify should be called when not in sketchspace")
  
  -- Restore
  core.notify = original_notify
  project.is_p5_project = original_is_p5
end

-- Test P5 uninstall requires sketchspace
local function test_uninstall_requires_sketchspace()
  local project = require("p5.project")
  local core = require("p5.core")
  
  -- Mock not in sketchspace
  local original_is_p5 = project.is_p5_project
  project.is_p5_project = function()
    return false, "No p5.json found"
  end
  
  local notify_called = false
  local original_notify = core.notify
  core.notify = function(msg, level)
    notify_called = true
    assert(level == "error", "Should be error level")
  end
  
  vim.cmd("P5Uninstall")
  
  assert(notify_called, "Notify should be called when not in sketchspace")
  
  -- Restore
  core.notify = original_notify
  project.is_p5_project = original_is_p5
end

-- Test P5 gist requires sketchspace
local function test_gist_requires_sketchspace()
  local project = require("p5.project")
  local core = require("p5.core")
  
  -- Mock not in sketchspace
  local original_is_p5 = project.is_p5_project
  project.is_p5_project = function()
    return false, "No p5.json found"
  end
  
  local notify_called = false
  local original_notify = core.notify
  core.notify = function(msg, level)
    notify_called = true
    assert(level == "error", "Should be error level")
  end
  
  vim.cmd("P5Gist")
  
  assert(notify_called, "Notify should be called when not in sketchspace")
  
  -- Restore
  core.notify = original_notify
  project.is_p5_project = original_is_p5
end

-- Test P5 setup requires sketchspace
local function test_setup_requires_sketchspace()
  local project = require("p5.project")
  local core = require("p5.core")
  
  -- Mock not in sketchspace
  local original_is_p5 = project.is_p5_project
  project.is_p5_project = function()
    return false, "No p5.json found"
  end
  
  local notify_called = false
  local original_notify = core.notify
  core.notify = function(msg, level)
    notify_called = true
    assert(level == "error", "Should be error level")
  end
  
  vim.cmd("P5Setup")
  
  assert(notify_called, "Notify should be called when not in sketchspace")
  
  -- Restore
  core.notify = original_notify
  project.is_p5_project = original_is_p5
end

-- Test P5 sync shows picker when no args
local function test_sync_picker()
  local project = require("p5.project")
  
  -- Mock in sketchspace
  local original_is_p5 = project.is_p5_project
  project.is_p5_project = function()
    return true, "Valid sketchspace"
  end
  
  local select_called = false
  local original_select = vim.ui.select
  vim.ui.select = function(options, opts, callback)
    select_called = true
    callback(nil)
  end
  
  vim.cmd("P5Sync")
  
  assert(select_called, "vim.ui.select should be called when no args")
  
  -- Restore
  vim.ui.select = original_select
  project.is_p5_project = original_is_p5
end

-- Test P5 sync gist
local function test_sync_gist()
  local project = require("p5.project")
  local gist = require("p5.gist")
  
  -- Mock in sketchspace with gist
  local original_is_p5 = project.is_p5_project
  project.is_p5_project = function()
    return true, "Valid sketchspace"
  end
  
  local original_find = core.find_project_root
  core.find_project_root = function()
    return "/tmp/test", {gist = "https://gist.github.com/user/abc123"}
  end
  
  local gist_updated = false
  local original_update = gist.update_gist
  gist.update_gist = function(id)
    gist_updated = true
  end
  
  vim.cmd("P5Sync gist")
  
  assert(gist_updated, "gist.update_gist should be called")
  
  -- Restore
  gist.update_gist = original_update
  core.find_project_root = original_find
  project.is_p5_project = original_is_p5
end

-- Run all tests
print("Running p5.nvim P5 command picker tests...")
print("=" .. string.rep("=", 50))

local tests = {
  test_p5_command_picker_options,
  test_install_requires_sketchspace,
  test_uninstall_requires_sketchspace,
  test_gist_requires_sketchspace,
  test_setup_requires_sketchspace,
  test_sync_picker,
  test_sync_gist,
}

local passed = 0
local failed = 0

for _, test in ipairs(tests) do
  local success, err = pcall(test)
  if success then
    print("✓ " .. test.__name__ or tostring(test))
    passed = passed + 1
  else
    print("✗ " .. test.__name__ or tostring(test))
    print("  Error: " .. tostring(err))
    failed = failed + 1
  end
end

print("=" .. string.rep("=", 50))
print(string.format("Tests completed: %d passed, %d failed", passed, failed))

if failed > 0 then
  os.exit(1)
end
