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
  
  -- Open sketch.js in editor
  vim.cmd("edit " .. project_path .. "/sketch.js")
  
  core.notify("Created p5.js project: " .. name, "info")
end

-- Create project files
M.create_files = function(project_path)
  -- Copy plugin assets to project first
  M.copy_assets_to_project(project_path)
  
  -- Create index.html
  local index_html = [[<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>p5.js Sketch</title>
  <script src="./assets/core/p5.js"></script>
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

-- Copy plugin assets to project with bundled types
M.copy_assets_to_project = function(project_path)
  local plugin_assets = core.get_asset_dir()
  local project_assets = project_path .. "/assets"
  
  -- Create project assets directory
  vim.fn.mkdir(project_assets, "p")
  
  -- Copy bundled p5.d.ts if it exists
  local bundled_types_src = plugin_assets .. "/types/p5.d.ts"
  local bundled_types_dest = project_assets .. "/types/p5.d.ts"
  
  if vim.fn.filereadable(bundled_types_src) == 1 then
    vim.fn.system("cp '" .. bundled_types_src .. "' '" .. bundled_types_dest .. "'")
    core.notify_fallback("Copied bundled p5.d.ts to project", "info")
  else
    core.notify_fallback("Bundled p5.d.ts not found - type support may be limited", "warn")
  end
  
  -- Copy supporting type files if they exist
  local support_files = {"constants.d.ts", "literals.d.ts"}
  for _, file in ipairs(support_files) do
    local src = plugin_assets .. "/types/" .. file
    local dest = project_assets .. "/types/" .. file
    if vim.fn.filereadable(src) == 1 then
      vim.fn.system("cp '" .. src .. "' '" .. dest .. "'")
    end
  end
  
  -- Copy unminified core files if they exist
  local core_src = plugin_assets .. "/core"
  local core_dest = project_assets .. "/core"
  if vim.fn.isdirectory(core_src) == 1 then
    local unminified_files = {"p5.js", "p5.sound.js"}
    for _, file in ipairs(unminified_files) do
      local src_file = core_src .. "/" .. file
      local dest_file = core_dest .. "/" .. file
      if vim.fn.filereadable(src_file) == 1 then
        vim.fn.system("cp '" .. src_file .. "' '" .. dest_file .. "'")
      end
    end
  end
end

M.setup = function(config)
  M.config = config
end

return M