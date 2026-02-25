-- Module loading tests for p5.nvim
-- These tests just verify that modules can be loaded without crashing

-- Test gist module loading
local function test_gist_loading()
  local success, err = pcall(function()
    require("p5.gist")
  end)
  assert(success, "p5.gist module should load without crashing")
  print("✓ p5.gist loaded successfully")
end

-- Test server module loading
local function test_server_loading()
  local success, err = pcall(function()
    require("p5.server")
  end)
  assert(success, "p5.server module should load without crashing")
  print("✓ p5.server loaded successfully")
end

-- Test project module loading
local function test_project_loading()
  local success, err = pcall(function()
    require("p5.project")
  end)
  assert(success, "p5.project module should load without crashing")
  print("✓ p5.project loaded successfully")
end

-- Test core module loading
local function test_core_loading()
  local success, err = pcall(function()
    require("p5.core")
  end)
  assert(success, "p5.core module should load without crashing")
  print("✓ p5.core loaded successfully")
end

-- Run all loading tests
print("Running p5.nvim module loading tests...")
test_gist_loading()
test_server_loading()
test_project_loading()
test_core_loading()
print("All module loading tests passed!")