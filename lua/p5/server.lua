-- Live server management
local S = {}
local core = require("p5.core")
local cdp = require("p5.cdp")
local project = require("p5.project")
local notify = core.notify

local user_stopped = false
local server_starting = false
local install_job = nil

S.config = {
	port = 8000,
	auto_open_browser = true,
	verbose = false,
	live_reload = {
		enabled = true,
		port = 12002,
		debounce_ms = 300,
		watch_extensions = { ".js", ".css", ".html", ".json" },
		exclude_dirs = { ".git", "node_modules", "dist", "build" },
	},
	libraries = {
		cdn_sources = { "jsdelivr", "cdnjs", "unpkg" },
		auto_update = false,
	},
}

local function server_bin()
	local root = core.plugin_root()
	local names = { "p5d", "p5d.exe" }
	local bases = {
		root .. "/",
		root .. "/srv/target/release/",
		root .. "/srv/target/debug/",
		root .. "/srv/",
	}
	for _, base in ipairs(bases) do
		for _, name in ipairs(names) do
			local p = base .. name
			if core.is_file(p) then
				return p
			end
		end
	end
	local in_path = vim.fn.exepath("p5d")
	if in_path ~= "" then
		return in_path
	end
	return nil
end

local function install_binary(cb)
	if install_job then
		if cb then
			cb(false, "install in progress")
		end
		return
	end
	local script = core.plugin_root() .. "/scripts/install-p5d.sh"
	if not core.is_file(script) then
		if cb then
			cb(false, "install script not found")
		end
		return
	end
	local cmd
	if vim.fn.has("win32") == 1 then
		cmd = { "bash", script }
	else
		cmd = { script }
	end
	notify("Installing p5d server binary...", "info")
	install_job = vim.fn.jobstart(cmd, {
		cwd = core.plugin_root(),
		on_exit = function(_, code)
			install_job = nil
			vim.schedule(function()
				if code == 0 and server_bin() then
					notify("p5d installed", "ok")
					if cb then
						cb(true)
					end
				else
					notify("p5d install failed (exit " .. tostring(code) .. "). Run ./scripts/install-p5d.sh manually.", "warn")
					if cb then
						cb(false, "exit " .. tostring(code))
					end
				end
			end)
		end,
	})
	if install_job <= 0 then
		install_job = nil
		if cb then
			cb(false, "failed to start install")
		end
	end
end

S.ensure_binary = function(cb)
	if server_bin() then
		if cb then
			cb(true)
		end
		return
	end
	install_binary(cb)
end

S.start = function(port)
	if S.server_job or server_starting then
		return
	end
	server_starting = true

	local buffer_dir = vim.fn.expand("%:p:h")
	if buffer_dir == "" or not core.is_dir(buffer_dir) then
		buffer_dir = vim.fn.getcwd()
	end

	local is_project = project.is_p5_project(buffer_dir)

	if not is_project then
		server_starting = false
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

	local bin = server_bin()
	if not bin then
		server_starting = false
		S.ensure_binary(function(ok)
			if ok then
				vim.schedule(function()
					S.start(port)
				end)
			end
		end)
		return
	end

	port = port or S.config.port or 8000

	local cmd = { bin, tostring(port), "--dir", buffer_dir }
	if S.config.live_reload then
		local lr = S.config.live_reload
		table.insert(cmd, "--lr-port")
		table.insert(cmd, tostring(lr.port or 12002))
		table.insert(cmd, "--lr-debounce")
		table.insert(cmd, tostring(lr.debounce_ms or 300))
		if lr.watch_extensions then
			table.insert(cmd, "--lr-extensions")
			table.insert(cmd, table.concat(lr.watch_extensions, ","))
		end
		if lr.exclude_dirs then
			table.insert(cmd, "--lr-exclude")
			table.insert(cmd, table.concat(lr.exclude_dirs, ","))
		end
		if lr.enabled == false then
			table.insert(cmd, "--lr-disabled")
		end
	end

	if S.config.cdp then
		table.insert(cmd, "--cdp-port")
		table.insert(cmd, tostring(S.config.cdp.remote_debugging_port or 9222))
	end

	if S.config.verbose then
		table.insert(cmd, "--verbose")
	end

	S.port = port
	S.type = "native"

	S.server_job = vim.fn.jobstart(cmd, {
		detach = true,
		cwd = buffer_dir,
		on_stdout = function(_, data)
			if not data then
				return
			end
			for _, line in ipairs(data) do
				if line == "" then
					goto continue
				end
				local level = line:match("%f[%w](ERROR)%f[%W]")
					or line:match("%f[%w](WARN)%f[%W]")
					or line:match("%f[%w](INFO)%f[%W]")
					or line:match("%f[%w](DEBUG)%f[%W]")
					or line:match("%f[%w](LOG)%f[%W]")
					or line:match("^%[browser%]%s+%[(%w+)%]")
				level = (level or ""):upper()
				local hl = "Normal"
				if level == "ERROR" then
					hl = "ErrorMsg"
				elseif level == "WARN" or level == "WARNING" then
					hl = "WarningMsg"
				elseif level == "INFO" then
					hl = "MoreMsg"
				elseif level == "DEBUG" then
					hl = "Comment"
				end
				vim.schedule(function()
					pcall(vim.api.nvim_echo, { { line, hl } }, true, {})
				end)
				::continue::
			end
		end,
		on_stderr = function(_, data)
			if data and #data > 0 and data[1] ~= "" then
				local error_msg = table.concat(data, " ")
				if error_msg:match("Address already in use") then
					notify("Port " .. port .. " is already in use. Try a different port.", "warn")
				elseif error_msg:match("Permission denied") or error_msg:match("EACCES") then
					notify("Permission denied. Check if port " .. port .. " requires elevated privileges.", "warn")
				else
					notify("Server: " .. error_msg, "warn")
				end
			end
		end,
		on_exit = function(_, exit_code, event)
			pcall(cdp.close)
			vim.api.nvim_exec_autocmds("User", { pattern = "P5ServerStopped" })

			if not user_stopped then
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
			end
			user_stopped = false

			S.server_job = nil
			S.type = nil
		end,
	})

	if S.server_job > 0 then
		server_starting = false
		local url = "http://localhost:" .. port
		local cdp_enabled = S.config.cdp and S.config.cdp.enabled
		local msg = "Server started (native) at " .. url
		if cdp_enabled then
			msg = msg .. " (CDP enabled)"
		end
		notify(msg, "ok")
		vim.api.nvim_exec_autocmds("User", { pattern = "P5ServerStarted" })

		vim.defer_fn(function()
			pcall(cdp.open)
		end, 500)

		if S.config.auto_open_browser ~= false and not cdp_enabled then
			vim.defer_fn(function()
				local chrome_cmd = core.find_chrome()
				if chrome_cmd then
					vim.fn.jobstart({ chrome_cmd, url }, {
						detach = true,
						on_exit = function(_, exit_code)
							if exit_code ~= 0 then
								notify("Failed to launch Chrome. Open manually: " .. url, "warn")
							end
						end,
					})
				else
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

					vim.fn.jobstart(open_cmd, {
						detach = true,
						on_exit = function(_, exit_code)
							if exit_code ~= 0 then
								notify("Please open manually: " .. url, "info")
							end
						end,
					})
				end
			end, 500)
		end
	else
		server_starting = false
	end
end

S.stop_server = function()
	if not S.server_job then
		notify("No server running", "info")
		return
	end

	user_stopped = true
	vim.fn.jobstop(S.server_job)
	S.server_job = nil
	S.type = nil

	cdp.close()

	notify("🛑 Server stopped", "info")
end

return S
