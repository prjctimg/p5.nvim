-- Live server management
local S = {}
local core = require("p5.core")
local cdp = require("p5.cdp")
local project = require("p5.project")
local notify = core.notify

local user_stopped = false
local server_starting = false

S.config = {
	port = 8000,
	auto_open_browser = true,
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
	local candidates = {
		root .. "/p5d",
		root .. "/srv/target/release/p5d",
		root .. "/srv/target/debug/p5d",
		root .. "/srv/p5d",
	}
	for _, p in ipairs(candidates) do
		if core.is_file(p) then
			return p
		end
	end
	return nil
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
		notify("Server binary not found. Build it with: (cd srv && cargo build --release)", "warn")
		return
	end

	port = port or S.config.port or 8000

	local cmd = { bin, tostring(port) }
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

	S.port = port
	S.type = "native"

	S.server_job = vim.fn.jobstart(cmd, {
		detach = true,
		cwd = buffer_dir,
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
