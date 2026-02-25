-- Basic smoke tests for p5.nvim
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

-- Test gist module
local function test_gist_module()
  local gist = require("p5.gist")
  local core = require("p5.core")
  
  -- Test function existence
  assert.is_true(type(gist.create_gist) == "function", "create_gist should be a function")
  assert.is_true(type(gist.update_current_gist) == "function", "update_current_gist should be a function")
  assert.is_true(type(gist.get_project_gist) == "function", "get_project_gist should be a function")
  
  -- Test gist creation (mocked)
  local mock_success = false
  local original_command_exists = core.command_exists
  core.command_exists = function(cmd)
    return cmd == "gh"
  end
  
  -- This should not crash
  local success, err = pcall(gist.create_gist, "test description")
  assert.is_true(success, "create_gist should not crash")
  
  core.command_exists = original_command_exists
end

-- Test server module
local function test_server_module()
  local server = require("p5.server")
  
  -- Test function existence
  assert.is_true(type(server.start_server) == "function", "start_server should be a function")
  assert.is_true(type(server.stop_server) == "function", "stop_server should be a function")
  assert.is_true(type(server.server_job) == "nil", "server_job should be nil initially")
  
  -- Test server startup (mocked)
  local success, err = pcall(server.start_server)
  assert.is_true(success, "start_server should not crash")
  
  -- Test server stop
  if server.server_job then
    local stop_success, stop_err = pcall(server.stop_server)
    assert.is_true(stop_success, "stop_server should not crash")
  end
end

-- Test project module
local function test_project_module()
  local project = require("p5.project")
  
  -- Test function existence
  assert.is_true(type(project.create_project) == "function", "create_project should be a function")
  assert.is_true(type(project.is_p5_project) == "function", "is_p5_project should be a function")
  
  -- Test project validation
  local test_dir = "/tmp/p5-test-project"
  vim.fn.mkdir(test_dir, "p")
  
  -- Test valid project
  vim.fn.writefile({ "<html><script src='./assets/libs/p5.js'></script></html>" }, test_dir .. "/index.html")
  
  local is_valid, msg = project.is_p5_project(test_dir)
  assert.is_true(is_valid, "Project with p5.js reference should be valid")
  
  -- Test invalid project
  vim.fn.writefile({ "<html></html>" }, test_dir .. "/index.html")
  
  local is_valid, msg = project.is_p5_project(test_dir)
  assert.is_false(is_valid, "Project without p5.js reference should be invalid")
  
  -- Clean up
  vim.fn.delete(test_dir .. "/index.html")
  vim.fn.delete(test_dir)
end

-- Run all smoke tests
print("Running p5.nvim smoke tests...")
test_gist_module()
test_server_module()
test_project_module()
print("All smoke tests passed!")