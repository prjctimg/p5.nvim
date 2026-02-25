-- Simple gist fixes verification
-- Test that gist functions work with nearest p5.json detection

local function test_gist_fixes_simple()
  local gist = require("p5.gist")
  local core = require("p5.core")
  
  -- Mock find_nearest_p5_config
  local original_find_config = core.find_nearest_p5_config
  local mock_config = { name = "test-project" }
  core.find_nearest_p5_config = function() return mock_config end
  
  -- Test gist creation doesn't crash
  local success, err = pcall(gist.create_gist, "test description")
  assert(success, "create_gist should not crash with nearest p5.json detection")
  
  -- Test gist update doesn't crash
  local update_success, update_err = pcall(gist.update_current_gist)
  assert(update_success, "update_current_gist should not crash with nearest p5.json detection")
  
  -- Restore original function
  core.find_nearest_p5_config = original_find_config
  
  print("✓ gist fixes verification passed")
end

-- Run simple gist fixes tests
print("Running p5.nvim simple gist fixes tests...")
test_gist_fixes_simple()
print("All simple gist fixes tests passed!")