-- Project creation and management for p5.nvim
local P = {}
local core = require("p5.core")
local notify = core.notify

-- Validate bundled assets before project creation
P.validate_bundled_assets = function()
  local plugin_assets = core.get_asset_dir()
  local required_assets = {
    "libs/p5.js",
    "libs/p5.sound.js", 
    "types/p5.d.ts"
  }
  
  local missing = {}
  for _, asset in ipairs(required_assets) do
    local full_path = plugin_assets .. "/" .. asset
    if vim.fn.filereadable(full_path) == 0 then
      table.insert(missing, asset)
    end
  end
  
  if #missing > 0 then
    notify("Missing required assets: " .. table.concat(missing, ", "), "error")
    return false
  end
  
  return true
end

-- Validate asset paths in generated config files
P.validate_asset_paths = function(project_path)
  local project_assets = project_path .. "/assets"
  local required_paths = {
    "libs/p5.js",
    "libs/p5.sound.js",
    "types/p5.d.ts"
  }
  
  local missing = {}
  for _, path in ipairs(required_paths) do
    local full_path = project_assets .. "/" .. path
    if vim.fn.filereadable(full_path) == 0 then
      table.insert(missing, path)
    end
  end
  
  if #missing > 0 then
    notify("Asset path validation failed - missing: " .. table.concat(missing, ", "), "warn")
    return false
  end
  
  return true
end

-- Create new p5.js project
P.create_project = function(name)
  name = name or "p5-sketch"
  
  -- Validate bundled assets first
  if not P.validate_bundled_assets() then
    notify("Cannot create project - required assets are missing", "error")
    return false
  end
  
  -- Check if directory already exists
  if vim.fn.isdirectory(name) ~= 0 then
    notify("Directory '" .. name .. "' already exists", "error")
    return false
  end
  
  -- Notify project creation start
  notify("Creating p5.js project: " .. name .. "...", "info")
  
  -- Create project directory
  vim.fn.mkdir(name, "p")
  local project_path = vim.fn.fnamemodify(name, ":p")
  
  -- Create project files
  P.create_files(project_path)
  
  -- Notify successful asset copying
  notify("Assets copied successfully. Project created!", "ok")
  
  -- Change CWD to new project directory
  vim.cmd("cd " .. project_path)
  
  -- Open sketch.js in editor
  vim.cmd("edit " .. project_path .. "/sketch.js")
  
  notify("Changed directory to: " .. project_path, "info")
  return project_path
end

-- Create project files
P.create_files = function(project_path)
  -- Copy plugin assets to project first
  P.copy_assets_to_project(project_path)
  
  -- Validate asset paths after copying
  if not P.validate_asset_paths(project_path) then
    notify("Warning: Some asset paths may not work correctly", "warn")
  end
  
  -- Create index.html
  local index_html = [[<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>p5.js Sketch</title>
  <script src="./assets/libs/p5.js"></script>
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
  
  -- Create tsconfig.json for TypeScript projects
  local tsconfig = [[{
  "compilerOptions": {
    "target": "ES2022",
    "module": "ESNext",
    "lib": ["DOM", "ES2022"],
    "types": ["./assets/types/p5.d.ts"],
    "strict": true,
    "allowJs": true,
    "checkJs": false,
    "moduleResolution": "node",
    "allowSyntheticDefaultImports": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true
  },
  "include": [
    "**/*.ts",
    "**/*.js"
  ],
  "exclude": [
    "node_modules",
    "dist",
    "build"
  ]
}]]
  
  vim.fn.writefile(vim.split(tsconfig, "\n"), project_path .. "/tsconfig.json")
  
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
  vim.fn.mkdir(project_path .. "/assets/libs", "p")
  vim.fn.mkdir(project_path .. "/assets/contrib", "p")
end

-- Copy plugin assets to project with bundled types and libraries
P.copy_assets_to_project = function(project_path)
  local plugin_assets = core.get_asset_dir()
  local project_assets = project_path .. "/assets"
  
  -- Create project assets directory
  vim.fn.mkdir(project_assets, "p")
  vim.fn.mkdir(project_assets .. "/types", "p")
  vim.fn.mkdir(project_assets .. "/libs", "p")
  vim.fn.mkdir(project_assets .. "/contrib", "p")
  
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
  
  -- Copy bundled library files from assets/libs/
  local libs_src = plugin_assets .. "/libs"
  local libs_dest = project_assets .. "/libs"
  if vim.fn.isdirectory(libs_src) == 1 then
    local lib_files = {"p5.js", "p5.sound.js"}
    for _, file in ipairs(lib_files) do
      local src_file = libs_src .. "/" .. file
      local dest_file = libs_dest .. "/" .. file
      if vim.fn.filereadable(src_file) == 1 then
        vim.fn.system("cp '" .. src_file .. "' '" .. dest_file .. "'")
        core.notify_fallback("Copied " .. file .. " to project", "info")
      else
        core.notify_fallback("Warning: " .. file .. " not found in plugin assets", "warn")
      end
    end
  else
    core.notify_fallback("Plugin libs directory not found", "warn")
  end
end

-- Check if current directory is a valid p5.js project
P.is_p5_project = function()
  local cwd = vim.fn.getcwd()
  
  -- Check for index.html
  local index_file = cwd .. "/index.html"
  if vim.fn.filereadable(index_file) == 0 then
    return false, "No index.html found in current directory"
  end
  
  -- Check if index.html contains p5.js reference
  local index_content = table.concat(vim.fn.readfile(index_file), "\n")
  if not (index_content:match("p5%.js") or index_content:match("p5%.min%.js")) then
    return false, "index.html does not reference p5.js"
  end
  
  -- Check for sketch.js (optional but common)
  local sketch_file = cwd .. "/sketch.js"
  local has_sketch = vim.fn.filereadable(sketch_file) == 1
  
  -- Check for project configuration (optional)
  local config_file = cwd .. "/p5.json"
  local has_config = vim.fn.filereadable(config_file) == 1
  
  return true, "Valid p5.js project detected", {
    has_sketch = has_sketch,
    has_config = has_config,
    index_path = index_file
  }
end

-- Create fallback HTML for non-project directories
P.create_fallback_html = function()
  local cwd = vim.fn.getcwd()
  local fallback_html = [[<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>p5.js Test Sketch</title>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/p5.js/1.9.0/p5.min.js"></script>
  <style>
    body { margin: 0; overflow: hidden; }
    canvas { display: block; }
  </style>
</head>
<body>
  <main>
  </main>
  <script>
    function setup() {
      createCanvas(800, 600);
      background(240);
      textAlign(CENTER, CENTER);
      text("p5.js is working!", width/2, height/2 - 20);
      text("Open browser console to see integration", width/2, height/2 + 20);
    }
    
    function draw() {
      // Test console integration
      if (frameCount % 60 === 0) {
        console.log('Frame:', frameCount);
        console.info('Animation running smoothly');
      }
    }
  </script>
</body>
</html>]]
  
  local temp_file = cwd .. "/.p5-temp.html"
  vim.fn.writefile(vim.split(fallback_html, "\n"), temp_file)
  return temp_file
end

P.setup = function(config)
  P.config = config
end

return P