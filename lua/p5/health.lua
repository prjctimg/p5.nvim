-- Health check module for p5.nvim
local H = {}

local function get_core()
	return require("p5.core")
end

H.check_dependencies = function()
	vim.health.start("Dependencies")
	local core = get_core()
	local ok = vim.health.ok
	local error = vim.health.error
	local warn = vim.health.warn

	local snacks, _ = core.require_snacks()
	if snacks then
		ok("snacks.nvim: available")
	else
		error("snacks.nvim: not found - required for UI components")
	end

	local plenary_ok, _ = pcall(require, "plenary")
	if plenary_ok then
		ok("plenary.nvim: available")
	else
		error("plenary.nvim: not found - required for async operations")
	end
end

H.check_external_tools = function()
	vim.health.start("External Tools")
	local core = get_core()
	local ok = vim.health.ok
	local warn = vim.health.warn

	if core.is_cmd("curl") then
		ok("curl: available")
	elseif core.is_cmd("wget") then
		ok("wget: available")
	else
		warn("curl/wget: not found - required for library downloads")
	end

	if core.is_cmd("gh") then
		ok("gh CLI: available")
	else
		warn("gh CLI: not found - optional for GitHub gist functionality")
	end

	if core.is_cmd("python3") or core.is_cmd("python") then
		ok("Python: available")
	else
		warn("Python: not found - optional for live server")
	end
end

H.check_plugin_env = function()
	vim.health.start("Plugin Environment")
	local core = get_core()
	local ok = vim.health.ok
	local error = vim.health.error

	local plugin_root = core.plugin_root()
	if core.validate_dir(plugin_root, "Plugin root", false) then
		ok("Plugin root: " .. plugin_root)
	else
		error("Plugin root: not found at " .. plugin_root)
	end

	local asset_dir = core.asset_dir()
	if core.validate_dir(asset_dir, "Asset directory", false) then
		ok("Asset directory: " .. asset_dir)
	else
		vim.health.warn("Asset directory: not found - optional, for IDE types only")
	end
end

H.check_workspace = function()
	vim.health.start("Workspace")
	local core = get_core()
	local info = vim.health.info
	local ok = vim.health.ok

	local cwd = vim.fs.normalize(vim.fn.getcwd())
	info("Current directory: " .. cwd)

	local config_file = cwd .. "/p5.json"
	if core.validate_file(config_file, "p5.json", false) then
		ok("p5.json: found")
	else
		info("p5.json: not found - not in a sketchspace")
	end

	local assets_dir = cwd .. "/assets"
	if core.validate_dir(assets_dir, "assets/", false) then
		ok("assets/: directory exists")

		local libs_dir = assets_dir .. "/libs"
		if core.validate_dir(libs_dir, "libs/", false) then
			local js_files = vim.fn.glob(libs_dir .. "/*.js", false, true)
			ok("libs/: " .. #js_files .. " library files")
		end
	else
		info("assets/: not found - run :P5Setup to create")
	end
end

H.check_project_config = function()
	vim.health.start("Project Configuration")
	local core = get_core()
	local ok = vim.health.ok
	local error = vim.health.error
	local info = vim.health.info

	local cwd = vim.fs.normalize(vim.fn.getcwd())
	local config_file = cwd .. "/p5.json"

	if core.validate_file(config_file, "p5.json", false) then
		ok("p5.json: found")

		local cfg, data = pcall(vim.fn.json_decode, vim.fn.readfile(config_file))
		if cfg then
			ok("p5.json: valid format")

			if type(data.libs) == "table" then
				local count = 0
				for _ in pairs(data.libs) do
					count = count + 1
				end
				ok("Libraries: " .. count .. " configured")
			end

			if data.server then
				ok("Server configuration: found")
			end
		else
			error("p5.json: invalid format")
		end
	else
		info("p5.json: not found - not in a sketchspace")
	end
end

H.check_neovim = function()
	vim.health.start("Neovim")
	local ok = vim.health.ok
	local warn = vim.health.warn

	local version = vim.version()
	if version.major > 0 or version.minor >= 9 then
		ok("Neovim version: " .. vim.version().major .. "." .. vim.version().minor .. "." .. vim.version().patch)
	else
		warn("Neovim version: " .. vim.version().major .. "." .. vim.version().minor .. " (>= 0.9 recommended)")
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
