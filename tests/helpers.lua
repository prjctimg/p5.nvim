local M = {}

M.load_module = function(name)
  local ok, module = pcall(require, name)
  if not ok then
    error("Failed to load module: " .. name .. "\n" .. tostring(module))
  end
  return module
end

M.with_temp_dir = function(test_fn)
  return function()
    local temp_dir = vim.fn.tempname()
    vim.fn.mkdir(temp_dir, "p")
    local original_cwd = vim.fn.getcwd()
    
    vim.fn.chdir(temp_dir)
    
    local function cleanup()
      vim.fn.chdir(original_cwd)
      pcall(vim.fn.delete, temp_dir, "rf")
    end
    
    local success, err = pcall(test_fn, temp_dir)
    cleanup()
    
    if not success and err then
      error(err)
    end
  end
end

M.with_project = function(test_fn)
  return M.with_temp_dir(test_fn)
end

M.create_p5_json = function(path, config)
  config = config or {
    version = "1.9.0",
    libs = {},
    includes = {"sketch.js"}
  }
  local content = vim.fn.json_encode(config)
  vim.fn.writefile(vim.split(content, "\n"), path .. "/p5.json")
end

M.create_sketch_js = function(path)
  local content = [[
function setup() {
  createCanvas(400, 400);
}

function draw() {
  background(220);
  circle(mouseX, mouseY, 50);
}
]]
  vim.fn.writefile(vim.split(content, "\n"), path .. "/sketch.js")
end

M.create_index_html = function(path)
  local content = [[
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>p5.js Sketch</title>
</head>
<body>
  <main></main>
  <script src="sketch.js"></script>
</body>
</html>
]]
  vim.fn.writefile(vim.split(content, "\n"), path .. "/index.html")
end

return M
