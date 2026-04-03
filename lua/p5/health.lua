-- Health check module for p5.nvim
local H = {}

-- Main health check function
H.check = function()
	vim.health.start("🩺 p5.nvim Health Check")

	local core = require("p5.core")
	local ok = vim.health.ok
	local error = vim.health.error
	local info = vim.health.info
	local warn = vim.health.warn

	-- Check snacks.nvim
	local snacks, _ = core.require_snacks()
	if snacks then
		ok("snacks.nvim: available")
	else
		error("snacks.nvim: not found - required for UI components")
	end

	-- Check plenary.nvim
	local plenary_ok, _ = pcall(require, "plenary")
	if plenary_ok then
		ok("plenary.nvim: available")
	else
		error("plenary.nvim: not found - required for async operations")
	end
	-- Check curl
	if core.is_cmd("curl") then
		ok("curl: available")
	elseif core.is_cmd("wget") then
		ok("wget: available")
	else
		warn("curl/wget: not found - required for library downloads")
	end

	-- Check gh CLI
	if core.is_cmd("gh") then
		ok("gh CLI: available")
	else
		warn("gh CLI: not found - optional for GitHub gist functionality")
	end

	-- Check Python
	if core.is_cmd("python3") or core.is_cmd("python") then
		ok("Python: available")
	else
		warn("Python: not found - optional for live server")
	end

	local plugin_root = core.plugin_root()
	if core.validate_dir(plugin_root, "Plugin root", false) then
		vim.health.ok("Plugin root: " .. plugin_root)
	else
		vim.health.error("Plugin root: not found at " .. plugin_root)
	end

	-- Check asset directory (for types)
	local asset_dir = core.asset_dir()
	if core.validate_dir(asset_dir, "Asset directory", false) then
		vim.health.ok("Asset directory: " .. asset_dir)
	else
		vim.health.warn("Asset directory: not found - optional, for IDE types only")
	end
	-- Check current directory for p5 project
	local cwd = vim.fs.normalize(vim.fn.getcwd())
	info("Current directory: " .. cwd)

	-- Check for p5.json
	local config_file = cwd .. "/p5.json"
	if core.validate_file(config_file, "p5.json", false) then
		ok("p5.json: found")

		-- Try to read config
		local cfg, data = pcall(vim.fn.json_decode, vim.fn.readfile(config_file))
		if cfg then
			ok("p5.json: valid format")

			if type(data.libs) == "table" then
				local count = 0
				for _ in pairs(data.libs) do
					count = count + 1
				end
				vim.health.ok("Libraries: " .. count .. " configured")
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

	-- Check for assets directory (optional - created by P5Setup)
	local assets_dir = cwd .. "/assets"
	if core.validate_dir(assets_dir, "assets/", false) then
		ok("assets/: directory exists")

		-- Check for libs directory
		local libs_dir = assets_dir .. "/libs"
		if core.validate_dir(libs_dir, "libs/", false) then
			local js_files = vim.fn.glob(libs_dir .. "/*.js", false, true)
			ok("libs/: " .. #js_files .. " library files")
		end
	else
		info("assets/: not found - run :P5Setup to create")
	end

	-- Check chrome-remote.nvim
	-- local chrome_remote = core.require_chrome_remote()
	-- if chrome_remote then
	-- 	ok("chrome-remote.nvim: available")
	-- else
	-- 	vim.health.warn("chrome-remote.nvim: not found - optional for Chrome DevTools Protocol support")
	-- end
end

return H
