local core = require("p5.core")

local M = {
  config = {
    libraries_dir = "assets/libs",
    index_file = "index.html"
  },
  
  -- Notification batching system
  notification_batch = {
    pending = {},
    timer = nil,
    delay = 1000 -- 1 second
  },
  
  contributor_libs = {
    {
      name = "ml5",
      description = "Machine Learning library for creative coding",
      github_repo = "ml5js/ml5-library",
      github_release = "latest",
      asset_pattern = "ml5%.min%.js$",
      cdn_fallback = "https://unpkg.com/ml5@0.12.2/dist/ml5.min.js"
    },
    {
      name = "p5.speech",
      description = "Speech synthesis and recognition for p5.js",
      github_repo = "IDMNYU/p5.js-speech",
      github_release = "latest", 
      asset_pattern = "p5%.speech%.js$",
      cdn_fallback = "https://cdn.jsdelivr.net/gh/IDMNYU/p5.js-speech@0.0.3/lib/p5.speech.js"
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

-- Download library from GitHub releases with CDN fallback
M.download_library = function(lib, dest, callback)
  -- Try GitHub releases first
  if lib.github_repo and lib.asset_pattern then
    core.get_github_release_asset(lib.github_repo, lib.github_release or "latest", lib.asset_pattern, function(download_url, error)
      if download_url then
        core.download_file(download_url, dest, callback, { cache = true })
      else
        -- Fallback to CDN
        if lib.cdn_fallback then
          core.notify_fallback("GitHub release failed for " .. lib.name .. ", using CDN fallback", "warn")
          core.download_file(lib.cdn_fallback, dest, callback, { cache = true })
        else
          core.notify_fallback("Failed to download " .. lib.name .. ": " .. (error or "No fallback available"), "error")
          if callback then callback(false) end
        end
      end
    end)
  elseif lib.cdn_fallback then
    -- Use CDN if no GitHub repo specified
    core.download_file(lib.cdn_fallback, dest, callback, { cache = true })
  else
    core.notify_fallback("No download source for " .. lib.name, "error")
    if callback then callback(false) end
  end
end

-- Batch notification system
M.batch_notify = function(message, level)
  table.insert(M.notification_batch.pending, {message, level})
  
  -- Debounce notifications
  if M.notification_batch.timer then
    vim.fn.timer_stop(M.notification_batch.timer)
  end
  
  M.notification_batch.timer = vim.fn.timer_start(M.notification_batch.delay, function()
    M.flush_notifications()
  end)
end

M.flush_notifications = function()
  local messages = M.notification_batch.pending
  if #messages > 0 then
    local success_count = 0
    local error_count = 0
    
    for _, msg in ipairs(messages) do
      if msg[2] == "ok" then
        success_count = success_count + 1
      else
        error_count = error_count + 1
      end
    end
    
    local summary = string.format("Completed %d operations (%d successful, %d failed)", 
      #messages, success_count, error_count)
    core.notify_fallback(summary, success_count > 0 and "info" or "error")
    M.notification_batch.pending = {}
  end
end

-- Process libraries with unified callback and batched notifications
M.process_libraries = function(libraries, operation, on_complete)
  local completed = 0
  
  for _, lib in ipairs(libraries) do
    local dest = vim.fn.getcwd() .. "/assets/libs/" .. lib.name .. ".js"
    
    M.download_library(lib, dest, function(success)
      completed = completed + 1
      local msg = (operation == "install" and "Installed " or "Updated ") .. lib.name
      local level = success and "ok" or "error"
      
      -- Use batched notifications instead of immediate ones
      M.batch_notify(msg, level)
      
      if completed == #libraries then
        -- Flush remaining notifications
        M.flush_notifications()
        
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