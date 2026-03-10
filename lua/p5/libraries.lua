local core = require("p5.core")

local L = {
  config = {
    libraries_dir = "assets/libs",
    types_dir = "assets/types",
    index_file = "index.html"
  }
}

local function get_cwd()
  return vim.fn.getcwd()
end

local function libs_dir()
  return get_cwd() .. "/" .. L.config.libraries_dir
end

local function types_dir()
  return get_cwd() .. "/" .. L.config.types_dir
end

local function index_file()
  return get_cwd() .. "/" .. L.config.index_file
end

-- Load libraries from JSON file
L.load_libs_json = function()
  local plugin_root = core.get_plugin_root()
  local libs_file = plugin_root .. "/libs.json"

  local data, err = core.read_json_file(libs_file)
  if data and data.libraries then
    return data.libraries
  end
  return {}
end

L.contrib_libs = L.load_libs_json()

-- Get installed libraries (core + contrib)
L.load = function()
  local libs = {}
  local config = core.read_workspace_config()
  
  -- Always include core modules (not stored in p5.json libs)
  table.insert(libs, "p5")
  table.insert(libs, "p5.sound")
  
  -- Handle libs as object with {name: version} format
  if config and config.libs and type(config.libs) == "table" then
    for lib_name, version in pairs(config.libs) do
      if lib_name and not vim.tbl_contains(libs, lib_name) then
        table.insert(libs, lib_name)
      end
    end
  end
  
  return libs
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

-- Add library to project
L.add_library = function(lib_name, version)
  local config = core.read_workspace_config()
  if not config then
    local p5_version = core.get_p5_version()
    config = { version = p5_version, libs = {}, includes = {"sketch.js"} }
  end
  
  config.libs = config.libs or {}
  
  -- Check if already exists
  if config.libs[lib_name] then
    core.notify("Library '" .. lib_name .. "' already exists (version: " .. config.libs[lib_name] .. ")", "warn")
    return
  end
  
  -- Add library with version
  config.libs[lib_name] = version or "latest"
  
  core.write_workspace_config(config)
end

-- Get list of installed libraries from project
L.get_installed_libs = function()
  local installed = {}

  if core.dir_exists(libs_dir()) then
    local js_files = vim.fn.glob(libs_dir() .. "/*.js", false, true)
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

-- Validate and clean broken links in index.html
L.validate_libs = function()
  local idx_file = index_file()
  if not core.file_exists(idx_file) then
    return { cleaned = 0 }
  end

  local content = vim.fn.readfile(idx_file)
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
        local js_file = libs_dir() .. "/" .. lib_name .. ".js"
        if core.file_exists(js_file) then
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
    vim.fn.writefile(new_content, idx_file)
    core.notify("Cleaned " .. cleaned .. " broken library link(s)", "info")
  end

  return { cleaned = cleaned }
end

-- Uninstall libraries (remove files and update config)
L.uninstall_libs = function(lib_names)
  if not lib_names or #lib_names == 0 then
    core.notify("No libraries specified", "warn")
    return
  end

  local config = core.read_workspace_config() or { libs = {}, includes = {"sketch.js"} }
  config.libs = config.libs or {}

  local removed = {}
  local failed = {}

  for _, name in ipairs(lib_names) do
    local js_file = libs_dir() .. "/" .. name .. ".js"
    local dts_file = types_dir() .. "/" .. name .. ".d.ts"

    local success = true

    if core.file_exists(js_file) then
      if vim.fn.delete(js_file) ~= 0 then
        success = false
        table.insert(failed, name)
      end
    end

    if core.file_exists(dts_file) then
      vim.fn.delete(dts_file)
    end

    if config.libs[name] then
      config.libs[name] = nil
    else
      success = false
      table.insert(failed, name)
    end

    if success then
      table.insert(removed, name)
    end
  end

  core.write_workspace_config(config)

  if #removed > 0 then
    core.notify("Removed: " .. table.concat(removed, ", "), "info")
  end

  if #failed > 0 then
    core.notify("Failed to remove: " .. table.concat(failed, ", "), "error")
  end
end

-- Generate static libs.js that reads from p5.json at runtime
L.generate_libs_js = function(project_path)
  local cwd = project_path or vim.fn.getcwd()
  local l_dir = cwd .. "/" .. L.config.libraries_dir
  local libs_js = l_dir .. "/libs.js"

  local js_content = [[
// Auto-generated - reads libraries from p5.json at runtime
(function() {
  function loadLibs() {
    // Fetch p5.json to get list of libraries
    fetch('p5.json')
      .then(function(response) { return response.json(); })
      .then(function(config) {
        var libsObj = config.libs || {};
        // Convert object {name: version} to array of names
        var libs = Object.keys(libsObj);
        return loadLibsSequential(libs, 0);
      })
      .catch(function(err) {
        console.warn('Could not load p5.json:', err);
      });
  }

  function loadLibsSequential(libs, index) {
    if (index >= libs.length) return Promise.resolve();

    var lib = libs[index];
    // Skip core libs (p5 and p5.sound are bundled)
    if (lib === 'p5' || lib === 'p5.sound') {
      return loadLibsSequential(libs, index + 1);
    }

    return new Promise(function(resolve) {
      var script = document.createElement('script');
      script.src = 'assets/libs/' + lib + '.js';
      script.onload = function() { 
        console.log('Loaded: ' + lib);
        resolve(); 
      };
      script.onerror = function() { 
        console.warn('Failed to load: ' + lib); 
        resolve(); 
      };
      document.head.appendChild(script);
    }).then(function() {
      return loadLibsSequential(libs, index + 1);
    });
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', loadLibs);
  } else {
    loadLibs();
  }
})();
]]

  vim.fn.writefile(vim.split(js_content, "\n"), libs_js)
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

-- Validate downloaded file contains actual JavaScript code
L.validate_download = function(dest)
  if not core.file_exists(dest) then
    return false
  end

  local size = vim.fn.getfsize(dest)
  if size < 100 then
    return false
  end

  local handle = io.open(dest, "r")
  if not handle then
    return false
  end

  local first_bytes = handle:read(100)
  handle:close()

  local error_patterns = {
    "Not found",
    "Internal Server Error",
    "Package not found",
    "404",
    "Error",
    "<!DOCTYPE html>",
    "<html>"
  }

  for _, pattern in ipairs(error_patterns) do
    if first_bytes:match(pattern) then
      return false
    end
  end

  return true
end

-- Download library file from hardcoded CDN URL
L.download_library = function(lib, dest, callback)
  local function done(success)
    if callback then callback(success) end
  end

  if not lib.cdn_url then
    done(false)
    return
  end

  core.download_file(lib.cdn_url, dest, function(dl_success)
    if dl_success and L.validate_download(dest) then
      done(true)
    else
      done(false)
    end
  end, { cache = true })
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

  L.validate_libs()

  vim.fn.mkdir(libs_dir(), "p")
  vim.fn.mkdir(types_dir(), "p")

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
      -- Note: libs.js reads from p5.json at runtime
      
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
    local lib_name = lib.name:gsub("%.js$", "")
    local dest = libs_dir() .. "/" .. lib_name .. ".js"
    local types_dest = types_dir() .. "/" .. lib_name .. ".d.ts"

    L.download_library(lib, dest, function(success)
      if success then
        table.insert(installed_names, lib_name)
        L.download_types(lib_name, types_dest, function()
          check_done()
        end)
      else
        table.insert(failed_names, lib.name)
        check_done()
      end
    end)
  end
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
