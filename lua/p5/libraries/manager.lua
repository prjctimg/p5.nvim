local M = {}

-- Known p5.js contributor libraries registry
local library_registry = {
  -- Core libraries (bundled)
  sound = {
    name = "p5.sound",
    url = "https://cdn.jsdelivr.net/npm/p5@latest/lib/addons/p5.sound.js",
    description = "Sound synthesis and analysis library",
    bundled = true,
    category = "Core"
  },
  
  -- Contributor libraries
  ml5 = {
    name = "ml5.js",
    url = "https://unpkg.com/ml5@latest/dist/ml5.min.js",
    description = "Friendly machine learning library",
    bundled = false,
    category = "AI/ML"
  },
  collide2d = {
    name = "p5.collide2d",
    url = "https://cdn.jsdelivr.net/gh/bmoren/p5.collide2d/p5.collide2d.js",
    description = "2D collision detection library",
    bundled = false,
    category = "Physics"
  },
  chart = {
    name = "p5.chart",
    url = "https://cdn.jsdelivr.net/npm/p5.chart@latest/dist/p5.chart.min.js",
    description = "Data visualization and charting",
    bundled = false,
    category = "Data"
  },
  createrLoop = {
    name = "p5.createLoop",
    url = "https://cdn.jsdelivr.net/gh/nature-of-code/p5.createLoop/dist/p5.createLoop.min.js",
    description = "Animation loop helper",
    bundled = false,
    category = "Animation"
  },
  fillerGradient = {
    name = "p5.fillGradient",
    url = "https://cdn.jsdelivr.net/gh/BkTi/p5.fillGradient/p5.fillGradient.js",
    description = "Gradient fills for shapes",
    bundled = false,
    category = "Drawing"
  },
  brush = {
    name = "p5.brush",
    url = "https://cdn.jsdelivr.net/gh/VectorKids/p5.brush/p5.brush.min.js",
    description = "Custom brushes and effects",
    bundled = false,
    category = "Drawing"
  },
  chroma = {
    name = "p5.chroma",
    url = "https://cdn.jsdelivr.net/gh/creative-coder/p5.chroma/p5.chroma.js",
    description = "Advanced color manipulation",
    bundled = false,
    category = "Color"
  },
  geolocation = {
    name = "p5.geolocation",
    url = "https://cdn.jsdelivr.net/gh/IDMNYU/p5.geolocation/lib/p5.geolocation.js",
    description = "Geolocation services",
    bundled = false,
    category = "Hardware"
  },
  webmidi = {
    name = "WEBMIDI.js",
    url = "https://cdn.jsdelivr.net/npm/webmidi@latest/dist/webmidi.min.js",
    description = "MIDI communication",
    bundled = false,
    category = "Sound"
  },
  party = {
    name = "p5.party",
    url = "https://cdn.jsdelivr.net/gh/p5party/p5.party/dist/p5.party.min.js",
    description = "Multiplayer networking",
    bundled = false,
    category = "Networking"
  }
}

-- Get cache directory for libraries
local function get_cache_dir()
  local config = require("p5.config")
  local cache_dir = config.get_cache_dir()
  local lib_cache_dir = cache_dir .. "/libraries"
  vim.fn.mkdir(lib_cache_dir, "p")
  return lib_cache_dir
end

-- Download a library using curl
local function download_library(library_key, library_info, cache_dir)
  local filename = library_info.name:gsub("[^%w%.]", "_") .. ".js"
  local filepath = cache_dir .. "/" .. filename
  
  -- Check if already exists
  if vim.fn.filereadable(filepath) == 1 then
    vim.notify("Library " .. library_info.name .. " already cached", vim.log.levels.INFO)
    return filepath
  end
  
  vim.notify("Downloading " .. library_info.name .. "...", vim.log.levels.INFO)
  
  -- Use curl to download
  local curl_cmd = string.format('curl --silent --fail --location --output "%s" "%s"', filepath, library_info.url)
  local result = vim.fn.system(curl_cmd)
  
  if vim.v.shell_error == 0 then
    local size = vim.fn.getfsize(filepath)
    vim.notify("✓ Downloaded " .. library_info.name .. " (" .. size .. " bytes)", vim.log.levels.INFO)
    return filepath
  else
    vim.notify("✗ Failed to download " .. library_info.name, vim.log.levels.ERROR)
    return nil
  end
end

-- Get library script tag for HTML
local function get_script_tag(library_key, project_dir)
  local library_info = library_registry[library_key]
  if not library_info then
    return ""
  end
  
  if library_info.bundled then
    -- Use bundled version
    local plugin_root = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h:h:h")
    local asset_path = plugin_root .. "/assets/core/" .. library_info.name .. ".js"
    
    if vim.fn.filereadable(asset_path) == 1 then
      return '  <script src="lib/' .. library_info.name .. '.js"></script>'
    end
  else
    -- Use cached version
    local cache_dir = get_cache_dir()
    local filename = library_info.name:gsub("[^%w%.]", "_") .. ".js"
    local cached_file = cache_dir .. "/" .. filename
    
    if vim.fn.filereadable(cached_file) == 1 then
      return '  <script src="lib/' .. filename .. '"></script>'
    end
  end
  
  return ""
end

-- Update index.html with selected libraries
local function update_index_html(project_dir, selected_libraries)
  local index_file = project_dir .. "/index.html"
  
  if vim.fn.filereadable(index_file) ~= 1 then
    vim.notify("index.html not found in project directory", vim.log.levels.ERROR)
    return false
  end
  
  -- Read current index.html
  local lines = vim.fn.readfile(index_file)
  local new_lines = {}
  local in_body = false
  local libraries_inserted = false
  
  for _, line in ipairs(lines) do
    table.insert(new_lines, line)
    
    -- Insert libraries after existing script tags but before closing head
    if not libraries_inserted and line:match("<!DOCTYPE html>") then
      -- Skip, we'll insert later
    elseif not libraries_inserted and line:match("</head>") then
      -- Insert libraries before closing head
      for _, lib_key in ipairs(selected_libraries) do
        local script_tag = get_script_tag(lib_key, project_dir)
        if script_tag ~= "" then
          table.insert(new_lines, script_tag)
        end
      end
      libraries_inserted = true
    end
  end
  
  -- Write back to file
  vim.fn.writefile(new_lines, index_file)
  vim.notify("Updated index.html with " .. #selected_libraries .. " libraries", vim.log.levels.INFO)
  return true
end

-- Copy library to project lib directory
local function copy_to_project(library_key, project_dir)
  local library_info = library_registry[library_key]
  if not library_info then
    return false
  end
  
  vim.fn.mkdir(project_dir .. "/lib", "p")
  
  if library_info.bundled then
    -- Copy from bundled assets
    local plugin_root = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h:h:h")
    local src_file = plugin_root .. "/assets/core/" .. library_info.name .. ".js"
    local dst_file = project_dir .. "/lib/" .. library_info.name .. ".js"
    
    if vim.fn.filereadable(src_file) == 1 then
      vim.fn.copy(src_file, dst_file)
      return true
    end
  else
    -- Copy from cache
    local cache_dir = get_cache_dir()
    local filename = library_info.name:gsub("[^%w%.]", "_") .. ".js"
    local cached_file = cache_dir .. "/" .. filename
    local dst_file = project_dir .. "/lib/" .. filename
    
    if vim.fn.filereadable(cached_file) == 1 then
      vim.fn.copy(cached_file, dst_file)
      return true
    end
  end
  
  return false
end

-- Enhanced library selection with nui.nvim
local function select_libraries()
  local menu = require("p5.ui.menu")
  
  -- Convert registry to menu items
  local items = {}
  for key, info in pairs(library_registry) do
    local status = info.bundled and "✅ bundled" or "⬇️ download"
    table.insert(items, {
      key = key,
      name = info.name,
      description = info.description,
      category = info.category,
      status = status
    })
  end
  
  -- Sort by category and name
  table.sort(items, function(a, b)
    if a.category ~= b.category then
      return a.category < b.category
    end
    return a.name < b.name
  end)
  
  -- Format function for menu items
  local function format_item(item)
    return string.format("%-30s %s - %s", item.name, item.status, item.description)
  end
  
  local selected_keys = {}
  
  -- Show multi-select menu
  menu.multi_select(items, function(selected_items)
    for _, item in ipairs(selected_items) do
      table.insert(selected_keys, item.key)
    end
  end, {
    title = "Select p5.js Libraries (Space to toggle)",
    format_item = format_item,
    width = 80
  })
  
  return selected_keys
end

-- Main library download function
function M.download_libraries(project_dir)
  project_dir = project_dir or vim.fn.getcwd()
  
  -- Select libraries
  local selected_libraries = select_libraries()
  
  if #selected_libraries == 0 then
    vim.notify("No libraries selected", vim.log.levels.INFO)
    return true
  end
  
  vim.notify("Downloading " .. #selected_libraries .. " libraries...", vim.log.levels.INFO)
  
  local cache_dir = get_cache_dir()
  local success_count = 0
  
  -- Download libraries
  for _, lib_key in ipairs(selected_libraries) do
    local library_info = library_registry[lib_key]
    if library_info and not library_info.bundled then
      if download_library(lib_key, library_info, cache_dir) then
        success_count = success_count + 1
      end
    end
  end
  
  -- Copy libraries to project
  vim.notify("Copying libraries to project...", vim.log.levels.INFO)
  for _, lib_key in ipairs(selected_libraries) do
    if copy_to_project(lib_key, project_dir) then
      success_count = success_count + 1
    end
  end
  
  -- Update index.html
  if #selected_libraries > 0 then
    update_index_html(project_dir, selected_libraries)
  end
  
  vim.notify("✓ Library download complete. " .. success_count .. "/" .. #selected_libraries .. " successful", vim.log.levels.INFO)
  return true
end

-- List available libraries
function M.list_libraries()
  vim.notify("Available p5.js libraries:", vim.log.levels.INFO)
  vim.notify("", vim.log.levels.INFO)
  
  local categories = {}
  for _, info in pairs(library_registry) do
    if not categories[info.category] then
      categories[info.category] = {}
    end
    table.insert(categories[info.category], info)
  end
  
  for category, libs in pairs(categories) do
    vim.notify("📂 " .. category .. ":", vim.log.levels.INFO)
    for _, lib in ipairs(libs) do
      local status = lib.bundled and "✅ bundled" or "⬇️ download"
      vim.notify("  " .. lib.name .. " - " .. status, vim.log.levels.INFO)
      vim.notify("    " .. lib.description, vim.log.levels.INFO)
    end
    vim.notify("", vim.log.levels.INFO)
  end
end

return M