-- Simple functional tests for p5.nvim
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

-- Test gist functionality
local function test_gist_integration()
  local gist = require("p5.gist")
  local core = require("p5.core")
  
  -- Test gist creation with mock
  local project_path = vim.fn.getcwd()
  
  -- Create test files
  vim.fn.writefile({ "test content" }, project_path .. "/sketch.js")
  vim.fn.writefile({ "test content" }, project_path .. "/index.html")
  vim.fn.writefile({ "test content" }, project_path .. "/p5.json")
  
  -- Mock gh command
  local original_command_exists = core.command_exists
  core.command_exists = function(cmd)
    return cmd == "gh"
  end
  
  -- Test gist creation
  local success, err = pcall(gist.create_gist, "test description")
  assert.is_true(success, "Gist creation should succeed with all required files")
  
  -- Clean up
  vim.fn.delete(project_path .. "/sketch.js")
  vim.fn.delete(project_path .. "/index.html")
  vim.fn.delete(project_path .. "/p5.json")
  
  core.command_exists = original_command_exists
end

-- Test server functionality
local function test_server_integration()
  local server = require("p5.server")
  local project = require("p5.project")
  
  -- Test server startup
  local success, err = pcall(server.start_server)
  assert.is_true(success, "Server should start successfully")
  
  -- Test server stop
  if server.server_job then
    local stop_success, stop_err = pcall(server.stop_server)
    assert.is_true(stop_success, "Server should stop successfully")
  end
end

-- Test project validation
local function test_project_validation()
  local project = require("p5.project")
  
  local test_dir = "/tmp/p5-test-project"
  vim.fn.mkdir(test_dir, "p")
  
  -- Test valid project
  vim.fn.writefile({ "<html><script src='./assets/libs/p5.js'></script></html>" }, test_dir .. "/index.html")
  vim.fn.writefile({ "test content" }, test_dir .. "/sketch.js")
  
  local is_valid, msg, info = project.is_p5_project(test_dir)
  assert.is_true(is_valid, "Project should be valid")
  assert.equals(info.has_sketch, true, "Project should have sketch.js")
  
  -- Test invalid project
  vim.fn.writefile({ "<html></html>" }, test_dir .. "/index.html")
  
  local is_valid, msg = project.is_p5_project(test_dir)
  assert.is_false(is_valid, "Project should be invalid without p5.js reference")
  
  -- Clean up
  vim.fn.delete(test_dir .. "/index.html")
  vim.fn.delete(test_dir .. "/sketch.js")
  vim.fn.delete(test_dir)
end

-- Run all tests
print("Running p5.nvim functional tests...")
test_gist_integration()
test_server_integration()
test_project_validation()
print("All tests passed!")