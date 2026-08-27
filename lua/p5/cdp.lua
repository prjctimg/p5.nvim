local C = {}
local core = require("p5.core")
local notify = core.notify

local set_opt = vim.api.nvim_set_option_value
local is_win = vim.api.nvim_win_is_valid
local is_buf = vim.api.nvim_buf_is_valid
local ns = { debug = vim.api.nvim_create_namespace("p5-cdp-debug") }

local function disable_term_mode(buf_)
	vim.cmd("stopinsert")
	for _, k in ipairs({ "<Esc>", "<C-c>", "<C-[>" }) do
		vim.keymap.set("t", k, "<C-\\><C-n>", { buffer = buf_ })
	end
end

C.config = {
	enabled = false,
	remote_debugging_port = 9222,
	browser_flags = {},
	keymaps = true,
	close_browser_on_close = true,
	view = { position = "below", height = 10 },
}

local function check_curl()
	if not core.is_cmd("curl") then
		notify("CDP: curl not found in PATH. Install curl or use wget.", "warn")
		return false
	end
	return true
end

local function http_request(method, url, opts)
	opts = opts or {}
	local cmd = { "curl", "-s", "--max-time", opts.timeout and tostring(opts.timeout) or "10" }
	if method == "POST" or method == "DELETE" then
		table.insert(cmd, "-X")
		table.insert(cmd, method)
	end
	if opts.body then
		table.insert(cmd, "-H")
		table.insert(cmd, "Content-Type: application/json")
		table.insert(cmd, "-d")
		table.insert(cmd, vim.json.encode(opts.body))
	end
	table.insert(cmd, url)
	return vim.fn.jobstart(cmd, {
		on_stdout = opts.on_stdout,
		on_stderr = opts.on_stderr,
		on_exit = opts.on_exit,
	})
end

C.state = {
	buf = nil,
	win = nil,
	job_id = nil,
	active_tab = 1,
	port = nil,
	connected = false,
	page_url = "",
	console_filter = "all",
	search = "",
	mode = nil,
	browser_launched = false,
	chrome_temp_dir = nil,
	sse_buffer = "",
	sse = {
		attempts = 0,
		max_attempts = 5,
		delay = 1000,
	},
	terminal = {
		timer = nil,
		attempts = 0,
		max_attempts = 5,
		delay = 1000,
		last_error = 0,
		clear_interval = 30000,
	},
	info_cursor = 1,
}

C.tab_data = {
	console = {},
	network = {},
	eval = {},
	debugger = { event = "resumed", callFrames = {}, reason = "" },
	perf = {
		fps = {},
		heap = 0,
		heap_total = 0,
		nodes = 0,
		listeners = 0,
		recording = true,
	},
	info = { symbols = {}, canvas_state = "" },
}

local tabs = {
	{ key = 1, name = "Console", data_key = "console" },
	{ key = 2, name = "Network", data_key = "network" },
	{ key = 3, name = "Eval", data_key = "eval" },
	{ key = 4, name = "Debug", data_key = "debugger" },
	{ key = 5, name = "Perf", data_key = "perf" },
	{ key = 6, name = "Info", data_key = "info" },
}

local function launch_browser()
	local chrome_cmd = core.find_chrome()
	if not chrome_cmd then
		notify("CDP: no Chrome/Chromium found in PATH", "warn")
		return
	end
	local server = require("p5.server")
	local url = server.port and string.format("http://localhost:%d", server.port) or nil
	local temp_dir = vim.fn.tempname()
	vim.fn.mkdir(temp_dir, "p")
	C.state.chrome_temp_dir = temp_dir
	local args = {
		chrome_cmd,
		"--remote-debugging-port=" .. C.config.remote_debugging_port,
		"--remote-debugging-address=127.0.0.1",
		"--user-data-dir=" .. temp_dir,
		"--no-first-run",
		"--no-default-browser-check",
	}
	local flags = C.config.browser_flags or {}
	for _, flag in ipairs(flags) do
		table.insert(args, flag)
	end
	if url then
		table.insert(args, url)
	end
	vim.fn.jobstart(args, { detach = true })
	notify("CDP: launched " .. chrome_cmd .. " with remote debugging on port " .. C.config.remote_debugging_port, "info")
end

local function close_browser()
	local temp_dir = C.state.chrome_temp_dir
	C.state.chrome_temp_dir = nil
	if C.config.close_browser_on_close and temp_dir then
		vim.fn.system({ "pkill", "-f", "--", temp_dir })
		vim.fn.delete(temp_dir, "rf")
	end
end

C.connect = function(attempt)
	attempt = attempt or 1
	if not check_curl() then
		return
	end
	if not C.config.enabled then
		C.config.enabled = true
		notify("CDP auto-enabled", "info")
		if not C.state.browser_launched then
			C.state.browser_launched = true
			vim.defer_fn(launch_browser, 300)
		end
	end
	local server = require("p5.server")
	if not (server.server_job and server.port) then
		notify("CDP: start server first with :P5 server", "warn")
		return
	end
	local port = server.port
	local max_attempts = 5
	http_request("POST", string.format("http://localhost:%d/api/cdp/connect", port), {
		timeout = 10,
		on_stdout = function(_, data)
			if not data or #data == 0 then
				return
			end
			local text = table.concat(data, "")
			local ok, result = pcall(vim.json.decode, text)
			vim.schedule(function()
				if ok and type(result) == "table" then
					if result.status == "connected" or result.status == "already_connected" then
						C.state.connected = true
						C.state.page_url = result.url or ""
						C.state.port = port
						notify("CDP connected to " .. (result.url or "browser"), "info")
						vim.defer_fn(C._fetch_canvas_state, 300)
						if C.state.buf and is_buf(C.state.buf) then
							C.render_all()
						end
						return
					elseif attempt < max_attempts then
						local delay = math.min(500 * (2 ^ (attempt - 1)), 8000)
						notify(
							string.format("CDP: connection attempt %d/%d failed, retrying in %dms...", attempt, max_attempts, delay),
							"info"
						)
						vim.defer_fn(function()
							C.connect(attempt + 1)
						end, delay)
					else
						notify("CDP: " .. (result.message or "connection failed") .. " (all attempts exhausted)", "warn")
					end
				elseif attempt < max_attempts then
					local delay = math.min(500 * (2 ^ (attempt - 1)), 8000)
					vim.defer_fn(function()
						C.connect(attempt + 1)
					end, delay)
				else
					notify("CDP: connection request failed (all attempts exhausted)", "warn")
				end
				if C.state.buf and is_buf(C.state.buf) then
					C.render_all()
				end
			end)
		end,
	})
end

C.disconnect = function()
	local port = C.state.port
	if not port then
		return
	end
	if not check_curl() then
		C.state.connected = false
		C.state.page_url = ""
		if C.state.buf and is_buf(C.state.buf) then
			C.render_all()
		end
		return
	end
	http_request("DELETE", string.format("http://localhost:%d/api/cdp/connect", port), {
		timeout = 5,
		on_exit = function()
			vim.schedule(function()
				C.state.connected = false
				C.state.page_url = ""
				notify("CDP disconnected", "info")
				if C.state.buf and is_buf(C.state.buf) then
					C.render_all()
				end
			end)
		end,
	})
end

C.status = function()
	if not C.state.port then
		notify("CDP: not connected", "warn")
		return
	end
	if not check_curl() then
		return
	end
	local port = C.state.port
	http_request("GET", string.format("http://localhost:%d/api/cdp/status", port), {
		timeout = 5,
		on_stdout = function(_, data)
			if not data or #data == 0 then
				return
			end
			local text = table.concat(data, "")
			local ok, result = pcall(vim.json.decode, text)
			vim.schedule(function()
				if ok and type(result) == "table" then
					if result.connected then
						notify("CDP connected to " .. (result.url or "browser"), "info")
					else
						notify("CDP not connected", "warn")
					end
				else
					notify("CDP status unavailable", "warn")
				end
			end)
		end,
	})
end

C.eval = function(expr)
	if not expr then
		vim.ui.input({ prompt = "JS expression: " }, function(input)
			if input and input ~= "" then
				C.eval(input)
			end
		end)
		return
	end
	if not C.state.port then
		notify("CDP: not connected", "warn")
		return
	end
	if not check_curl() then
		return
	end
	local port = C.state.port
	local entry = { expression = expr, status = "pending", result = nil }
	table.insert(C.tab_data.eval, entry)
	if C.state.active_tab == 3 then
		C.render_all()
	end
	http_request("POST", string.format("http://localhost:%d/api/cdp/evaluate", port), {
		timeout = 15,
		body = { expression = expr },
		on_stdout = function(_, data)
			if not data or #data == 0 then
				return
			end
			local text = table.concat(data, "")
			local ok, result = pcall(vim.json.decode, text)
			vim.schedule(function()
				local last = C.tab_data.eval[#C.tab_data.eval]
				if last then
					if ok and type(result) == "table" then
						last.status = "done"
						last.result = result
						if result.exceptionDetails then
							last.status = "error"
						end
					else
						last.status = "error"
						last.result = text
					end
				end
				if C.state.active_tab == 3 then
					C.render_all()
				end
			end)
		end,
		on_exit = function()
			vim.schedule(function()
				local last = C.tab_data.eval[#C.tab_data.eval]
				if last and last.status == "pending" then
					last.status = "error"
					last.result = "request failed (server unavailable?)"
					if C.state.active_tab == 3 then
						C.render_all()
					end
				end
			end)
		end,
	})
end

C.set_breakpoint = function(location)
	if not location then
		vim.ui.input({ prompt = "Breakpoint location (file.js:line): " }, function(input)
			if input and input ~= "" then
				C.set_breakpoint(input)
			end
		end)
		return
	end
	local port = C.state.port
	if not port then
		notify("CDP: not connected", "warn")
		return
	end
	if not check_curl() then
		return
	end
	http_request("POST", string.format("http://localhost:%d/api/cdp/debug/break", port), {
		timeout = 10,
		body = { location = location },
		on_stdout = function(_, data)
			if not data or #data == 0 then
				return
			end
			local text = table.concat(data, "")
			local ok, result = pcall(vim.json.decode, text)
			vim.schedule(function()
				if ok and type(result) == "table" then
					notify("Breakpoint set at " .. location, "info")
					if C.state.buf and is_buf(C.state.buf) then
						C.render_all()
					end
				else
					notify("Failed to set breakpoint: " .. (text or "unknown"), "warn")
				end
			end)
		end,
	})
end

C.pause = function()
	local port = C.state.port
	if not port or not check_curl() then
		return
	end
	http_request("POST", string.format("http://localhost:%d/api/cdp/debug/pause", port), { timeout = 5 })
end

C.pause_exceptions = function(state)
	if not state then
		vim.ui.input({ prompt = "Pause on exceptions (none/uncaught/all): " }, function(input)
			if input and input ~= "" then
				C.pause_exceptions(input)
			end
		end)
		return
	end
	local port = C.state.port
	if not port or not check_curl() then
		return
	end
	http_request("POST", string.format("http://localhost:%d/api/cdp/debug/pauseExceptions", port), {
		timeout = 5,
		body = { state = state },
	})
end

C.reload = function()
	local port = C.state.port
	if not port or not check_curl() then
		return
	end
	http_request("POST", string.format("http://localhost:%d/api/cdp/page/reload", port), { timeout = 5 })
end

C._decode_screenshot = function(b64)
	if type(b64) ~= "string" or b64 == "" then
		return nil
	end
	local ok, raw = pcall(vim.base64.decode, b64)
	if not ok then
		return nil
	end
	return raw
end

C.screenshot = function(path)
	if not path then
		vim.ui.input({ prompt = "Save screenshot to: " }, function(input)
			if input and input ~= "" then
				C.screenshot(input)
			end
		end)
		return
	end
	local port = C.state.port
	if not port or not check_curl() then
		return
	end
	http_request("GET", string.format("http://localhost:%d/api/cdp/page/screenshot", port), {
		timeout = 10,
		on_stdout = function(_, data)
			if not data or #data == 0 then
				return
			end
			local text = table.concat(data, "")
			local ok, result = pcall(vim.json.decode, text)
			vim.schedule(function()
				if ok and type(result) == "table" and result.data then
					local raw = C._decode_screenshot(result.data)
					if raw then
						local f = io.open(path, "wb")
						if f then
							f:write(raw)
							f:close()
							notify("Screenshot saved to " .. path, "info")
						else
							notify("CDP: cannot write " .. path, "warn")
						end
					else
						notify("CDP: screenshot decode failed", "warn")
					end
				else
					notify("CDP: screenshot failed", "warn")
				end
			end)
		end,
	})
end

C._format_canvas_state = function(v)
	if type(v) ~= "table" then
		return nil
	end
	local parts = { "p5 " .. tostring(v.mode or "?") }
	if v.w and v.h then
		table.insert(parts, string.format("canvas %dx%d", v.w, v.h))
	end
	if v.frameRate then
		table.insert(parts, string.format("~%d fps", math.floor(v.frameRate)))
	end
	if v.frameCount then
		table.insert(parts, string.format("frame %d", v.frameCount))
	end
	return table.concat(parts, " | ")
end

C._fetch_canvas_state = function()
	local port = C.state.port
	if not port or not C.state.connected or not check_curl() then
		return
	end
	http_request("POST", string.format("http://localhost:%d/api/cdp/evaluate", port), {
		timeout = 10,
		body = {
			expression = [[(function () {
  var c = document.querySelector('canvas');
  var isP5Global = typeof window.setup === 'function' && typeof window.draw === 'function';
  var fr = null;
  try { if (typeof window.frameRate === 'function') { fr = window.frameRate(); } } catch (e) {}
  var fc = null;
  try { if (typeof window.frameCount === 'number') { fc = window.frameCount; } } catch (e) {}
  return {
    mode: isP5Global ? 'global' : (c ? 'instance' : 'none'),
    w: c ? c.width : null,
    h: c ? c.height : null,
    frameRate: fr,
    frameCount: fc
  };
})()]],
		},
		on_stdout = function(_, data)
			if not data or #data == 0 then
				return
			end
			local text = table.concat(data, "")
			local ok, result = pcall(vim.json.decode, text)
			vim.schedule(function()
				if ok and type(result) == "table" and result.result then
					local fmt = C._format_canvas_state(result.result.value)
					if fmt then
						C.tab_data.info.canvas_state = fmt
						if C.state.active_tab == 6 then
							C.render_all()
						end
					end
				end
			end)
		end,
	})
end

C.clear_network = function()
	local port = C.state.port
	C.tab_data.network = {}
	if C.state.active_tab == 2 then
		C.render_all()
	end
	if port and check_curl() then
		http_request("DELETE", string.format("http://localhost:%d/api/cdp/network", port), { timeout = 5 })
	end
end

C.continue = function()
	local port = C.state.port
	if not port or not check_curl() then
		return
	end
	http_request("POST", string.format("http://localhost:%d/api/cdp/debug/continue", port), { timeout = 5 })
end

C.step = function()
	local port = C.state.port
	if not port or not check_curl() then
		return
	end
	http_request("POST", string.format("http://localhost:%d/api/cdp/debug/step", port), { timeout = 5 })
end

C.step_in = function()
	local port = C.state.port
	if not port or not check_curl() then
		return
	end
	http_request("POST", string.format("http://localhost:%d/api/cdp/debug/stepIn", port), { timeout = 5 })
end

C.step_out = function()
	local port = C.state.port
	if not port or not check_curl() then
		return
	end
	http_request("POST", string.format("http://localhost:%d/api/cdp/debug/stepOut", port), { timeout = 5 })
end

C.switch_tab = function(n)
	if n < 1 or n > #tabs then
		return
	end
	C.state.active_tab = n
	if n == 6 then
		C._fetch_lsp_symbols()
		C._fetch_canvas_state()
	end
	C.render_all()
end

C.toggle = function()
	if C.state.win and is_win(C.state.win) then
		C.close()
	else
		C.open()
	end
end

C.open = function()
	local server = require("p5.server")
	if not (server.server_job and server.port) then
		notify("CDP: start server first with :P5 server", "info")
		return
	end
	if C.state.win and is_win(C.state.win) then
		vim.api.nvim_set_current_win(C.state.win)
		return
	end
	C.state.port = server.port

	if not core.find_chrome() then
		C._open_terminal()
		return
	end

	if not C.config.enabled then
		C.config.enabled = true
		notify("CDP auto-enabled", "info")
	end
	if not C.state.browser_launched then
		C.state.browser_launched = true
		vim.defer_fn(launch_browser, 300)
	end
	C.state.mode = "panel"
	local buf = vim.api.nvim_create_buf(false, true)
	set_opt("filetype", "p5-cdp", { buf = buf })
	set_opt("buftype", "nofile", { buf = buf })
	set_opt("swapfile", false, { buf = buf })
	set_opt("modifiable", true, { buf = buf })

	local pos = C.config.view.position or "below"
	local height = C.config.view.height or math.floor(vim.o.lines * 0.3)
	local split_pattern = core.split_cmd[pos] or core.split_cmd.below
	vim.cmd(split_pattern:format(height))
	local win = vim.api.nvim_get_current_win()
	vim.api.nvim_win_set_buf(win, buf)
	C.state.win = win

	set_opt("number", false, { scope = "local", win = C.state.win })
	set_opt("relativenumber", false, { scope = "local", win = C.state.win })
	set_opt("signcolumn", "no", { scope = "local", win = C.state.win })
	set_opt("wrap", false, { scope = "local", win = C.state.win })
	set_opt("cursorline", true, { scope = "local", win = C.state.win })
	C.state.buf = buf
	if C.config.keymaps ~= false then
		C._set_keymaps(buf)
	end
	C.render_all()
	C._start_sse_job()
	if not C.state.connected then
		vim.defer_fn(function()
			C.connect()
		end, 2000)
	end
	vim.api.nvim_create_autocmd("BufWinLeave", {
		buffer = buf,
		once = true,
		callback = function()
			C.close()
		end,
	})
end

C.close = function()
	if C.state.mode == "panel" then
		C.disconnect()
	end
	if C.state.mode == "terminal" then
		local has_snacks, snacks = pcall(require, "snacks")
		if has_snacks and C.state.buf then
			pcall(snacks.terminal.close, C.state.buf)
		end
	end
	if C.state.job_id then
		vim.fn.jobstop(C.state.job_id)
		C.state.job_id = nil
	end
	if C.state.terminal and C.state.terminal.timer then
		C.state.terminal.timer:close()
		C.state.terminal.timer = nil
	end
	if C.state.win and is_win(C.state.win) then
		pcall(vim.api.nvim_win_close, C.state.win, true)
	end
	C.state.win = nil
	C.state.buf = nil
	C.state.connected = false
	C.state.page_url = ""
	C.state.mode = nil
	C.state.search = ""
	C.state.info_cursor = 1
	C.state.browser_launched = false
	C.state.sse_buffer = ""
	close_browser()
	if C.state.terminal then
		C.state.terminal.attempts = 0
	end
	C.state.sse.attempts = 0
end

C._set_keymaps = function(buf)
	local km = vim.keymap.set
	local tab = function()
		return C.state.active_tab
	end
	km("n", "1", function()
		C.switch_tab(1)
	end, { buffer = buf, desc = "Console tab" })
	km("n", "2", function()
		C.switch_tab(2)
	end, { buffer = buf, desc = "Network tab" })
	km("n", "3", function()
		C.switch_tab(3)
	end, { buffer = buf, desc = "Eval tab" })
	km("n", "4", function()
		C.switch_tab(4)
	end, { buffer = buf, desc = "Debug tab" })
	km("n", "5", function()
		C.switch_tab(5)
	end, { buffer = buf, desc = "Perf tab" })
	km("n", "6", function()
		C.switch_tab(6)
	end, { buffer = buf, desc = "Info tab" })
	km("n", "q", C.close, { buffer = buf, desc = "Close CDP" })
	km("n", "<Esc>", C.close, { buffer = buf, desc = "Close CDP" })
	km("n", "r", function()
		local t = tab()
		if t == 5 then
			C.tab_data.perf.recording = not C.tab_data.perf.recording
		elseif t == 6 then
			C._fetch_lsp_symbols()
		end
		C.render_all()
	end, { buffer = buf, desc = "Refresh / toggle recording" })
	km("n", "c", function()
		local k = tab()
		local keys = { "console", "network", "eval", "debugger", "perf", "info" }
		local dk = keys[k]
		if dk == "debugger" then
			C.tab_data.debugger = { event = "resumed", callFrames = {}, reason = "" }
		elseif dk == "eval" then
			C.tab_data.eval = {}
		elseif dk == "perf" then
			C.tab_data.perf = { fps = {}, heap = 0, heap_total = 0, nodes = 0, listeners = 0, recording = true }
		elseif dk == "info" then
			-- no-op, info is ephemeral
		else
			C.tab_data[dk] = {}
		end
		C.render_all()
	end, { buffer = buf, desc = "Clear current tab" })
	km("n", "<CR>", function()
		local t = tab()
		if t == 3 then
			C.eval()
		end
		if t == 4 then
			vim.ui.input({ prompt = "Breakpoint (file.js:line): " }, function(input)
				if input then
					C.set_breakpoint(input)
				end
			end)
		end
		if t == 6 then
			local s = C.tab_data.info.symbols[C.state.info_cursor or 1]
			if s then
				vim.api.nvim_win_set_cursor(0, { s.lnum, 0 })
				vim.cmd("normal! zz")
			end
		end
	end, { buffer = buf, desc = "Action" })
	km("n", "f", function()
		local t = tab()
		if t == 1 then
			vim.ui.input({ prompt = "Filter (all/error/warn/info/log): " }, function(input)
				if input and input ~= "" then
					C.state.console_filter = input
					C.render_all()
				end
			end)
		end
	end, { buffer = buf, desc = "Filter console level" })
	km("n", "/", function()
		local t = tab()
		if t == 1 or t == 2 then
			vim.ui.input({ prompt = "Search: " }, function(input)
				if input and input ~= "" then
					C.state.search = input
					C.render_all()
				end
			end)
		end
	end, { buffer = buf, desc = "Search" })
	km("n", "b", function()
		if tab() == 4 then
			C.set_breakpoint()
		end
	end, { buffer = buf, desc = "Set breakpoint" })
	km("n", "s", function()
		if tab() == 4 then
			C.step()
		end
	end, { buffer = buf, desc = "Step over" })
	km("n", "i", function()
		if tab() == 4 then
			C.step_in()
		end
	end, { buffer = buf, desc = "Step into" })
	km("n", "o", function()
		if tab() == 4 then
			C.step_out()
		end
	end, { buffer = buf, desc = "Step out" })
	km("n", "x", function()
		if tab() == 4 then
			C.continue()
		end
	end, { buffer = buf, desc = "Continue" })
	km("n", "p", function()
		if tab() == 4 then
			C.pause()
		end
	end, { buffer = buf, desc = "Pause" })
	km("n", "P", function()
		if tab() == 4 then
			C.pause_exceptions()
		end
	end, { buffer = buf, desc = "Pause on exceptions" })
	km("n", "R", function()
		C.reload()
	end, { buffer = buf, desc = "Reload page" })
	km("n", "S", function()
		C.screenshot()
	end, { buffer = buf, desc = "Screenshot" })
	km("n", "D", function()
		if tab() == 2 then
			C.clear_network()
		end
	end, { buffer = buf, desc = "Clear network" })
	km("n", "g", function()
		vim.api.nvim_win_call(C.state.win, function()
			vim.cmd("normal! gg")
		end)
	end, { buffer = buf, desc = "Top" })
	km("n", "G", function()
		vim.api.nvim_win_call(C.state.win, function()
			vim.cmd("normal! G")
		end)
	end, { buffer = buf, desc = "Bottom" })
	km("n", "<LeftMouse>", function()
		local click = vim.fn.getmousepos()
		if click.line == 1 and click.winid == C.state.win then
			local tab_line = vim.api.nvim_buf_get_lines(C.state.buf, 0, 1, false)[1] or ""
			for _, t in ipairs(tabs) do
				local pattern = string.format("%d:%s", t.key, t.name)
				local s, e = tab_line:find(pattern, 1, true)
				if s and click.column >= s and click.column <= e then
					C.switch_tab(t.key)
					return
				end
			end
			local xs, xe = tab_line:find("%[X%]", 1, true)
			if xs and click.column >= xs and click.column <= xe then
				C.close()
			end
		end
	end, { buffer = buf, desc = "Click tab / close" })
	km("n", "K", function()
		if tab() == 6 then
			local s = C.tab_data.info.symbols
			C.state.info_cursor = C.state.info_cursor or 1
			if #s > 0 then
				C.state.info_cursor = math.max(1, C.state.info_cursor - 1)
				C.render_all()
			end
		end
	end, { buffer = buf, desc = "Previous symbol" })
	km("n", "J", function()
		if tab() == 6 then
			local s = C.tab_data.info.symbols
			C.state.info_cursor = C.state.info_cursor or 1
			if #s > 0 then
				C.state.info_cursor = math.min(#s, C.state.info_cursor + 1)
				C.render_all()
			end
		end
	end, { buffer = buf, desc = "Next symbol" })
end

C._start_sse_job = function()
	if C.state.job_id then
		return
	end
	if not check_curl() then
		return
	end
	local url = string.format("http://localhost:%d/api/cdp/stream", C.state.port)
	C.state.job_id = vim.fn.jobstart({ "curl", "-s", "-N", "--max-time", "3600", url }, {
		on_stdout = function(_, data)
			if not data then
				return
			end
			local buf = C.state.sse_buffer or ""
			for _, chunk in ipairs(data) do
				buf = buf .. (chunk or "")
			end
			local lines = vim.split(buf, "\n", { plain = true })
			C.state.sse_buffer = table.remove(lines) or ""
			for _, line in ipairs(lines) do
				if line ~= "" then
					local ok, ev = pcall(vim.json.decode, line)
					if ok then
						vim.schedule(function()
							C._on_event(ev)
						end)
					end
				end
			end
		end,
		on_exit = function()
			vim.schedule(function()
				C.state.job_id = nil
				C.state.sse_buffer = ""
				C._sse_reconnect()
			end)
		end,
	})
	if C.state.job_id > 0 then
		C.state.sse.attempts = 0
	end
end

C._sse_reconnect = function()
	if not C.state.buf or not is_buf(C.state.buf) or not C.state.connected then
		return false
	end
	local s = C.state.sse
	s.attempts = s.attempts + 1
	if s.attempts > s.max_attempts then
		notify("CDP stream reconnection failed: max attempts reached", "warn")
		return false
	end
	local delay = s.delay * (2 ^ (s.attempts - 1))
	notify("CDP stream disconnected, reconnecting...", "info")
	vim.defer_fn(function()
		C._start_sse_job()
	end, delay)
	return true
end

C._on_event = function(data)
	local t = data.type
	if t == "console" then
		local cd = C.tab_data.console
		table.insert(cd, data)
		if #cd > 1000 then
			table.remove(cd, 1)
		end
		if C.state.active_tab == 1 then
			C.render_all()
		end
	elseif t == "network" then
		local nd = C.tab_data.network
		table.insert(nd, data)
		if #nd > 500 then
			table.remove(nd, 1)
		end
		if C.state.active_tab == 2 then
			C.render_all()
		end
	elseif t == "debugger" then
		C.tab_data.debugger = data
		if data.event == "paused" then
			local frames = data.callFrames or {}
			if #frames > 0 then
				C._highlight_paused(frames[1].url, frames[1].line)
			end
		elseif data.event == "resumed" then
			C._clear_debug_highlights()
		end
		if C.state.active_tab == 4 then
			C.render_all()
		end
	elseif t == "perf" then
		local pd = C.tab_data.perf
		if pd.recording then
			if data.fps then
				table.insert(pd.fps, data.fps)
				if #pd.fps > 100 then
					table.remove(pd.fps, 1)
				end
			end
			if data.heap then
				pd.heap = data.heap
			end
			if data.heap_total then
				pd.heap_total = data.heap_total
			end
			if data.nodes then
				pd.nodes = data.nodes
			end
			if data.listeners then
				pd.listeners = data.listeners
			end
		end
		if C.state.active_tab == 5 then
			C.render_all()
		end
	elseif t == "status" then
		local was_connected = C.state.connected
		C.state.connected = (data.state == "connected")
		C.state.page_url = data.url or ""
		if was_connected and not C.state.connected and C.state.buf and is_buf(C.state.buf) then
			if C.state.mode == "panel" then
				notify("CDP disconnected, reconnecting...", "info")
				vim.defer_fn(function()
					if C.state.buf and is_buf(C.state.buf) then
						C.connect()
					end
				end, 1000)
			end
		end
		if C.state.buf and is_buf(C.state.buf) then
			C.render_all()
		end
	end
end

C._highlight_paused = function(url, line)
	C._clear_debug_highlights()
	if not url or not line then
		return
	end
	local project_root = vim.fn.getcwd()
	local path = url:match("^%a+://[^/]+(/.*)$") or url
	if path == url then
		path = "/" .. vim.fn.fnamemodify(url, ":t")
	end
	path = path:gsub("/$", "")
	local abs_path = project_root .. path
	local basename = vim.fn.fnamemodify(url, ":t")
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		local name = vim.api.nvim_buf_get_name(buf)
		if name == abs_path or vim.fn.fnamemodify(name, ":t") == basename then
			pcall(vim.api.nvim_buf_set_extmark, buf, ns.debug, line - 1, 0, {
				sign_text = "●",
				sign_hl_group = "P5CDPDebugSign",
				hl_group = "P5CDPDebugCurrentLine",
				priority = 200,
			})
			local ok, win = pcall(vim.api.nvim_buf_get_var, buf, "p5_sketch_win")
			if ok and win and is_win(win) then
				pcall(vim.api.nvim_set_current_win, win)
			end
			pcall(vim.api.nvim_win_set_cursor, 0, { line, 0 })
			pcall(vim.cmd, "normal! zz")
			return
		end
	end
end

C._clear_debug_highlights = function()
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		pcall(vim.api.nvim_buf_clear_namespace, buf, ns.debug, 0, -1)
	end
end

C._fetch_lsp_symbols = function()
	C.tab_data.info.symbols = {}
	local bufnr
	for _, b in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_get_name(b):match("sketch%.js$") then
			bufnr = b
			break
		end
	end
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	if not bufnr then
		return
	end
	local clients = vim.lsp.get_clients({ bufnr = bufnr })
	if #clients == 0 then
		return
	end
	local ok, result = pcall(vim.lsp.buf_request_sync, bufnr, "textDocument/documentSymbol", {
		textDocument = { uri = vim.uri_from_bufnr(bufnr) },
	}, 1000)
	if not ok or not result then
		return
	end
	for _, res in ipairs(result) do
		if res.result then
			local function flatten(symbols, depth)
				depth = depth or 0
				for _, sym in ipairs(symbols) do
					local kind_name = ({
						"File",
						"Module",
						"Namespace",
						"Package",
						"Class",
						"Method",
						"Property",
						"Field",
						"Constructor",
						"Enum",
						"Interface",
						"Function",
						"Variable",
						"Constant",
						"String",
						"Number",
						"Boolean",
						"Array",
						"Object",
						"Key",
						"Null",
						"EnumMember",
						"Struct",
						"Event",
						"Operator",
						"TypeParameter",
					})[sym.kind] or "Unknown"
					local icon = ({
						Method = "ƒ",
						Function = "ƒ",
						Variable = "◆",
						Constant = "◇",
						Class = "○",
						Property = "●",
						Field = "●",
					})[kind_name] or "·"
					table.insert(C.tab_data.info.symbols, {
						name = sym.name,
						kind = kind_name,
						icon = icon,
						depth = depth,
						lnum = (sym.range or {}).start and sym.range.start.line + 1 or 0,
					})
					if sym.children then
						flatten(sym.children, depth + 1)
					end
				end
			end
			if type(res.result) == "table" then
				flatten(res.result)
			end
		end
	end
end

C.render_all = function()
	local buf = C.state.buf
	if not buf or not is_buf(buf) then
		return
	end
	local win = C.state.win
	if not win or not is_win(win) then
		return
	end
	local lines = {}
	table.insert(lines, C._render_tab_bar())
	table.insert(lines, string.rep("─", vim.api.nvim_win_get_width(win)))
	local content = C._render_tab_content()
	for _, l in ipairs(content) do
		table.insert(lines, l)
	end
	set_opt("modifiable", true, { buf = buf })
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	set_opt("modifiable", false, { buf = buf })
	C._apply_highlights()
end

C._render_tab_bar = function()
	local parts = {}
	local counts =
		{ #C.tab_data.console, #C.tab_data.network, #C.tab_data.eval, 0, #C.tab_data.perf.fps, #C.tab_data.info.symbols }
	for i, tab in ipairs(tabs) do
		if i > 1 then
			table.insert(parts, "│")
		end
		local label = string.format("%s:%s", tab.key, tab.name)
		if counts[i] > 0 then
			label = label .. "(" .. counts[i] .. ")"
		end
		if i == C.state.active_tab then
			label = "▎" .. label
		else
			label = " " .. label
		end
		table.insert(parts, label)
	end
	table.insert(parts, "  [X]")
	local dot
	if C.state.connected then
		dot = { "●", "P5CDPConnected" }
	else
		dot = { "●", "P5CDPDisconnected" }
	end
	table.insert(parts, "  " .. dot[1])
	return table.concat(parts, " ")
end

C._apply_highlights = function()
	local buf = C.state.buf
	if not buf or not is_buf(buf) then
		return
	end
	vim.api.nvim_buf_clear_namespace(buf, -1, 0, -1)
	local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
	local tab_line = lines[1] or ""
	for _, tab in ipairs(tabs) do
		local pattern = string.format("▎%d:%s", tab.key, tab.name)
		local start_idx = tab_line:find(pattern, 1, true)
		if start_idx then
			vim.api.nvim_buf_add_highlight(buf, -1, "P5CDPActiveTab", 0, start_idx - 1, start_idx - 1 + #pattern)
		else
			local raw = string.format(" %d:%s", tab.key, tab.name)
			local raw_start = tab_line:find(raw, 1, true)
			if raw_start then
				vim.api.nvim_buf_add_highlight(buf, -1, "P5CDPTab", 0, raw_start - 1, raw_start - 1 + #raw)
			end
		end
	end
	local close_start = tab_line:find("[X]", 1, true)
	if close_start then
		vim.api.nvim_buf_add_highlight(buf, -1, "P5CDPClose", 0, close_start - 1, close_start + 2)
	end
	local connected_dot = tab_line:find("●", 1, true)
	if connected_dot then
		local hl = C.state.connected and "P5CDPConnected" or "P5CDPDisconnected"
		vim.api.nvim_buf_add_highlight(buf, -1, hl, 0, connected_dot - 1, connected_dot)
	end
	local k = C.state.active_tab
	for ln = 3, #lines do
		local l = lines[ln] or ""
		if k == 1 then
			local level = l:match("%[%d+:%d+:%d+%]%s+(%w+)")
			if level == "ERROR" then
				vim.api.nvim_buf_add_highlight(buf, -1, "P5CDPConsoleError", ln - 1, 0, -1)
			elseif level == "WARN" then
				vim.api.nvim_buf_add_highlight(buf, -1, "P5CDPConsoleWarn", ln - 1, 0, -1)
			elseif level == "INFO" then
				vim.api.nvim_buf_add_highlight(buf, -1, "P5CDPConsoleInfo", ln - 1, 0, -1)
			elseif level == "LOG" then
				vim.api.nvim_buf_add_highlight(buf, -1, "P5CDPConsoleLog", ln - 1, 0, -1)
			end
		elseif k == 2 then
			local status = l:match("^%s+(%d+)")
			if status then
				local first = status:sub(1, 1)
				local hl = ({
					["2"] = "P5CDPNetwork2xx",
					["3"] = "P5CDPNetwork3xx",
					["4"] = "P5CDPNetwork4xx",
					["5"] = "P5CDPNetwork5xx",
				})[first]
				if hl then
					local _, s = l:find("^%s+%S+%s+")
					if s then
						vim.api.nvim_buf_add_highlight(buf, -1, hl, ln - 1, s, s + #status)
					end
				end
			end
		elseif k == 3 then
			if l:match("^%s+←") then
				vim.api.nvim_buf_add_highlight(buf, -1, "P5CDPEvalSuccess", ln - 1, 0, -1)
			elseif l:match("^%s+Error:") then
				vim.api.nvim_buf_add_highlight(buf, -1, "P5CDPEvalError", ln - 1, 0, -1)
			end
		elseif k == 5 then
			if l:match("^ FPS:") then
				vim.api.nvim_buf_add_highlight(buf, -1, "P5CDPPerfFPS", ln - 1, 0, -1)
			elseif l:match("^ JS Heap:") then
				vim.api.nvim_buf_add_highlight(buf, -1, "P5CDPPerfMem", ln - 1, 0, -1)
			end
		elseif k == 6 then
			if l:match("^ [▎ ] [○·●◇◆ƒ]") then
				vim.api.nvim_buf_add_highlight(buf, -1, "P5CDPInfoSymbol", ln - 1, 0, -1)
			elseif l:match("^ [^▎ ]") and not l:match("^  ") then
				vim.api.nvim_buf_add_highlight(buf, -1, "P5CDPInfoLabel", ln - 1, 0, -1)
			end
		end
	end
end

C._render_tab_content = function()
	local k = C.state.active_tab
	if k == 1 then
		return C._render_console()
	end
	if k == 2 then
		return C._render_network()
	end
	if k == 3 then
		return C._render_eval()
	end
	if k == 4 then
		return C._render_debugger()
	end
	if k == 5 then
		return C._render_performance()
	end
	if k == 6 then
		return C._render_info()
	end
	return { "" }
end

C._render_console = function()
	local data = C.tab_data.console
	local filter = C.state.console_filter or "all"
	local search = C.state.search or ""
	if #data == 0 then
		return { " No console output yet" }
	end
	local lines = {}
	for _, entry in ipairs(data) do
		if filter ~= "all" and entry.level ~= filter then
			goto continue
		end
		local ts = entry.timestamp or ""
		local lvl = (entry.level or "log"):upper():sub(1, 5)
		local msg = entry.message or ""
		if search ~= "" and not msg:lower():find(search:lower(), 1, true) then
			goto continue
		end
		local line = string.format(" [%s] %s %s", ts, lvl, msg)
		table.insert(lines, line)
		if entry.stack and #entry.stack > 0 then
			for _, frame in ipairs(entry.stack) do
				local floc = string.format("   at %s (%s:%d:%d)", frame["function"], frame.url, frame.line, frame.column)
				table.insert(lines, floc)
			end
		end
		::continue::
	end
	if #lines == 0 then
		table.insert(lines, ' (no matches for filter "' .. filter .. '")')
	end
	return lines
end

C._render_network = function()
	local data = C.tab_data.network
	if #data == 0 then
		return { " No network requests yet" }
	end
	local lines = {}
	table.insert(lines, " Method  Status  Duration  URL")
	table.insert(lines, " ──────  ──────  ────────  ───")
	for _, entry in ipairs(data) do
		local method = entry.method or "GET"
		local status = entry.error and "FAIL" or (entry.status and tostring(entry.status) or "?")
		local dur = entry.duration ~= nil and string.format("%.1fms", entry.duration) or "?"
		local url = entry.url or ""
		local label = string.format(" %-6s  %-6s  %-8s  %s", method, status, dur, url)
		table.insert(lines, label)
		if entry.error then
			table.insert(lines, "   Error: " .. entry.error)
		end
	end
	return lines
end

C._render_eval = function()
	local data = C.tab_data.eval
	local lines = {}
	table.insert(lines, " Evaluate JavaScript expressions")
	table.insert(lines, " Press <CR> or type :P5 cdp eval <expr>")
	table.insert(lines, " " .. string.rep("─", 30))
	if #data > 0 then
		for _, entry in ipairs(data) do
			table.insert(lines, string.format(" > %s", entry.expression))
			if entry.status == "pending" then
				table.insert(lines, "   Evaluating...")
			elseif entry.status == "done" then
				local r = entry.result
				if r and r.exceptionDetails then
					local ed = r.exceptionDetails
					local text = ed.text or "Error"
					local ln = (ed.lineNumber or 0) + 1
					table.insert(lines, string.format("   Error: %s (line %d)", text, ln))
				elseif r and r.result then
					local rtype = r.result.type or "undefined"
					local rval = r.result.value
					if rval ~= nil then
						table.insert(lines, string.format("   ← %s", tostring(rval)))
					elseif rtype == "undefined" then
						table.insert(lines, "   ← undefined")
					elseif r.result.description then
						table.insert(lines, string.format("   ← %s", r.result.description))
					else
						table.insert(lines, string.format("   ← [%s]", rtype))
					end
				else
					table.insert(lines, "   ← (no result)")
				end
			else
				table.insert(lines, string.format("   Error: %s", vim.inspect(entry.result)))
			end
		end
	end
	return lines
end

C._render_debugger = function()
	local d = C.tab_data.debugger
	local lines = {}
	if d.event == "paused" then
		table.insert(lines, " Status: ⏸ PAUSED")
		if d.reason and d.reason ~= "" then
			table.insert(lines, string.format(" Reason: %s", d.reason))
		end
		table.insert(lines, "")
		table.insert(lines, " Call Stack:")
		if d.callFrames and #d.callFrames > 0 then
			for i, f in ipairs(d.callFrames) do
				local fline = string.format("   #%d  %s  %s:%d:%d", i, f["function"], f.url, f.line, f.column)
				table.insert(lines, fline)
			end
		else
			table.insert(lines, "   (no frames)")
		end
	else
		table.insert(lines, " Status: ▶ Running")
	end
	table.insert(lines, "")
	table.insert(lines, " Keymaps:")
	table.insert(lines, "   <CR>  set breakpoint")
	table.insert(lines, "   p     pause")
	table.insert(lines, "   P     pause on exceptions")
	table.insert(lines, "   s     step over")
	table.insert(lines, "   i     step into")
	table.insert(lines, "   o     step out")
	table.insert(lines, "   x     continue")
	table.insert(lines, "   c     clear tab")
	table.insert(lines, "   R     reload page")
	table.insert(lines, "   S     screenshot")
	return lines
end

C._render_performance = function()
	local pd = C.tab_data.perf
	local lines = {}
	local rec = pd.recording
	table.insert(lines, string.format(" Recording: %s", rec and "● ON" or "○ OFF"))
	table.insert(lines, string.rep("─", 30))
	local fps = pd.fps
	local avg1 = 0
	local avg10 = 0
	local latest = fps[#fps] or 0
	if #fps > 0 then
		local sum1, sum10 = 0, 0
		local n1 = math.min(#fps, 1)
		local n10 = math.min(#fps, 10)
		for i = #fps - n1 + 1, #fps do
			if i >= 1 then
				sum1 = sum1 + fps[i]
			end
		end
		for i = #fps - n10 + 1, #fps do
			if i >= 1 then
				sum10 = sum10 + fps[i]
			end
		end
		avg1 = n1 > 0 and math.floor(sum1 / n1) or 0
		avg10 = n10 > 0 and math.floor(sum10 / n10) or 0
	end
	table.insert(lines, string.format(" FPS:      %d (1s: %d | 10s: %d)", latest, avg1, avg10))
	local spark = {}
	local bars = { "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█" }
	local window = 20
	local recent = {}
	for i = math.max(1, #fps - window + 1), #fps do
		table.insert(recent, fps[i])
	end
	local max_fps = 60
	for _, v in ipairs(recent) do
		local idx = math.min(math.floor((v / max_fps) * #bars) + 1, #bars)
		table.insert(spark, bars[idx])
	end
	if #spark > 0 then
		table.insert(lines, " FPS trend: " .. table.concat(spark, ""))
	end
	table.insert(lines, "")
	table.insert(lines, string.format(" JS Heap:  %.1f / %.1f MB", pd.heap / 1048576, pd.heap_total / 1048576))
	table.insert(lines, string.format(" DOM nodes: %d", pd.nodes))
	table.insert(lines, string.format(" Listeners: %d", pd.listeners))
	table.insert(lines, "")
	table.insert(lines, " Keymaps:")
	table.insert(lines, "   r     toggle recording")
	table.insert(lines, "   c     clear metrics")
	return lines
end

C._render_info = function()
	local info = C.tab_data.info
	local lines = {}
	table.insert(lines, " Project")
	table.insert(lines, string.rep(" ─", 15))
	local pconfig = core.read_workspace_config()
	if pconfig then
		table.insert(lines, string.format("   p5.js v%s", pconfig.version or "?"))
		local libs = pconfig.libs and vim.tbl_keys(pconfig.libs) or {}
		if #libs > 0 then
			table.insert(lines, "   Libraries: " .. table.concat(libs, ", "))
		end
	end
	table.insert(lines, "")
	table.insert(lines, " Canvas")
	table.insert(lines, string.rep(" ─", 15))
	table.insert(lines, "   " .. (info.canvas_state ~= "" and info.canvas_state or "(evaluate to populate)"))
	table.insert(lines, "")
	table.insert(lines, " Symbols (" .. vim.fn.expand("%:t") .. ")")
	table.insert(lines, string.rep(" ─", 15))
	local symbols = info.symbols
	if #symbols == 0 then
		table.insert(lines, "   (no LSP data — press r to refresh)")
	else
		local cursor = C.state.info_cursor or 1
		for i, sym in ipairs(symbols) do
			local indent = string.rep("  ", sym.depth)
			local marker = (i == cursor) and "▎" or " "
			table.insert(lines, string.format(" %s%s%s %s", marker, indent, sym.icon, sym.name))
		end
	end
	table.insert(lines, "")
	table.insert(lines, " Keymaps:")
	table.insert(lines, "   <CR>  jump to symbol")
	table.insert(lines, "   K/J   navigate symbols")
	table.insert(lines, "   r     refresh")
	return lines
end

C._open_terminal = function(reconnecting)
	local has_snacks, snacks = pcall(require, "snacks")
	C.state.mode = "terminal"
	local t = C.state.terminal
	t.connected = false
	if not reconnecting then
		t.attempts = 0
	end

	local url = string.format("http://localhost:%d/api/console/stream", C.state.port)
	local pos = C.config.view.position or "below"
	local height = C.config.view.height or math.floor(vim.o.lines * 0.3)
	local split_cmd = core.split_cmd[pos] or core.split_cmd.below

	if has_snacks then
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
		C.state.win = term.win
		C.state.buf = term.buf
		disable_term_mode(C.state.buf)
		C._terminal_auto_clear()
		return
	end

	-- Manual terminal fallback (no snacks)
	vim.cmd(split_cmd:format(height))
	local win = vim.api.nvim_get_current_win()
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_win_set_buf(win, buf)
	vim.api.nvim_set_current_win(win)

	set_opt("filetype", "log", { buf = buf })
	set_opt("scrollback", 1000, { buf = buf })

	C.state.job_id = vim.fn.termopen({ "curl", "-s", "-N", url }, {
		on_exit = function(_, exit_code, _)
			vim.schedule(function()
				C.state.job_id = nil
				if exit_code ~= 0 and C.state.mode == "terminal" then
					t.last_error = os.time()
					notify("Console connection lost", "warn")
					C._terminal_reconnect()
				end
			end)
		end,
	})

	C.state.win = win
	C.state.buf = buf

	set_opt("wrap", true, { scope = "local", win = win })
	set_opt("number", false, { scope = "local", win = win })
	set_opt("relativenumber", false, { scope = "local", win = win })
	set_opt("signcolumn", "no", { scope = "local", win = win })

	local km = vim.keymap.set
	km("n", "q", C.close, { buffer = buf, desc = "Hide console" })
	km("n", "c", C._terminal_clear, { buffer = buf, desc = "Clear console" })
	km("n", "<C-c>", C.close, { buffer = buf, desc = "Hide console" })
	disable_term_mode(buf)
	C._terminal_auto_clear()
end

C._terminal_reconnect = function()
	local t = C.state.terminal
	if not C.state.buf then
		return
	end
	if t.attempts >= t.max_attempts then
		notify("Console reconnection failed: max attempts reached", "warn")
		return
	end
	local delay = t.delay * (2 ^ t.attempts)
	t.attempts = t.attempts + 1
	vim.defer_fn(function()
		if C.state.win and is_win(C.state.win) and C.state.mode == "terminal" then
			notify(string.format("Reconnecting to console (attempt %d)...", t.attempts), "info")
			C._open_terminal(true)
		end
	end, delay)
end

C._terminal_auto_clear = function()
	local t = C.state.terminal
	if t.timer then
		t.timer:close()
	end
	t.timer = vim.uv.new_timer()
	if t.timer then
		t.timer:start(t.clear_interval, t.clear_interval, function()
			vim.schedule(function()
				if not C.state.buf or not is_buf(C.state.buf) or C.state.mode ~= "terminal" then
					return
				end
				local now = os.time()
				if now - t.last_error > 30 then
					local lc = vim.api.nvim_buf_line_count(C.state.buf)
					if lc > 100 then
						pcall(vim.api.nvim_buf_set_lines, C.state.buf, 0, lc - 50, false, {})
					end
				end
			end)
		end)
	end
end

C._terminal_clear = function()
	if C.state.buf and is_buf(C.state.buf) and C.state.job_id then
		vim.api.nvim_chan_send(C.state.job_id, "\027[H\027[2J")
	end
end

return C
