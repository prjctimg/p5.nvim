-- Health check module for p5.nvim
local H = {}

local core = require("p5.core")

-- Check core dependencies
H.check_dependencies = function()
  vim.health.start("p5.nvim Dependencies")
  
  -- Check snacks.nvim
  local snacks = core.require_snacks()
  if snacks then
    vim.health.ok("snacks.nvim: available")
  else
    vim.health.error("snacks.nvim: not found - required for UI components")
  end
  
  -- Check plenary.nvim
  local plenary_ok, _ = pcall(require, "plenary")
  if plenary_ok then
    vim.health.ok("plenary.nvim: available")
  else
    vim.health.error("plenary.nvim: not found - required for async operations")
  end
  
  -- Check chrome-remote.nvim
  local chrome_remote = core.require_chrome_remote()
  if chrome_remote then
    vim.health.ok("chrome-remote.nvim: available")
  else
    vim.health.warn("chrome-remote.nvim: not found - optional for Chrome DevTools Protocol support")
  end
end

-- Check external tools
H.check_external_tools = function()
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
  
end

-- Check plugin environment
H.check_plugin_env = function()
  vim.health.start("p5.nvim Plugin Environment")
  
  local plugin_root = core.get_plugin_root()
  if core.validate_dir(plugin_root, "Plugin root", false) then
    vim.health.ok("Plugin root: " .. plugin_root)
  else
    vim.health.error("Plugin root: not found at " .. plugin_root)
  end
  
  -- Check asset directory (for types)
  local asset_dir = core.get_asset_dir()
  if core.validate_dir(asset_dir, "Asset directory", false) then
    vim.health.ok("Asset directory: " .. asset_dir)
  else
    vim.health.warn("Asset directory: not found - optional, for IDE types only")
  end
end

-- Check project configuration
H.check_project_config = function()
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
      
      if config.libs and type(config.libs) == "table" then
        local count = 0
        for _ in pairs(config.libs) do count = count + 1 end
        vim.health.ok("Libraries: " .. count .. " configured")
      end
      
      if config.server then
        vim.health.ok("Server configuration: found")
      end
    else
      vim.health.error("p5.json: invalid format")
    end
  else
    vim.health.info("p5.json: not found - not in a sketchspace")
  end
  
  -- Check for assets directory (optional - created by P5Setup)
  local assets_dir = cwd .. "/assets"
  if core.validate_dir(assets_dir, "assets/", false) then
    vim.health.ok("assets/: directory exists")
    
    -- Check for libs directory
    local libs_dir = assets_dir .. "/libs"
    if core.validate_dir(libs_dir, "libs/", false) then
      local js_files = vim.fn.glob(libs_dir .. "/*.js", false, true)
      vim.health.ok("libs/: " .. #js_files .. " library files")
    end
  else
    vim.health.info("assets/: not found - run :P5Setup to create")
  end
end

-- Check workspace and permissions
H.check_workspace = function()
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
H.check_neovim = function()
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
H.check = function()
  vim.health.start("p5.nvim Health Check")
  vim.health.info("A comprehensive Neovim plugin for p5.js development")
  
  H.check_neovim()
  H.check_dependencies()
  H.check_external_tools()
  H.check_plugin_env()
  H.check_workspace()
  H.check_project_config()
  
  vim.health.start("p5.nvim Health Check Complete")
end

return H