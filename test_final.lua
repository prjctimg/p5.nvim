#!/usr/bin/env nvim --headless -l

-- Add current directory to Lua path
vim.opt.runtimepath:append(vim.fn.getcwd())

-- Final Integration Test for p5.nvim
print("🚀 p5.nvim Final Integration Test")
print("=" .. string.rep("=", 50))

-- Test 1: Complete module loading
print("\n📦 Module Loading Test:")
local modules = {
  "p5.init",
  "p5.config", 
  "p5.ui.input",
  "p5.ui.menu",
  "p5.project.templates",
  "p5.project.create",
  "p5.libraries.manager",
  "p5.libraries.updater",
  "p5.server.init",
  "p5.console.logger",
  "p5.gist.push"
}

local loaded_count = 0
local failed_modules = {}

for _, module in ipairs(modules) do
  local ok, err = pcall(require, module)
  if ok then
    loaded_count = loaded_count + 1
    print("✅ " .. module)
  else
    table.insert(failed_modules, {name = module, error = err})
    print("❌ " .. module .. " - " .. tostring(err))
  end
end

print("\n📊 Module Loading Summary:")
print("✅ Loaded: " .. loaded_count .. "/" .. #modules)
if #failed_modules > 0 then
  print("❌ Failed: " .. #failed_modules)
  for _, failed in ipairs(failed_modules) do
    print("   • " .. failed.name .. ": " .. tostring(failed.error))
  end
end

-- Test 2: Plugin setup
print("\n⚙️  Plugin Setup Test:")
local setup_ok, setup_err = pcall(function()
  require("p5").setup({
    port = 8001,
    libraries = { sound = true, ml5 = false },
    auto_open = false
  })
end)

if setup_ok then
  print("✅ Plugin setup successful")
else
  print("❌ Plugin setup failed: " .. tostring(setup_err))
end

-- Test 3: Configuration system
print("\n🔧 Configuration Test:")
local config = require("p5.config")
local config_tests = {
  {name = "Port", test = function() return config.get_port() > 0 end},
  {name = "Cache Directory", test = function() return config.get_cache_dir() and config.get_cache_dir() ~= "" end},
  {name = "Server Type", test = function() return config.get_server_type() end},
  {name = "Libraries", test = function() return type(config.get_libraries()) == "table" end}
}

local config_passed = 0
for _, test in ipairs(config_tests) do
  local ok, result = pcall(test.test)
  if ok and result then
    config_passed = config_passed + 1
    print("✅ " .. test.name)
  else
    print("❌ " .. test.name)
  end
end

print("✅ Config tests: " .. config_passed .. "/4")

-- Test 4: UI Components availability
print("\n🎨 UI Components Test:")
local ui = {
  input = require("p5.ui.input"),
  menu = require("p5.ui.menu")
}

local ui_functions = {
  "input.input",
  "input.confirm", 
  "menu.multi_select",
  "menu.single_select"
}

local ui_passed = 0
for _, func_name in ipairs(ui_functions) do
  local ok, func = pcall(function()
    local module, func = func_name:match("([^.]+)%.(.+)")
    return ui[module][func]
  end)
  if ok and type(func) == "function" then
    ui_passed = ui_passed + 1
    print("✅ " .. func_name)
  else
    print("❌ " .. func_name)
  end
end

print("✅ UI functions: " .. ui_passed .. "/" .. #ui_functions)

-- Test 5: Asset availability
print("\n📁 Asset Test:")
local asset_files = {
  "assets/core/p5.js",
  "assets/core/p5.min.js", 
  "assets/core/p5.sound.js",
  "assets/core/p5.sound.min.js",
  "assets/types/p5.d.ts",
  "assets/types/constants.d.ts",
  "assets/types/literals.d.ts"
}

local assets_passed = 0
for _, asset in ipairs(asset_files) do
  if vim.fn.filereadable(asset) == 1 then
    assets_passed = assets_passed + 1
    local size = vim.fn.getfsize(asset)
    print("✅ " .. asset .. " (" .. size .. " bytes)")
  else
    print("❌ " .. asset)
  end
end

print("✅ Assets: " .. assets_passed .. "/" .. #asset_files)

-- Test 6: Server management functionality
print("\n🌐 Server Management Test:")
local server = require("p5.server.init")
local server_functions = {"start_server", "stop_server", "get_status", "toggle_server", "restart_server"}

local server_passed = 0
for _, func_name in ipairs(server_functions) do
  if type(server[func_name]) == "function" then
    server_passed = server_passed + 1
    print("✅ " .. func_name)
  else
    print("❌ " .. func_name)
  end
end

print("✅ Server functions: " .. server_passed .. "/" .. #server_functions)

-- Test 7: Documentation availability
print("\n📚 Documentation Test:")
local doc_files = {"doc/p5.txt", "README.md", "PLAN.md"}
local docs_passed = 0

for _, doc in ipairs(doc_files) do
  if vim.fn.filereadable(doc) == 1 then
    docs_passed = docs_passed + 1
    print("✅ " .. doc)
  else
    print("❌ " .. doc)
  end
end

print("✅ Documentation: " .. docs_passed .. "/" .. #doc_files)

-- Test 8: Scripts availability  
print("\n🔧 Scripts Test:")
local script_files = {"scripts/update-assets.sh", "scripts/verify-assets.sh"}
local scripts_passed = 0

for _, script in ipairs(script_files) do
  if vim.fn.executable(script) == 1 then
    scripts_passed = scripts_passed + 1
    print("✅ " .. script)
  else
    print("❌ " .. script)
  end
end

print("✅ Scripts: " .. scripts_passed .. "/" .. #script_files)

-- Final Summary
print("\n" .. string.rep("=", 52))
print("🎉 FINAL INTEGRATION TEST SUMMARY")
print(string.rep("=", 52))

local total_tests = 8
local categories = {
  {name = "Module Loading", passed = loaded_count == #modules, score = loaded_count},
  {name = "Plugin Setup", passed = setup_ok, score = setup_ok and 1 or 0},
  {name = "Configuration", passed = config_passed == 4, score = config_passed},
  {name = "UI Components", passed = ui_passed == #ui_functions, score = ui_passed},
  {name = "Assets", passed = assets_passed == #asset_files, score = assets_passed},
  {name = "Server Management", passed = server_passed == #server_functions, score = server_passed},
  {name = "Documentation", passed = docs_passed == #doc_files, score = docs_passed},
  {name = "Scripts", passed = scripts_passed == #script_files, score = scripts_passed}
}

local passed_categories = 0
local total_score = 0
local max_score = 0

for _, category in ipairs(categories) do
  local status = category.passed and "✅ PASS" or "❌ FAIL"
  print(string.format("%-18s %s %d/%d", category.name, status, category.score, category.passed and 1 or 0))
  
  if category.passed then
    passed_categories = passed_categories + 1
  end
  
  -- Simple scoring for demonstration
  if category.name == "Module Loading" then
    max_score = max_score + #modules
    total_score = total_score + category.score
  elseif category.name == "Configuration" then
    max_score = max_score + 4
    total_score = total_score + category.score
  elseif category.name == "UI Components" then
    max_score = max_score + #ui_functions
    total_score = total_score + category.score
  elseif category.name == "Assets" then
    max_score = max_score + #asset_files
    total_score = total_score + category.score
  elseif category.name == "Server Management" then
    max_score = max_score + #server_functions
    total_score = total_score + category.score
  elseif category.name == "Documentation" then
    max_score = max_score + #doc_files
    total_score = total_score + category.score
  elseif category.name == "Scripts" then
    max_score = max_score + #script_files
    total_score = total_score + category.score
  else
    max_score = max_score + 1
    total_score = total_score + (category.passed and 1 or 0)
  end
end

print(string.rep("-", 52))
print(string.format("Categories Passed: %d/%d (%.1f%%)", 
                   passed_categories, total_tests, 
                   (passed_categories / total_tests) * 100))

if max_score > 0 then
  print(string.format("Overall Score: %d/%d (%.1f%%)", 
                     total_score, max_score, 
                     (total_score / max_score) * 100))
end

print(string.rep("=", 52))

if passed_categories == total_tests then
  print("🎊 ALL TESTS PASSED! p5.nvim is ready for production!")
  print("📦 Plugin: Fully functional")
  print("🔧 Features: All implemented") 
  print("📚 Documentation: Complete")
  print("🌐 Ready to use!")
  os.exit(0)
else
  print("⚠️  Some tests failed. Review the output above.")
  print("🔧 Plugin may need additional configuration or fixes.")
  os.exit(1)
end