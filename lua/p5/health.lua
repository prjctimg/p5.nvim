local H = {}

local function get_core()
	return require("p5.core")
end

local ok = vim.health.ok
local error = vim.health.error
local warn = vim.health.warn

local core = get_core()

H.check_dependencies = function()
	vim.health.start("Dependencies")
	local snacks, _ = pcall(require, "snacks")
	if snacks then
		ok("snacks.nvim: available")
	else
		warn("snacks.nvim: not found - optional, the HUD falls back to a plain terminal console")
	end

	local plenary, _ = pcall(require, "plenary")
	if plenary then
		ok("plenary.nvim: available")
	else
		warn("plenary.nvim: not found - only required for running the test suite")
	end
end

H.check_external_tools = function()
	vim.health.start("External Tools")

	if core.is_cmd("curl") then
		ok("curl: available")
	elseif core.is_cmd("wget") then
		ok("wget: available")
	else
		error("curl/wget: not found - required for library downloads")
	end

	if core.is_cmd("gh") then
		ok("gh CLI: available")
	else
		warn("gh CLI: not found - gist features will be unavailable")
	end

	local python_cmd = core.is_cmd("python3") and "python3" or core.is_cmd("python") and "python" or nil
	if python_cmd then
		ok("Python: available (" .. python_cmd .. ")")
		local ws_result = vim.fn.system(python_cmd .. " -c 'import websockets' 2>/dev/null")
		if vim.v.shell_error == 0 then
			ok("websockets module: available")
		else
			warn("websockets module: not found - live server will not work. Install with: pip install websockets")
		end
	else
		warn("Python: not found - live server will be unavailable")
	end
end

H.check_plugin_env = function()
	vim.health.start("Plugin Environment")

	local plugin_root = core.plugin_root()
	if core.is_dir(plugin_root) then
		ok("Plugin root: " .. plugin_root)
	else
		error("Plugin root: not found at " .. plugin_root)
	end

	local server_script = plugin_root .. "/server.py"
	if core.is_file(server_script) then
		ok("Server script: found")
	else
		warn("Server script: not found at " .. server_script)
	end

	local asset_dir = core.asset_dir()
	if core.is_dir(asset_dir) then
		ok("Asset directory: " .. asset_dir)
		local types = asset_dir .. "/types"
		if core.is_dir(types) and #(vim.fn.glob(types .. "/*.d.ts", false, true) or {}) > 0 then
			ok("Type definitions: present in assets/types (synced via automata)")
		else
			warn("Type definitions: missing — update plugin or wait for automata sync")
		end
		ok("p5.js runtime: cached under ~/.cache/p5.nvim/versions on first download")
	else
		warn("Asset directory: not found at " .. asset_dir)
	end
end

H.check_workspace = function()
	vim.health.start("Workspace")
	local info = vim.health.info

	local cwd = vim.fs.normalize(vim.fn.getcwd())
	info("Current directory: " .. cwd)

	local config_file = cwd .. "/p5.json"
	if core.is_file(config_file) then
		ok("p5.json: found")
	else
		info("p5.json: not found - not in a sketchspace")
	end

	local assets_dir = cwd .. "/assets"
	if core.is_dir(assets_dir) then
		ok("assets/: directory exists")
		local libs_dir = assets_dir .. "/libs"
		if core.is_dir(libs_dir) then
			local js_files = vim.fn.glob(libs_dir .. "/*.js", false, true)
			ok("libs/: " .. #js_files .. " library files")
		end
	else
		info("assets/: not found - run :P5Setup to create")
	end
end

H.check_project_config = function()
	vim.health.start("Project Configuration")

	local cwd = vim.fs.normalize(vim.fn.getcwd())
	local config_file = cwd .. "/p5.json"

	if core.is_file(config_file) then
		ok("p5.json: found")
		local data, _ = core.read_json(config_file)
		if data then
			ok("p5.json: valid format")

			if type(data.libs) == "table" then
				local count = 0
				for _ in pairs(data.libs) do
					count = count + 1
				end
				ok("Libraries: " .. count .. " configured")
			end

			if data.gist then
				if type(data.gist) == "table" then
					if data.gist.url then
						ok("Gist: linked to " .. data.gist.url)
					end
					if data.gist.title and data.gist.title ~= "" then
						ok("Gist title: " .. data.gist.title)
					end
				elseif type(data.gist) == "string" then
					-- Legacy format
				end
			end
		else
			error("p5.json: invalid format")
		end
	else
		warn("p5.json: not found - not in a sketchspace")
	end
end

H.check_neovim = function()
	vim.health.start("Neovim")

	local version = vim.version()
	if version.major > 0 or version.minor >= 9 then
		ok("Neovim version: " .. version.major .. "." .. version.minor .. "." .. version.patch)
	else
		warn("Neovim version: " .. version.major .. "." .. version.minor .. " (>= 0.9 recommended)")
	end

	if vim.fn.has("nvim") == 1 then
		ok("nvim feature: available")
	else
		warn("nvim feature: not available")
	end
end

H.check = function()
	vim.health.start("p5.nvim Health Check")

	H.check_dependencies()
	H.check_external_tools()
	H.check_plugin_env()
	H.check_workspace()
	H.check_project_config()
	H.check_neovim()
end

return H
