local gist = require("p5.gist")
local core = require("p5.core")

-- Mock file system structure
local original_filereadable = vim.fn.filereadable
local original_getcwd = vim.fn.getcwd

-- Mock directory structure
vim.fn.filereadable = function(path)
  if path == "/tmp/p5-test-project/p5.json" then return 1 end
  if path == "/tmp/p5-test-project/sketch.js" then return 1 end
  if path == "/tmp/p5-test-project/index.html" then return 1 end
  return 0
end

-- Mock current directory
vim.fn.getcwd = function() return "/tmp/p5-test-project" end

-- Test gist creation
local success, err = pcall(gist.create_gist, "test gist")
print("Gist creation test:")
if success then
  print("  ✓ Gist creation succeeded")
else
  print("  ✗ Gist creation failed: " .. tostring(err))
end

-- Test gist update
local update_success, update_err = pcall(gist.update_current_gist)
print("Gist update test:")
if update_success then
  print("  ✓ Gist update succeeded")
else
  print("  ✗ Gist update failed: " .. tostring(update_err))
end

-- Restore mocks
vim.fn.filereadable = original_filereadable
vim.fn.getcwd = original_getcwd

print("All gist tests completed!")