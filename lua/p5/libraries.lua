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
  
  if config and config.libraries then
    for _, lib in ipairs(config.libraries) do
      table.insert(libs, lib.name)
    end
  end
  
  local libs_dir = vim.fn.getcwd() .. "/" .. L.config.libraries_dir
  if vim.fn.isdirectory(libs_dir) == 1 then
    local js_files = vim.fn.glob(libs_dir .. "/*.js", false, true)
    for _, file in ipairs(js_files) do
      local lib_name = vim.fn.fnamemodify(file, ":t:r")
      if not vim.tbl_contains(libs, lib_name) then
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
    config = { libraries = {} }
  end
  
  config.libraries = config.libraries or {}
  
  for _, lib in ipairs(config.libraries) do
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
  L.update_index_html()
  core.notify("Added library: " .. lib_name, "success")
end

-- Remove library from project
L.remove_library = function(lib_name)
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
  L.update_index_html()
  core.notify("Removed library: " .. lib_name, "success")
end

-- Update index.html with library includes
L.update_index_html = function()
  local index_file = vim.fn.getcwd() .. "/index.html"
  if vim.fn.filereadable(index_file) == 0 then
    return
  end
  
  local content = vim.fn.readfile(index_file)
  local libs = L.load()
  
  local script_tags = {}
  for _, lib in ipairs(libs) do
    table.insert(script_tags, '    <script src="assets/libs/' .. lib .. '.js"></script>')
  end
  
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
  
  local format_item = function(item)
    local status = item.status ~= "" and " " .. item.status or ""
    return item.name .. " - " .. item.description .. status
  end
  
  if snacks and snacks.picker then
    snacks.picker.pick({
      title = "Select Libraries (multi-select)",
      items = items,
      format = {
        item = function(item)
          return format_item(item)
        end
      },
      multi_select = true,
      on_submit = function(selected)
        callback(selected)
      end
    })
  else
    local selected_items = {}
    local current_index = 1
    local filtered_items = items
    
    local function next_selection()
      if current_index > #filtered_items then
        if #selected_items > 0 then
          callback(selected_items)
        else
          callback(nil)
        end
        return
      end
      
      local item = filtered_items[current_index]
      vim.ui.select({ "Yes", "No", "All", "None" }, {
        prompt = string.format("[%d/%d] Add '%s'? (Yes/No/All/None)", 
          current_index, #filtered_items, item.name),
      }, function(choice)
        if choice == "Yes" then
          table.insert(selected_items, item)
        elseif choice == "All" then
          for i = current_index, #filtered_items do
            table.insert(selected_items, filtered_items[i])
          end
          callback(selected_items)
          return
        elseif choice == "None" then
          callback({})
          return
        end
        current_index = current_index + 1
        vim.schedule(next_selection)
      end)
    end
    
    next_selection()
  end
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
L.install_libs = function(lib_names)
  if not lib_names or #lib_names == 0 then
    core.notify("No libraries selected", "warn")
    return
  end
  
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
  
  if #to_install == 0 then
    core.notify("No matching libraries found", "warn")
    return
  end
  
  local pending = #to_install
  local completed = 0
  
  local function check_done()
    completed = completed + 1
    if completed >= pending then
      core.notify("Library installation complete", "ok")
      L.update_index_html()
    end
  end
  
  for _, lib in ipairs(to_install) do
    local dest = libs_dir .. "/" .. lib.name .. ".js"
    local types_dest = types_dir .. "/" .. lib.name .. ".d.ts"
    
    L.download_library(lib, dest, function(success)
      if success then
        L.download_types(lib.name, types_dest, function()
          check_done()
        end)
      else
        core.notify("Failed to download " .. lib.name, "error")
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
