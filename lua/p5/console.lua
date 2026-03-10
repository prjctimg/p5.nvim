-- Browser console integration for p5.nvim with SSE streaming
local C = {}
local core = require("p5.core")
local project = require("p5.project")
local server = require("p5.server")
local notify = core.notify

C.console_win = nil
C.console_buf = nil
C.console_job = nil
C.console_term = nil  -- Store snacks.terminal reference
C.server_port = nil
C.reconnect_attempts = 0
C.max_reconnect_attempts = 5
C.reconnect_delay = 1000
C.clear_timer = nil
C.last_error_time = 0
C.auto_clear_interval = 30000  -- 30 seconds

C.create_console_terminal = function()
  if C.console_win and vim.api.nvim_win_is_valid(C.console_win) then
    return C.console_win
  end

  if not (server.server_job and server.port) then
    notify("Console requires a running server first", "warn")
    return nil
  end

  C.server_port = server.port
  C.reconnect_attempts = 0
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
  vim.api.nvim_set_option_value("modifiable", true, { buf = C.console_buf })
  vim.api.nvim_set_option_value("scrollback", 1000, { buf = C.console_buf })

  local connection_confirmed = false

  C.console_job = vim.fn.jobstart(curl_cmd, {
    term = true,
    on_stdout = function(_, data)
      if data and #data > 0 then
        -- Check for errors in the logs
        for _, line in ipairs(data) do
          if line:match("error") or line:match("Error") or line:match("❌") then
            C.mark_error()
          end
        end
        
        if not connection_confirmed then
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

C.show = function(opts)
  opts = opts or {}
  local enter = opts.enter ~= false

  if not project.is_p5_project() then
    notify("Console only works in p5.js projects", "warn")
    return
  end

  if not server.server_job then
    notify("Start server first with :P5 server", "info")
    return
  end

  if C.console_win and vim.api.nvim_win_is_valid(C.console_win) then
    if enter then
      vim.api.nvim_set_current_win(C.console_win)
    end
    return
  end

  local position = (C.config and C.config.console and C.config.console.position) or "below"
  local viewport_height = vim.o.lines
  local height = math.floor(viewport_height * 0.3)
  C.server_port = server.port

  if C.console_win and vim.api.nvim_win_is_valid(C.console_win) then
    if enter then
      vim.api.nvim_set_current_win(C.console_win)
    end
    return
  end

  -- Reset state since window was closed externally
  C.console_win = nil
  C.console_buf = nil

  -- Use snacks.terminal if available
  local snacks = core.require_snacks()
  if snacks and snacks.terminal then
    local url = string.format("http://localhost:%d/api/console/stream", C.server_port)
    local term = snacks.terminal({"curl", "-s", "-N", url}, {
      win = {
        title = "p5-console",
        position = position == "below" and "bottom" or position,
        size = height,
      },
      auto_close = false,
      scrollback = 1000,
      enter = enter,
      keys = {
        q = "hide",
        ["<C-c>"] = "hide",
        j = "scroll_down",
        k = "scroll_up",
        G = "scroll_to_bottom",
        gg = "scroll_to_top",
        ["<C-d>"] = "page_down",
        ["<C-u>"] = "page_up",
      },
    })
    C.console_term = term
    C.console_win = term.win
    C.console_buf = term.buf
    C.start_auto_clear()
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

  vim.keymap.set("n", "q", C.hide, { buffer = buf, desc = "Hide p5 console" })
  vim.keymap.set("n", "c", C.clear_terminal, { buffer = buf, desc = "Clear p5 console" })
  vim.keymap.set("n", "i", function()
    vim.cmd("startinsert")
  end, { buffer = buf, desc = "Enter terminal mode" })

  vim.keymap.set("n", "j", "gj", { buffer = buf, noremap = true, silent = true })
  vim.keymap.set("n", "k", "gk", { buffer = buf, noremap = true, silent = true })
  vim.keymap.set("n", "<Down>", "gj", { buffer = buf, noremap = true, silent = true })
  vim.keymap.set("n", "<Up>", "gk", { buffer = buf, noremap = true, silent = true })
  vim.keymap.set("n", "G", "G", { buffer = buf, noremap = true, silent = true, desc = "Scroll to bottom" })
  vim.keymap.set("n", "gg", "gg", { buffer = buf, noremap = true, silent = true, desc = "Scroll to top" })
  vim.keymap.set("n", "<C-d>", "<C-d>zT", { buffer = buf, noremap = true, silent = true, desc = "Page down" })
  vim.keymap.set("n", "<C-u>", "<C-u>zb", { buffer = buf, noremap = true, silent = true, desc = "Page up" })
  vim.keymap.set("n", "<C-c>", C.hide, { buffer = buf, desc = "Hide console" })

  vim.cmd("startinsert")

  C.start_auto_clear()
  notify("Console connected to server on port " .. C.server_port, "info")
end

C.hide = function()
  if C.console_win and vim.api.nvim_win_is_valid(C.console_win) then
    vim.api.nvim_win_close(C.console_win, true)
    C.console_win = nil
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

C.setup = function(config)
  C.config = config

  vim.api.nvim_set_hl(0, "P5ConsoleError", { fg = "#ff5555", bold = true })
  vim.api.nvim_set_hl(0, "P5ConsoleWarn", { fg = "#ffb86c" })
  vim.api.nvim_set_hl(0, "P5ConsoleInfo", { fg = "#8be9fd" })
  vim.api.nvim_set_hl(0, "P5ConsoleLog", { fg = "#6272a4" })

  -- Register toggle with snacks.toggle if available
  local snacks = core.require_snacks()
  if snacks and snacks.toggle then
    snacks.toggle.new({
      name = "p5console",
      get = function()
        return C.console_win and vim.api.nvim_win_is_valid(C.console_win) or false
      end,
      set = function(state)
        if state then
          C.show()
        else
          C.hide()
        end
      end,
    })
  end

  C.start_auto_clear()
end

C.start_auto_clear = function()
  if C.clear_timer then
    C.clear_timer:close()
  end
  
  local timer = vim.uv.new_timer()
  C.clear_timer = timer
  
  timer:start(C.auto_clear_interval, C.auto_clear_interval, vim.schedule_wrap(function()
    if not C.console_buf or not vim.api.nvim_buf_is_valid(C.console_buf) then
      return
    end
    
    local current_time = os.time()
    if current_time - C.last_error_time > 30 then
      local line_count = vim.api.nvim_buf_line_count(C.console_buf)
      if line_count > 100 then
        vim.api.nvim_buf_set_lines(C.console_buf, 0, line_count - 50, false, {})
      end
    end
  end))
end

C.mark_error = function()
  C.last_error_time = os.time()
end

return C
