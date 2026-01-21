local M = {}

-- Get the plugin root directory
local function get_plugin_root()
  local config = require("p5.config")
  return vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h:h:h")
end

-- Get bundled assets path
local function get_bundled_asset_path(asset_name)
  local plugin_root = get_plugin_root()
  return plugin_root .. "/assets/core/" .. asset_name
end

-- Create basic HTML template
local function create_html_template(project_dir, libraries)
  local html = [[<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>p5.js Sketch</title>
  <style>
    body {
      margin: 0;
      padding: 0;
      overflow: hidden;
    }
  </style>
</head>
<body>
  <script src="lib/p5.js"></script>]]

  -- Add sound library if enabled
  if libraries.sound then
    html = html .. "\n  <script src=\"lib/p5.sound.js\"></script>"
  end

  html = html .. [[\n  <script src="sketch.js"></script>
</body>
</html>]]

  local file = io.open(project_dir .. "/index.html", "w")
  if file then
    file:write(html)
    file:close()
    return true
  end
  return false
end

-- Create basic CSS template
local function create_css_template(project_dir)
  local css = [[/* p5.js Sketch Styles */
body {
  margin: 0;
  padding: 0;
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  background: #f0f0f0;
}

canvas {
  display: block;
}
]]

  local file = io.open(project_dir .. "/style.css", "w")
  if file then
    file:write(css)
    file:close()
    return true
  end
  return false
end

-- Create basic JavaScript template
local function create_js_template(project_dir)
  local js = [[// p5.js Sketch
function setup() {
  createCanvas(800, 600);
  background(220);
}

function draw() {
  // Your drawing code here
}

// Mouse interaction example
function mousePressed() {
  fill(random(255), random(255), random(255));
  ellipse(mouseX, mouseY, 50, 50);
}
]]

  local file = io.open(project_dir .. "/sketch.js", "w")
  if file then
    file:write(js)
    file:close()
    return true
  end
  return false
end

-- Copy bundled assets to project
local function copy_bundled_assets(project_dir, libraries)
  -- Create lib directory
  vim.fn.mkdir(project_dir .. "/lib", "p")

  -- Copy core p5.js
  local plugin_root = get_plugin_root()
  local p5_src = plugin_root .. "/assets/core/p5.js"
  local p5_dst = project_dir .. "/lib/p5.js"

  if vim.fn.filereadable(p5_src) == 1 then
    vim.fn.copy(p5_src, p5_dst)
  else
    vim.notify("Warning: Bundled p5.js not found at " .. p5_src, vim.log.levels.WARN)
    return false
  end

  -- Copy sound library if enabled
  if libraries.sound then
    local sound_src = plugin_root .. "/assets/core/p5.sound.js"
    local sound_dst = project_dir .. "/lib/p5.sound.js"

    if vim.fn.filereadable(sound_src) == 1 then
      vim.fn.copy(sound_src, sound_dst)
    else
      vim.notify("Warning: Bundled p5.sound.js not found at " .. sound_src, vim.log.levels.WARN)
    end
  end

  return true
end

-- Main project creation function
function M.create_project()
  -- Get current directory as default
  local current_dir = vim.fn.getcwd()
  
  -- Ask user for project directory
  local project_name = vim.fn.input("Project name (default: sketch): ", "sketch")
  if project_name == "" then
    project_name = "sketch"
  end

  local project_dir = current_dir .. "/" .. project_name
  
  -- Check if directory already exists
  if vim.fn.isdirectory(project_dir) == 1 then
    local overwrite = vim.fn.confirm("Directory '" .. project_name .. "' already exists. Overwrite?", "&Yes\n&No", 2)
    if overwrite ~= 1 then
      vim.notify("Project creation cancelled", vim.log.levels.INFO)
      return
    end
  else
    -- Create project directory
    vim.fn.mkdir(project_dir, "p")
  end

  -- Get library configuration
  local config = require("p5.config")
  local libraries = config.get_libraries()

  -- Create project files
  vim.notify("Creating p5.js project...", vim.log.levels.INFO)

  -- Copy bundled assets
  if not copy_bundled_assets(project_dir, libraries) then
    vim.notify("Failed to copy bundled assets", vim.log.levels.ERROR)
    return
  end

  -- Create templates
  if not create_html_template(project_dir, libraries) then
    vim.notify("Failed to create index.html", vim.log.levels.ERROR)
    return
  end

  if not create_css_template(project_dir) then
    vim.notify("Failed to create style.css", vim.log.levels.ERROR)
    return
  end

  if not create_js_template(project_dir) then
    vim.notify("Failed to create sketch.js", vim.log.levels.ERROR)
    return
  end

  vim.notify("✓ p5.js project created successfully!", vim.log.levels.INFO)
  vim.notify("📁 " .. project_dir, vim.log.levels.INFO)
  vim.notify("📄 Files: index.html, style.css, sketch.js", vim.log.levels.INFO)
  vim.notify("📚 Libraries: " .. (libraries.sound and "p5.sound" or "p5.js only"), vim.log.levels.INFO)

  -- Ask if user wants to open the project
  local open_project = vim.fn.confirm("Open project in Neovim?", "&Yes\n&No", 1)
  if open_project == 1 then
    vim.cmd("cd " .. project_dir)
    vim.cmd("edit sketch.js")
  end
end

return M