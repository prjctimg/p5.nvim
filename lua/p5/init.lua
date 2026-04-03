-- p5.nvim entry point
local I = {}

local core = require("p5.core")
local project = require("p5.project")
local server = require("p5.server")
local libraries = require("p5.libraries")
local console = require("p5.console")
local gist = require("p5.gist")

I.config = {
	server = {
		port = 8000,
		auto_start = false,
		auto_open_browser = true,
		live_reload = {
			enabled = true,
			port = 12002,
			debounce_ms = 300,
			watch_extensions = { ".js", ".css", ".html", ".json" },
			exclude_dirs = { ".git", "node_modules", "dist", "build" },
		},
	},
	console = {
		position = "below",
		height = 10,
	},
	libraries = {
		cdn_sources = { "jsdelivr", "cdnjs", "unpkg" },
		auto_update = false,
	},
}

I.setup = function(opts)
	I.config = vim.tbl_deep_extend("force", I.config, opts or {})

	core.setup(I.config)
	project.setup(I.config)
	server.setup(I.config)
	libraries.setup(I.config)
	console.setup(I.config)
	gist.setup(I.config)

	vim.api.nvim_create_autocmd("DirChanged", {
		callback = function(args)
			local dir = vim.fn.getcwd()
			if core.is_file(dir .. "/p5.json") then
				core.add_ss(dir)
			end
		end,
	})

	local function require_sketchspace(action)
		if not project.is_p5_project() then
			core.notify(action .. " requires a sketchspace (p5.json)", "error")
			return false
		end
		return true
	end

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
					project.create_project(input)
				end
			end)
		else
			project.create_project(name)
		end
	end

	handlers.setup = function()
		if not require_sketchspace("Setup") then
			return
		end

		local cwd = vim.fs.normalize(vim.fn.getcwd())
		local config = core.read_workspace_config()

		if config and config.gist then
			local gist_info = gist.current()
			if gist_info and gist_info.id then
				local ok, err = gist.fetch(gist_info.id, cwd)
				if not ok then
					core.notify("Gist download failed: " .. err .. ". Removing invalid gist URL.", "warn")
					config.gist = nil
					core.write_workspace_config(config)
				end
			end
		end

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

		project.copy_assets_to_project(cwd, function(err)
			if err then
				core.notify("Failed to copy assets: " .. err, "error")
				return
			end

			core.notify("Assets copied successfully", "info")

			libraries.bootstrap(cwd)

			local updated_config = core.read_workspace_config()
			if updated_config and updated_config.libs then
				local lib_names = vim.tbl_keys(updated_config.libs)
				if #lib_names > 0 then
					libraries.install(lib_names)
				end
			end

			core.notify("Sketchspace setup complete", "ok")
		end)
	end

	handlers.install = function(args)
		if not require_sketchspace("Install") then
			return
		end

		local lib_names = #args > 0 and args or nil
		if not lib_names then
			local libs = libraries.available()
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
					libraries.install({ lib_map[selected] or selected })
				end
			end)
		else
			libraries.install(lib_names)
		end
	end

	handlers.uninstall = function(args)
		if not require_sketchspace("Uninstall") then
			return
		end

		local lib_names = #args > 0 and args or nil
		if not lib_names then
			local installed = libraries.installed()
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
					libraries.uninstall({ lib_map[selected] or selected })
				end
			end)
		else
			libraries.uninstall(lib_names)
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

	handlers.sync = function(args)
		local target = args[1]

		if not target then
			vim.ui.select({ "Gist", "Libraries" }, { prompt = "What to sync:" }, function(choice)
				if choice == "Gist" then
					if not require_sketchspace("Sync gist") then
						return
					end
					gist.update()
				elseif choice == "Libraries" then
					if not require_sketchspace("Sync libraries") then
						return
					end
					libraries.update_libs()
				end
			end)
		elseif target == "gist" then
			if not require_sketchspace("Sync gist") then
				return
			end
			gist.update()
		elseif target == "libs" or target == "libraries" then
			if not require_sketchspace("Sync libraries") then
				return
			end
			libraries.update_libs()
		else
			core.notify("Unknown sync target: " .. target .. ". Use 'gist' or 'libs'", "warn")
		end
	end

	handlers.gist = function(args)
		if not require_sketchspace("Gist") then
			return
		end
		local desc = args[1]
		gist.create(desc)
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
			"Sync",
			"Create/update Gist",
		}

		local menu_dispatch = {
			["Create new sketchspace"] = function()
				handlers.create({})
			end,
			["Open recent sketchspace"] = function()
				handlers.list()
			end,
			["Setup sketchspace"] = function()
				handlers.setup()
			end,
			["Install library"] = function()
				handlers.install({})
			end,
			["Uninstall library"] = function()
				handlers.uninstall({})
			end,
			["Start server"] = function()
				handlers.server({})
			end,
			["Stop server"] = function()
				handlers.server({})
			end,
			["Toggle console"] = function()
				handlers.console()
			end,
			["Open docs"] = function()
				handlers.docs()
			end,
			["Sync"] = function()
				handlers.sync({})
			end,
			["Create/update Gist"] = function()
				handlers.gist({})
			end,
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

	local subcommands = vim.tbl_keys(handlers)

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
			local libs = libraries.available()
			return vim.tbl_map(function(l)
				return l.name
			end, libs or {})
		elseif subcmd == "server" then
			return { "8000", "8001", "8002", "8003" }
		elseif subcmd == "sync" then
			return { "gist", "libs", "libraries" }
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

return I
