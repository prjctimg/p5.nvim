-- Test gist integration fixes
-- Verify gist option is available and commands work correctly

local function test_gist_fixes()
  local init = require("p5.init")
  local gist = require("p5.gist")
  local core = require("p5.core")
  
  -- Test P5 command picker includes gist option
  local picker_called = false
  local original_ui_select = vim.ui.select
  vim.ui.select = function(options, opts, callback)
    picker_called = true
    -- Verify gist option is included
    local has_gist_option = false
    for _, option in ipairs(options) do
      if option == "Create/update Gist" then
        has_gist_option = true
        break
      end
    end
    assert(has_gist_option, "P5 picker should include Create/update Gist option")
    callback("Create/update Gist")
  end
  
  -- Mock project configuration
  local mock_config = { name = "test-project" }
  local original_find_config = core.find_nearest_p5_config
  core.find_nearest_p5_config = function() return mock_config end
  
  -- Test P5 command
  local success, err = pcall(init.P5)
  assert(success, "P5 command should execute successfully")
  assert(picker_called, "vim.ui.select should be called")
  
  -- Restore mocks
  vim.ui.select = original_ui_select
  core.find_nearest_p5_config = original_find_config
  
  -- Test gist command works
  local gist_success, gist_err = pcall(gist.create_gist, "test description")
  assert(gist_success, "Gist command should work without crashing")
  
  print("✓ gist integration fixes tests passed")
end

-- Run gist fixes tests
print("Running p5.nvim gist integration fixes tests...")
test_gist_fixes()
print("All gist integration fixes tests passed!")