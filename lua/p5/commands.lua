local C = {}

local core = require("p5.core")
local project = require("p5.project")
local server = require("p5.server")
local libraries = require("p5.libraries")
local console = require("p5.console")
local gist = require("p5.gist")
local cdp = require("p5.cdp")

C.setup = function(opts)
	local require_sketchspace = opts.require_sketchspace
	local config = opts.config

	local handlers = {}

	handlers.create = function(args)
		local name = args[1]
		if not name then
			vim.ui.input({
				prompt = "Sketchspace name: ",
				default = "p5-sketch",
				completion = "dir",
			}, function(input)
				if input and input ~= "" then
					vim.ui.select({"Latest (2.x)", "Legacy (1.x)"}, {
						prompt = "Choose p5.js version:",
						default = 1,
					}, function(choice)
						local major = choice and choice:match("^Legacy") and 1 or 2
						project.create_project(input, major)
					end)
				end
			end)
		else
			if name == "--1" or name == "--1.x" then
				project.create_project(args[2], 1)
			else
				project.create_project(name, 2)
			end
		end
	end

	handlers.setup = function()
		if not require_sketchspace("Setup") then
			return
		end

		local cwd = vim.fs.normalize(vim.fn.getcwd())
		local config = core.read_workspace_config()
		local major = config and config.major or 2

		local steps = {
			function(next_step)
				if config and config.gist then
					local gist_info = gist.current()
					if gist_info and gist_info.id then
						gist.fetch(gist_info.id, cwd, function(ok, err)
							if not ok then
								core.notify("Gist download failed: " .. err .. ". Removing invalid gist URL.", "warn")
								config.gist = nil
								core.write_workspace_config(config)
							end
							next_step()
						end)
						return
					end
				end
				next_step()
			end,
			function(next_step)
				local sketch_file = cwd .. "/sketch.js"
				if not core.is_file(sketch_file) then
					local sketch_js = [[function setup() {
  createCanvas(400, 400);
}

function draw() {
  background(220);
  circle(mouseX, mouseY, 50);
}
]]
					vim.fn.writefile(vim.split(sketch_js, "\n"), sketch_file)
					core.notify("Created default sketch.js", "info")
				end
				next_step()
			end,
			function(next_step)
				project.ensure_assets(cwd, major, function()
					core.notify("Assets ready", "info")
					libraries.generate_libs_js(cwd)
					local updated_config = core.read_workspace_config()
					if updated_config and updated_config.libs then
						local lib_names = vim.tbl_keys(updated_config.libs)
						if #lib_names > 0 then
							libraries.install_libs(lib_names)
						end
					end
					core.notify("Sketchspace setup complete", "ok")
					next_step()
				end)
			end,
		}

		local function run(i)
			if i <= #steps then
				steps[i](function() run(i + 1) end)
			end
		end
		run(1)
	end

	handlers.install = function(args)
		if not require_sketchspace("Install") then
			return
		end

		local lib_names = #args > 0 and args or nil
		if not lib_names then
			local libs = libraries.get_available_libs()
			if not libs or #libs == 0 then
				core.notify("No libraries available", "warn")
				return
			end
			local items = {}
			local lib_map = {}
			for _, lib in ipairs(libs) do
				local display = lib.name
				if lib.description and lib.description ~= "" then
					display = display .. " - " .. lib.description
				end
				if lib.status and lib.status ~= "" then
					display = display .. " " .. lib.status
				end
				table.insert(items, display)
				lib_map[display] = lib.name
			end
			vim.ui.select(items, { prompt = "Select library to install:" }, function(selected)
				if selected then
					libraries.install_libs({ lib_map[selected] or selected })
				end
			end)
		else
			libraries.install_libs(lib_names)
		end
	end

	handlers.uninstall = function(args)
		if not require_sketchspace("Uninstall") then
			return
		end

		local lib_names = #args > 0 and args or nil
		if not lib_names then
			local installed = libraries.get_installed_libs()
			if #installed == 0 then
				core.notify("No contrib libraries installed", "warn")
				return
			end
			local items = {}
			local lib_map = {}
			for _, lib in ipairs(installed) do
				table.insert(items, lib.name)
				lib_map[lib.name] = lib.name
			end
			vim.ui.select(items, { prompt = "Select library to uninstall:" }, function(selected)
				if selected then
					libraries.uninstall_libs({ lib_map[selected] or selected })
				end
			end)
		else
			libraries.uninstall_libs(lib_names)
		end
	end

	handlers.server = function(args)
		if server.server_job then
			server.stop_server()
		else
			local port = #args > 0 and tonumber(args[1]) or nil
			server.start(port)
		end
	end

	handlers.console = function()
		console.toggle()
	end

	handlers.docs = function()
		vim.cmd("help p5.nvim")
	end

	handlers.sync = function(_)
		core.notify(
			"P5 sync is deprecated. Use 'P5 gist sync' to sync gists or 'P5 update' to update libraries.",
			"error"
		)
	end

	handlers.gist = function(args)
		if not require_sketchspace("Gist") then
			return
		end
		local sub = args[1]
		if sub == "sync" then
			gist.sync()
		elseif sub == "edit" then
			gist.edit()
		else
			gist.create(table.concat(args, " "))
		end
	end

	handlers.update = function(args)
		if not require_sketchspace("Update") then
			return
		end
		if #args > 0 then
			libraries.install_libs(args)
		else
			libraries.update_libs()
		end
	end

	handlers.skchbk = function(args)
		local subcmd = args[1]
		local username = config.sketchbook.user

		if not username or username == "" then
			vim.ui.input({ prompt = "GitHub username for sketchbook: " }, function(input)
				if input and input ~= "" then
					username = input
					if subcmd == "list" then
						gist.skchbk_list(username, vim.fn.getcwd() .. "/skchbk")
					else
						gist.clone(username, vim.fn.getcwd() .. "/skchbk", "all")
					end
				else
					core.notify("Set sketchbook.user in p5 config or provide a username", "warn")
				end
			end)
			return
		end

		local skchbk_dir = vim.fn.getcwd() .. "/skchbk"

		if subcmd == "list" then
			gist.skchbk_list(username, skchbk_dir)
		else
			gist.clone(username, skchbk_dir, "all")
		end
	end

	handlers.cdp = function(args)
		local sub = args[1]
		if not sub then
			cdp.toggle()
		elseif sub == "connect" then
			cdp.connect()
		elseif sub == "disconnect" then
			cdp.disconnect()
		elseif sub == "status" then
			cdp.status()
		elseif sub == "eval" then
			local expr = table.concat(args, " ", 2)
			cdp.eval(expr ~= "" and expr or nil)
		elseif sub == "break" then
			local loc = args[2]
			cdp.set_breakpoint(loc)
		elseif sub == "continue" then
			cdp.continue()
		elseif sub == "step" then
			cdp.step()
		elseif sub == "stepIn" then
			cdp.step_in()
		elseif sub == "stepOut" then
			cdp.step_out()
		end
	end

	handlers.menu = function()
		local server_status = server.server_job and "Stop server" or "Start server"
		local menu_options = {
			"Create new sketchspace",
			"Open recent sketchspace",
			"Setup sketchspace",
			"Install library",
			"Uninstall library",
			server_status,
			"Toggle console",
			"Open docs",
			"Update libraries",
			"Create gist",
			"Download sketchbook",
		}
		local menu_dispatch = {
			["Create new sketchspace"] = function() handlers.create({}) end,
			["Open recent sketchspace"] = function() handlers.list() end,
			["Setup sketchspace"] = function() handlers.setup() end,
			["Install library"] = function() handlers.install({}) end,
			["Uninstall library"] = function() handlers.uninstall({}) end,
			["Start server"] = function() handlers.server({}) end,
			["Stop server"] = function() handlers.server({}) end,
			["Toggle console"] = function() handlers.console() end,
			["Open docs"] = function() handlers.docs() end,
			["Update libraries"] = function() handlers.update({}) end,
			["Create gist"] = function() handlers.gist({}) end,
			["Download sketchbook"] = function() handlers.skchbk({}) end,
		}
		vim.ui.select(menu_options, { prompt = "p5.nvim:" }, function(choice)
			if choice and menu_dispatch[choice] then
				menu_dispatch[choice]()
			end
		end)
	end

	handlers.list = function()
		local recent = core.purge_ss()
		if #recent == 0 then
			core.notify("No recent sketchspaces found", "warn")
			return
		end
		vim.ui.select(recent, { prompt = "Select a sketchspace:" }, function(selected)
			if selected then
				vim.api.nvim_set_current_dir(selected)
			end
		end)
	end

	local subcommands = vim.tbl_filter(function(k) return k ~= "sync" end, vim.tbl_keys(handlers))

	local function get_completion(line)
		local args = vim.split(line, "%s+")
		local cmd_pos = 1
		while args[cmd_pos] and args[cmd_pos] ~= "P5" do
			cmd_pos = cmd_pos + 1
		end
		local subcmd_pos = cmd_pos + 1

		if #args <= subcmd_pos then
			return subcommands
		end

		local subcmd = args[subcmd_pos]
		if subcmd == "install" or subcmd == "uninstall" then
			local libs = libraries.get_available_libs()
			return vim.tbl_map(function(l) return l.name end, libs or {})
		elseif subcmd == "server" then
			return { "8000", "8001", "8002", "8003" }
		elseif subcmd == "gist" then
			return { "sync", "edit" }
		elseif subcmd == "update" then
			local libs = libraries.get_available_libs()
			return vim.tbl_map(function(l) return l.name end, libs or {})
		elseif subcmd == "skchbk" then
			return { "list" }
		elseif subcmd == "cdp" then
			local sub = args[subcmd_pos + 1]
			if not sub then
				return { "connect", "disconnect", "status", "eval", "break", "continue", "step", "stepIn", "stepOut" }
			end
		end
		return {}
	end

	vim.api.nvim_create_user_command("P5", function(cmd)
		local args = {}
		for match in vim.gsplit(vim.trim(cmd.args), "%s+") do
			if match and match ~= "" then
				table.insert(args, match)
			end
		end
		local subcmd = #args > 0 and args[1] or "menu"

		table.remove(args, 1)

		local handler = handlers[subcmd]
		if handler then
			handler(args)
		else
			core.notify("Unknown P5 command: " .. subcmd .. ". Run :P5 for interactive picker", "warn")
		end
	end, {
		nargs = "*",
		bar = true,
		desc = "p5.nvim commands",
		complete = function(_, line)
			return get_completion(line)
		end,
	})
end

return C
