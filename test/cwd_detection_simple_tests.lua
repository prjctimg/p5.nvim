local core = require("p5.core")

local function test_cwd_detection()
  -- Test function exists
  assert(core.find_nearest_p5_config, "find_nearest_p5_config should exist")
  assert(core.read_workspace_config, "read_workspace_config should exist")
  print("✓ cwd detection functions exist")
  
  -- Test basic functionality
  local original_getcwd = vim.fn.getcwd
  vim.fn.getcwd = function() return "/home/user/project" end
  
  local config = core.read_workspace_config()
  assert(config == nil, "Should return nil when no p5.json found")
  
  vim.fn.getcwd = original_getcwd
  print("✓ cwd detection tests passed")
end

print("Running p5.nvim cwd detection tests...")
test_cwd_detection()
print("All cwd detection tests passed!")