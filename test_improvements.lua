#!/usr/bin/env lua

-- Comprehensive test suite for p5.nvim improvements
-- This script tests all the new features and improvements

local M = {}

-- Test utilities
local function run_test(test_name, test_func)
    io.write("Testing " .. test_name .. "... ")
    local success, result = pcall(test_func)
    if success then
        print("✓ PASSED")
        return true
    else
        print("✗ FAILED: " .. result)
        return false
    end
end

-- Test 1: Project creation with CWD management
local function test_project_creation()
    -- This would be tested in Neovim environment
    -- For now, just verify the functions exist
    local project = require("p5.project")
    
    if not project.create_project then
        error("create_project function not found")
    end
    
    if not project.is_p5_project then
        error("is_p5_project function not found")
    end
    
    return true
end

-- Test 2: Server port management
local function test_server_port_management()
    local server = require("p5.server")
    
    if not server.find_available_port then
        error("find_available_port function not found")
    end
    
    if not server.validate_server then
        error("validate_server function not found")
    end
    
    -- Test port validation with invalid port
    local valid, msg = server.validate_server("python", -1)
    if valid then
        error("Invalid port should fail validation")
    end
    
    valid, msg = server.validate_server("python", 70000)
    if valid then
        error("Port > 65535 should fail validation")
    end
    
    return true
end

-- Test 3: Console log formatting
local function test_console_formatting()
    local console = require("p5.console")
    
    if not console.get_injection_script then
        error("get_injection_script function not found")
    end
    
    local script = console.get_injection_script()
    
    -- Verify script contains debouncing logic
    if not script:match("debounce") then
        error("Console script missing debouncing logic")
    end
    
    -- Verify script contains batch processing
    if not script:match("console_batch") then
        error("Console script missing batch processing")
    end
    
    return true
end

-- Test 4: Python server enhancements
local function test_python_server_enhancements()
    -- Read the Python server file to verify enhancements
    local file = io.open("servers/python.py", "r")
    if not file then
        error("Could not read servers/python.py")
    end
    
    local content = file:read("*all")
    file:close()
    
    -- Check for ANSI color codes
    if not content:match("ANSI_COLORS") then
        error("Python server missing ANSI color definitions")
    end
    
    -- Check for formatted streaming endpoint
    if not content:match("/api/console/stream") then
        error("Python server missing streaming endpoint")
    end
    
    -- Check for batch log processing
    if not content:match("console_batch") then
        error("Python server missing batch log processing")
    end
    
    -- Check for log formatting function
    if not content:match("format_log_entry") then
        error("Python server missing log formatting function")
    end
    
    return true
end

-- Test 5: User command registration
local function test_user_commands()
    -- Check if user command file contains the new command
    local file = io.open("plugin/p5.lua", "r")
    if not file then
        error("Could not read plugin/p5.lua")
    end
    
    local content = file:read("*all")
    file:close()
    
    if not content:match("P5CreateProject") then
        error("P5CreateProject command not registered")
    end
    
    return true
end

-- Main test runner
local function run_all_tests()
    print("Running p5.nvim improvement tests...")
    print("=====================================")
    
    local tests = {
        {"Project Creation Functions", test_project_creation},
        {"Server Port Management", test_server_port_management},
        {"Console Log Formatting", test_console_formatting},
        {"Python Server Enhancements", test_python_server_enhancements},
        {"User Command Registration", test_user_commands}
    }
    
    local passed = 0
    local total = #tests
    
    for _, test in ipairs(tests) do
        if run_test(test[1], test[2]) then
            passed = passed + 1
        end
    end
    
    print("=====================================")
    print(string.format("Tests passed: %d/%d", passed, total))
    
    if passed == total then
        print("🎉 All tests passed!")
        return 0
    else
        print("❌ Some tests failed")
        return 1
    end
end

-- Check if running as script
if arg and arg[0] and arg[0]:match("test_improvements%.lua$") then
    os.exit(run_all_tests())
end

return M