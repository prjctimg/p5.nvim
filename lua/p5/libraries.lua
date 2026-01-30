-- Library management for p5.nvim
local M = {}
local core = require("p5.core")

-- Available contributor libraries from p5js.org
M.contributor_libs = {
  {
    name = "p5.anaglyph",
    description = "Create 3D stereoscopic scenes",
    cdn = "https://cdn.jsdelivr.net/gh/jenna-deboisblanc/p5.anaglyph@master/dist/p5.anaglyph.js"
  },
  {
    name = "p5.bezier",
    description = "Draw complex Bézier curves",
    cdn = "https://cdn.jsdelivr.net/gh/peilingjiang/p5.bezier@master/dist/p5.bezier.js"
  },
  {
    name = "p5.brush",
    description = "Custom brushes and effects",
    cdn = "https://cdn.jsdelivr.net/gh/alejandrocamposuribe/p5.brush@master/dist/p5.brush.js"
  },
  {
    name = "p5.fillGradient",
    description = "Gradient fills for shapes",
    cdn = "https://cdn.jsdelivr.net/gh/jorgemoreno/p5.fillGradient@master/dist/p5.fillGradient.js"
  },
  {
    name = "p5.cmyk",
    description = "CMYK color support",
    cdn = "https://cdn.jsdelivr.net/gh/jtnimoy/p5.cmyk@master/lib/p5.cmyk.js"
  },
  {
    name = "p5.play",
    description = "Game engine with physics",
    cdn = "https://cdn.jsdelivr.net/npm/p5play@latest/lib/p5play.js"
  },
  {
    name = "p5.collide2d",
    description = "2D collision detection",
    cdn = "https://cdn.jsdelivr.net/gh/benmoren/p5.collide2d@master/lib/p5.collide2d.js"
  },
  {
    name = "ml5",
    description = "Machine learning for the web",
    cdn = "https://unpkg.com/ml5@latest/dist/ml5.min.js"
  },
  {
    name = "p5.speech",
    description = "Speech synthesis and recognition",
    cdn = "https://cdn.jsdelivr.net/gh/IDMNYU/p5.speech@master/lib/p5.speech.js"
  },
  {
    name = "p5.party",
    description = "Networked multiplayer support",
    cdn = "https://cdn.jsdelivr.net/gh/justinbakse/p5.party@master/dist/p5.party.js"
  }
}

-- Show library picker
M.show_library_picker = function(callback)
  local snacks = require("snacks")
  local items = {}

  for _, lib in ipairs(M.contributor_libs) do
    table.insert(items, {
      text = lib.name,
      description = lib.description,
      lib = lib
    })
  end

  snacks.picker.pick({
    items = items,
    title = "Select p5.js Libraries",
    multi = true,
    format = "text",
    on_submit = function(selected)
      local libs = {}
      for _, item in ipairs(selected) do
        table.insert(libs, item.lib)
      end
      callback(libs)
    end
  })
end

-- Install libraries
M.install_libs = function(lib_names)
  if #lib_names == 0 then
    M.show_library_picker(M.install_selected_libs)
    return
  end

  local libs = {}
  for _, name in ipairs(lib_names) do
    for _, lib in ipairs(M.contributor_libs) do
      if lib.name == name then
        table.insert(libs, lib)
        break
      end
    end
  end

  M.install_selected_libs(libs)
end

-- Install selected libraries
M.install_selected_libs = function(libs)
  if #libs == 0 then
    core.notify("No libraries selected", "warn")
    return
  end

  local config = core.read_workspace_config()
  if not config then
    core.notify("Not in a p5.js project", "error")
    return
  end

  local project_path = vim.fn.getcwd()
  local contrib_dir = project_path .. "/assets/contrib"
  
  vim.fn.mkdir(contrib_dir, "p")

  local installed_count = 0

  for _, lib in ipairs(libs) do
    local filename = lib.name .. ".js"
    local dest_path = contrib_dir .. "/" .. filename

    -- Check if already installed
    for _, installed in ipairs(config.libraries) do
      if installed.name == lib.name then
        core.notify("Library " .. lib.name .. " already installed", "warn")
        goto continue
      end
    end

    core.download_file(lib.cdn, dest_path, function(ok)
      if ok then
        -- Add to config
        table.insert(config.libraries, {
          name = lib.name,
          version = "latest",
          cdn = lib.cdn,
          local_path = "assets/contrib/" .. filename
        })

        installed_count = installed_count + 1
        core.notify("Installed " .. lib.name, "ok")
      else
        core.notify("Failed to install " .. lib.name, "error")
      end

      -- Update config when all downloads complete
      if installed_count == #libs then
        core.write_workspace_config(config)
        M.update_index_html()
      end
    end)

    ::continue::
  end
end

-- Remove libraries
M.remove_libs = function(lib_names)
  local config = core.read_workspace_config()
  if not config then
    core.notify("Not in a p5.js project", "error")
    return
  end

  local project_path = vim.fn.getcwd()
  local removed_count = 0

  for _, name in ipairs(lib_names) do
    -- Remove from config
    local new_libs = {}
    for _, lib in ipairs(config.libraries) do
      if lib.name ~= name then
        table.insert(new_libs, lib)
      else
        -- Remove local file
        if lib.local_path then
          local full_path = project_path .. "/" .. lib.local_path
          if vim.fn.filereadable(full_path) ~= 0 then
            vim.fn.delete(full_path)
          end
        end
        removed_count = removed_count + 1
        core.notify("Removed " .. name, "ok")
      end
    end
    config.libraries = new_libs
  end

  core.write_workspace_config(config)
  M.update_index_html()
end

-- Update all libraries
M.update_libs = function()
  local config = core.read_workspace_config()
  if not config then
    core.notify("Not in a p5.js project", "error")
    return
  end

  if #config.libraries == 0 then
    core.notify("No libraries to update", "warn")
    return
  end

  core.notify("Updating " .. #config.libraries .. " libraries...", "info")
  
  local project_path = vim.fn.getcwd()
  local updated_count = 0

  for _, lib in ipairs(config.libraries) do
    if lib.local_path then
      local dest_path = project_path .. "/" .. lib.local_path
      core.download_file(lib.cdn, dest_path, function(ok)
        if ok then
          updated_count = updated_count + 1
        end
        
        if updated_count == #config.libraries then
          core.notify("Library update complete", "ok")
        end
      end)
    end
  end
end

-- Update index.html with libraries
M.update_index_html = function()
  local config = core.read_workspace_config()
  if not config then
    return
  end

  local index_file = vim.fn.getcwd() .. "/index.html"
  if vim.fn.filereadable(index_file) == 0 then
    return
  end

  local content = vim.fn.readfile(index_file)
  local html = table.concat(content, "\n")

  -- Remove existing library scripts
  html = html:gsub('<!-- p5 libraries start -->.*<!-- p5 libraries end -->', '')
    :gsub('<script src="assets/contrib/[^"]*"></script>', '')

  -- Add library scripts
  local lib_scripts = {}
  for _, lib in ipairs(config.libraries) do
    if lib.local_path then
      table.insert(lib_scripts, '    <script src="' .. lib.local_path .. '"></script>')
    elseif lib.cdn then
      table.insert(lib_scripts, '    <script src="' .. lib.cdn .. '"></script>')
    end
  end

  if #lib_scripts > 0 then
    local lib_html = "  <!-- p5 libraries start -->\n" ..
                    table.concat(lib_scripts, "\n") ..
                    "\n  <!-- p5 libraries end -->"
    
    -- Insert before closing </head>
    html = html:gsub("</head>", lib_html .. "\n</head>")
  end

  vim.fn.writefile(vim.split(html, "\n"), index_file)
end

M.setup = function(config)
  M.config = config
end

return M