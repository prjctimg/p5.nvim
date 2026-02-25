local core = require("p5.core")

local function test_cwd_detection()
  -- Mock file system structure
  local original_filereadable = vim.fn.filereadable
  local original_getcwd = vim.fn.getcwd
  
  -- Mock directory structure
  vim.fn.filereadable = function(path)
    if path == "/home/user/project/p5.json" then return 1 end
    if path == "/home/user/project/sketch.js" then return 1 end
    if path == "/home/user/project/index.html" then return 1 end
    return 0
  end
  
  -- Mock current directory
  vim.fn.getcwd = function() return "/home/user/project/subdir" end
  
  -- Test find_nearest_p5_config
  local config = core.find_nearest_p5_config()
  assert(config, "Should find p5.json in parent directory")
  assert(config.name == "test-project", "Should read config from p5.json")
  
  -- Test read_workspace_config still works
  local original_cwd = vim.fn.getcwd
  vim.fn.getcwd = function() return "/home/user/project" end
  local config2 = core.read_workspace_config()
  assert(config2, "read_workspace_config should work in p5.json directory")
  
  -- Restore mocks
  vim.fn.filereadable = original_filereadable
  vim.fn.getcwd = original_cwd
  
  print("✓ cwd detection tests passed")
end

-- Run cwd detection tests
print("Running p5.nvim cwd detection tests...")
test_cwd_detection()
print("All cwd detection tests passed!")