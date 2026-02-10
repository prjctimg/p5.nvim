-- Test script to simulate P5StartServer command
local M = {}

-- Load plugin modules
local core = require("p5.core")
local server = require("p5.server")
local console = require("p5.console")

-- Setup with test configuration
local test_config = {
  server = {
    port = 8006,
    auto_open_browser = false, -- Don't open browser in test
    preferred_order = {"python", "node", "bun", "deno"}
  },
  console = {
    enabled = true,
    auto_show = false -- Don't show console in test
  }
}

print("Testing p5.nvim server startup...")

-- Initialize modules
core.setup(test_config)
server.setup(test_config)
console.setup(test_config)

-- Test server detection
local detected_server = server.detect_server()
if detected_server then
  print("✅ Server detected: " .. detected_server)
else
  print("❌ No server detected")
  return
end

-- Test server validation
local valid, message = server.validate_server(detected_server, 8006)
if valid then
  print("✅ Server validation passed")
else
  print("❌ Server validation failed: " .. message)
  return
end

print("All tests passed! Server startup should work correctly.")

return M