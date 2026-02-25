-- Basic gist module structure tests
-- Test that gist module has the expected functions and structure

local function test_gist_module_structure()
  local gist = require("p5.gist")
  
  -- Test module exists
  assert(gist, "p5.gist module should exist")
  
  -- Test required functions exist
  local required_functions = {
    "create_gist",
    "update_gist", 
    "update_current_gist",
    "get_project_gist",
    "list_gists",
    "open_gist",
    "clone_gist"
  }
  
  for _, func_name in ipairs(required_functions) do
    local func = gist[func_name]
    assert(type(func) == "function", func_name .. " should be a function")
    print("✓ " .. func_name .. " exists")
  end
  
  -- Test setup function exists
  assert(type(gist.setup) == "function", "setup should be a function")
  print("✓ setup exists")
  
  print("✓ gist module structure tests passed")
end

-- Run structure tests
print("Running p5.nvim gist module structure tests...")
test_gist_module_structure()
print("All gist module structure tests passed!")