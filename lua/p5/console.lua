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

  -- Determine split command using lookup table
  local split_pattern = core.split_commands[position] or core.split_commands.below
  local split_cmd = split_pattern:format(height)

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

-- Start HTTP console polling for browser logs
M.start_console_polling = function(server_port)
  local core = require("p5.core")
  
  -- Reset restart count on successful start
  M.restart_count = 0
  
  -- Use provided port or fall back to config
  local port = server_port or M.config.server.port or 8000
  local server_url = "http://localhost:" .. port
  
  M.polling_job = vim.fn.jobstart(string.format("curl -s '%s/api/console/poll'", server_url), {
    on_stdout = function(_, data)
      for _, line in ipairs(data) do
        if line and line ~= "" then
          local ok, log_entry = pcall(vim.fn.json_decode, line)
          if ok then
            M.add_log(log_entry.level or "log", log_entry.message or "", log_entry.source or "browser")
          end
        end
      end
    end,
    on_stderr = function(_, data)
      -- Handle polling errors with better feedback
      if data and #data > 0 and data[1] ~= "" then
        local error_msg = table.concat(data, " ")
        
        -- Only show certain errors to avoid spam
        if error_msg:match("Connection refused") then
          -- Server might be starting up, this is expected
        elseif error_msg:match("No route to host") or error_msg:match("Could not resolve host") then
          local core = require("p5.core")
          core.notify("Console polling: Server not reachable", "warn")
        end
      end
    end,
    on_exit = function(_, exit_code)
      if exit_code ~= 0 and M.console_enabled then
        local core = require("p5.core")
        
        -- Implement exponential backoff for restarts
        local current_time = os.time()
        local last_restart = M.last_console_restart or 0
        local restart_delay = math.min(5000, 1000 * (2 ^ M.restart_count)) -- Max 5 seconds
        
        -- Avoid too frequent restarts
        if current_time - last_restart > 10 then
          M.restart_count = (M.restart_count or 0) + 1
          M.last_console_restart = current_time
          
          -- Restart polling if server is still expected to be running
          vim.defer_fn(function()
            if M.console_enabled then
              core.notify("Restarting console polling (attempt " .. M.restart_count .. ")", "info")
              M.start_console_polling(server_port)
            end
          end, restart_delay)
        end
      end
    end
  })
  
  M.add_log("info", "Console polling started", "server")
  return true
end

-- Stop console polling
M.stop_console_polling = function()
  if M.polling_job then
    vim.fn.jobstop(M.polling_job)
    M.polling_job = nil
    M.add_log("info", "Console polling stopped", "server")
  end
  M.console_enabled = false
end

-- Generate JavaScript code to inject in HTML
M.get_injection_script = function()
  return [[
    <script>
      (function() {
        console.log('p5.nvim console integration enabled');
        
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
          
          // Send via HTTP POST to server endpoint
          fetch('/api/console/log', {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json'
            },
            body: JSON.stringify({
              type: 'console',
              level: level,
              message: message,
              source: 'javascript',
              timestamp: new Date().toISOString()
            })
          }).catch(err => {
            // Fallback to original console if fetch fails
            originalConsole.log.apply(console, ['p5.nvim console error:', err]);
          });
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
          sendToConsole('error', [msg + ' at ' + source + ':' + lineno + ':' + colno]);
          return false;
        };
      })();
    </script>]]
end

-- Setup console integration
M.setup = function(config)
  M.config = config
  M.console_enabled = true
  
  -- Create highlight groups
  vim.api.nvim_set_hl(0, "P5ConsoleError", { fg = "#ff5555", bold = true })
  vim.api.nvim_set_hl(0, "P5ConsoleWarn", { fg = "#ffb86c" })
  vim.api.nvim_set_hl(0, "P5ConsoleInfo", { fg = "#8be9fd" })
  vim.api.nvim_set_hl(0, "P5ConsoleLog", { fg = "#6272a4" })
  
  -- Start console polling if enabled
  if config.console and config.console.enabled then
    M.start_console_polling()
  end
end

return M