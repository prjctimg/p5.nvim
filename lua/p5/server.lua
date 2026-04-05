-- Live server management
local S = {}
local core = require("p5.core")
local console = require("p5.console")
local project = require("p5.project")
local notify = core.notify

S.config = {
	port = 8000,
	auto_start = false,
	live_reload = {
		enabled = true,
		port = 12002,
		debounce_ms = 300,
		watch_extensions = { ".js", ".css", ".html", ".json" },
		exclude_dirs = { ".git", "node_modules", "dist", "build" },
	},
	console = {
		enabled = true,
		auto_show = true,
		position = "below",
		height = 10,
	},
	libraries = {
		cdn_sources = { "jsdelivr", "cdnjs", "unpkg" },
		auto_update = false,
	},
}

S.start = function(port)
	local buffer_dir = vim.fn.expand("%:p:h")
	if buffer_dir == "" or not core.is_dir(buffer_dir) then
		buffer_dir = vim.fn.getcwd()
	end

	local is_project = project.is_p5_project(buffer_dir)

	if not is_project then
		vim.ui.select(
			{ "Create new sketchspace", "Open recent sketchspace" },
			{ prompt = "Not in a valid p5.js sketchspace. What would you like to do?" },
			function(choice)
				if choice == "Create new sketchspace" then
					vim.cmd("P5 create")
				elseif choice == "Open recent sketchspace" then
					local recent = core.read_ss()
					if #recent == 0 then
						notify("No recent sketchspaces found", "warn")
						return
					end
					vim.ui.select(recent, { prompt = "Select a sketchspace:" }, function(selected)
						if selected then
							vim.api.nvim_set_current_dir(selected)
							S.start(port)
						end
					end)
				end
			end
		)
		return
	end

	vim.api.nvim_set_current_dir(buffer_dir)

	local type
	local cfg = core.server_cfg
	if core.is_cmd(cfg.check) then
		local server_script = core.plugin_root() .. "/server.py"
		if core.is_file(server_script) then
			type = "python"
		else
			notify("Server script not found: " .. server_script, "warn")
		end
	else
		notify("python3 not found in PATH. Please install Python to use the development server.", "error")
	end

	if not type then
		notify("No suitable server found (python3, bun, deno, or node)", "error")
		notify("Please install one of the supported runtimes", "info")
		return
	end

	port = port or S.config.port or 8000

	local max_attempts = 20
	local preferred_ports = {}
	for i = 0, max_attempts - 1 do
		table.insert(preferred_ports, port + i)
	end
	local alt_ranges = { 3000, 5000, 9000 }
	for _, base in ipairs(alt_ranges) do
		for i = 0, 9 do
			table.insert(preferred_ports, base + i)
		end
	end

	local actual_port = port
	for _, test_port in ipairs(preferred_ports) do
		local result = vim.fn.system(
			string.format("lsof -i:%d 2>/dev/null || netstat -tuln 2>/dev/null | grep ':%d'", test_port, test_port)
		)
		if vim.v.shell_error ~= 0 or result == "" then
			if vim.v.shell_error ~= 0 then
				actual_port = test_port
				break
			end
		end
	end
	if actual_port ~= port then
		notify("Port " .. port .. " in use, using " .. actual_port .. " instead", "warn")
		port = actual_port
	end

	local server_config = core.server_cfg
	if not core.is_cmd(server_config.check) then
		notify("Server validation failed: " .. server_config.cmd .. " is not available", "error")
		return
	end
	local server_script = core.plugin_root() .. "/server.py"
	if not core.is_file(server_script) then
		notify("Server validation failed: Server script not found", "error")
		return
	end
	vim.fn.system("python3 -c 'import websockets' 2>/dev/null")
	if vim.v.shell_error ~= 0 then
		notify("Server validation failed: websockets module not found. Install with: pip install websockets", "error")
		return
	end
	if not port or port <= 0 or port >= 65536 then
		notify("Server validation failed: Invalid port number", "error")
		return
	end
	if port < 1024 then
		local result = vim.fn.system("id -u 2>/dev/null")
		local user_id = vim.trim(result)
		if user_id ~= "0" then
			notify("Server validation failed: Port " .. port .. " requires root privileges", "error")
			return
		end
	end

	S.port = port
	S.type = type

	local plugin_root = core.plugin_root()
	local cmd = { "python3", plugin_root .. "/server.py", tostring(port) }

	S.server_job = vim.fn.jobstart(cmd, {
		on_stderr = function(_, data)
			if data and #data > 0 and data[1] ~= "" then
				local error_msg = table.concat(data, " ")

				if error_msg:match("Address already in use") then
					notify("Port " .. port .. " is already in use. Try a different port.", "error")
				elseif error_msg:match("Permission denied") or error_msg:match("EACCES") then
					notify("Permission denied. Check if port " .. port .. " requires elevated privileges.", "error")
				elseif error_msg:match("ModuleNotFoundError") or error_msg:match("ImportError") then
					notify("Server import error: " .. error_msg, "error")
				else
					notify("Server warning: " .. error_msg, "warn")
				end
			end
		end,
		on_exit = function(_, exit_code, event)
			console.hide()

			if exit_code == 0 then
				notify("🛑 Server stopped", "info")
			else
				local reason = ""
				if event == "exit" then
					reason = " (exited normally)"
				elseif event == "term" then
					reason = " (terminated)"
				else
					reason = " (event: " .. (event or "unknown") .. ")"
				end

				notify("Server stopped with code " .. exit_code .. reason, "warn")
			end

			S.server_job = nil
			S.type = nil
		end,
	})

	if S.server_job > 0 then
		local url = "http://localhost:" .. port
		notify("🎉 Server started (" .. type .. ") at " .. url, "ok")

		if S.config.console.enabled then
			vim.defer_fn(function()
				console.show({ enter = false })
				notify("Console polling started on port " .. S.port, "ok")
			end, 2000)
		end

		if S.config.auto_open_browser ~= false then
			vim.defer_fn(function()
				local open_cmd
				if vim.fn.has("unix") == 1 then
					if vim.fn.has("mac") == 1 then
						open_cmd = { "open", url }
					else
						open_cmd = { "xdg-open", url }
					end
				elseif vim.fn.has("win32") == 1 then
					open_cmd = { "cmd", "/c", "start", "", url }
				else
					open_cmd = { "xdg-open", url }
				end

				local result = vim.fn.system(open_cmd)
				if vim.v.shell_error ~= 0 then
					notify("Failed to open browser: " .. vim.trim(result), "warn")
					notify("Please open manually: " .. url, "info")
				end
			end, 2000)
		end

		if S.config.console.auto_show then
			vim.defer_fn(function()
				console.show({ enter = false })
			end, 2500)
		end
	end
end

S.stop_server = function()
	if not S.server_job then
		notify("No server running", "warn")
		return
	end

	local stopped_port = S.port
	local server_type = S.type

	vim.fn.jobstop(S.server_job)
	S.server_job = nil
	S.type = nil

	console.hide()

	notify("🛑 Server stopped on port " .. stopped_port .. " (" .. server_type .. ")", "info")
end

return S
