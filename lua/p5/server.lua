-- Server management for p5.nvim
local M = {}
local core = require("p5.core")

M.server_job = nil
M.server_type = nil
M.port = 8000

-- Detect available server options
M.detect_server = function()
  local config = core.read_workspace_config()
  local preferred_order = config and config.server and config.server.preferred_order or M.config.server.preferred_order

  for _, server in ipairs(preferred_order) do
    if server == "python" and core.command_exists("python3") then
      return "python"
    elseif server == "bun" and core.command_exists("bun") then
      return "bun"
    elseif server == "deno" and core.command_exists("deno") then
      return "deno"
    elseif server == "live-server" and core.command_exists("npx") then
      return "live-server"
    end
  end

  return nil
end

-- Get server command
M.get_server_command = function(server_type, port)
  local plugin_root = core.get_plugin_root()
  
  if server_type == "python" then
    return {"python3", "-m", "http.server", tostring(port)}
  elseif server_type == "bun" then
    return {"bun", "run", plugin_root .. "/scripts/live-server/bun.js", tostring(port)}
  elseif server_type == "deno" then
    return {"deno", "run", "--allow-net", plugin_root .. "/scripts/live-server/deno.js", tostring(port)}
  elseif server_type == "live-server" then
    return {"npx", "live-server", "--port=" .. tostring(port), "--quiet"}
  end
  
  return nil
end

-- Start live server
M.start_server = function(port)
  if M.server_job then
    core.notify("Server already running", "warn")
    return
  end

  port = port or M.port
  M.port = port

  local server_type = M.detect_server()
  if not server_type then
    core.notify("No suitable server found (python3, bun, deno, or npx)", "error")
    return
  end

  local cmd = M.get_server_command(server_type, port)
  if not cmd then
    core.notify("Failed to get server command for: " .. server_type, "error")
    return
  end

  M.server_job = vim.fn.jobstart(cmd, {
    on_stdout = function(_, data)
      if data and #data > 0 then
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
      require("p5.console").show()
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
  core.notify("Server stopped", "info")
end

-- Get server status
M.get_status = function()
  return {
    running = M.server_job ~= nil,
    type = M.server_type,
    port = M.port
  }
end

M.setup = function(config)
  M.config = config
end

return M