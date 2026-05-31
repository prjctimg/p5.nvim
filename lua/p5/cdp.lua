local C = {}
local core = require("p5.core")
local project = require("p5.project")
local notify = core.notify

local set_opt = vim.api.nvim_set_option_value
local is_win = vim.api.nvim_win_is_valid
local is_buf = vim.api.nvim_buf_is_valid

C.config = {
	cdp = { enabled = false, remote_debugging_port = 9222 },
	view = { position = "below", height = 10 },
}

C.state = {
	buf = nil,
	win = nil,
	job_id = nil,
	active_tab = 1,
	port = nil,
	connected = false,
	page_url = "",
}

C.tab_data = {
	console = {},
	network = {},
	eval = {},
	debugger = { event = "resumed", callFrames = {}, reason = "" },
}

local tabs = {
	{ key = 1, name = "Console", data_key = "console" },
	{ key = 2, name = "Network", data_key = "network" },
	{ key = 3, name = "Evaluate", data_key = "eval" },
	{ key = 4, name = "Debugger", data_key = "debugger" },
}

C.connect = function()
	local server = require("p5.server")
	if not (server.server_job and server.port) then
		notify("CDP: start server first with :P5 server", "warn")
		return
	end
	local port = server.port
	vim.fn.jobstart({
		"curl", "-s", "-X", "POST",
		string.format("http://localhost:%d/api/cdp/connect", port),
	}, {
		on_stdout = function(_, data)
			if not data or #data == 0 then return end
			local text = table.concat(data, "")
			local ok, result = pcall(vim.json.decode, text)
			vim.schedule(function()
				if ok then
					if result.status == "connected" or result.status == "already_connected" then
						C.state.connected = true
						C.state.page_url = result.url or ""
						C.state.port = port
						notify("CDP connected to " .. (result.url or "browser"), "info")
					else
						notify("CDP: " .. (result.message or "connection failed"), "warn")
					end
				else
					notify("CDP: connection request failed", "warn")
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
	if not port then return end
	vim.fn.jobstart({
		"curl", "-s", "-X", "DELETE",
		string.format("http://localhost:%d/api/cdp/connect", port),
	}, {
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
	local port = C.state.port or (require("p5.server").port)
	if not port then
		notify("CDP: server not running", "warn")
		return
	end
	vim.fn.jobstart({
		"curl", "-s", string.format("http://localhost:%d/api/cdp/status", port),
	}, {
		on_stdout = function(_, data)
			if not data or #data == 0 then return end
			local text = table.concat(data, "")
			local ok, result = pcall(vim.json.decode, text)
			vim.schedule(function()
				if ok then
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
	local port = C.state.port or (require("p5.server").port)
	if not port then
		notify("CDP: server not running", "warn")
		return
	end
	local entry = { expression = expr, status = "pending", result = nil }
	table.insert(C.tab_data.eval, entry)
	if C.state.active_tab == 3 then C.render_all() end
	vim.fn.jobstart({
		"curl", "-s", "-X", "POST",
		"-H", "Content-Type: application/json",
		"-d", vim.json.encode({ expression = expr }),
		string.format("http://localhost:%d/api/cdp/evaluate", port),
	}, {
		on_stdout = function(_, data)
			if not data or #data == 0 then return end
			local text = table.concat(data, "")
			local ok, result = pcall(vim.json.decode, text)
			vim.schedule(function()
				local last = C.tab_data.eval[#C.tab_data.eval]
				if last then
					if ok then
						last.status = "done"
						last.result = result
						if result and result.exceptionDetails then
							last.status = "error"
						end
					else
						last.status = "error"
						last.result = text
					end
				end
				if C.state.active_tab == 3 then C.render_all() end
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
	if not port then notify("CDP: not connected", "warn") return end
	vim.fn.jobstart({
		"curl", "-s", "-X", "POST",
		"-H", "Content-Type: application/json",
		"-d", vim.json.encode({ location = location }),
		string.format("http://localhost:%d/api/cdp/debug/break", port),
	}, {
		on_stdout = function(_, data)
			if not data or #data == 0 then return end
			local text = table.concat(data, "")
			local ok, result = pcall(vim.json.decode, text)
			vim.schedule(function()
				if ok then
					notify("Breakpoint set at " .. location, "info")
					if C.state.buf and is_buf(C.state.buf) then C.render_all() end
				else
					notify("Failed to set breakpoint: " .. (text or "unknown"), "warn")
				end
			end)
		end,
	})
end

C.continue = function()
	local port = C.state.port
	if not port then return end
	vim.fn.jobstart({
		"curl", "-s", "-X", "POST",
		string.format("http://localhost:%d/api/cdp/debug/continue", port),
	})
end

C.step = function()
	local port = C.state.port
	if not port then return end
	vim.fn.jobstart({
		"curl", "-s", "-X", "POST",
		string.format("http://localhost:%d/api/cdp/debug/step", port),
	})
end

C.step_in = function()
	local port = C.state.port
	if not port then return end
	vim.fn.jobstart({
		"curl", "-s", "-X", "POST",
		string.format("http://localhost:%d/api/cdp/debug/stepIn", port),
	})
end

C.step_out = function()
	local port = C.state.port
	if not port then return end
	vim.fn.jobstart({
		"curl", "-s", "-X", "POST",
		string.format("http://localhost:%d/api/cdp/debug/stepOut", port),
	})
end

C.switch_tab = function(n)
	if n < 1 or n > #tabs then return end
	C.state.active_tab = n
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
	C.state.port = server.port
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
	C._set_keymaps(buf)
	C.render_all()
	C._start_sse_job()
	if not C.state.connected then
		C.connect()
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
	if C.state.job_id then
		vim.fn.jobstop(C.state.job_id)
		C.state.job_id = nil
	end
	if C.state.win and is_win(C.state.win) then
		vim.api.nvim_win_close(C.state.win, true)
	end
	C.state.win = nil
	C.state.buf = nil
end

C._set_keymaps = function(buf)
	local km = vim.keymap.set
	km("n", "1", function() C.switch_tab(1) end, { buffer = buf, desc = "Console tab" })
	km("n", "2", function() C.switch_tab(2) end, { buffer = buf, desc = "Network tab" })
	km("n", "3", function() C.switch_tab(3) end, { buffer = buf, desc = "Evaluate tab" })
	km("n", "4", function() C.switch_tab(4) end, { buffer = buf, desc = "Debugger tab" })
	km("n", "q", C.close, { buffer = buf, desc = "Close CDP" })
	km("n", "<Esc>", C.close, { buffer = buf, desc = "Close CDP" })
	km("n", "r", function() C.render_all() end, { buffer = buf, desc = "Refresh tab" })
	km("n", "c", function()
		local k = C.state.active_tab
		local keys = { "console", "network", "eval", "debugger" }
		local dk = keys[k]
		if dk == "debugger" then
			C.tab_data.debugger = { event = "resumed", callFrames = {}, reason = "" }
		elseif dk == "eval" then
			C.tab_data.eval = {}
		else
			C.tab_data[dk] = {}
		end
		C.render_all()
	end, { buffer = buf, desc = "Clear current tab" })
	km("n", "<CR>", function()
		if C.state.active_tab == 3 then C.eval() end
		if C.state.active_tab == 4 then
			vim.ui.input({ prompt = "Breakpoint (file.js:line): " }, function(input)
				if input then C.set_breakpoint(input) end
			end)
		end
	end, { buffer = buf, desc = "Action" })
	km("n", "b", function()
		if C.state.active_tab == 4 then
			C.set_breakpoint()
		end
	end, { buffer = buf, desc = "Set breakpoint" })
	km("n", "s", function()
		if C.state.active_tab == 4 then C.step() end
	end, { buffer = buf, desc = "Step over" })
	km("n", "i", function()
		if C.state.active_tab == 4 then C.step_in() end
	end, { buffer = buf, desc = "Step into" })
	km("n", "o", function()
		if C.state.active_tab == 4 then C.step_out() end
	end, { buffer = buf, desc = "Step out" })
	km("n", "x", function()
		if C.state.active_tab == 4 then C.continue() end
	end, { buffer = buf, desc = "Continue" })
	km("n", "D", function()
		if C.state.active_tab == 2 then
			C.tab_data.network = {}
			C.render_all()
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
end

C._start_sse_job = function()
	if C.state.job_id then return end
	local url = string.format("http://localhost:%d/api/cdp/stream", C.state.port)
	C.state.job_id = vim.fn.jobstart({ "curl", "-s", "-N", url }, {
		on_stdout = function(_, data)
			if not data then return end
			for _, line in ipairs(data) do
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
			end)
		end,
	})
end

C._on_event = function(data)
	local t = data.type
	if t == "console" then
		local cd = C.tab_data.console
		table.insert(cd, data)
		if #cd > 1000 then table.remove(cd, 1) end
		if C.state.active_tab == 1 then C.render_all() end
	elseif t == "network" then
		local nd = C.tab_data.network
		table.insert(nd, data)
		if #nd > 500 then table.remove(nd, 1) end
		if C.state.active_tab == 2 then C.render_all() end
	elseif t == "debugger" then
		C.tab_data.debugger = data
		if C.state.active_tab == 4 then C.render_all() end
	elseif t == "status" then
		C.state.connected = (data.state == "connected")
		C.state.page_url = data.url or ""
		if C.state.buf and is_buf(C.state.buf) then
			C.render_all()
		end
	end
end

C.render_all = function()
	local buf = C.state.buf
	if not buf or not is_buf(buf) then return end
	local win = C.state.win
	if not win or not is_win(win) then return end
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
	table.insert(parts, " ")
	for i, tab in ipairs(tabs) do
		local label = string.format("[%d:%s]", tab.key, tab.name)
		if i == C.state.active_tab then
			label = ">" .. label .. "<"
		end
		table.insert(parts, label)
		table.insert(parts, " ")
	end
	table.insert(parts, "[X]")
	if not C.state.connected then
		table.insert(parts, " (disconnected)")
	end
	return table.concat(parts, "")
end

C._apply_highlights = function()
	local buf = C.state.buf
	if not buf or not is_buf(buf) then return end
	vim.api.nvim_buf_clear_namespace(buf, -1, 0, -1)
	local tab_line = vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1] or ""
	for i, tab in ipairs(tabs) do
		local pattern = string.format(">%d:%s<", tab.key, tab.name)
		local start_idx = tab_line:find(pattern, 1, true)
		if start_idx and i == C.state.active_tab then
			vim.api.nvim_buf_add_highlight(buf, -1, "P5CDPActiveTab", 0, start_idx - 1, start_idx - 1 + #pattern)
		elseif start_idx then
			local raw = string.format("[%d:%s]", tab.key, tab.name)
			local raw_start = tab_line:find(raw, 1, true)
			if raw_start then
				vim.api.nvim_buf_add_highlight(buf, -1, "P5CDPTab", 0, raw_start - 1, raw_start - 1 + #raw)
			end
		end
	end
	local disconnected_start = tab_line:find("(disconnected)", 1, true)
	if disconnected_start then
		vim.api.nvim_buf_add_highlight(buf, -1, "P5CDPDebugPaused", 0, disconnected_start - 1, disconnected_start - 1 + 13)
	end
end

C._render_tab_content = function()
	local k = C.state.active_tab
	if k == 1 then return C._render_console() end
	if k == 2 then return C._render_network() end
	if k == 3 then return C._render_eval() end
	if k == 4 then return C._render_debugger() end
	return { "" }
end

C._render_console = function()
	local data = C.tab_data.console
	if #data == 0 then
		return { " No console output yet" }
	end
	local lines = {}
	for _, entry in ipairs(data) do
		local ts = entry.timestamp or ""
		local lvl = (entry.level or "log"):upper():sub(1, 5)
		local msg = entry.message or ""
		local line = string.format(" [%s] %s %s", ts, lvl, msg)
		table.insert(lines, line)
		if entry.stack and #entry.stack > 0 then
			for _, frame in ipairs(entry.stack) do
				local floc = string.format("   at %s (%s:%d:%d)", frame["function"], frame.url, frame.line, frame.column)
				table.insert(lines, floc)
			end
		end
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
		local status = tostring(entry.status or (entry.error and "FAIL" or "?"))
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
		table.insert(lines, " Status: PAUSED")
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
		table.insert(lines, " Status: Running")
	end
	table.insert(lines, "")
	table.insert(lines, " Keymaps:")
	table.insert(lines, "   <CR>  set breakpoint")
	table.insert(lines, "   s     step over")
	table.insert(lines, "   i     step into")
	table.insert(lines, "   o     step out")
	table.insert(lines, "   x     continue")
	table.insert(lines, "   c     clear tab")
	return lines
end

return C
