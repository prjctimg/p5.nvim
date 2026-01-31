-- Health check module for p5.nvim
local M = {}

local core = require("p5.core")

-- Check core dependencies
M.check_dependencies = function()
  vim.health.start("p5.nvim Dependencies")
  
  -- Check snacks.nvim
  local snacks = core.require_snacks()
  if snacks then
    vim.health.ok("snacks.nvim: available")
  else
    vim.health.error("snacks.nvim: not found - required for notifications and UI")
  end
  
  -- Check websocket.nvim
  local websocket = core.require_websocket()
  if websocket then
    vim.health.ok("websocket.nvim: available")
  else
    vim.health.error("websocket.nvim: not found - required for browser console")
  end
end

-- Check external tools
M.check_external_tools = function()
  vim.health.start("p5.nvim External Tools")
  
  -- Check curl
  if core.command_exists("curl") then
    vim.health.ok("curl: available")
  elseif core.command_exists("wget") then
    vim.health.ok("wget: available")
  else
    vim.health.warn("curl/wget: not found - required for library downloads")
  end
  
  -- Check gh CLI
  if core.command_exists("gh") then
    vim.health.ok("gh CLI: available")
  else
    vim.health.warn("gh CLI: not found - optional for GitHub gist functionality")
  end
  
  -- Check Python
  if core.command_exists("python3") or core.command_exists("python") then
    vim.health.ok("Python: available")
  else
    vim.health.warn("Python: not found - optional for live server")
  end
  
  -- Check Node.js
  if core.command_exists("node") then
    vim.health.ok("Node.js: available")
  else
    vim.health.warn("Node.js: not found - optional for live server")
  end
  
  -- Check Bun
  if core.command_exists("bun") then
    vim.health.ok("Bun: available")
  else
    vim.health.warn("Bun: not found - optional for live server")
  end
  
  -- Check Deno
  if core.command_exists("deno") then
    vim.health.ok("Deno: available")
  else
    vim.health.warn("Deno: not found - optional for live server")
  end
end

-- Check plugin environment
M.check_plugin_env = function()
  vim.health.start("p5.nvim Plugin Environment")
  
  local plugin_root = core.get_plugin_root()
  if core.validate_dir(plugin_root, "Plugin root", false) then
    vim.health.ok("Plugin root: " .. plugin_root)
  else
    vim.health.error("Plugin root: not found at " .. plugin_root)
  end
  
  -- Check asset directory
  local asset_dir = core.get_asset_dir()
  if core.validate_dir(asset_dir, "Asset directory", false) then
    vim.health.ok("Asset directory: " .. asset_dir)
  else
    vim.health.error("Asset directory: not found at " .. asset_dir)
  end
  
  -- Check template directory
  local template_dir = core.get_template_dir()
  if core.validate_dir(template_dir, "Template directory", false) then
    vim.health.ok("Template directory: " .. template_dir)
  else
    vim.health.warn("Template directory: not found at " .. template_dir)
  end
  
  -- Check core assets
  local core_dir = asset_dir .. "/core"
  if core.validate_dir(core_dir, "Core assets", false) then
    vim.health.ok("Core assets: available")
    
    -- Check for essential files
    local p5_js = core_dir .. "/p5.js"
    if core.validate_file(p5_js, "p5.js", false) then
      vim.health.ok("p5.js: available")
    else
      vim.health.warn("p5.js: not found - will be downloaded on demand")
    end
  else
    vim.health.warn("Core assets: directory not found")
  end
end

-- Check project configuration
M.check_project_config = function()
  vim.health.start("p5.nvim Project Configuration")
  
  -- Check current directory for p5 project
  local cwd = vim.fn.getcwd()
  vim.health.info("Current directory: " .. cwd)
  
  -- Check for p5.json
  local config_file = cwd .. "/p5.json"
  if core.validate_file(config_file, "p5.json", false) then
    vim.health.ok("p5.json: found")
    
    -- Try to read config
    local ok, config = pcall(vim.fn.json_decode, vim.fn.readfile(config_file))
    if ok and config then
      vim.health.ok("p5.json: valid format")
      
      if config.libraries and type(config.libraries) == "table" then
        vim.health.ok("Libraries: " .. #config.libraries .. " configured")
      end
      
      if config.server then
        vim.health.ok("Server configuration: found")
      end
    else
      vim.health.error("p5.json: invalid format")
    end
  else
    vim.health.info("p5.json: not found - not in a p5.js project")
  end
  
  -- Check for index.html
  local index_file = cwd .. "/index.html"
  if core.validate_file(index_file, "index.html", false) then
    vim.health.ok("index.html: found")
  else
    vim.health.info("index.html: not found - run :P5ProjectCreate to create a new project")
  end
  
  -- Check for assets directory
  local assets_dir = cwd .. "/assets"
  if core.validate_dir(assets_dir, "assets/", false) then
    vim.health.ok("assets/: directory exists")
    
    -- Check for subdirectories
    local contrib_dir = assets_dir .. "/contrib"
    if core.validate_dir(contrib_dir, "contrib/", false) then
      local js_files = vim.fn.glob(contrib_dir .. "/*.js", false, true)
      vim.health.ok("contrib/: " .. #js_files .. " library files")
    end
    
    local libs_dir = assets_dir .. "/libs"
    if core.validate_dir(libs_dir, "libs/", false) then
      local js_files = vim.fn.glob(libs_dir .. "/*.js", false, true)
      vim.health.ok("libs/: " .. #js_files .. " library files")
    end
  else
    vim.health.info("assets/: not found - run :P5ProjectCreate to create project structure")
  end
end

-- Check workspace and permissions
M.check_workspace = function()
  vim.health.start("p5.nvim Workspace")
  
  local cwd = vim.fn.getcwd()
  vim.health.info("Working directory: " .. cwd)
  
  -- Check write permissions
  local test_file = cwd .. "/.p5_write_test"
  local ok, err = io.open(test_file, "w")
  if ok then
    ok:close()
    vim.fn.delete(test_file)
    vim.health.ok("Write permissions: available")
  else
    vim.health.error("Write permissions: " .. (err or "denied"))
  end
  
  -- Check temp directory
  local tmp_dir = vim.fn.stdpath("cache")
  if core.validate_dir(tmp_dir, "Cache directory", false) then
    vim.health.ok("Cache directory: " .. tmp_dir)
  else
    vim.health.warn("Cache directory: not found")
  end
end

-- Check Neovim version and features
M.check_neovim = function()
  vim.health.start("p5.nvim Neovim Compatibility")
  
  local version = vim.version()
  vim.health.info("Neovim version: " .. version.major .. "." .. version.minor .. "." .. version.patch)
  
  if version.major >= 0 and version.minor >= 9 then
    vim.health.ok("Neovim version: compatible (>= 0.9.0)")
  else
    vim.health.error("Neovim version: incompatible (< 0.9.0)")
  end
  
  -- Check required features
  local required_features = { "job", "channel", "nvim" }
  for _, feature in ipairs(required_features) do
    if vim.fn.has(feature) == 1 then
      vim.health.ok("Feature " .. feature .. ": available")
    else
      vim.health.error("Feature " .. feature .. ": missing")
    end
  end
end

-- Main health check function
M.check = function()
  vim.health.start("p5.nvim Health Check")
  vim.health.info("A comprehensive Neovim plugin for p5.js development")
  
  M.check_neovim()
  M.check_dependencies()
  M.check_external_tools()
  M.check_plugin_env()
  M.check_workspace()
  M.check_project_config()
  
  vim.health.start("p5.nvim Health Check Complete")
end

return M