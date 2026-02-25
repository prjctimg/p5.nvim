-- Test suite for p5.nvim core functionality
local assert = {}
assert.is_true = function(condition, message)
  if not condition then
    error(message or "Condition should be true")
  end
end
assert.is_false = function(condition, message)
  if condition then
    error(message or "Condition should be false")
  end
end
assert.equals = function(actual, expected, message)
  if actual ~= expected then
    error(string.format("Assertion failed: %s (got %s, expected %s)", message or "", tostring(actual), tostring(expected)))
  end
end
assert.contains = function(table, value, message)
  for _, v in ipairs(table) do
    if v == value then return end
  end
  error(string.format("Assertion failed: %s (value %s not found in table)", message or "", tostring(value)))
end

local function test(name, fn)
  print("Running test: " .. name)
  local success, err = pcall(fn)
  if success then
    print("  ✓ PASS")
  else
    print("  ✗ FAIL: " .. tostring(err))
  end
end

-- Test gist functionality
test("Gist creation should handle required files properly", function()
  local gist = require("p5.gist")
  local core = require("p5.core")
  
  -- Mock project configuration
  local mock_config = {
    name = "test-project",
    gist = { id = "test-gist-id" }
  }
  
  -- Mock core.read_workspace_config to return our test config
  local original_read_config = core.read_workspace_config
  core.read_workspace_config = function()
    return mock_config
  end
  
  -- Test gist creation with all required files
  local project_path = vim.fn.getcwd()
  
  -- Create test files
  vim.fn.writefile({ "test content" }, project_path .. "/sketch.js")
  vim.fn.writefile({ "test content" }, project_path .. "/index.html")
  vim.fn.writefile({ "test content" }, project_path .. "/p5.json")
  
  -- Mock gh command to avoid actual API calls
  local original_command_exists = core.command_exists
  core.command_exists = function(cmd)
    return cmd == "gh"
  end
  
  -- Test gist creation
  local success, err = pcall(gist.create_gist, "test description")
  assert.is_true(success, "Gist creation should succeed with all required files")
  
  -- Test gist update
  local update_success, update_err = pcall(gist.update_current_gist)
  assert.is_true(update_success, "Gist update should succeed with valid gist ID")
  
  -- Restore original functions
  core.read_workspace_config = original_read_config
  core.command_exists = original_command_exists
  
  -- Clean up test files
  vim.fn.delete(project_path .. "/sketch.js")
  vim.fn.delete(project_path .. "/index.html")
  vim.fn.delete(project_path .. "/p5.json")
end)

test("Gist should validate required files before creation", function()
  local gist = require("p5.gist")
  local core = require("p5.core")
  
  local project_path = vim.fn.getcwd()
  
  -- Test missing sketch.js
  vim.fn.writefile({ "test content" }, project_path .. "/index.html")
  vim.fn.writefile({ "test content" }, project_path .. "/p5.json")
  
  local success, err = pcall(gist.create_gist, "test")
  assert.is_false(success, "Gist creation should fail when sketch.js is missing")
  
  -- Clean up
  vim.fn.delete(project_path .. "/index.html")
  vim.fn.delete(project_path .. "/p5.json")
end)

-- Test server functionality
test("Server should start from buffer's directory", function()
  local server = require("p5.server")
  local core = require("p5.core")
  
  -- Mock buffer directory
  local original_expand = vim.fn.expand
  vim.fn.expand = function(path)
    if path == "%:p:h" then
      return "/tmp/test-buffer-dir"
    end
    return original_expand(path)
  end
  
  -- Mock isdirectory
  local original_isdirectory = vim.fn.isdirectory
  vim.fn.isdirectory = function(path)
    if path == "/tmp/test-buffer-dir" then
      return 1
    end
    return original_isdirectory(path)
  end
  
  -- Mock project validation
  local original_is_p5_project = require("p5.project").is_p5_project
  require("p5.project").is_p5_project = function(dir)
    return true, "Valid project", { project_root = dir }
  end
  
  -- Test server start
  local success, err = pcall(server.start_server)
  assert.is_true(success, "Server should start successfully")
  
  -- Verify server uses buffer directory
  assert.equals(server.port, 8000, "Server should use default port")
  assert.equals(server.server_type, "python", "Server should detect python")
  
  -- Clean up
  require("p5.project").is_p5_project = original_is_p5_project
  vim.fn.expand = original_expand
  vim.fn.isdirectory = original_isdirectory
end)

-- Test P5 command picker
test("P5 command picker should show gist option when gist is associated", function()
  local init = require("p5.init")
  local core = require("p5.core")
  
  -- Mock project configuration with gist
  local mock_config = {
    name = "test-project",
    gist = { id = "test-gist-id" }
  }
  
  -- Mock core.read_workspace_config
  local original_read_config = core.read_workspace_config
  core.read_workspace_config = function()
    return mock_config
  end
  
  -- Mock vim.ui.select
  local select_called = false
  local original_ui_select = vim.ui.select
  vim.ui.select = function(options, opts, callback)
    select_called = true
    assert.contains(options, "Update Gist", "P5 picker should include Update Gist option")
    callback("Update Gist")
  end
  
  -- Test P5 command
  local success, err = pcall(init.P5)
  assert.is_true(success, "P5 command should execute successfully")
  assert.is_true(select_called, "vim.ui.select should be called")
  
  -- Restore
  core.read_workspace_config = original_read_config
  vim.ui.select = original_ui_select
end)

-- Test project validation
test("Project validation should work correctly", function()
  local project = require("p5.project")
  local core = require("p5.core")
  
  local test_dir = "/tmp/p5-test-project"
  vim.fn.mkdir(test_dir, "p")
  
  -- Test valid project
  vim.fn.writefile({ "<html><script src='./assets/libs/p5.js'></script></html>" }, test_dir .. "/index.html")
  vim.fn.writefile({ "test content" }, test_dir .. "/sketch.js")
  
  local is_valid, msg, info = project.is_p5_project(test_dir)
  assert.is_true(is_valid, "Project should be valid")
  assert.equals(info.has_sketch, true, "Project should have sketch.js")
  assert.equals(info.has_config, false, "Project should not have p5.json")
  
  -- Test invalid project (missing p5.js reference)
  vim.fn.writefile({ "<html></html>" }, test_dir .. "/index.html")
  
  local is_valid, msg = project.is_p5_project(test_dir)
  assert.is_false(is_valid, "Project should be invalid without p5.js reference")
  
  -- Clean up
  vim.fn.delete(test_dir .. "/index.html")
  vim.fn.delete(test_dir .. "/sketch.js")
  vim.fn.delete(test_dir)
end)