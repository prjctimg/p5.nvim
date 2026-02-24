-- Live server management
local S = {}
local core = require("p5.core")
local notify = core.notify
local console = require("p5.console")
local project = require("p5.project")

-- Default configuration
S.config = {
  port = 8000,
  auto_start = false,
  preferred_order = {"python"},
  live_reload = {
    enabled = true,
    port = 12002,
    debounce_ms = 300,
    watch_extensions = {".js", ".css", ".html", ".json"},
    exclude_dirs = {".git", "node_modules", "dist", "build"}
  },
  console = {
    enabled = true,
    auto_show = true,
    position = "below",
    height = 10
  },
  libraries = {
    cdn_sources = {"jsdelivr", "cdnjs", "unpkg"},
    auto_update = false
  }
}

-- Detect available server options
S.detect_server = function()
  local server_config = core.server_configs.python
  if core.command_exists(server_config.check) then
    local plugin_root = core.get_plugin_root()
    local server_script = plugin_root .. "/server.py"

    if vim.fn.filereadable(server_script) == 1 then
      return "python"
    else
      notify("Server script not found: " .. server_script, "warn")
    end
  else
    notify("Python3 not found. Please install Python to use the development server.", "error")
  end

  return nil
end

-- Validate server before starting
S.validate_server = function(server_type, port)
  local server_config = core.server_configs[server_type]
  if not server_config then
    return false, "Unknown server type: " .. tostring(server_type)
  end
  
  -- Check if runtime is available
  if not core.command_exists(server_config.check) then
    return false, server_config.cmd .. " is not available"
  end
  
  -- Check if server script exists
  local plugin_root = core.get_plugin_root()
  local server_script = plugin_root .. "/server.py"
  if vim.fn.filereadable(server_script) == 0 then
    return false, "Server script not found: " .. server_script
  end
  
  -- Validate port range
  if not port or port <= 0 or port >= 65536 then
    return false, "Invalid port number: " .. tostring(port)
  end
  
  -- System port check (more robust)
  if port < 1024 then
    local result = vim.fn.system("id -u 2>/dev/null")
    local user_id = vim.trim(result)
    if user_id ~= "0" then
      return false, "Port " .. port .. " requires root privileges (ports < 1024)"
    end
  end
  
  return true, "Server validation passed"
end

-- Find available port starting from the given port
S.find_available_port = function(start_port)
  local max_attempts = 20
  local preferred_ports = {}
  
  -- Generate list of preferred ports to try
  for i = 0, max_attempts - 1 do
    table.insert(preferred_ports, start_port + i)
  end
  
  -- Add some alternative ranges if preferred range is full
  local alternative_ranges = {3000, 5000, 9000}
  for _, base in ipairs(alternative_ranges) do
    for i = 0, 9 do
      table.insert(preferred_ports, base + i)
    end
  end
  
  for _, test_port in ipairs(preferred_ports) do
    -- More robust port checking
    local result = vim.fn.system(string.format("lsof -i:%d 2>/dev/null || netstat -tuln 2>/dev/null | grep ':%d'", test_port, test_port))
    if vim.v.shell_error ~= 0 or result == "" then
      -- Double check by trying to bind to the port briefly
      local test_bind = vim.fn.system(string.format("timeout 1 bash -c 'echo > /dev/tcp/localhost/%d' 2>/dev/null", test_port))
      if vim.v.shell_error ~= 0 then
        return test_port
      end
    end
  end
  
  notify("Warning: Could not find an available port, using " .. start_port .. " anyway", "warn")
  return start_port -- Fallback to original port if all are taken
end

-- Get server command
S.get_server_command = function(server_type, port)
  local plugin_root = core.get_plugin_root()
  
  local server_config = core.server_configs[server_type]
  if not server_config then
    return nil
  end
  
  if server_type == "python" then
    return {"python3", plugin_root .. "/server.py", tostring(port)}
  end
  
  return nil
end

-- Start live server
S.start_server = function(port)
  local console = require("p5.console")
  local project = require("p5.project")
  
  -- Get directory from currently focused buffer, fallback to cwd
  local buffer_dir = vim.fn.expand('%:p:h')
  if buffer_dir == '' or vim.fn.isdirectory(buffer_dir) == 0 then
    buffer_dir = vim.fn.getcwd()
  end
  
  -- Check if buffer's directory is a valid p5.js project
  local is_project, project_msg, project_info = project.is_p5_project(buffer_dir)
  
  if not is_project then
    notify("Not a p5.js project: " .. project_msg, "error")
    notify("Use :P5CreateProject to create a new project first", "info")
    return
  end
  
  -- Change to project directory for server
  vim.api.nvim_set_current_dir(buffer_dir)
  
  local server_type = S.detect_server()
  if not server_type then
    notify("No suitable server found (python3, bun, deno, or node)", "error")
    notify("Please install one of the supported runtimes", "info")
    return
  end

  port = port or S.config.server.port or 8000
  
  -- Check if port is available and find alternative if needed
  local actual_port = S.find_available_port(port)
  if actual_port ~= port then
    notify("Port " .. port .. " in use, using " .. actual_port .. " instead", "warn")
    port = actual_port
  end
  
  -- Validate server before starting
  local valid, message = S.validate_server(server_type, port)
  if not valid then
    notify("Server validation failed: " .. message, "error")
    return
  end
  
  S.port = port
  S.server_type = server_type

  local cmd = S.get_server_command(server_type, port)
  if not cmd then
    notify("Failed to get server command for: " .. server_type, "error")
    return
  end

  -- Console polling will be started after server is ready
  S.server_start_time = os.time()

  S.server_job = vim.fn.jobstart(cmd, {
    on_stdout = function(_, data)
      if data and #data > 0 and data[1] ~= "" then
        for _, line in ipairs(data) do
          if line:match("Server running at") then
            -- Server ready, notification handled below
          end
        end
      end
    end,
    on_stderr = function(_, data)
      if data and #data > 0 and data[1] ~= "" then
        local error_msg = table.concat(data, " ")
        
        -- Handle specific error cases
        if error_msg:match("Address already in use") then
          notify("Port " .. port .. " is already in use. Try a different port.", "error")
        elseif error_msg:match("Permission denied") then
          notify("Permission denied. Check if port " .. port .. " requires elevated privileges.", "error")
        elseif error_msg:match("EACCES") then
          notify("Access denied. Check file permissions.", "error")
        end
      end
    end,
    on_exit = function(_, exit_code, event)
      -- Stop console polling when HTTP server stops
      console.hide()
      
      if exit_code == 0 then
        notify("🛑 Server stopped", "info")
      else
        local reason = ""
        if event == "exit" then
          reason = " (exited normally)"
        elseif event == "term" then
          reason = " (terminated)"
        else
          reason = " (event: " .. (event or "unknown") .. ")"
        end
        
        notify("Server stopped with code " .. exit_code .. reason, "warn")
      end
      
      S.server_job = nil
      S.server_type = nil
    end
  })

  if S.server_job > 0 then
    local url = "http://localhost:" .. port
    notify("🎉 Server started (" .. server_type .. ") at " .. url, "ok")
    
    -- Start console polling AFTER server is confirmed ready
    if S.config.console.enabled then
      vim.defer_fn(function()
        S.start_console_after_ready()
      end, 2000) -- Wait 2 seconds for server to be ready
    end
    
    -- Auto-open browser
    if S.config.server.auto_open_browser ~= false then
      S.open_browser(url)
    end
    
    -- Show console if enabled
    if S.config.console.auto_show then
      vim.defer_fn(function()
        console.show({ enter = false })
      end, 2500) -- Show console after server is ready
    end
  end
end

-- Stop live server
S.stop_server = function()
  if not S.server_job then
    notify("No server running", "warn")
    return
  end

  local stopped_port = S.port -- Store port for notification
  local server_type = S.server_type -- Store server type for notification
  
  vim.fn.jobstop(S.server_job)
  S.server_job = nil
  S.server_type = nil
  
  -- Stop console
  local console = require("p5.console")
  console.hide()
  
  notify("🛑 Server stopped on port " .. stopped_port .. " (" .. server_type .. ")", "info")
end

-- Start console polling after server is ready
S.start_console_after_ready = function()
  local console = require("p5.console")
  
  -- Pass the actual server port to console module
  local console_config = vim.deepcopy(S.config)
  console_config.server = {
    port = S.port,
    auto_start = false
  }
  
  local console_started = console.create_console_terminal()
  
  if console_started then
    notify("Console polling started on port " .. S.port, "ok")
  end
end

-- Open browser with cross-platform support
S.open_browser = function(url)
  local open_cmd
  
  -- Detect OS and use appropriate command
  if vim.fn.has("unix") == 1 then
    if vim.fn.has("mac") == 1 then
      -- macOS
      open_cmd = {"open", url}
    else
      -- Linux and other Unix-like systems
      open_cmd = {"xdg-open", url}
    end
  elseif vim.fn.has("win32") == 1 then
    -- Windows
    open_cmd = {"cmd", "/c", "start", "", url}
  else
    -- Fallback
    open_cmd = {"xdg-open", url}
  end
  
  local result = vim.fn.system(open_cmd)
  if vim.v.shell_error ~= 0 then
    notify("Failed to open browser: " .. vim.trim(result), "warn")
    notify("Please open manually: " .. url, "info")
  end
end

-- Start server with fallback HTML
S.start_server_with_fallback = function(port)
  local fallback_file = project.create_fallback_html()
  
  local server_type = S.detect_server()
  if not server_type then
    notify("No suitable server found (python3, bun, deno, or node)", "error")
    return
  end

  port = port or S.config.server.port or 8000
  
  -- Validate server before starting
  local valid, message = S.validate_server(server_type, port)
  if not valid then
    notify("Server validation failed: " .. message, "error")
    return
  end
  
  S.port = port
  S.server_type = server_type
  notify("Starting " .. server_type .. " server with fallback page on port " .. port, "info")

  local cmd = S.get_server_command(server_type, port)
  if not cmd then
    notify("Failed to get server command for: " .. server_type, "error")
    return
  end

  -- Console polling will be started after server is ready
  S.server_start_time = os.time()

  S.server_job = vim.fn.jobstart(cmd, {
    on_stdout = function(_, data)
      if data and #data > 0 and data[1] ~= "" then
        -- Process server output for ready signal
        for _, line in ipairs(data) do
          if line:match("Server running at") then
            notify("Server confirmed ready", "ok")
          end
        end
      end
    end,
    on_stderr = function(_, data)
      if data and #data > 0 and data[1] ~= "" then
        local error_msg = table.concat(data, " ")
        
        -- Handle specific error cases
        if error_msg:match("Address already in use") then
          notify("Port " .. port .. " is already in use. Try a different port.", "error")
        elseif error_msg:match("Permission denied") then
          notify("Permission denied. Check if port " .. port .. " requires elevated privileges.", "error")
        elseif error_msg:match("EACCES") then
          notify("Access denied. Check file permissions.", "error")
        else
          notify("Server error: " .. error_msg, "error")
        end
      end
    end,
    on_exit = function(_, exit_code, event)
      -- Stop console polling when HTTP server stops
      console.hide()
      
      -- Clean up fallback file
      if vim.fn.filereadable(fallback_file) == 1 then
        vim.fn.delete(fallback_file)
      end
      
      if exit_code == 0 then
        notify("🛑 Server stopped", "info")
      else
        local reason = ""
        if event == "exit" then
          reason = " (exited normally)"
        elseif event == "term" then
          reason = " (terminated)"
        else
          reason = " (event: " .. (event or "unknown") .. ")"
        end
        
        notify("Server stopped with code " .. exit_code .. reason, "warn")
      end
      
      S.server_job = nil
      S.server_type = nil
    end
  })

  if S.server_job > 0 then
    local url = "http://localhost:" .. port .. "/.p5-temp.html"
    notify("🎉 Server started (" .. server_type .. ") at " .. url, "ok")
    
    -- Start console polling AFTER server is confirmed ready
    if S.config.console.enabled then
      vim.defer_fn(function()
        S.start_console_after_ready()
      end, 2000) -- Wait 2 seconds for server to be ready
    end
    
    -- Auto-open browser
    if S.config.server.auto_open_browser ~= false then
      S.open_browser(url)
    end
    
    -- Show console if enabled
    if S.config.console.auto_show then
      vim.defer_fn(function()
        local console = require("p5.console")
        console.show({ enter = false })
      end, 2500) -- Show console after server is ready
    end
  else
    notify("Failed to start server", "error")
  end
end

-- Setup server module
S.setup = function(config)
  S.config = vim.tbl_deep_extend("force", S.config, config or {})
end

return S