#!/usr/bin/env nvim --headless -l

-- Add current directory to Lua path
package.path = vim.fn.stdpath('config') .. '/lua/?.lua;' .. 
                vim.fn.stdpath('config') .. '/lua/?/init.lua;' ..
                vim.fn.getcwd() .. '/lua/?.lua;' .. 
                vim.fn.getcwd() .. '/lua/?/init.lua;' .. 
                package.path

-- Test Phase 1: Basic plugin functionality
print("Testing p5.nvim Phase 1...")

-- Test 1: Plugin loads without errors
local ok, p5 = pcall(require, "p5")
if not ok then
  print("❌ Failed to load p5 module: " .. tostring(p5))
  os.exit(1)
end
print("✅ p5 module loads successfully")

-- Test 2: Setup function works
local ok_setup, err = pcall(p5.setup)
if not ok_setup then
  print("❌ Failed to setup p5: " .. tostring(err))
  os.exit(1)
end
print("✅ p5.setup() works")

-- Test 3: Config module works
local config = require("p5.config")
local cache_dir = config.get_cache_dir()
if not cache_dir or cache_dir == "" then
  print("❌ Cache directory not configured")
  os.exit(1)
end
print("✅ Config module works, cache dir: " .. cache_dir)

-- Test 4: Project creation module loads
local ok_create, create_module = pcall(require, "p5.project.create")
if not ok_create then
  print("❌ Failed to load project creation module: " .. tostring(create_module))
  os.exit(1)
end
print("✅ Project creation module loads")

-- Test 5: Bundled assets exist
local plugin_root = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h:h")
local p5_asset = plugin_root .. "/assets/core/p5.js"
local sound_asset = plugin_root .. "/assets/core/p5.sound.js"

if vim.fn.filereadable(p5_asset) ~= 1 then
  print("❌ Bundled p5.js not found at: " .. p5_asset)
  os.exit(1)
end
print("✅ Bundled p5.js exists")

if vim.fn.filereadable(sound_asset) ~= 1 then
  print("❌ Bundled p5.sound.js not found at: " .. sound_asset)
  os.exit(1)
end
print("✅ Bundled p5.sound.js exists")

print("\n🎉 Phase 1 tests passed!")
print("✅ Basic plugin structure is functional")
print("✅ Configuration system works")
print("✅ Bundled assets are available")
print("✅ Project creation module is ready")

os.exit(0)