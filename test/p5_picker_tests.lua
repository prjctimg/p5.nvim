-- P5 command picker tests
-- Test that the P5 command picker includes gist options when appropriate

-- Mock vim.ui.select for testing
local original_ui_select = vim.ui.select
local select_called = false
local select_options = nil

vim.ui.select = function(options, opts, callback)
  select_called = true
  select_options = options
  callback("Update Gist")
end

-- Test P5 command picker functionality
local function test_p5_command_picker()
  local init = require("p5.init")
  local core = require("p5.core")
  
  -- Mock project configuration with gist
  local mock_config = {
    name = "test-project",
    gist = { id = "test-gist-id" }
  }
  
  -- Mock core.read_workspace_config
  local original_read_config = core.read_workspace_config
  core.read_workspace_config = function()
    return mock_config
  end
  
  -- Test P5 command
  local success, err = pcall(init.P5)
  assert(success, "P5 command should execute successfully")
  assert(select_called, "vim.ui.select should be called")
  assert(select_options, "vim.ui.select should receive options")
  
  -- Verify gist option is included
  assert(select_options, "Options should be provided to vim.ui.select")
  assert(select_options[6] == "Update Gist", "Update Gist should be in options list")
  
  -- Restore mocks
  core.read_workspace_config = original_read_config
end

-- Run P5 command picker tests
print("Running p5.nvim P5 command picker tests...")
test_p5_command_picker()
print("All P5 command picker tests passed!")