-- Browser console integration for p5.nvim with SSE streaming
local C = {}
local core = require("p5.core")
local project = require("p5.project")

local notify = core.notify
local is_win = vim.api.nvim_win_is_valid
local set_opt = vim.api.nvim_set_option_value
-- Use snacks.terminal if available
local has_snacks, snacks = pcall(require, "snacks")

local disable_term_mode = function(buf_)
	vim.cmd("stopinsert")
	for _, k in ipairs({ "<Esc>", "<C-c>", "<C-[>" }) do
		vim.keymap.set("t", k, "<C-\\><C-n>", { buffer = buf_ })
	end
end

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
local connected = false

C.create = function()
	local server = require("p5.server")
	if C.win and is_win(C.win) then
		return C.win
	end

	if not (server.server_job and server.port) then
		notify("Console requires a running server first", "info")
		return nil
	end

	C.port = server.port
	C.attempts = 0

	local cmd = string.format('curl -s -N "http://localhost:%d/api/console/stream" 2>/dev/null', C.port)

	C.buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_name(C.buf, "p5-console-terminal")
	set_opt("filetype", "log", { buf = C.buf })
	set_opt("modifiable", true, { buf = C.buf })
	set_opt("scrollback", 1000, { buf = C.buf })

	connected = false

	C.job = vim.fn.jobstart(cmd, {
		term = true,
		on_stdout = function(_, data)
			if data and #data > 0 then
				-- Check for errors in the logs
				for _, line in ipairs(data) do
					if line:match("error") or line:match("Error") or line:match("❌") then
						C.mark_error()
					end
				end

				if not connected then
					for _, line in ipairs(data) do
						if line:match("\027%[%d") then
							connected = true
							C.attempts = 0
							notify("Console connected to browser", "info")
							break
						end
					end
				end
			end
		end,
		on_exit = function(_, exit_code)
			connected = false
			if exit_code ~= 0 and C.win and vim.api.nvim_win_is_valid(C.win) then
				vim.schedule(function()
					if connected then
						notify("🔌 Console disconnected from browser", "info")
						C.reconnect()
					else
						notify("☹️ Console connection failed", "warn")
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
		notify(" ☹️ Console reconnection failed: max attempts reached", "warn")
		return
	end

	local delay = C.delay * (2 ^ C.attempts)
	C.attempts = C.attempts + 1

	vim.defer_fn(function()
		if C.win and is_win(C.win) then
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
		notify("📺 Console only works in p5.js projects", "warn")
		return
	end

	if not server.server_job then
		notify("📺 Start server first with :P5 server", "info")
		return
	end

	if C.win and is_win(C.win) then
		if enter then
			vim.api.nvim_set_current_win(C.win)
		end
		return
	end

	local pos = C.config.console.position or "below"
	local viewport_height = vim.o.lines
	local height = math.floor(viewport_height * 0.3)
	C.port = server.port

	-- Reset state since window was closed externally
	C.win = nil
	C.buf = nil

	if has_snacks then
		local url = string.format("http://localhost:%d/api/console/stream", C.port)
		local term = snacks.terminal({ "curl", "-s", "-N", url }, {
			win = {
				title = "p5-console",
				---@diagnostic disable-next-line: assign-type-mismatch
				position = pos == "below" and "bottom" or pos,
				size = height,
			},
			auto_close = false,
			scrollback = 1000,
			interactive = false,
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
		disable_term_mode(C.buf)
		notify("📺 Console connected to server on port " .. C.port, "info")
		return
	end

	-- Fallback to manual terminal creation
	local buf = C.create()
	if not buf then
		return
	end

	local split_pattern = core.split_cmd[pos] or core.split_cmd.below
	local split_cmd = split_pattern:format(height)

	vim.cmd(split_cmd)
	C.win = vim.api.nvim_get_current_win()
	vim.api.nvim_win_set_buf(C.win, buf)

	set_opt("wrap", true, { scope = "local", win = C.win })
	set_opt("number", false, { scope = "local", win = C.win })
	set_opt("relativenumber", false, { scope = "local", win = C.win })
	set_opt("signcolumn", "no", { scope = "local", win = C.win })
	local keymap = vim.keymap.set
	keymap("n", "q", C.hide, { buffer = buf, desc = "Hide p5 console" })
	keymap("n", "c", C.clear, { buffer = buf, desc = "Clear p5 console" })
	keymap("n", "<C-c>", C.hide, { buffer = buf, desc = "Hide console" })
	disable_term_mode(buf)

	C.auto_clear()
	notify("Console connected to server on port " .. C.port, "info")
end

C.hide = function()
	if C.win and is_win(C.win) then
		vim.api.nvim_win_close(C.win, true)
	end
	if C.job then
		vim.fn.jobstop(C.job)
	end
	if C.term then
		C.term:close()
	end
	C.win = nil
	C.buf = nil
	C.job = nil
	C.term = nil
end

C.toggle = function()
	if C.win and is_win(C.win) then
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

C.auto_clear = function()
	if C.timer then
		C.timer:close()
	end

	C.timer = vim.uv.new_timer()

	if C.timer then
		C.timer:start(C.clear_interval, C.clear_interval, function()
			vim.schedule(function()
				if not C.buf or not vim.api.nvim_buf_is_valid(C.buf) then
					return
				end

				local now = os.time()
				if now - C.last_error > 30 then
					local line_count = vim.api.nvim_buf_line_count(C.buf)
					if line_count > 100 then
						vim.api.nvim_buf_set_lines(C.buf, 0, line_count - 50, false, {})
					end
				end
			end)
		end)
	end
end

C.mark_error = function()
	C.last_error = os.time()
end

return C
