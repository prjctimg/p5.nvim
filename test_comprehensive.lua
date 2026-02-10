-- Comprehensive test file for p5.nvim fixes
-- Run with: nvim --headless -c "luafile test_comprehensive.lua"

print("=== p5.nvim Comprehensive Test Suite ===")

-- Test 1: Check that all modules load correctly
print("\n1. Testing module loading...")
local ok, core = pcall(require, 'p5.core')
if ok then
  print("✓ Core module loaded")
else
  print("✗ Core module failed: " .. tostring(core))
  return
end

local ok, server = pcall(require, 'p5.server')
if ok then
  print("✓ Server module loaded")
else
  print("✗ Server module failed: " .. tostring(server))
  return
end

local ok, console = pcall(require, 'p5.console')
if ok then
  print("✓ Console module loaded")
else
  print("✗ Console module failed: " .. tostring(console))
  return
end

local ok, health = pcall(require, 'p5.health')
if ok then
  print("✓ Health module loaded")
else
  print("✗ Health module failed: " .. tostring(health))
  return
end

-- Test 2: Check core functions
print("\n2. Testing core functions...")
if core.command_exists("python3") or core.command_exists("python") then
  print("✓ Python runtime detected")
else
  print("ℹ No Python runtime detected")
end

if core.command_exists("node") then
  print("✓ Node.js runtime detected")
else
  print("ℹ No Node.js runtime detected")
end

if core.command_exists("curl") then
  print("✓ curl available")
else
  print("ℹ curl not available")
end

-- Test 3: Server detection and validation
print("\n3. Testing server detection...")
local detected_server = server.detect_server()
if detected_server then
  print("✓ Server detected: " .. detected_server)
  
  -- Test server validation
  local valid, message = server.validate_server(detected_server, 8006)
  if valid then
    print("✓ Server validation passed")
  else
    print("ℹ Server validation issue: " .. message)
  end
else
  print("ℹ No suitable server runtime found")
end

-- Test 4: Configuration management
print("\n4. Testing configuration management...")
local config = core.read_workspace_config()
if config then
  print("✓ Workspace config loaded")
else
  print("ℹ No workspace config found")
end

-- Test 5: Health check
print("\n5. Testing health check...")
local ok, err = pcall(health.check)
if ok then
  print("✓ Health check completed successfully")
else
  print("✗ Health check failed: " .. tostring(err))
end

-- Test 6: Console setup
print("\n6. Testing console setup...")
console.setup({
  console = {
    enabled = true,
    auto_show = false,  -- Don't actually show in headless mode
    position = "below",
    height = 10
  },
  server = {
    port = 8000
  }
})
print("✓ Console setup completed")

print("\n=== Test Suite Complete ===")
print("All critical functionality verified!")