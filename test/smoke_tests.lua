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
  assert.is_true(type(gist.get_includes) == "function", "get_includes should be a function")
  
  -- Test gist creation (mocked)
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
  
  -- Test valid sketchspace (with p5.json)
  local test_dir = "/tmp/p5-test-sketchspace"
  vim.fn.mkdir(test_dir, "p")
  
  -- Create valid p5.json
  local p5_json = {
    version = "1.9.0",
    libs = {},
    includes = {"sketch.js"}
  }
  vim.fn.writefile({vim.fn.json_encode(p5_json)}, test_dir .. "/p5.json")
  
  local is_valid, msg, info = project.is_p5_project(test_dir)
  assert.is_true(is_valid, "Sketchspace with p5.json should be valid: " .. tostring(msg))
  assert.equals(info.project_root, test_dir, "Should return correct project root")
  
  -- Test invalid sketchspace (no p5.json)
  vim.fn.delete(test_dir .. "/p5.json")
  
  local is_valid, msg = project.is_p5_project(test_dir)
  assert.is_false(is_valid, "Directory without p5.json should be invalid")
  
  -- Clean up
  vim.fn.delete(test_dir)
end

-- Test libraries module
local function test_libraries_module()
  local libraries = require("p5.libraries")
  local core = require("p5.core")
  
  -- Test function existence
  assert.is_true(type(libraries.load) == "function", "load should be a function")
  assert.is_true(type(libraries.get_libs) == "function", "get_libs should be a function")
  assert.is_true(type(libraries.get_includes) == "function", "get_includes should be a function")
  assert.is_true(type(libraries.add_library) == "function", "add_library should be a function")
  assert.is_true(type(libraries.remove_library) == "function", "remove_library should be a function")
  assert.is_true(type(libraries.generate_libs_js) == "function", "generate_libs_js should be a function")
end

-- Test core module
local function test_core_module()
  local core = require("p5.core")
  
  -- Test function existence
  assert.is_true(type(core.find_project_root) == "function", "find_project_root should be a function")
  assert.is_true(type(core.read_workspace_config) == "function", "read_workspace_config should be a function")
  assert.is_true(type(core.write_workspace_config) == "function", "write_workspace_config should be a function")
  assert.is_true(type(core.notify) == "function", "notify should be a function")
end

-- Run all smoke tests
print("Running p5.nvim smoke tests...")
test_gist_module()
test_server_module()
test_project_module()
test_libraries_module()
test_core_module()
print("All smoke tests passed!")
