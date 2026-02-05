local core = require("p5.core")

local M = {
  config = {
    libraries_dir = "assets/libs",
    index_file = "index.html"
  },
  
  contributor_libs = {
    {
      name = "ml5",
      description = "Machine Learning library for creative coding",
      cdn = "https://unpkg.com/ml5@0.12.2/dist/ml5.min.js"
    },
    {
      name = "p5.speech",
      description = "Speech synthesis and recognition for p5.js",
      cdn = "https://cdn.jsdelivr.net/npm/p5.speech/lib/p5.speech.js"
    }
  }
}

-- Load libraries from project
M.load = function()
  local libs = {}
  local config = core.read_workspace_config()
  
  if config and config.libraries then
    for _, lib in ipairs(config.libraries) do
      table.insert(libs, lib.name)
    end
  end
  
  -- Also scan library directory for any .js files
  local libs_dir = vim.fn.getcwd() .. "/assets/libs"
  if vim.fn.isdirectory(libs_dir) == 1 then
    local js_files = vim.fn.glob(libs_dir .. "/*.js", false, true)
    for _, file in ipairs(js_files) do
      local lib_name = vim.fn.fnamemodify(file, ":t:r")
      table.insert(libs, lib_name)
    end
  end
  
  return libs
end

-- Add library to project
M.add_library = function(lib_name, source)
  local config = core.read_workspace_config()
  if not config then
    config = { libraries = {} }
  end
  
  -- Check if library already exists
  for _, lib in ipairs(config.libraries or {}) do
    if lib.name == lib_name then
      core.notify("Library '" .. lib_name .. "' already exists", "warn")
      return
    end
  end
  
  table.insert(config.libraries, {
    name = lib_name,
    source = source or "manual"
  })
  
  core.write_workspace_config(config)
  M.update_index_html()
  core.notify("Added library: " .. lib_name, "success")
end

-- Remove library from project
M.remove_library = function(lib_name)
  local config = core.read_workspace_config()
  if not config or not config.libraries then
    return
  end
  
  local new_libs = {}
  for _, lib in ipairs(config.libraries) do
    if lib.name ~= lib_name then
      table.insert(new_libs, lib)
    end
  end
  
  config.libraries = new_libs
  core.write_workspace_config(config)
  M.update_index_html()
  core.notify("Removed library: " .. lib_name, "success")
end

-- Update index.html with library includes
M.update_index_html = function()
  local index_file = vim.fn.getcwd() .. "/index.html"
  if not vim.fn.filereadable(index_file) then
    return
  end
  
  local content = vim.fn.readfile(index_file)
  local libs = M.load()
  
  -- Generate script tags
  local script_tags = {}
  for _, lib in ipairs(libs) do
    table.insert(script_tags, '    <script src="assets/libs/' .. lib .. '.js"></script>')
  end
  
  -- Find and replace library section
  local new_content = {}
  local in_lib_section = false
  
  for _, line in ipairs(content) do
    if line:match("<!-- LIBRARIES -->") then
      in_lib_section = true
      table.insert(new_content, line)
      for _, tag in ipairs(script_tags) do
        table.insert(new_content, tag)
      end
    elseif line:match("<!-- END LIBRARIES -->") then
      in_lib_section = false
      table.insert(new_content, line)
    elseif not in_lib_section then
      table.insert(new_content, line)
    end
  end
  
  vim.fn.writefile(new_content, index_file)
end

-- Get available libraries list for picker
M.get_available_libs = function()
  local libs = {}
  for _, lib in ipairs(M.contributor_libs) do
    table.insert(libs, {
      name = lib.name,
      description = lib.description
    })
  end
  return libs
end

-- Show library picker
M.show_library_picker = function(callback)
  if core.require_snacks() then
    core.require_snacks().picker.pick({
      title = "Select Libraries",
      items = M.get_available_libs(),
      on_submit = function(selected)
        callback(selected)
      end
    })
  else
    local libs = M.get_available_libs()
    vim.ui.select(libs, {
      prompt = "Select Libraries",
      format_item = function(item)
        return item.name .. " - " .. item.description
      end
    }, function(choice)
      callback(choice)
    end)
  end
end

-- Install contributor libraries from CDN
M.install_libs = function(lib_names)
  -- Find library definitions
  local libs = {}
  for _, name in ipairs(lib_names) do
    for _, lib in ipairs(M.contributor_libs) do
      if lib.name == name then
        table.insert(libs, lib)
        break
      end
    end
  end
  
  if #libs == 0 then
    core.notify_fallback("No matching libraries found: " .. table.concat(lib_names, ", "), "warn")
    return
  end
  
  core.notify_fallback("Installing " .. #libs .. " libraries...", "info")
  
  -- Create libs directory
  local libs_dir = vim.fn.getcwd() .. "/assets/libs"
  vim.fn.mkdir(libs_dir, "p")
  
  M.process_libraries(libs, "install", function(completed)
    local message = "Library installation complete: " .. completed .. "/" .. #libs
    core.notify_fallback(message, "ok")
    
    -- Update project configuration
    local config = core.read_workspace_config()
    if config then
      config.libraries = vim.tbl_deep_extend("force", config.libraries or {}, libs)
      core.write_workspace_config(config)
      M.update_index_html()
    end
  end)
end

-- Process libraries with unified callback
M.process_libraries = function(libraries, operation, on_complete)
  local completed = 0
  
  for _, lib in ipairs(libraries) do
    core.download_file(lib.cdn, lib.name .. ".js", function(success)
      completed = completed + 1
      local msg = (operation == "install" and "Installed " or "Updated ") .. lib.name
      local level = success and "ok" or "error"
      core.notify_fallback(msg, level)
      
      if completed == #libraries then
        if on_complete then
          on_complete(completed)
        end
      end
    end)
  end
end

-- Update all installed libraries
M.update_libs = function()
  local config = core.read_workspace_config()
  if not config or not config.libraries then
    core.notify_fallback("No libraries installed", "warn")
    return
  end
  
  core.notify_fallback("Checking for library updates...", "info")
  
  M.process_libraries(config.libraries, "update", function()
    core.notify_fallback("Library update complete", "ok")
  end)
end

-- Setup libraries module
M.setup = function(config)
  M.config = vim.tbl_deep_extend("force", M.config, config or {})
end

return M