local P = {}
local core = require("p5.core")
local libraries = require("p5.libraries")
local notify = core.notify

local CDN = "https://cdn.jsdelivr.net/npm/p5"

P.V1_VERSION = "1.11.3"

P.download_p5_assets = function(project_path, version, callback)
	local major = core.parse_major(version)
	local libs_dir = project_path .. "/assets/libs"
	local types_dir = project_path .. "/assets/types"
	core.mkdir(libs_dir)
	core.mkdir(types_dir)

	local urls = { lib = CDN .. "@" .. version .. "/lib/p5.min.js" }
	if major == 1 then
		urls.sound = CDN .. "@" .. version .. "/lib/addons/p5.sound.min.js"
	end
	urls.types = CDN .. "@" .. version .. "/types/p5.d.ts"

	local downloads = { { url = urls.lib, dest = libs_dir .. "/p5.js" } }
	if urls.sound then
		table.insert(downloads, { url = urls.sound, dest = libs_dir .. "/p5.sound.js" })
	end
	table.insert(downloads, { url = urls.types, dest = types_dir .. "/p5.d.ts" })

	local pending = #downloads
	for _, d in ipairs(downloads) do
		core.fetch(d.url, d.dest, function(ok)
			if not ok then
				notify("Download failed: " .. d.url, "warn")
			end
			pending = pending - 1
			if pending == 0 and callback then
				callback()
			end
		end, { cache = true })
	end
end

P.create_project = function(name, major)
	major = major or 2
	name = name or "p5-sketch"

	if vim.fn.isdirectory(name) ~= 0 then
		notify("Directory '" .. name .. "' already exists", "info")
		return false
	end

	local path = vim.fn.fnamemodify(name, ":p")

	local search_dir = vim.fn.fnamemodify(path, ":h")
	while search_dir and #search_dir > 1 do
		if core.is_file(search_dir .. "/p5.json") then
			notify("Cannot create project inside existing sketchspace at " .. search_dir, "error")
			return false
		end
		local parent = vim.fn.fnamemodify(search_dir, ":h")
		if parent == search_dir then break end
		search_dir = parent
	end

	core.mkdir(path)

	local function finish(version)
		P.create_project_continue(name, version)
	end

	if major == 1 then
		P.download_p5_assets(path, P.V1_VERSION, function()
			finish(P.V1_VERSION)
		end)
	else
		notify("Fetching latest p5.js version...", "info")
		core.fetch_latest_p5_version(function(version)
			version = version or core.DEFAULT_P5_VERSION
			notify("Downloading p5.js " .. version .. "...", "info")
			P.download_p5_assets(path, version, function()
				finish(version)
			end)
		end)
	end
end

function P.create_project_continue(name, override_version)
	local path = vim.fn.fnamemodify(name, ":p")

	P.copy_favicon(path)

	local version = core.p5_version(override_version)
	local major = core.parse_major(version)
	local sound_script = major == 1 and '\n  <script src="assets/libs/p5.sound.js"></script>' or ""
	local index_html = [[<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>p5.js Sketch</title>
  <link rel="icon" type="image/x-icon" href="assets/favicon.ico">
  <script src="assets/libs/p5.js"></script>~~sound_script~~
  <script src="assets/libs/libs.js"></script>
</head>
<body>
  <main>
  </main>
  <script src="sketch.js"></script>
</body>
</html>]]
	vim.fn.writefile(vim.split(index_html:gsub("~~sound_script~~", sound_script), "\n"), path .. "/index.html")

	local sketch_js = [[const sketch = (p) => {
  p.setup = () => {
    p.createCanvas(400, 400);
  };

  p.draw = () => {
    p.background(220);
    p.circle(p.mouseX, p.mouseY, 50);
  };
};

new p5(sketch);
]]
	vim.fn.writefile(vim.split(sketch_js, "\n"), path .. "/sketch.js")

	local tsconfig = [[{
  "compilerOptions": {
    "target": "ES2022",
    "module": "ESNext",
    "lib": ["DOM", "ES2022"],
    "strict": true,
    "allowJs": true,
    "checkJs": true,
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
		version = version,
		libs = vim.empty_dict(),
		includes = { "sketch.js" },
	}
	vim.fn.writefile(vim.split(vim.json.encode(p5_config), "\n"), path .. "/p5.json")

	core.mkdir(path .. "/assets/types")
	core.mkdir(path .. "/assets/libs")
	libraries.generate_libs_js(path)

	notify("Sketchspace created: " .. name, "ok")
	vim.api.nvim_set_current_dir(path)
	vim.cmd({ cmd = "edit", args = { path .. "/sketch.js" } })
end

P.copy_favicon = function(project_path)
	local src = core.asset_dir() .. "/favicon.ico"
	local dest = project_path .. "/assets/favicon.ico"
	core.mkdir(project_path .. "/assets")
	if vim.uv and vim.uv.fs_copyfile then
		vim.uv.fs_copyfile(src, dest)
	else
		vim.fn.system({ "cp", src, dest })
	end
end

P.ensure_assets = function(project_path, callback)
	local config = core.read_workspace_config()
	local version = config and config.version or core.DEFAULT_P5_VERSION
	local major = core.parse_major(version)
	local libs_dir = project_path .. "/assets/libs"
	local p5_file = libs_dir .. "/p5.js"

	if core.is_file(p5_file) then
		P.copy_favicon(project_path)
		if callback then callback() end
		return
	end

	core.mkdir(libs_dir)
	core.mkdir(project_path .. "/assets/types")

	if major == 1 then
		P.download_p5_assets(project_path, P.V1_VERSION, function()
			P.copy_favicon(project_path)
			if callback then callback() end
		end)
	else
		notify("Fetching latest p5.js version...", "info")
		core.fetch_latest_p5_version(function(version)
			version = version or core.DEFAULT_P5_VERSION
			notify("Downloading p5.js " .. version .. "...", "info")
			P.download_p5_assets(project_path, version, function()
				P.copy_favicon(project_path)
				if callback then callback() end
			end)
		end)
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
