-- Gist integration logic tests
-- Test the core gist functionality without UI dependencies

local function test_gist_integration_logic()
  local gist = require("p5.gist")
  local core = require("p5.core")
  
  -- Test gist creation function existence
  assert(type(gist.create_gist) == "function", "create_gist should be a function")
  assert(type(gist.update_current_gist) == "function", "update_current_gist should be a function")
  assert(type(gist.get_project_gist) == "function", "get_project_gist should be a function")
  
  -- Test gist creation with mock
  local mock_success = false
  local original_command_exists = core.command_exists
  core.command_exists = function(cmd)
    return cmd == "gh"
  end
  
  -- This should not crash
  local success, err = pcall(gist.create_gist, "test description")
  assert(success, "create_gist should not crash")
  
  -- Test gist update
  local update_success, update_err = pcall(gist.update_current_gist)
  assert(success, "update_current_gist should not crash")
  
  core.command_exists = original_command_exists
  print("✓ gist integration logic tests passed")
end

-- Run gist integration tests
print("Running p5.nvim gist integration tests...")
test_gist_integration_logic()
print("All gist integration tests passed!")