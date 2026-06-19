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
	auto_start = false,
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
		notify("python3 not found in PATH. Please install Python to use the development server.", "warn")
	end

	if not type then
		server_starting = false
		notify("No suitable server found (python3, bun, deno, or node)", "warn")
		notify("Please install one of the supported runtimes", "info")
		return
	end

	port = port or S.config.port or 8000

	-- Validate environment asynchronously before starting server
	local validation_cancelled = false
	local validation_steps = {
		function(next_step)
			vim.fn.jobstart({ "python3", "-c", "import websockets" }, {
				on_exit = function(_, exit_code)
					if exit_code ~= 0 then
						validation_cancelled = true
						notify("Server validation failed: websockets module not found. Install with: pip install websockets", "warn")
					end
					next_step()
				end,
			})
		end,
		function(next_step)
			if validation_cancelled then next_step() return end
			if port < 1024 then
				vim.fn.jobstart({ "id", "-u" }, {
					on_stdout = function(_, data)
						local user_id = vim.trim(table.concat(data or {}, ""))
						if user_id ~= "0" then
							validation_cancelled = true
							notify("Server validation failed: Port " .. port .. " requires root privileges", "warn")
						end
						next_step()
					end,
				})
			else
				next_step()
			end
		end,
		function(next_step)
			if validation_cancelled then server_starting = false return end
			-- All validations passed, start server
			S.port = port
			S.type = type

			local plugin_root = core.plugin_root()
			local cmd = { "python3", plugin_root .. "/server.py", tostring(port) }
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

			S.server_job = vim.fn.jobstart(cmd, {
				detach = true,
				on_stderr = function(_, data)
					if data and #data > 0 and data[1] ~= "" then
						local error_msg = table.concat(data, " ")

						if error_msg:match("Address already in use") then
							notify("Port " .. port .. " is already in use. Try a different port.", "warn")
						elseif error_msg:match("Permission denied") or error_msg:match("EACCES") then
							notify("Permission denied. Check if port " .. port .. " requires elevated privileges.", "warn")
						elseif error_msg:match("ModuleNotFoundError") or error_msg:match("ImportError") then
							notify("Server import error: " .. error_msg, "warn")
						else
							notify("Server warning: " .. error_msg, "warn")
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
				local msg = "Server started (" .. type .. ") at " .. url
				if cdp_enabled then
					msg = msg .. " (CDP enabled)"
				end
				notify(msg, "ok")
				vim.api.nvim_exec_autocmds("User", { pattern = "P5ServerStarted" })

				vim.defer_fn(function()
					pcall(cdp.open)
				end, 500)

				-- Auto-open browser (skip when CDP enabled - CDP module handles it)
				if S.config.auto_open_browser ~= false and not cdp_enabled then
					vim.defer_fn(function()
						local chrome_cmd = core.find_chrome()
						if chrome_cmd then
							local chrome_args = { chrome_cmd }
							table.insert(chrome_args, url)
							vim.fn.jobstart(chrome_args, {
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
		end,
	}

	core.step_runner(validation_steps)
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
