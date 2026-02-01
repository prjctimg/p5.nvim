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

-- Copy plugin assets to project
M.copy_assets_to_project = function(project_path)
  local plugin_assets = core.get_asset_dir()
  local project_assets = project_path .. "/assets"
  
  -- Create project assets directory
  vim.fn.mkdir(project_assets, "p")
  
  -- Copy TypeScript definitions if they exist
  local types_src = plugin_assets .. "/types"
  local types_dest = project_assets .. "/types"
  if vim.fn.isdirectory(types_src) == 1 then
    vim.fn.mkdir(types_dest, "p")
    local type_files = vim.fn.glob(types_src .. "/*.d.ts", false, true)
    for _, file in ipairs(type_files) do
      local filename = vim.fn.fnamemodify(file, ":t")
      vim.fn.system("cp '" .. file .. "' '" .. types_dest .. "/" .. filename .. "'")
    end
  else
    core.notify_fallback("TypeScript definitions not found in plugin assets", "warn")
  end
  
  -- Copy core files if they exist
  local core_src = plugin_assets .. "/core"
  local core_dest = project_assets .. "/core"
  if vim.fn.isdirectory(core_src) == 1 then
    vim.fn.mkdir(core_dest, "p")
    local core_files = vim.fn.glob(core_src .. "/*.js", false, true)
    for _, file in ipairs(core_files) do
      local filename = vim.fn.fnamemodify(file, ":t")
      vim.fn.system("cp '" .. file .. "' '" .. core_dest .. "/" .. filename .. "'")
    end
  end
end

-- Create project files
M.create_files = function(project_path)
  -- Ensure plugin assets are available first
  if not core.assets_available() then
    core.download_core_assets()
    if not core.assets_available() then
      core.notify("Unable to download required assets. Project created but may have missing files.", "warn")
    end
  end
  
  -- Copy assets to project first
  M.copy_assets_to_project(project_path)
  
  -- Create index.html
  local index_html = [[<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>p5.js Sketch</title>
  <script src="./assets/core/p5.js"></script>
  <script src="./assets/core/p5.sound.js"></script>
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
  
  -- Create jsconfig.json for TypeScript support (after assets are copied)
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
end

M.setup = function(config)
  M.config = config
end

return M