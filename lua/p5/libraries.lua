local core = require("p5.core")

local L = {
  config = {
    libraries_dir = "assets/libs",
    types_dir = "assets/types",
    index_file = "index.html"
  }
}

-- Load libraries from JSON file
L.load_libs_json = function()
  local plugin_root = core.get_plugin_root()
  local libs_file = plugin_root .. "/libs.json"
  
  if vim.fn.filereadable(libs_file) == 1 then
    local content = vim.fn.readfile(libs_file)
    local ok, data = pcall(vim.fn.json_decode, table.concat(content, "\n"))
    if ok and data and data.libraries then
      return data.libraries
    end
  end
  return {}
end

L.contrib_libs = L.load_libs_json()

-- Get installed libraries
L.load = function()
  local libs = {}
  local config = core.read_workspace_config()
  
  -- Always include core modules
  table.insert(libs, "p5")
  table.insert(libs, "p5.sound")
  
  -- Handle both string array and object array formats
  if config and config.libraries then
    for _, lib in ipairs(config.libraries) do
      local lib_name = type(lib) == "table" and lib.name or lib
      if lib_name and not vim.tbl_contains(libs, lib_name) then
        table.insert(libs, lib_name)
      end
    end
  end
  
  return libs
end

-- Check if library is installed
L.is_installed = function(lib_name)
  local libs = L.load()
  return vim.tbl_contains(libs, lib_name)
end

-- Get library info from contrib libs
L.get_library_info = function(lib_name)
  for _, lib in ipairs(L.contrib_libs) do
    if lib.name == lib_name then
      return lib
    end
  end
  return nil
end

-- Get latest version from GitHub
L.get_latest_version = function(lib, callback)
  if not lib.github_repo then
    if callback then callback(nil) end
    return
  end
  
  local api_url = string.format("https://api.github.com/repos/%s/releases/%s", lib.github_repo, lib.github_release or "latest")
  
  local cmd = {"curl", "-s", api_url}
  vim.fn.jobstart(cmd, {
    on_stdout = function(_, data)
      if not data or #data == 0 then
        if callback then callback(nil) end
        return
      end
      
      local content = table.concat(data, "\n")
      local ok, release_info = pcall(vim.fn.json_decode, content)
      
      if ok and release_info and release_info.tag_name then
        local version = release_info.tag_name:gsub("^v", "")
        if callback then callback(version) end
      else
        if callback then callback(nil) end
      end
    end,
    on_stderr = function()
      if callback then callback(nil) end
    end
  })
end

-- Add library to project
L.add_library = function(lib_name, source)
  local config = core.read_workspace_config()
  if not config then
    config = { version = "1.0.0", libraries = {} }
  end
  
  config.libraries = config.libraries or {}
  
  -- Check if already exists (handle both string and object formats)
  for _, lib in ipairs(config.libraries) do
    local existing_name = type(lib) == "table" and lib.name or lib
    if existing_name == lib_name then
      core.notify("Library '" .. lib_name .. "' already exists", "warn")
      return
    end
  end
  
  table.insert(config.libraries, lib_name)
  
  core.write_workspace_config(config)
  L.update_index_html()
end

-- Remove library from project
L.remove_library = function(lib_name)
  local config = core.read_workspace_config()
  if not config or not config.libraries then
    return
  end
  
  local new_libs = {}
  for _, lib in ipairs(config.libraries) do
    local lib_name_str = type(lib) == "table" and lib.name or lib
    if lib_name_str ~= lib_name then
      table.insert(new_libs, lib)
    end
  end
  
  config.libraries = new_libs
  core.write_workspace_config(config)
  L.update_index_html()
end

-- Get list of installed libraries from project
L.get_installed_libs = function()
  local libs_dir = vim.fn.getcwd() .. "/" .. L.config.libraries_dir
  local installed = {}
  
  if vim.fn.isdirectory(libs_dir) == 1 then
    local js_files = vim.fn.glob(libs_dir .. "/*.js", false, true)
    for _, file in ipairs(js_files) do
      local lib_name = vim.fn.fnamemodify(file, ":t:r")
      if lib_name ~= "p5" and lib_name ~= "p5.sound" then
        table.insert(installed, {
          name = lib_name,
          file = file
        })
      end
    end
  end
  
  return installed
end

-- Check for conflicts before installing
L.check_conflicts = function(lib_name)
  local result = { has_config = false, has_html = false, has_file = false }
  local config = core.read_workspace_config()
  
  if config and config.libraries then
    for _, lib in ipairs(config.libraries) do
      if lib.name == lib_name then
        result.has_config = true
        break
      end
    end
  end
  
  local index_file = vim.fn.getcwd() .. "/" .. L.config.index_file
  if vim.fn.filereadable(index_file) == 1 then
    local content = vim.fn.readfile(index_file)
    for _, line in ipairs(content) do
      if line:match('src="assets/libs/' .. lib_name .. '%.js"') or
         line:match("src='assets/libs/" .. lib_name .. "%.js'") then
        result.has_html = true
        break
      end
    end
  end
  
  local libs_dir = vim.fn.getcwd() .. "/" .. L.config.libraries_dir
  local js_file = libs_dir .. "/" .. lib_name .. ".js"
  if vim.fn.filereadable(js_file) == 1 then
    result.has_file = true
  end
  
  return result
end

-- Validate and clean broken links in index.html
L.validate_libs = function()
  local index_file = vim.fn.getcwd() .. "/" .. L.config.index_file
  if vim.fn.filereadable(index_file) == 0 then
    return { cleaned = 0 }
  end
  
  local libs_dir = vim.fn.getcwd() .. "/" .. L.config.libraries_dir
  local content = vim.fn.readfile(index_file)
  local new_content = {}
  local cleaned = 0
  
  local in_lib_section = false
  for _, line in ipairs(content) do
    if line:match("<!--%s*LIBRARIES%s*-->") then
      in_lib_section = true
      table.insert(new_content, line)
    elseif line:match("<!--%s*END LIBRARIES%s*-->") then
      in_lib_section = false
      table.insert(new_content, line)
    elseif in_lib_section and line:match("<script") then
      local lib_name = line:match('src="assets/libs/(%w+)%.js"') or
                       line:match("src='assets/libs/(%w+)%.js'")
      if lib_name then
        local js_file = libs_dir .. "/" .. lib_name .. ".js"
        if vim.fn.filereadable(js_file) == 1 then
          table.insert(new_content, line)
        else
          cleaned = cleaned + 1
        end
      else
        table.insert(new_content, line)
      end
    else
      table.insert(new_content, line)
    end
  end
  
  if cleaned > 0 then
    vim.fn.writefile(new_content, index_file)
    core.notify("Cleaned " .. cleaned .. " broken library link(s)", "info")
  end
  
  return { cleaned = cleaned }
end

-- Show conflict resolution picker
L.show_conflict_picker = function(lib_name, callback)
  local options = {"Replace existing", "Skip", "Cancel"}

  vim.ui.select(options, {
    prompt = "Library '" .. lib_name .. "' already exists:",
  }, function(choice)
    if not choice then
      callback("cancel")
      return
    end
    if choice == "Replace existing" then
      callback("replace")
    elseif choice == "Skip" then
      callback("skip")
    else
      callback("cancel")
    end
  end)
end

-- Uninstall libraries (remove files and update config)
L.uninstall_libs = function(lib_names)
  if not lib_names or #lib_names == 0 then
    core.notify("No libraries specified", "warn")
    return
  end
  
  local libs_dir = vim.fn.getcwd() .. "/" .. L.config.libraries_dir
  local types_dir = vim.fn.getcwd() .. "/" .. L.config.types_dir
  
  local config = core.read_workspace_config() or { libraries = {} }
  config.libraries = config.libraries or {}
  
  local removed = {}
  local failed = {}
  
  for _, name in ipairs(lib_names) do
    local js_file = libs_dir .. "/" .. name .. ".js"
    local dts_file = types_dir .. "/" .. name .. ".d.ts"
    
    local success = true
    
    -- Remove JS file
    if vim.fn.filereadable(js_file) == 1 then
      if vim.fn.delete(js_file) ~= 0 then
        success = false
        table.insert(failed, name)
      end
    end
    
    -- Remove TypeScript definitions
    if vim.fn.filereadable(dts_file) == 1 then
      vim.fn.delete(dts_file)
    end
    
    -- Remove from config
    local new_libs = {}
    for _, lib in ipairs(config.libraries) do
      local lib_name_str = type(lib) == "table" and lib.name or lib
      if lib_name_str ~= name then
        table.insert(new_libs, lib)
      end
    end
    config.libraries = new_libs
    
    if success then
      table.insert(removed, name)
    end
  end
  
  -- Save updated config
  core.write_workspace_config(config)
  
  if #removed > 0 then
    core.notify("🎉 Removed: " .. table.concat(removed, ", "), "info")
  end
  
  if #failed > 0 then
    core.notify("Failed to remove: " .. table.concat(failed, ", "), "error")
  end
  
  -- Update index.html
  L.update_index_html()
end

-- Show uninstall picker with multiselect
L.show_uninstall_picker = function()
  local installed = L.get_installed_libs()
  local snacks = core.require_snacks()

  if #installed == 0 then
    core.notify("No contrib libraries installed", "warn")
    return
  end

  if not snacks then
    vim.ui.select(installed, { prompt = "Select library to uninstall:" }, function(selected)
      if selected then
        L.uninstall_libs({selected.name})
      end
    end)
    return
  end

  local items = vim.tbl_map(function(lib)
    return {
      label = lib.name,
      detail = lib.file,
      value = lib.name,
    }
  end, installed)

  snacks.picker({
    prompt = "Uninstall contributor libraries",
    items = items,
    multi = true,
    on_confirm = function(selected)
      if not selected or vim.tbl_isempty(selected) then
        core.notify("No libraries selected", "info")
        return
      end
      local names = {}
      for _, item in ipairs(selected) do
        table.insert(names, item.value or item.label)
      end
      L.uninstall_libs(names)
    end
  })
end

-- Update index.html with library includes
L.update_index_html = function()
  local index_file = vim.fn.getcwd() .. "/index.html"
  if vim.fn.filereadable(index_file) == 0 then
    return
  end
  
  local libs = L.load()
  local content = vim.fn.readfile(index_file)
  
  -- Generate all script tags fresh from libraries
  local script_tags = {}
  for _, lib in ipairs(libs) do
    table.insert(script_tags, '  <script src="assets/libs/' .. lib .. '.js"></script>')
  end
  
  local new_content = {}
  local in_p5_section = false
  local p5_section_found = false
  
  for _, line in ipairs(content) do
    if line:match("<!--%s*P5 SCRIPTS%s*-->") then
      in_p5_section = true
      p5_section_found = true
      table.insert(new_content, line)
      -- Add all new script tags
      for _, tag in ipairs(script_tags) do
        table.insert(new_content, tag)
      end
    elseif line:match("<!--%s*END P5 SCRIPTS%s*-->") then
      in_p5_section = false
      table.insert(new_content, line)
    elseif not in_p5_section then
      -- Only add lines outside P5 SCRIPTS section
      table.insert(new_content, line)
    end
    -- Skip all lines inside P5 SCRIPTS section (they'll be replaced)
  end
  
  -- If no P5 SCRIPTS section found, add after <body>
  if not p5_section_found then
    local new_content2 = {}
    for _, line in ipairs(new_content) do
      table.insert(new_content2, line)
      if line:match("<body") then
        table.insert(new_content2, "  <!-- P5 SCRIPTS -->")
        for _, tag in ipairs(script_tags) do
          table.insert(new_content2, tag)
        end
        table.insert(new_content2, "  <!-- END P5 SCRIPTS -->")
      end
    end
    new_content = new_content2
  end
  
  vim.fn.writefile(new_content, index_file)
end

-- Get available libraries for picker
L.get_available_libs = function()
  local installed = L.load()
  local items = {}
  
  for _, lib in ipairs(L.contrib_libs) do
    local is_installed = vim.tbl_contains(installed, lib.name)
    local status = is_installed and "(installed)" or ""
    table.insert(items, {
      name = lib.name,
      description = lib.description or "",
      category = lib.category or "",
      status = status,
      installed = is_installed
    })
  end
  
  return items
end

-- Show library picker with multiselect
L.show_library_picker = function(callback)
  local items = L.get_available_libs()
  local snacks = core.require_snacks()

  if not snacks then
    vim.ui.select(items, { prompt = "Select library to install:" }, function(selected)
      if selected then
        callback({selected})
      else
        callback(nil)
      end
    end)
    return
  end

  local picker_items = vim.tbl_map(function(lib)
    local detail = lib.description or ""
    local status = lib.status or ""
    if status ~= "" then
      detail = detail .. " " .. status
    end
    return {
      label = lib.name,
      detail = detail,
      value = lib.name,
    }
  end, items)

  snacks.picker({
    prompt = "Install contributor libraries",
    items = picker_items,
    multi = true,
    on_confirm = function(selected)
      if not selected or vim.tbl_isempty(selected) then
        callback(nil)
        return
      end
      local result = {}
      for _, item in ipairs(selected) do
        local lib_name = item.value or item.label
        for _, lib in ipairs(items) do
          if lib.name == lib_name then
            table.insert(result, lib)
            break
          end
        end
      end
      callback(result)
    end
  })
end

-- Download library file from GitHub Releases or fallback to CDN
L.download_library = function(lib, dest, callback)
  local function done(success)
    if callback then callback(success) end
  end

  if not lib.github_repo then
    if lib.cdn_fallback then
      core.download_file(lib.cdn_fallback, dest, done, { cache = true })
    else
      done(false)
    end
    return
  end

  local api_url = string.format("https://api.github.com/repos/%s/releases/%s", lib.github_repo, lib.github_release or "latest")

  local cmd = {"curl", "-s", "-L", "-w", "%{url_effective}", "-o", "/dev/null", api_url}
  vim.fn.jobstart(cmd, {
    on_stdout = function(_, data)
      if not data or #data == 0 then
        if lib.cdn_fallback then
          core.download_file(lib.cdn_fallback, dest, done, { cache = true })
        else
          done(false)
        end
        return
      end

      local content = table.concat(data, "\n")
      local ok, release_info = pcall(vim.fn.json_decode, content)

      if not ok or not release_info then
        if lib.cdn_fallback then
          core.download_file(lib.cdn_fallback, dest, done, { cache = true })
        else
          done(false)
        end
        return
      end

      local assets = release_info.assets
      if not assets or #assets == 0 then
        if lib.cdn_fallback then
          core.download_file(lib.cdn_fallback, dest, done, { cache = true })
        else
          done(false)
        end
        return
      end

      local selected_asset = nil
      if lib.asset_pattern then
        local pattern = lib.asset_pattern
        for _, asset in ipairs(assets) do
          if asset.name and asset.name:match(pattern) then
            selected_asset = asset
            break
          end
        end
      end

      if not selected_asset then
        selected_asset = assets[1]
      end

      local download_url = selected_asset.browser_download_url or selected_asset.url
      if download_url then
        core.download_file(download_url, dest, function(success)
          if not success and lib.cdn_fallback then
            core.download_file(lib.cdn_fallback, dest, done, { cache = true })
          else
            done(success)
          end
        end, { cache = true })
      else
        if lib.cdn_fallback then
          core.download_file(lib.cdn_fallback, dest, done, { cache = true })
        else
          done(false)
        end
      end
    end,
    on_stderr = function()
      if lib.cdn_fallback then
        core.download_file(lib.cdn_fallback, dest, done, { cache = true })
      else
        done(false)
      end
    end
  })
end

-- Download types for library
L.download_types = function(lib_name, dest, callback)
  local types_urls = {
    ml5 = "https://unpkg.com/ml5@latest/dist/ml5.d.ts",
    ["p5.speech"] = "https://unpkg.com/p5.js-speech@latest/lib/p5.speech.d.ts",
  }
  
  local types_url = types_urls[lib_name]
  if types_url then
    core.download_file(types_url, dest, callback, { cache = true })
  else
    if callback then callback(true) end
  end
end

-- Install libraries with version check
L.install_libs = function(lib_names, skip_confirm)
  if not lib_names or #lib_names == 0 then
    core.notify("No libraries selected", "warn")
    return
  end
  
  -- Validate and clean broken links first
  L.validate_libs()
  
  local libs_dir = vim.fn.getcwd() .. "/" .. L.config.libraries_dir
  vim.fn.mkdir(libs_dir, "p")
  
  local types_dir = vim.fn.getcwd() .. "/" .. L.config.types_dir
  vim.fn.mkdir(types_dir, "p")
  
  local to_install = {}
  
  for _, name in ipairs(lib_names) do
    local lib = L.get_library_info(name)
    if lib then
      table.insert(to_install, lib)
    end
  end
  
  L.do_install(to_install)
end

L.do_install = function(to_install)
  if #to_install == 0 then
    core.notify("No libraries to install", "info")
    return
  end
  
  local libs_dir = vim.fn.getcwd() .. "/" .. L.config.libraries_dir
  local types_dir = vim.fn.getcwd() .. "/" .. L.config.types_dir
  
  local pending = #to_install
  local completed = 0
  local installed_names = {}
  local failed_names = {}
  
  local function check_done()
    completed = completed + 1
    if completed >= pending then
      -- Add each installed library to config
      for _, name in ipairs(installed_names) do
        L.add_library(name)
      end
      L.update_index_html()
      
      -- Show single notification
      if #installed_names > 0 then
        local msg = "🎉 Installed: " .. table.concat(installed_names, ", ")
        core.notify(msg, "info")
      end
      if #failed_names > 0 then
        core.notify("Failed: " .. table.concat(failed_names, ", "), "error")
      end
    end
  end
  
  for _, lib in ipairs(to_install) do
    local dest = libs_dir .. "/" .. lib.name .. ".js"
    local types_dest = types_dir .. "/" .. lib.name .. ".d.ts"
    
    L.download_library(lib, dest, function(success)
      if success then
        table.insert(installed_names, lib.name)
        L.download_types(lib.name, types_dest, function()
          check_done()
        end)
      else
        table.insert(failed_names, lib.name)
        check_done()
      end
    end)
  end
end

-- Prompt for library installation with version check
L.prompt_install = function(selected)
  if not selected or #selected == 0 then
    return
  end
  
  local to_install = {}
  local to_update = {}
  
  for _, item in ipairs(selected) do
    local lib_name = type(item) == "table" and item.name or item
    local lib = L.get_library_info(lib_name)
    
    if lib then
      if L.is_installed(lib_name) then
        table.insert(to_update, lib)
      else
        table.insert(to_install, lib_name)
      end
    end
  end
  
  if #to_install > 0 then
    L.install_libs(to_install)
  end
  
  if #to_update > 0 then
    local names = {}
    for _, lib in ipairs(to_update) do
      table.insert(names, lib.name)
    end
    core.notify("Reinstalling: " .. table.concat(names, ", "), "info")
    L.install_libs(names)
  end
end

-- Show picker and install
L.show_and_install = function()
  L.show_library_picker(function(selected)
    L.prompt_install(selected)
  end)
end

-- Update all installed libraries
L.update_libs = function()
  local installed = L.load()
  if #installed == 0 then
    core.notify("No libraries installed", "warn")
    return
  end
  
  core.notify("Updating " .. #installed .. " libraries...", "info")
  L.install_libs(installed)
end

L.setup = function(config)
  L.config = vim.tbl_deep_extend("force", L.config, config or {})
end

return L
