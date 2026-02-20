-- Browser console integration for p5.nvim with SSE streaming
local C = {}
local core = require("p5.core")
local notify = core.notify
local project = require("p5.project")
local server = require("p5.server")

C.console_win = nil
C.console_buf = nil
C.console_job = nil
C.server_port = nil
C.reconnect_attempts = 0
C.max_reconnect_attempts = 5
C.reconnect_delay = 1000

C.create_console_terminal = function()
  if C.console_win and vim.api.nvim_win_is_valid(C.console_win) then
    return C.console_win
  end

  local server = require("p5.server")
  if not (server.server_job and server.port) then
    notify("Console requires a running server first", "warn")
    return nil
  end

  C.server_port = server.port
  C.reconnect_attempts = 0

  local curl_cmd = string.format(
    'curl -s -N "http://localhost:%d/api/console/stream" 2>/dev/null',
    C.server_port
  )

  C.console_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_name(C.console_buf, "p5-console-terminal")
  vim.api.nvim_set_option_value("filetype", "log", { buf = C.console_buf })
  vim.api.nvim_set_option_value("modifiable", false, { buf = C.console_buf })

  local connection_confirmed = false

  C.console_job = vim.fn.jobstart(curl_cmd, {
    term = true,
    on_stdout = function(_, data)
      if data and #data > 0 and not connection_confirmed then
        for _, line in ipairs(data) do
          if line:match("\027%[%d") then
            connection_confirmed = true
            C.reconnect_attempts = 0
            vim.schedule(function()
              notify("Console connected to browser", "info")
            end)
            break
          end
        end
      end
    end,
    on_stderr = function(_, data)
      if data and #data > 0 then
        for _, line in ipairs(data) do
          if line:match("Connection refused") or line:match("curl:") then
          end
        end
      end
    end,
    on_exit = function(_, exit_code)
      if exit_code ~= 0 and C.console_win and vim.api.nvim_win_is_valid(C.console_win) then
        vim.schedule(function()
          if connection_confirmed then
            notify("Console disconnected from browser", "warn")
            C.attempt_reconnect()
          else
            notify("Console connection failed", "error")
          end
        end)
      end
      C.console_job = nil
    end
  })

  return C.console_buf
end

C.attempt_reconnect = function()
  if C.reconnect_attempts >= C.max_reconnect_attempts then
    notify("Console reconnection failed: max attempts reached", "error")
    return
  end

  local delay = C.reconnect_delay * (2 ^ C.reconnect_attempts)
  C.reconnect_attempts = C.reconnect_attempts + 1

  vim.defer_fn(function()
    if C.console_win and vim.api.nvim_win_is_valid(C.console_win) then
      notify(string.format("Reconnecting to console (attempt %d)...", C.reconnect_attempts), "info")
      C.create_console_terminal()
    end
  end, delay)
end

C.show = function()
  local is_project = project.is_p5_project()

  if not is_project then
    notify("Console only works in p5.js projects", "warn")
    return
  end

  if not server.server_job then
    notify("Start server first with :P5StartServer", "info")
    return
  end

  if C.console_win and vim.api.nvim_win_is_valid(C.console_win) then
    vim.api.nvim_set_current_win(C.console_win)
    return
  end

  local position = C.config.console.position or "below"
  local height = C.config.console.height or 10
  C.server_port = server.port

  local curl_cmd = string.format(
    'curl -s -N "http://localhost:%d/api/console/stream" 2>/dev/null',
    C.server_port
  )

  -- Try snacks.terminal first for predictable behavior
  local snacks = core.require_snacks()
  if snacks and snacks.terminal then
    local term = snacks.terminal(curl_cmd, {
      win = {
        title = "p5-console",
        position = position,
        size = height,
      },
    })
    C.console_win = term.win
    C.console_buf = term.buf
    notify("Console connected to server on port " .. C.server_port, "info")
    return
  end

  -- Fallback to manual terminal creation
  local buf = C.create_console_terminal()
  if not buf then
    return
  end

  local split_pattern = core.split_commands[position] or core.split_commands.below
  local split_cmd = split_pattern:format(height)

  vim.cmd(split_cmd)
  C.console_win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(C.console_win, buf)

  vim.api.nvim_set_option_value("wrap", true, { scope = "local", win = C.console_win })
  vim.api.nvim_set_option_value("number", false, { scope = "local", win = C.console_win })
  vim.api.nvim_set_option_value("relativenumber", false, { scope = "local", win = C.console_win })
  vim.api.nvim_set_option_value("signcolumn", "no", { scope = "local", win = C.console_win })

  vim.api.nvim_buf_set_keymap(buf, "t", "<Esc>", "", {
    callback = function()
      vim.cmd("stopinsert")
      C.hide()
    end,
    desc = "Hide p5 console",
    noremap = true
  })

  vim.api.nvim_buf_set_keymap(buf, "n", "q", "", {
    callback = C.hide,
    desc = "Hide p5 console"
  })
  vim.api.nvim_buf_set_keymap(buf, "n", "c", "", {
    callback = C.clear_terminal,
    desc = "Clear p5 console"
  })
  vim.api.nvim_buf_set_keymap(buf, "n", "i", "", {
    callback = function()
      vim.cmd("startinsert")
    end,
    desc = "Enter terminal mode"
  })

  vim.api.nvim_buf_set_keymap(buf, "t", "<C-/>", "", {
    callback = C.toggle,
    desc = "Toggle p5 console",
    noremap = true
  })

  vim.cmd("startinsert")

  notify("Console connected to server on port " .. C.server_port, "info")
end

C.hide = function()
  if C.console_win and vim.api.nvim_win_is_valid(C.console_win) then
    vim.api.nvim_win_close(C.console_win, true)
    C.console_win = nil
    C.console_buf = nil

    if C.console_job then
      vim.fn.jobstop(C.console_job)
      C.console_job = nil
    end
  end
end

C.toggle = function()
  if C.console_win and vim.api.nvim_win_is_valid(C.console_win) then
    C.hide()
  else
    C.show()
  end
end

C.clear_terminal = function()
  if C.console_buf and vim.api.nvim_buf_is_valid(C.console_buf) and C.console_job then
    vim.api.nvim_chan_send(C.console_job, "\027[H\027[2J")
  end
end

C.get_injection_script = function()
  return [[
    <script>
      (function() {
        console.log('p5.nvim console integration enabled');

        const originalConsole = {
          log: console.log,
          error: console.error,
          warn: console.warn,
          info: console.info
        };

        let logBuffer = [];
        let flushTimeout;

        function flushLogBuffer() {
          if (logBuffer.length === 0) return;

          const logs = [...logBuffer];
          logBuffer = [];

          fetch('/api/console/log', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
              type: 'console_batch',
              logs: logs,
              timestamp: new Date().toISOString()
            })
          }).catch(() => {
            logs.forEach(log => {
              fetch('/api/console/log', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(log)
              }).catch(() => {});
            });
          });
        }

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

          const logEntry = {
            type: 'console',
            level: level,
            message: message,
            source: 'javascript',
            timestamp: new Date().toISOString()
          };

          logBuffer.push(logEntry);

          clearTimeout(flushTimeout);
          flushTimeout = setTimeout(flushLogBuffer, 100);
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

        window.onerror = function(msg, source, lineno, colno, error) {
          sendToConsole('error', [msg + ' at ' + source + ':' + lineno + ':' + colno]);
          return false;
        };

        window.addEventListener('beforeunload', flushLogBuffer);
      })();
    </script>]]
end

C.setup = function(config)
  C.config = config
  C.console_enabled = false

  vim.api.nvim_set_hl(0, "P5ConsoleError", { fg = "#ff5555", bold = true })
  vim.api.nvim_set_hl(0, "P5ConsoleWarn", { fg = "#ffb86c" })
  vim.api.nvim_set_hl(0, "P5ConsoleInfo", { fg = "#8be9fd" })
  vim.api.nvim_set_hl(0, "P5ConsoleLog", { fg = "#6272a4" })
end

return C
