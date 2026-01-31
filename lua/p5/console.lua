-- Browser console integration for p5.nvim
local M = {}
local core = require("p5.core")

M.console_buf = nil
M.console_win = nil
M.ws_server = nil
M.logs = {}

-- Create console buffer
M.create_console_buffer = function()
  if M.console_buf and vim.api.nvim_buf_is_valid(M.console_buf) then
    return M.console_buf
  end

  M.console_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_name(M.console_buf, "p5-console")
  vim.api.nvim_buf_set_option(M.console_buf, "filetype", "log")
  vim.api.nvim_buf_set_option(M.console_buf, "modifiable", true)
  
  -- Set buffer options
  vim.api.nvim_buf_set_lines(M.console_buf, 0, -1, false, {
    "p5.js Browser Console",
    "====================",
    ""
  })

  return M.console_buf
end

-- Show console window
M.show = function()
  if M.console_win and vim.api.nvim_win_is_valid(M.console_win) then
    -- Window already visible, just focus it
    vim.api.nvim_set_current_win(M.console_win)
    return
  end

  local buf = M.create_console_buffer()
  local position = M.config.console.position or "below"
  local height = M.config.console.height or 10

  -- Determine split command
  local split_cmd
  if position == "below" then
    split_cmd = "botright " .. height .. "new"
  elseif position == "above" then
    split_cmd = "topleft " .. height .. "new"
  elseif position == "left" then
    split_cmd = "topleft vertical " .. height .. "new"
  elseif position == "right" then
    split_cmd = "botright vertical " .. height .. "new"
  else
    split_cmd = "botright " .. height .. "new"
  end

  vim.cmd(split_cmd)
  M.console_win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(M.console_win, buf)
  
  -- Set window options
  vim.api.nvim_win_set_option(M.console_win, "wrap", false)
  vim.api.nvim_win_set_option(M.console_win, "number", false)
  vim.api.nvim_win_set_option(M.console_win, "relativenumber", false)
  vim.api.nvim_win_set_option(M.console_win, "signcolumn", "no")

  -- Set up keymaps for console window
  vim.api.nvim_buf_set_keymap(buf, "n", "q", "", {
    callback = M.hide,
    desc = "Hide p5 console"
  })
  vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", "", {
    callback = M.hide,
    desc = "Hide p5 console"
  })
  vim.api.nvim_buf_set_keymap(buf, "n", "c", "", {
    callback = M.clear,
    desc = "Clear p5 console"
  })
end

-- Hide console window
M.hide = function()
  if M.console_win and vim.api.nvim_win_is_valid(M.console_win) then
    vim.api.nvim_win_close(M.console_win, true)
    M.console_win = nil
  end
end

-- Toggle console
M.toggle = function()
  if M.console_win and vim.api.nvim_win_is_valid(M.console_win) then
    M.hide()
  else
    M.show()
  end
end

-- Clear console
M.clear = function()
  if not M.console_buf or not vim.api.nvim_buf_is_valid(M.console_buf) then
    return
  end

  vim.api.nvim_buf_set_lines(M.console_buf, 0, -1, false, {
    "p5.js Browser Console",
    "====================",
    ""
  })
  M.logs = {}
end

-- Add log entry
M.add_log = function(level, message, source)
  if not M.console_buf or not vim.api.nvim_buf_is_valid(M.console_buf) then
    return
  end

  local timestamp = os.date("%H:%M:%S")
  local level_str = string.upper(level)
  local source_str = source and (" [" .. source .. "]") or ""
  local log_entry = string.format("[%s] %s%s: %s", timestamp, level_str, source_str, message)

  -- Add to logs array
  table.insert(M.logs, {
    timestamp = timestamp,
    level = level,
    message = message,
    source = source
  })

  -- Add to buffer
  local lines = vim.api.nvim_buf_get_lines(M.console_buf, 0, -1, false)
  table.insert(lines, log_entry)
  vim.api.nvim_buf_set_lines(M.console_buf, 0, -1, false, lines)

  -- Auto-scroll to bottom
  if M.console_win and vim.api.nvim_win_is_valid(M.console_win) then
    vim.api.nvim_win_set_cursor(M.console_win, {#lines, 0})
  end

  -- Highlight based on level
  local line_count = #lines
  local ns_id = vim.api.nvim_create_namespace("p5_console")
  
  if level == "error" then
    vim.api.nvim_buf_add_highlight(M.console_buf, ns_id, "Error", line_count - 1, 0, -1)
  elseif level == "warn" then
    vim.api.nvim_buf_add_highlight(M.console_buf, ns_id, "WarningMsg", line_count - 1, 0, -1)
  elseif level == "info" then
    vim.api.nvim_buf_add_highlight(M.console_buf, ns_id, "Normal", line_count - 1, 0, -1)
  elseif level == "log" then
    vim.api.nvim_buf_add_highlight(M.console_buf, ns_id, "Comment", line_count - 1, 0, -1)
  end
end

-- Start WebSocket server for browser logs
M.start_websocket_server = function()
  local core = require("p5.core")
  local websocket = core.require_websocket()
  if not websocket then
    if core.require_snacks() then
      core.require_snacks().notifier.show("WebSocket library not found. Install websocket.nvim for browser console", "warn")
    else
      core.notify("WebSocket library not found. Install websocket.nvim for browser console", "warn")
    end
    return false
  end

  -- Initialize websocket.nvim
  websocket.setup({})
  local server_mod = require("websocket.server")
  local WebsocketServer = server_mod.WebsocketServer
  M.ws_server = WebsocketServer.new({
    host = "localhost",
    port = 12001,
    on_message = function(self, client_id, message)
      local ok, data = pcall(vim.fn.json_decode, message)
      if not ok then
        M.add_log("warn", "Invalid JSON message from browser", "ws:" .. client_id)
        return
      end

      if data.type == "console" then
        M.add_log(data.level or "log", data.message or "", data.source or "browser")
      end
    end,
    on_client_connect = function(self, client_id)
      M.add_log("info", "Browser connected", "ws:" .. client_id)
    end,
    on_client_disconnect = function(self, client_id)
      M.add_log("info", "Browser disconnected", "ws:" .. client_id)
    end,
    on_error = function(self, err)
      M.add_log("error", "WebSocket error: " .. tostring(err), "server")
    end
  })

  local started = M.ws_server:try_start()
  if started then
    M.add_log("info", "WebSocket server started on port 12001", "server")
  end

  return started
end

-- Stop WebSocket server
M.stop_websocket_server = function()
  if M.ws_server then
    M.ws_server:try_stop()
    M.ws_server = nil
    M.add_log("info", "WebSocket server stopped", "server")
  end
end

-- Generate JavaScript code to inject in HTML
M.get_injection_script = function()
  return [[
    <script>
      (function() {
        const ws = new WebSocket('ws://localhost:12001');
        
        ws.onopen = function() {
          console.log('Connected to p5.nvim console');
        };
        
        ws.onclose = function() {
          console.log('Disconnected from p5.nvim console');
        };
        
        // Override console methods
        const originalConsole = {
          log: console.log,
          error: console.error,
          warn: console.warn,
          info: console.info
        };
        
        function sendToConsole(level, args) {
          const message = args.map(arg => {
            if (typeof arg === 'object') {
              try {
                return JSON.stringify(arg);
              } catch (e) {
                return String(arg);
              }
            }
            return String(arg);
          }).join(' ');
          
          ws.send(JSON.stringify({
            type: 'console',
            level: level,
            message: message,
            source: 'javascript',
            timestamp: new Date().toISOString()
          }));
        }
        
        console.log = function(...args) {
          originalConsole.log.apply(console, args);
          sendToConsole('log', args);
        };
        
        console.error = function(...args) {
          originalConsole.error.apply(console, args);
          sendToConsole('error', args);
        };
        
        console.warn = function(...args) {
          originalConsole.warn.apply(console, args);
          sendToConsole('warn', args);
        };
        
        console.info = function(...args) {
          originalConsole.info.apply(console, args);
          sendToConsole('info', args);
        };
        
        // Handle uncaught errors
        window.onerror = function(msg, source, lineno, colno, error) {
          ws.send(JSON.stringify({
            type: 'console',
            level: 'error',
            message: msg + ' at ' + source + ':' + lineno + ':' + colno,
            source: 'javascript',
            timestamp: new Date().toISOString()
          }));
          return false;
        };
      })();
    </script>]]
end

-- Setup console integration
M.setup = function(config)
  M.config = config
  
  -- Create highlight groups
  vim.api.nvim_set_hl(0, "P5ConsoleError", { fg = "#ff5555", bold = true })
  vim.api.nvim_set_hl(0, "P5ConsoleWarn", { fg = "#ffb86c" })
  vim.api.nvim_set_hl(0, "P5ConsoleInfo", { fg = "#8be9fd" })
  vim.api.nvim_set_hl(0, "P5ConsoleLog", { fg = "#6272a4" })
end

return M