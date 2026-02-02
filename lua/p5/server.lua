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
      return server
    end
  end

  return nil
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
    return
  end

  port = port or M.port
  M.port = port

  local cmd = M.get_server_command(server_type, port)
  if not cmd then
    core.notify("Failed to get server command for: " .. server_type, "error")
    return
  end

  -- Start WebSocket server for console integration
  local console = require("p5.console")
  local core_ref = require("p5.core")
  local ws_started = console.start_websocket_server()
  
  if ws_started then
    core_ref.notify_fallback("Console WebSocket server started on port 12001", "ok")
  end

  M.server_job = vim.fn.jobstart(cmd, {
    on_stdout = function(_, data)
      if data and #data > 0 and data[1] ~= "" then
        -- Process server output if needed
      end
    end,
    on_stderr = function(_, data)
      if data and #data > 0 and data[1] ~= "" then
        core.notify("Server error: " .. table.concat(data, " "), "error")
      end
    end,
    on_exit = function(_, exit_code)
      if exit_code == 0 then
        core.notify("Server stopped", "info")
      else
        core.notify("Server exited with code: " .. exit_code, "error")
      end
      M.server_job = nil
      M.server_type = nil
      
      -- Stop WebSocket server when HTTP server stops
      console.stop_websocket_server()
    end
  })

  if M.server_job > 0 then
    M.server_type = server_type
    local url = "http://localhost:" .. port
    core.notify("Server started (" .. server_type .. ") at " .. url, "ok")
    
    -- Auto-open browser
    vim.fn.system({ "xdg-open", url })
    
    -- Show console if enabled
    if M.config.console.auto_show then
      console.show()
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
  
  -- Stop WebSocket server
  local console = require("p5.console")
  console.stop_websocket_server()
  
  core.notify("Server stopped", "info")
end

-- Setup server module
M.setup = function(config)
  M.config = vim.tbl_deep_extend("force", M.config, config or {})
end

return M