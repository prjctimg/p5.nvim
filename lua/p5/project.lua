-- Project creation and management for p5.nvim
local P = {}
local core = require("p5.core")
local libraries = require("p5.libraries")
local notify = core.notify

local required_assets = {
  "libs/p5.js",
  "libs/p5.sound.js",
  "types/p5.d.ts"
}

-- Validate bundled assets before project creation
P.validate_bundled_assets = function()
  local plugin_assets = core.get_asset_dir()
  local missing = {}

  for _, asset in ipairs(required_assets) do
    if not core.file_exists(plugin_assets .. "/" .. asset) then
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
  local missing = {}

  for _, path in ipairs(required_assets) do
    if not core.file_exists(project_assets .. "/" .. path) then
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

  vim.fn.mkdir(project_assets, "p")
  vim.fn.mkdir(project_assets .. "/types", "p")
  vim.fn.mkdir(project_assets .. "/libs", "p")

  local pending_copies = 0
  local copy_errors = {}

  local function try_copy(src, dest)
    if core.file_exists(src) then
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
      if vim.uv and vim.uv.fs_copyfile then
        vim.uv.fs_copyfile(src, dest, on_copy)
      else
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

  try_copy(plugin_assets .. "/types/p5.d.ts", project_assets .. "/types/p5.d.ts")

  if core.dir_exists(plugin_assets .. "/libs") then
    for _, file in ipairs({"p5.js", "p5.sound.js"}) do
      try_copy(plugin_assets .. "/libs/" .. file, project_assets .. "/libs/" .. file)
    end
  end

  try_copy(plugin_assets .. "/favicon.ico", project_assets .. "/favicon.ico")

  if pending_copies == 0 and callback then
    vim.schedule(function()
      callback(#copy_errors > 0 and table.concat(copy_errors, ", ") or nil)
    end)
  end
end

-- Check if current directory is a valid p5.js sketchspace
P.is_p5_project = function(dir)
  local cwd = vim.fs.normalize(dir or vim.fn.getcwd())

  local config_file = cwd .. "/p5.json"
  if not core.file_exists(config_file) then
    return false, "No p5.json found in " .. cwd
  end

  local config, err = core.read_json_file(config_file)
  if err or type(config) ~= "table" then
    return false, "Invalid p5.json format"
  end

  if config.includes ~= nil then
    if type(config.includes) ~= "table" then
      return false, "p5.json: 'includes' must be an array"
    end
    for _, item in ipairs(config.includes) do
      if type(item) ~= "string" then
        return false, "p5.json: 'includes' must contain only strings"
      end
    end
  end

  if config.libs ~= nil then
    if type(config.libs) ~= "table" then
      return false, "p5.json: 'libs' must be an object"
    end
    for key, value in pairs(config.libs) do
      if type(key) ~= "string" then
        return false, "p5.json: 'libs' keys must be strings"
      end
      if type(value) ~= "string" then
        return false, "p5.json: 'libs' values must be strings (versions)"
      end
    end
  end

  local sketch_file = cwd .. "/sketch.js"
  local has_sketch = core.file_exists(sketch_file)

  local includes = config.includes or {"sketch.js"}

  return true, "Valid p5.js sketchspace detected", {
    has_sketch = has_sketch,
    has_index = core.file_exists(cwd .. "/index.html"),
    config = config,
    includes = includes,
    project_root = cwd
  }
end

P.setup = function(config)
  P.config = config
end

return P