-- Live server management
local M = {}
local core = require("p5.core")

-- Default configuration
M.config = {
  port = 8000,
  auto_start = false,
  preferred_order = {"python", "bun", "deno", "node"},
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
M.detect_server = function()
  local config = core.read_workspace_config()
  local preferred_order = config and config.server and config.server.preferred_order or M.config.server.preferred_order

  for _, server in ipairs(preferred_order) do
    local server_config = core.server_configs[server]
    if server_config and core.command_exists(server_config.check) then
      -- Validate that server script exists
      local plugin_root = core.get_plugin_root()
      local server_script = plugin_root .. "/servers/" .. server_config.script
      
      if vim.fn.filereadable(server_script) == 1 then
        return server
      else
        core.notify("Server script not found: " .. server_script, "warn")
      end
    end
  end

  return nil
end

-- Validate server before starting
M.validate_server = function(server_type, port)
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
  local server_script = plugin_root .. "/servers/" .. server_config.script
  if vim.fn.filereadable(server_script) == 0 then
    return false, "Server script not found: " .. server_script
  end
  
  -- Check if port is available (basic check)
  if port and port > 0 and port < 65536 then
    local result = vim.fn.system("netstat -tuln 2>/dev/null | grep ':" .. port .. "'")
    if vim.v.shell_error == 0 and result ~= "" then
      return false, "Port " .. port .. " is already in use"
    end
  end
  
  return true, "Server validation passed"
end

-- Get server command
M.get_server_command = function(server_type, port)
  local plugin_root = core.get_plugin_root()
  
  local server_config = core.server_configs[server_type]
  if not server_config then
    return nil
  end
  
  if server_type == "python" then
    return {"python3", plugin_root .. "/servers/" .. server_config.script, tostring(port)}
  elseif server_type == "deno" then
    return {"deno", "run", "--allow-net", plugin_root .. "/servers/" .. server_config.script, tostring(port)}
  else
    return {server_config.cmd, "run", plugin_root .. "/servers/" .. server_config.script, tostring(port)}
  end
  
  return nil
end

-- Start live server
M.start_server = function(port)
  local server_type = M.detect_server()
  if not server_type then
    core.notify("No suitable server found (python3, bun, deno, or node)", "error")
    core.notify("Please install one of the supported runtimes", "info")
    return
  end

  port = port or M.config.server.port or 8000
  
  -- Validate server before starting
  local valid, message = M.validate_server(server_type, port)
  if not valid then
    core.notify("Server validation failed: " .. message, "error")
    return
  end
  
  M.port = port
  M.server_type = server_type
  core.notify("Starting " .. server_type .. " server on port " .. port, "info")

  local cmd = M.get_server_command(server_type, port)
  if not cmd then
    core.notify("Failed to get server command for: " .. server_type, "error")
    return
  end

  -- Console polling will be started after server is ready
  M.server_start_time = os.time()

  M.server_job = vim.fn.jobstart(cmd, {
    on_stdout = function(_, data)
      if data and #data > 0 and data[1] ~= "" then
        -- Process server output for ready signal
        for _, line in ipairs(data) do
          if line:match("Server running at") then
            core.notify("Server confirmed ready", "ok")
          end
        end
      end
    end,
    on_stderr = function(_, data)
      if data and #data > 0 and data[1] ~= "" then
        local error_msg = table.concat(data, " ")
        
        -- Handle specific error cases
        if error_msg:match("Address already in use") then
          core.notify("Port " .. port .. " is already in use. Try a different port.", "error")
        elseif error_msg:match("Permission denied") then
          core.notify("Permission denied. Check if port " .. port .. " requires elevated privileges.", "error")
        elseif error_msg:match("EACCES") then
          core.notify("Access denied. Check file permissions.", "error")
        else
          core.notify("Server error: " .. error_msg, "error")
        end
      end
    end,
    on_exit = function(_, exit_code, event)
      -- Stop console polling when HTTP server stops
      local console = require("p5.console")
      console.stop_console_polling()
      
      if exit_code == 0 then
        core.notify("Server stopped successfully", "info")
      else
        local reason = ""
        if event == "exit" then
          reason = " (exited normally)"
        elseif event == "term" then
          reason = " (terminated)"
        else
          reason = " (event: " .. (event or "unknown") .. ")"
        end
        
        core.notify("Server stopped with code " .. exit_code .. reason, "warn")
      end
      
      M.server_job = nil
      M.server_type = nil
    end
  })

  if M.server_job > 0 then
    local url = "http://localhost:" .. port
    core.notify("Server started (" .. server_type .. ") at " .. url, "ok")
    
    -- Start console polling AFTER server is confirmed ready
    if M.config.console.enabled then
      vim.defer_fn(function()
        M.start_console_after_ready()
      end, 2000) -- Wait 2 seconds for server to be ready
    end
    
    -- Auto-open browser
    if M.config.server.auto_open_browser ~= false then
      M.open_browser(url)
    end
    
    -- Show console if enabled
    if M.config.console.auto_show then
      vim.defer_fn(function()
        console.show()
      end, 2500) -- Show console after server is ready
    end
  else
    core.notify("Failed to start server", "error")
  end
end

-- Stop live server
M.stop_server = function()
  if not M.server_job then
    core.notify("No server running", "warn")
    return
  end

  vim.fn.jobstop(M.server_job)
  M.server_job = nil
  M.server_type = nil
  
  -- Stop console polling
  local console = require("p5.console")
  console.stop_console_polling()
  
  core.notify("Server stopped", "info")
end

-- Start console polling after server is ready
M.start_console_after_ready = function()
  local console = require("p5.console")
  local core_ref = require("p5.core")
  
  -- Pass the actual server port to console module
  local console_config = vim.deepcopy(M.config)
  console_config.server = {
    port = M.port,
    auto_start = false
  }
  
  local console_started = console.start_console_polling(M.port)
  
  if console_started then
    core_ref.notify("Console polling started on port " .. M.port, "ok")
  end
end

-- Open browser with cross-platform support
M.open_browser = function(url)
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
    core.notify("Failed to open browser: " .. vim.trim(result), "warn")
    core.notify("Please open manually: " .. url, "info")
  end
end

-- Setup server module
M.setup = function(config)
  M.config = vim.tbl_deep_extend("force", M.config, config or {})
end

return M