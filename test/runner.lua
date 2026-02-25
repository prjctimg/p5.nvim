-- Simple test runner for p5.nvim
local tests = {}
local test_results = {}

function test(name, fn)
  table.insert(tests, { name = name, fn = fn })
end

function assert_equal(actual, expected, message)
  if actual ~= expected then
    error(string.format("Assertion failed: %s (got %s, expected %s)", message or "", tostring(actual), tostring(expected)))
  end
end

function assert_true(condition, message)
  assert_equal(condition, true, message or "Condition should be true")
end

function assert_false(condition, message)
  assert_equal(condition, false, message or "Condition should be false")
end

function assert_contains(table, value, message)
  for _, v in ipairs(table) do
    if v == value then return end
  end
  error(string.format("Assertion failed: %s (value %s not found in table)", message or "", tostring(value)))
end

function run_tests()
  local passed = 0
  local failed = 0
  
  print("Running p5.nvim tests...")
  print("=" .. string.rep("=", 50))
  
  for _, test in ipairs(tests) do
    local success = true
    local error_msg = nil
    
    local status, err = pcall(test.fn)
    if not status then
      success = false
      error_msg = err
    end
    
    test_results[test.name] = {
      success = success,
      error = error_msg
    }
    
    if success then
      passed = passed + 1
      print("✓ " .. test.name)
    else
      failed = failed + 1
      print("✗ " .. test.name)
      if error_msg then
        print("  Error: " .. error_msg)
      end
    end
  end
  
  print("=" .. string.rep("=", 50))
  print(string.format("Tests completed: %d passed, %d failed", passed, failed))
  
  if failed > 0 then
    os.exit(1)
  else
    os.exit(0)
  end
end

-- Load and run test files
local test_files = {
  "test/gist_server_tests.lua"
}

for _, file in ipairs(test_files) do
  local ok, err = pcall(dofile, file)
  if not ok then
    print("Error loading test file " .. file .. ": " .. tostring(err))
    os.exit(1)
  end
end

run_tests()