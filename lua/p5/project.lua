-- Project creation and management for p5.nvim
local P = {}
local core = require("p5.core")
local notify = core.notify
local libraries = require("p5.libraries")

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
  
  -- Create project directory
  vim.fn.mkdir(name, "p")
  local project_path = vim.fn.fnamemodify(name, ":p")
  
  -- Create project files synchronously (fast)
  P.create_files(project_path, function(err)
    if err then
      notify("Failed to create project: " .. err, "error")
      return
    end
    
    -- Only notify on final success
    notify("🎉 Project created: " .. name, "ok")
    
    -- Change CWD to new project directory
    vim.api.nvim_set_current_dir(project_path)
    
    -- Open sketch.js in editor
    vim.cmd({ cmd = "edit", args = { project_path .. "/sketch.js" } })
  end)
end

-- Create project files
P.create_files = function(project_path, callback)
  -- Copy plugin assets to project (async with callback)
  P.copy_assets_to_project(project_path, function(err)
    -- Validate asset paths after copying
    if not P.validate_asset_paths(project_path) then
      -- Don't spam - just continue
    end
    if callback then
      vim.schedule(function()
        callback(err)
      end)
    end
  end)
  
  -- Create index.html
  local index_html = [[<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>p5.js Sketch</title>
  <link rel="icon" type="image/x-icon" href="assets/favicon.ico">
  <script src="assets/libs/p5.js"></script>
  <script src="assets/libs/libs.js"></script>
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
  
  -- Get p5.js version from bundled library
  local p5_version = core.get_p5_version()
  
  -- Create p5.json with new structure (libs object, includes array)
  local p5_config = {
    version = p5_version,
    libs = {},
    includes = {"sketch.js"}
  }
  
  vim.fn.writefile(vim.split(vim.fn.json_encode(p5_config), "\n"), project_path .. "/p5.json")

  -- Create assets directory
  vim.fn.mkdir(project_path .. "/assets/types", "p")
  vim.fn.mkdir(project_path .. "/assets/libs", "p")

  -- Generate initial libs.js (empty since no contrib libs installed yet)
  libraries.generate_libs_js(project_path)
end

-- Copy plugin assets to project with bundled types and libraries
P.copy_assets_to_project = function(project_path, callback)
  local plugin_assets = core.get_asset_dir()
  local project_assets = project_path .. "/assets"
  
  -- Create project assets directory synchronously (fast operation)
  vim.fn.mkdir(project_assets, "p")
  vim.fn.mkdir(project_assets .. "/types", "p")
  vim.fn.mkdir(project_assets .. "/libs", "p")
  
  local pending_copies = 0
  local copy_errors = {}
  
  local function try_copy(src, dest)
    if vim.fn.filereadable(src) == 1 then
      pending_copies = pending_copies + 1
      local function on_copy(err)
        pending_copies = pending_copies - 1
        if err then
          table.insert(copy_errors, dest .. ": " .. vim.inspect(err))
        end
        if pending_copies == 0 and callback then
          vim.schedule(function()
            callback(#copy_errors > 0 and table.concat(copy_errors, ", ") or nil)
          end)
        end
      end
      -- Use vim.uv for async copy if available (0.10+), fallback to sync
      if vim.uv and vim.uv.fs_copyfile then
        vim.uv.fs_copyfile(src, dest, on_copy)
      else
        -- Fallback for older Neovim versions
        local result = vim.fn.system({"cp", src, dest})
        vim.schedule(function()
          if vim.v.shell_error ~= 0 then
            on_copy(result)
          else
            on_copy(nil)
          end
        end)
      end
    end
  end
  
  -- Copy bundled p5.d.ts
  try_copy(plugin_assets .. "/types/p5.d.ts", project_assets .. "/types/p5.d.ts")
  
  -- Copy supporting type files
  for _, file in ipairs({"constants.d.ts", "literals.d.ts"}) do
    try_copy(plugin_assets .. "/types/" .. file, project_assets .. "/types/" .. file)
  end
  
  -- Copy bundled library files
  if vim.fn.isdirectory(plugin_assets .. "/libs") == 1 then
    for _, file in ipairs({"p5.js", "p5.sound.js"}) do
      try_copy(plugin_assets .. "/libs/" .. file, project_assets .. "/libs/" .. file)
    end
  end
  
  -- Copy favicon
  try_copy(plugin_assets .. "/favicon.ico", project_assets .. "/favicon.ico")
  
  -- If no async copies were started, call callback immediately
  if pending_copies == 0 and callback then
    vim.schedule(function()
      callback(#copy_errors > 0 and table.concat(copy_errors, ", ") or nil)
    end)
  end
end

-- Check if current directory is a valid p5.js sketchspace
P.is_p5_project = function(dir)
  local cwd = dir or vim.fn.getcwd()
  
  -- Check for p5.json (required for sketchspace)
  local config_file = cwd .. "/p5.json"
  if vim.fn.filereadable(config_file) == 0 then
    return false, "No p5.json found in " .. cwd
  end
  
  -- Validate p5.json is valid JSON
  local ok, config = pcall(vim.fn.json_decode, table.concat(vim.fn.readfile(config_file), "\n"))
  if not ok or type(config) ~= "table" then
    return false, "Invalid p5.json format"
  end
  
  -- Check for sketch.js (optional but expected)
  local sketch_file = cwd .. "/sketch.js"
  local has_sketch = vim.fn.filereadable(sketch_file) == 1
  
  -- Get includes from config (defaults to sketch.js)
  local includes = config.includes or {"sketch.js"}
  
  return true, "Valid p5.js sketchspace detected", {
    has_sketch = has_sketch,
    has_index = vim.fn.filereadable(cwd .. "/index.html") == 1,
    config = config,
    includes = includes,
    project_root = cwd
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