local gist = require("p5.gist")
local core = require("p5.core")

-- Test gist creation functionality
local function test_gist_creation()
  local config = core.find_nearest_p5_config()
  assert(config, "Should find nearest p5.json configuration")
  
  -- Test gist creation
  local success, err = pcall(gist.create_gist, "test gist description")
  assert(success, "create_gist should succeed with all required files")
  print("✓ gist creation test passed")
end

-- Test gist update functionality
local function test_gist_update()
  local config = core.find_nearest_p5_config()
  assert(config, "Should find nearest p5.json configuration")
  
  -- Test gist update
  local success, err = pcall(gist.update_current_gist)
  assert(success, "update_current_gist should succeed with valid gist ID")
  print("✓ gist update test passed")
end

-- Run all gist tests
print("Running p5.nvim gist integration tests...")
test_gist_creation()
test_gist_update()
print("All gist integration tests passed!")