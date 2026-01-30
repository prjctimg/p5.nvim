-- Project creation and management for p5.nvim
local M = {}
local core = require("p5.core")

-- Create new p5.js project
M.create_project = function(name)
  name = name or "p5-sketch"
  
  -- Check if directory already exists
  if vim.fn.isdirectory(name) ~= 0 then
    core.notify("Directory '" .. name .. "' already exists", "error")
    return
  end
  
  -- Create project directory
  vim.fn.mkdir(name, "p")
  local project_path = vim.fn.fnamemodify(name, ":p")
  
  -- Create files
  M.create_files(project_path)
  
  -- Open sketch.js in editor
  vim.cmd("edit " .. project_path .. "/sketch.js")
  
  core.notify("Created p5.js project: " .. name, "info")
end

-- Create project files
M.create_files = function(project_path)
  -- Create index.html
  local index_html = [[<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>p5.js Sketch</title>
  <script src="https://cdn.jsdelivr.net/npm/p5@latest/lib/p5.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/p5@latest/lib/addons/p5.sound.js"></script>
</head>
<body>
  <main>
  </main>
  <script src="sketch.js"></script>
</body>
</html>]]
  
  vim.fn.writefile(vim.split(index_html, "\n"), project_path .. "/index.html")
  
  -- Create sketch.js
  local sketch_js = [[function setup() {
  createCanvas(400, 400);
}

function draw() {
  background(220);
  circle(mouseX, mouseY, 50);
}]]
  
  vim.fn.writefile(vim.split(sketch_js, "\n"), project_path .. "/sketch.js")
  
  -- Create jsconfig.json for TypeScript support
  local jsconfig = [[{
  "compilerOptions": {
    "target": "ES2022",
    "module": "ESNext", 
    "lib": ["DOM", "ES2022"],
    "types": ["./assets/types/p5.d.ts"],
    "checkJs": true,
    "strict": false,
    "allowJs": true,
    "moduleResolution": "node"
  },
  "include": [
    "**/*.js",
    "**/*.ts"
  ],
  "exclude": [
    "node_modules"
  ]
}]]
  
  vim.fn.writefile(vim.split(jsconfig, "\n"), project_path .. "/jsconfig.json")
  
  -- Create p5.json workspace configuration
  local p5_config = [[{
  "name": "]] .. vim.fn.fnamemodify(project_path, ":t") .. [[",
  "version": "1.0.0",
  "p5js_version": "latest",
  "libraries": [],
  "server": {
    "type": "python",
    "port": 8000
  },
  "console": {
    "enabled": true,
    "position": "below",
    "height": 10
  }
}]]
  
  vim.fn.writefile(vim.split(p5_config, "\n"), project_path .. "/p5.json")
  
  -- Create assets directory
  vim.fn.mkdir(project_path .. "/assets/types", "p")
  vim.fn.mkdir(project_path .. "/assets/contrib", "p")
end

M.setup = function(config)
  M.config = config
end

return M