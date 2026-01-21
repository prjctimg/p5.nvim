local M = {}

-- Server state
local server_state = {
  running = false,
  job_id = nil,
  port = nil,
  type = nil,
  pid = nil
}

-- Get configuration
local function get_config()
  return require("p5.config")
end

-- Check if a command is available
local function command_exists(cmd)
  return vim.fn.executable(cmd) == 1
end

-- Get current working directory
local function get_project_dir()
  return vim.fn.getcwd()
end

-- Check if we're in a p5.js project
local function is_p5_project()
  local project_dir = get_project_dir()
  local index_file = project_dir .. "/index.html"
  return vim.fn.filereadable(index_file) == 1
end

-- Auto-detect best server type
local function auto_detect_server()
  -- Priority order: live-server > python > static
  if command_exists("live-server") then
    return "live-server"
  elseif command_exists("python3") then
    return "python"
  else
    return "static"
  end
end

-- Start live-server
local function start_live_server(port)
  local project_dir = get_project_dir()
  local cmd = string.format("cd %s && live-server --port=%d --quiet", project_dir, port)
  
  vim.notify("Starting live-server on port " .. port, vim.log.levels.INFO)
  
  local job_id = vim.fn.jobstart(cmd, {
    on_stdout = function(_, data)
      if data and #data > 0 and data[1] ~= "" then
        vim.notify("live-server: " .. table.concat(data, ""), vim.log.levels.INFO)
      end
    end,
    on_stderr = function(_, data)
      if data and #data > 0 and data[1] ~= "" then
        vim.notify("live-server error: " .. table.concat(data, ""), vim.log.levels.ERROR)
      end
    end,
    on_exit = function(_, code)
      if code == 0 then
        vim.notify("live-server stopped", vim.log.levels.INFO)
      else
        vim.notify("live-server exited with code " .. code, vim.log.levels.ERROR)
      end
      server_state.running = false
      server_state.job_id = nil
    end,
    detach = true
  })
  
  return job_id
end

-- Start Python HTTP server
local function start_python_server(port)
  local project_dir = get_project_dir()
  local cmd = string.format("cd %s && python3 -m http.server %d", project_dir, port)
  
  vim.notify("Starting Python HTTP server on port " .. port, vim.log.levels.INFO)
  
  local job_id = vim.fn.jobstart(cmd, {
    on_stdout = function(_, data)
      if data and #data > 0 and data[1] ~= "" then
        vim.notify("Python server: " .. table.concat(data, ""), vim.log.levels.INFO)
      end
    end,
    on_stderr = function(_, data)
      if data and #data > 0 and data[1] ~= "" then
        vim.notify("Python server error: " .. table.concat(data, ""), vim.log.levels.ERROR)
      end
    end,
    on_exit = function(_, code)
      if code == 0 then
        vim.notify("Python server stopped", vim.log.levels.INFO)
      else
        vim.notify("Python server exited with code " .. code, vim.log.levels.ERROR)
      end
      server_state.running = false
      server_state.job_id = nil
    end,
    detach = true
  })
  
  return job_id
end

-- Static file serving (fallback)
local function start_static_server(port)
  vim.notify("Static file serving (fallback mode) - server URL: http://localhost:" .. port, vim.log.levels.INFO)
  vim.notify("Note: For live reload, install live-server: npm install -g live-server", vim.log.levels.WARN)
  
  -- Return a dummy job ID since we're not actually running a server
  return -1
end

-- Open browser
local function open_browser(port)
  local config = get_config()
  if not config.auto_open_enabled() then
    return
  end
  
  local url = "http://localhost:" .. port
  
  -- Detect OS and open browser
  local open_cmd
  if vim.fn.has("mac") == 1 then
    open_cmd = "open " .. url
  elseif vim.fn.has("unix") == 1 then
    open_cmd = "xdg-open " .. url
  elseif vim.fn.has("win32") == 1 then
    open_cmd = "start " .. url
  else
    vim.notify("Cannot auto-open browser on this platform", vim.log.levels.WARN)
    return
  end
  
  vim.fn.jobstart(open_cmd, { detach = true })
  vim.notify("Opening browser at " .. url, vim.log.levels.INFO)
end

-- Main server start function
function M.start_server()
  -- Check if server is already running
  if server_state.running then
    vim.notify("Server is already running on port " .. server_state.port, vim.log.levels.WARN)
    return
  end
  
  -- Check if we're in a p5.js project
  if not is_p5_project() then
    vim.notify("Not in a p5.js project (index.html not found)", vim.log.levels.ERROR)
    return
  end
  
  -- Get configuration
  local config = get_config()
  local port = config.get_port()
  local server_type = config.get_server_type()
  
  -- Auto-detect server type if needed
  if server_type == "auto" then
    server_type = auto_detect_server()
    vim.notify("Auto-detected server type: " .. server_type, vim.log.levels.INFO)
  end
  
  -- Start the appropriate server
  local job_id
  if server_type == "live-server" then
    if not command_exists("live-server") then
      vim.notify("live-server not found. Install with: npm install -g live-server", vim.log.levels.ERROR)
      return
    end
    job_id = start_live_server(port)
  elseif server_type == "python" then
    if not command_exists("python3") then
      vim.notify("python3 not found", vim.log.levels.ERROR)
      return
    end
    job_id = start_python_server(port)
  elseif server_type == "static" then
    job_id = start_static_server(port)
  else
    vim.notify("Unknown server type: " .. server_type, vim.log.levels.ERROR)
    return
  end
  
  -- Update server state
  if job_id and job_id > 0 then
    server_state.running = true
    server_state.job_id = job_id
    server_state.port = port
    server_state.type = server_type
    
    -- Create statusline component if enabled
    if config.get("statusline") and config.get("statusline").enabled then
      M.update_statusline()
    end
    
    -- Open browser if configured
    vim.defer_fn(function()
      open_browser(port)
    end, 1000)  -- Wait 1 second for server to start
    
    vim.notify("✓ " .. server_type .. " started successfully!", vim.log.levels.INFO)
    vim.notify("🌐 Server URL: http://localhost:" .. port, vim.log.levels.INFO)
    vim.notify("📁 Serving: " .. get_project_dir(), vim.log.levels.INFO)
    
  else
    vim.notify("Failed to start server", vim.log.levels.ERROR)
  end
end

-- Stop server
function M.stop_server()
  if not server_state.running then
    vim.notify("No server is currently running", vim.log.levels.WARN)
    return
  end
  
  if server_state.job_id and server_state.job_id > 0 then
    vim.fn.jobstop(server_state.job_id)
    vim.notify("Stopping " .. server_state.type .. " server...", vim.log.levels.INFO)
  end
  
  server_state.running = false
  server_state.job_id = nil
  server_state.port = nil
  server_state.type = nil
  
  vim.notify("✓ Server stopped", vim.log.levels.INFO)
end

-- Get server status
function M.get_status()
  if server_state.running then
    return {
      running = true,
      type = server_state.type,
      port = server_state.port,
      url = "http://localhost:" .. server_state.port
    }
  else
    return { running = false }
  end
end

-- Toggle server
function M.toggle_server()
  if server_state.running then
    M.stop_server()
  else
    M.start_server()
  end
end

-- Update statusline component
function M.update_statusline()
  -- This will be enhanced in Phase 3 with lualine/mini.statusline integration
  local status = M.get_status()
  if status.running then
    vim.g.p5_server_status = "🌐 " .. status.type .. ":" .. status.port
  else
    vim.g.p5_server_status = ""
  end
end

-- Restart server
function M.restart_server()
  M.stop_server()
  vim.defer_fn(function()
    M.start_server()
  end, 1000)  -- Wait 1 second before restart
end

return M