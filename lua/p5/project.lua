-- Project creation and management for p5.nvim
local P = {}
local core = require("p5.core")
local libraries = require("p5.libraries")
local notify = core.notify

P.create_project = function(name, major)
	major = major or 2
	name = name or "p5-sketch"

	if major == 1 then
		local required_1x = {
			"libs/p5.js",
			"libs/p5.sound.js",
			"types/p5.d.ts",
		}
		local missing = {}
		for _, asset in ipairs(required_1x) do
			if not core.is_file(core.asset_dir() .. "/" .. asset) then
				table.insert(missing, asset)
			end
		end
		if #missing > 0 then
			notify("Missing required assets: " .. table.concat(missing, ", "), "warn")
			notify("😩 Cannot create project - required assets are missing", "info")
			return false
		end
	end

	if vim.fn.isdirectory(name) ~= 0 then
		notify("😅 Directory '" .. name .. "' already exists", "info")
		return false
	end

	local path = vim.fn.fnamemodify(name, ":p")

	-- Always compute CDN version for p5.json, download if not cached
	local cdn_url = "https://cdn.jsdelivr.net/npm/p5@2.0.5/lib/p5.min.js"
	local cdn_version = cdn_url:match("@([^/]+)")
	if major == 2 and not core.is_file(core.asset_dir() .. "/libs/p5-v2.js") then
		notify("Downloading p5.js 2.x assets...", "info")
	end

	P.create_project_continue(name, major, cdn_version)

	if major == 2 and cdn_version then
		local libs_dir = core.asset_dir() .. "/libs"
		local types_dir = core.asset_dir() .. "/types"
		core.fetch(cdn_url, libs_dir .. "/p5-v2.js", function(ok)
			if ok then
				-- Best-effort types download; skip silently if unavailable for this major
				core.fetch(
					"https://cdn.jsdelivr.net/npm/p5@2.0.5/types/p5.d.ts",
					types_dir .. "/p5-v2.d.ts",
					function(_)
						P.copy_assets_to_project(path, 2, function(err)
							if err then
								notify("Failed to copy p5.js assets: " .. err, "warn")
							else
								notify("p5.js 2.x assets ready", "ok")
							end
						end)
					end,
					{ cache = true }
				)
			else
				notify("Download failed. Run :P5 setup to retry.", "warn")
			end
		end, { cache = true })
	end
end

function P.create_project_continue(name, major, override_version)
	core.mkdir(name)
	local path = vim.fn.fnamemodify(name, ":p")

	P.copy_assets_to_project(path, major, function(err)
		if err then
			notify("Failed to create project: " .. err, "info")
			return
		end

		local index_html = [[<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>p5.js Sketch</title>
  <link rel="icon" type="image/x-icon" href="assets/favicon.ico">
  <script src="assets/libs/p5.js"></script>
  <script src="assets/libs/libs.js"></script>
</head>
<body>
  <main>
  </main>
  <script src="sketch.js"></script>
</body>
</html>]]
		vim.fn.writefile(vim.split(index_html, "\n"), path .. "/index.html")

		local sketch_js = [[function setup() {
  createCanvas(400, 400);
}

function draw() {
  background(220);
  circle(mouseX, mouseY, 50);
}]]
		vim.fn.writefile(vim.split(sketch_js, "\n"), path .. "/sketch.js")

		local jsconfig = [[{
  "compilerOptions": {
    "target": "ES2022",
    "module": "ESNext", 
    "lib": ["DOM", "ES2022"],
    "types":["./assets/types/p5.d.ts"],
    "checkJs": true,
    "strict": false,
    "allowJs": true,
    "moduleResolution": "node"
  },
  "include": [
    "**/*.js",
    "**/*.ts"
  ],
  "exclude": [
    "node_modules"
  ]
}]]
		vim.fn.writefile(vim.split(jsconfig, "\n"), path .. "/jsconfig.json")

		local tsconfig = [[{
  "compilerOptions": {
    "target": "ES2022",
    "module": "ESNext",
    "lib": ["DOM", "ES2022"],
    "types":["./assets/types/p5.d.ts"],
    "strict": true,
    "allowJs": true,
    "checkJs": false,
    "moduleResolution": "node",
    "allowSyntheticDefaultImports": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true
  },
  "include": [
    "**/*.ts",
    "**/*.js"
  ],
  "exclude": [
    "node_modules",
    "dist",
    "build"
  ]
}]]
		vim.fn.writefile(vim.split(tsconfig, "\n"), path .. "/tsconfig.json")

		local p5_config = {
			version = core.p5_version(major, override_version),
			major = major,
			libs = {},
			includes = { "sketch.js" },
		}
		vim.fn.writefile(vim.split(vim.fn.json_encode(p5_config), "\n"), path .. "/p5.json")

		core.mkdir(path .. "/assets/types")
		core.mkdir(path .. "/assets/libs")
		libraries.generate_libs_js(path)

		notify("🎉 Sketchspace created: " .. name, "ok")
		vim.api.nvim_set_current_dir(path)
		vim.cmd({ cmd = "edit", args = { path .. "/sketch.js" } })
	end)
end

P.copy_assets_to_project = function(project_path, major, callback)
	major = major or 2
	local plugin_assets = core.asset_dir()
	local project_assets = project_path .. "/assets"

	core.mkdir(project_assets)
	core.mkdir(project_assets .. "/types")
	core.mkdir(project_assets .. "/libs")

	local pending_copies = 0
	local copy_errors = {}
	local called_once = false

	local function try_copy(src, dest)
		if core.is_file(src) then
			pending_copies = pending_copies + 1
			local function on_copy(err)
				pending_copies = pending_copies - 1
				if err then
					table.insert(copy_errors, dest .. ": " .. vim.inspect(err))
				end
				if pending_copies == 0 and callback then
					if not called_once then
						called_once = true
						vim.schedule(function()
							callback(#copy_errors > 0 and table.concat(copy_errors, ", ") or nil)
						end)
					end
				end
			end
			if vim.uv and vim.uv.fs_copyfile then
				vim.uv.fs_copyfile(src, dest, on_copy)
			else
				local result = vim.fn.system({ "cp", src, dest })
				vim.schedule(function()
					if vim.v.shell_error ~= 0 then
						on_copy(result)
					else
						on_copy(nil)
					end
				end)
			end
		else
			core.notify("Skipped (not found): " .. src, "info")
		end
	end

	local types_file = major == 1 and "p5.d.ts" or "p5-v2.d.ts"
	try_copy(plugin_assets .. "/types/" .. types_file, project_assets .. "/types/p5.d.ts")

	if core.is_dir(plugin_assets .. "/libs") then
		local p5_file = major == 1 and "p5.js" or "p5-v2.js"
		local sound_file = major == 1 and "p5.sound.js" or "p5-v2.sound.js"
		for _, file in ipairs({ p5_file, sound_file }) do
			try_copy(plugin_assets .. "/libs/" .. file, project_assets .. "/libs/" .. file)
		end
	end

	try_copy(plugin_assets .. "/favicon.ico", project_assets .. "/favicon.ico")

	if pending_copies == 0 and callback then
		if not called_once then
			called_once = true
			vim.schedule(function()
				callback(#copy_errors > 0 and table.concat(copy_errors, ", ") or nil)
			end)
		end
	end
end

P.is_p5_project = function(dir)
	local cwd = vim.fs.normalize(dir or vim.fn.getcwd())

	local config_file = cwd .. "/p5.json"
	if not core.is_file(config_file) then
		return false, "No p5.json found in " .. cwd
	end

	local config, err = core.read_json(config_file)
	if err or type(config) ~= "table" then
		return false, "Invalid p5.json format"
	end

	if config.includes ~= nil then
		if type(config.includes) ~= "table" then
			return false, "p5.json: 'includes' must be an array"
		end
		for _, item in ipairs(config.includes) do
			if type(item) ~= "string" then
				return false, "p5.json: 'includes' must contain only strings"
			end
		end
	end

	if config.libs ~= nil then
		if type(config.libs) ~= "table" then
			return false, "p5.json: 'libs' must be an object"
		end
		for key, value in pairs(config.libs) do
			if type(key) ~= "string" then
				return false, "p5.json: 'libs' keys must be strings"
			end
			if type(value) ~= "string" then
				return false, "p5.json: 'libs' values must be strings (versions)"
			end
		end
	end

	local sketch_file = cwd .. "/sketch.js"
	local has_sketch = core.is_file(sketch_file)

	local includes = config.includes or { "sketch.js" }

	return true,
		"Valid p5.js sketchspace detected",
		{
			has_sketch = has_sketch,
			has_index = core.is_file(cwd .. "/index.html"),
			config = config,
			includes = includes,
			project_root = cwd,
		}
end

return P
