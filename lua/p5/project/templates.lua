local M = {}

-- Project templates
local templates = {
  basic = {
    js = [[// p5.js Basic Sketch
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
]],
    css = [[/* Basic p5.js Sketch Styles */
body {
  margin: 0;
  padding: 0;
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  background: #f0f0f0;
  font-family: Arial, sans-serif;
}

canvas {
  display: block;
  border: 1px solid #ccc;
  box-shadow: 0 2px 10px rgba(0,0,0,0.1);
}

.info {
  position: absolute;
  top: 10px;
  left: 10px;
  background: rgba(255,255,255,0.9);
  padding: 10px;
  border-radius: 5px;
  font-size: 12px;
}
]]
  },
  particles = {
    js = [[// p5.js Particles Sketch
let particles = [];

function setup() {
  createCanvas(800, 600);
  background(20);
  
  // Create initial particles
  for (let i = 0; i < 100; i++) {
    particles.push(new Particle());
  }
}

function draw() {
  background(20, 25); // Trail effect
  
  for (let i = particles.length - 1; i >= 0; i--) {
    let p = particles[i];
    p.update();
    p.display();
    
    if (p.isDead()) {
      particles.splice(i, 1);
    }
  }
  
  // Add new particles occasionally
  if (frameCount % 5 === 0) {
    particles.push(new Particle());
  }
}

class Particle {
  constructor() {
    this.x = width / 2;
    this.y = height / 2;
    this.vx = random(-5, 5);
    this.vy = random(-5, 5);
    this.alpha = 255;
    this.size = random(3, 8);
    this.color = color(random(100, 255), random(100, 255), random(100, 255));
  }
  
  update() {
    this.x += this.vx;
    this.y += this.vy;
    this.alpha -= 2;
    this.size *= 0.99;
  }
  
  display() {
    noStroke();
    fill(red(this.color), green(this.color), blue(this.color), this.alpha);
    ellipse(this.x, this.y, this.size);
  }
  
  isDead() {
    return this.alpha <= 0 || this.size < 0.5;
  }
}

function mousePressed() {
  // Burst of particles at mouse position
  for (let i = 0; i < 20; i++) {
    let p = new Particle();
    p.x = mouseX;
    p.y = mouseY;
    p.vx = random(-8, 8);
    p.vy = random(-8, 8);
    particles.push(p);
  }
}
]],
    css = [[/* Particles Sketch Styles */
body {
  margin: 0;
  padding: 0;
  background: #000;
  overflow: hidden;
  font-family: 'Courier New', monospace;
}

canvas {
  display: block;
  cursor: crosshair;
}

.info {
  position: absolute;
  top: 10px;
  right: 10px;
  color: #fff;
  background: rgba(0,0,0,0.7);
  padding: 10px;
  border-radius: 5px;
  font-size: 12px;
}
]]
  },
  animation = {
    js = [[// p5.js Animation Sketch
let angle = 0;
let radius = 100;

function setup() {
  createCanvas(800, 600);
  background(240);
}

function draw() {
  background(240, 10); // Fade effect
  
  // Draw rotating circles
  push();
  translate(width / 2, height / 2);
  
  for (let i = 0; i < 8; i++) {
    let x = cos(angle + (TWO_PI * i / 8)) * radius;
    let y = sin(angle + (TWO_PI * i / 8)) * radius;
    
    fill(100 + i * 20, 150, 200 - i * 15, 150);
    noStroke();
    ellipse(x, y, 40, 40);
    
    // Connect to center
    stroke(100 + i * 20, 150, 200 - i * 15, 50);
    line(0, 0, x, y);
  }
  
  // Center circle
  fill(50, 100, 150);
  ellipse(0, 0, 60, 60);
  
  pop();
  
  angle += 0.02;
  radius = 100 + sin(angle * 2) * 30;
}

function mousePressed() {
  // Reset and randomize
  angle = random(TWO_PI);
  radius = random(50, 150);
  background(240);
}
]],
    css = [[/* Animation Sketch Styles */
body {
  margin: 0;
  padding: 0;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  font-family: Arial, sans-serif;
}

canvas {
  display: block;
  border-radius: 50%;
  box-shadow: 0 20px 60px rgba(0,0,0,0.3);
}

.info {
  position: absolute;
  bottom: 20px;
  left: 50%;
  transform: translateX(-50%);
  background: rgba(255,255,255,0.9);
  padding: 15px 30px;
  border-radius: 25px;
  text-align: center;
}
]]
  }
}

-- Get the plugin root directory
local function get_plugin_root()
  return vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h:h:h")
end

-- Create enhanced HTML template
local function create_html_template(project_dir, libraries, template_name)
  local html = [[<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>p5.js ]] .. template_name:gsub("^%l", string.upper) .. [[ Sketch</title>
  <link rel="stylesheet" href="style.css">
</head>
<body>
  <div class="info">
    <strong>p5.js ]] .. template_name:gsub("^%l", string.upper) .. [[</strong><br>
    Click to interact • Press 'R' to reset
  </div>
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

-- Create project files based on template
local function create_project_files(project_dir, template_name, libraries)
  local template = templates[template_name]
  if not template then
    template = templates.basic  -- fallback to basic
  end

  -- Create JavaScript file
  local js_file = io.open(project_dir .. "/sketch.js", "w")
  if js_file then
    js_file:write(template.js)
    js_file:close()
  else
    return false
  end

  -- Create CSS file
  local css_file = io.open(project_dir .. "/style.css", "w")
  if css_file then
    css_file:write(template.css)
    css_file:close()
  else
    return false
  end

  -- Create HTML file
  return create_html_template(project_dir, libraries, template_name)
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

  -- Copy TypeScript definitions if they exist
  if vim.fn.isdirectory(plugin_root .. "/assets/types") == 1 then
    vim.fn.mkdir(project_dir .. "/types", "p")
    vim.fn.copy(plugin_root .. "/assets/types/*", project_dir .. "/types/")
  end

  return true
end

-- Create README.md for the project
local function create_readme(project_dir, template_name, libraries)
  local readme = [[# ]] .. (template_name:gsub("^%l", string.upper)) .. [[ p5.js Sketch

A p5.js creative coding sketch created with p5.nvim.

## Getting Started

Open `index.html` in your browser or use the p5.nvim development server:

```bash
:P5Server
```

## Project Structure

- `sketch.js` - Main p5.js code
- `index.html` - HTML page
- `style.css` - Styling
- `lib/` - p5.js libraries]]

  if libraries.sound then
    readme = readme .. "\n- `p5.sound.js` - Sound library included"
  end

  readme = readme .. [[\n\n## Customization

Edit `sketch.js` to modify the sketch behavior.
Edit `style.css` to change the appearance.
Edit `index.html` to add additional libraries or modify the page structure.

## Learn More

- [p5.js Reference](https://p5js.org/reference/)
- [p5.nvim Documentation](https://github.com/prjctimg/p5.nvim)
]]

  local file = io.open(project_dir .. "/README.md", "w")
  if file then
    file:write(readme)
    file:close()
    return true
  end
  return false
end

-- Interactive template selection with nui.nvim
local function select_template()
  local menu = require("p5.ui.menu")
  
  -- Convert templates to menu items
  local items = {}
  for name, template in pairs(templates) do
    table.insert(items, {
      key = name,
      name = name:gsub("^%l", string.upper),
      description = get_template_description(name)
    })
  end
  
  -- Format function for menu items
  local function format_item(item)
    return string.format("%-15s %s", item.name, item.description)
  end
  
  local selected_template = nil
  
  -- Show single-select menu
  menu.single_select(items, function(selected_items)
    if #selected_items > 0 then
      selected_template = selected_items[1].key
    end
  end, {
    title = "Select Project Template",
    format_item = format_item,
    width = 60
  })
  
  return selected_template or "basic"
end

-- Get template description
local function get_template_description(name)
  local descriptions = {
    basic = "Simple p5.js sketch with basic functionality",
    particles = "Interactive particle system with mouse interaction",
    animation = "Animated patterns and rotating shapes"
  }
  return descriptions[name] or "p5.js project template"
end

-- Enhanced project creation function
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

  -- Select template (enhanced in Phase 3 with nui.nvim)
  local template_name = select_template()

  -- Create project files
  vim.notify("Creating p5.js project with " .. template_name .. " template...", vim.log.levels.INFO)

  -- Copy bundled assets
  if not copy_bundled_assets(project_dir, libraries) then
    vim.notify("Failed to copy bundled assets", vim.log.levels.ERROR)
    return
  end

  -- Create template-based files
  if not create_project_files(project_dir, template_name, libraries) then
    vim.notify("Failed to create project files", vim.log.levels.ERROR)
    return
  end

  -- Create README
  create_readme(project_dir, template_name, libraries)

  vim.notify("✓ Enhanced p5.js project created successfully!", vim.log.levels.INFO)
  vim.notify("📁 " .. project_dir, vim.log.levels.INFO)
  vim.notify("📄 Files: index.html, style.css, sketch.js, README.md", vim.log.levels.INFO)
  vim.notify("📚 Template: " .. template_name:gsub("^%l", string.upper), vim.log.levels.INFO)
  vim.notify("🔧 Libraries: " .. (libraries.sound and "p5.sound" or "p5.js only"), vim.log.levels.INFO)

  -- Ask if user wants to open the project
  local open_project = vim.fn.confirm("Open project in Neovim?", "&Yes\n&No", 1)
  if open_project == 1 then
    vim.cmd("cd " .. project_dir)
    vim.cmd("edit sketch.js")
  end
end

return M