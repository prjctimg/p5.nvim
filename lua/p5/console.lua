-- Browser console integration for p5.nvim with SSE streaming
local C = {}
local core = require("p5.core")
local project = require("p5.project")
local notify = core.notify

C.win = nil
C.buf = nil
C.job = nil
C.term = nil -- Store snacks.terminal reference
C.port = nil
C.attempts = 0
C.max_attempts = 5
C.delay = 1000
C.timer = nil
C.last_error = 0
C.clear_interval = 30000 -- 30 seconds

C.create = function()
	local server = require("p5.server")

	if C.win and vim.api.nvim_win_is_valid(C.win) then
		return C.win
	end

	if not (server.server_job and server.port) then
		notify("Console requires a running server first", "warn")
		return nil
	end

	C.port = server.port
	C.attempts = 0

	local curl_cmd = string.format('curl -s -N "http://localhost:%d/api/console/stream" 2>/dev/null', C.port)

	C.buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_name(C.buf, "p5-console-terminal")
	vim.api.nvim_set_option_value("filetype", "log", { buf = C.buf })
	vim.api.nvim_set_option_value("modifiable", true, { buf = C.buf })
	vim.api.nvim_set_option_value("scrollback", 1000, { buf = C.buf })

	local connection_confirmed = false

	C.job = vim.fn.jobstart(curl_cmd, {
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
							C.attempts = 0
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
			if exit_code ~= 0 and C.win and vim.api.nvim_win_is_valid(C.win) then
				vim.schedule(function()
					if connection_confirmed then
						notify("Console disconnected from browser", "warn")
						C.reconnect()
					else
						notify("Console connection failed", "error")
					end
				end)
			end
			C.job = nil
		end,
	})

	return C.buf
end

C.reconnect = function()
	if C.attempts >= C.max_attempts then
		notify("Console reconnection failed: max attempts reached", "error")
		return
	end

	local delay = C.delay * (2 ^ C.attempts)
	C.attempts = C.attempts + 1

	vim.defer_fn(function()
		if C.win and vim.api.nvim_win_is_valid(C.win) then
			notify(string.format("Reconnecting to console (attempt %d)...", C.attempts), "info")
			C.create()
		end
	end, delay)
end

C.show = function(opts)
	local server = require("p5.server")
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

	if C.win and vim.api.nvim_win_is_valid(C.win) then
		if enter then
			vim.api.nvim_set_current_win(C.win)
		end
		return
	end

	local position = (C.config and C.config.console and C.config.console.position) or "below"
	local viewport_height = vim.o.lines
	local height = math.floor(viewport_height * 0.3)
	C.port = server.port

	if C.win and vim.api.nvim_win_is_valid(C.win) then
		if enter then
			vim.api.nvim_set_current_win(C.win)
		end
		return
	end

	-- Reset state since window was closed externally
	C.win = nil
	C.buf = nil

	-- Use snacks.terminal if available
	local snacks = core.require_snacks()
	if snacks and snacks.terminal then
		local url = string.format("http://localhost:%d/api/console/stream", C.port)
		local term = snacks.terminal({ "curl", "-s", "-N", url }, {
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
		C.term = term
		C.win = term.win
		C.buf = term.buf
		C.auto_clear()
		notify("Console connected to server on port " .. C.port, "info")
		return
	end

	-- Fallback to manual terminal creation
	local buf = C.create()
	if not buf then
		return
	end

	local split_pattern = core.split_commands[position] or core.split_commands.below
	local split_cmd = split_pattern:format(height)

	vim.cmd(split_cmd)
	C.win = vim.api.nvim_get_current_win()
	vim.api.nvim_win_set_buf(C.win, buf)

	vim.api.nvim_set_option_value("wrap", true, { scope = "local", win = C.win })
	vim.api.nvim_set_option_value("number", false, { scope = "local", win = C.win })
	vim.api.nvim_set_option_value("relativenumber", false, { scope = "local", win = C.win })
	vim.api.nvim_set_option_value("signcolumn", "no", { scope = "local", win = C.win })

	vim.keymap.set("n", "q", C.hide, { buffer = buf, desc = "Hide p5 console" })
	vim.keymap.set("n", "c", C.clear, { buffer = buf, desc = "Clear p5 console" })

	vim.keymap.set("n", "j", "gj", { buffer = buf, noremap = true, silent = true })
	vim.keymap.set("n", "k", "gk", { buffer = buf, noremap = true, silent = true })
	vim.keymap.set("n", "<Down>", "gj", { buffer = buf, noremap = true, silent = true })
	vim.keymap.set("n", "<Up>", "gk", { buffer = buf, noremap = true, silent = true })
	vim.keymap.set("n", "G", "G", { buffer = buf, noremap = true, silent = true, desc = "Scroll to bottom" })
	vim.keymap.set("n", "gg", "gg", { buffer = buf, noremap = true, silent = true, desc = "Scroll to top" })
	vim.keymap.set("n", "<C-d>", "<C-d>zT", { buffer = buf, noremap = true, silent = true, desc = "Page down" })
	vim.keymap.set("n", "<C-u>", "<C-u>zb", { buffer = buf, noremap = true, silent = true, desc = "Page up" })
	vim.keymap.set("n", "<C-c>", C.hide, { buffer = buf, desc = "Hide console" })

	C.auto_clear()
	notify("Console connected to server on port " .. C.port, "info")
end

C.hide = function()
	if C.win and vim.api.nvim_win_is_valid(C.win) then
		vim.api.nvim_win_close(C.win, true)
		C.win = nil
	end
end

C.toggle = function()
	if C.win and vim.api.nvim_win_is_valid(C.win) then
		C.hide()
	else
		C.show()
	end
end

C.clear = function()
	if C.buf and vim.api.nvim_buf_is_valid(C.buf) and C.job then
		vim.api.nvim_chan_send(C.job, "\027[H\027[2J")
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
				return C.win and vim.api.nvim_win_is_valid(C.win) or false
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

	C.auto_clear()
end

C.auto_clear = function()
	if C.timer then
		C.timer:close()
	end

	C.timer = vim.uv.new_timer()

	if C.timer then
		C.timer:start(
			C.clear_interval,
			C.clear_interval,
			vim.schedule_wrap(function()
				if not C.buf or not vim.api.nvim_buf_is_valid(C.buf) then
					return
				end

				local current_time = os.time()
				if current_time - C.last_error > 30 then
					local line_count = vim.api.nvim_buf_line_count(C.buf)
					if line_count > 100 then
						vim.api.nvim_buf_set_lines(C.buf, 0, line_count - 50, false, {})
					end
				end
			end)
		)
	end
end

C.mark_error = function()
	C.last_error = os.time()
end

return C
