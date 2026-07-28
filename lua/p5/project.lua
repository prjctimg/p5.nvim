local P = {}
local core = require("p5.core")
local libraries = require("p5.libraries")
local notify = core.notify

P.config = P.config or {}

local TEMPLATES = {
	instance = [[const sketch = (p) => {
  p.setup = () => {
    p.createCanvas(400, 400);
  };

  p.draw = () => {
    p.background(220);
    p.circle(p.mouseX, p.mouseY, 50);
  };
};

new p5(sketch);
]],
	global = [[function setup() {
  createCanvas(400, 400);
}

function draw() {
  background(220);
  circle(mouseX, mouseY, 50);
}
]],
}

local INDEX_HTML = [[<!DOCTYPE html>
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

local TSCONFIG = [[{
  "compilerOptions": {
    "target": "ES2022",
    "module": "ESNext",
    "lib": ["DOM", "ES2022"],
    "strict": true,
    "allowJs": true,
    "checkJs": true,
    "moduleResolution": "bundler",
    "allowSyntheticDefaultImports": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true
  },
  "include": [
    "**/*.ts",
    "**/*.js",
    "assets/types/**/*.d.ts"
  ],
  "exclude": [
    "node_modules",
    "dist",
    "build"
  ]
}]]

P.sketch_template = function(mode)
	return TEMPLATES[mode] or TEMPLATES.instance
end

P.copy_favicon = function(project_path)
	local src = core.asset_dir() .. "/favicon.ico"
	local dest = project_path .. "/assets/favicon.ico"
	core.mkdir(project_path .. "/assets")
	if core.is_file(src) then
		pcall(vim.uv.fs_copyfile, src, dest)
	end
end

P.copy_types = function(project_path)
	local src_dir = core.asset_dir() .. "/types"
	local dest_dir = project_path .. "/assets/types"
	core.mkdir(dest_dir)
	if not core.is_dir(src_dir) then
		return false
	end
	local files = vim.fn.readdir(src_dir) or {}
	local copied = 0
	for _, name in ipairs(files) do
		if name:match("%.d%.ts$") then
			local ok = vim.uv.fs_copyfile(src_dir .. "/" .. name, dest_dir .. "/" .. name)
			if ok then
				copied = copied + 1
			end
		end
	end
	return copied > 0
end

P.hydrate_assets = function(project_path, version, callback)
	local dest = project_path .. "/assets/libs/p5.js"
	core.mkdir(project_path .. "/assets/libs")
	core.ensure_cached_p5(version, dest, function(ok, from_cache)
		P.copy_favicon(project_path)
		P.copy_types(project_path)
		if ok then
			notify(from_cache and ("p5.js " .. version .. " ready (cache)") or ("p5.js " .. version .. " downloaded"), "ok")
		else
			notify("Could not obtain p5.js " .. version .. " (offline or download failed)", "warn")
		end
		if callback then
			callback(ok)
		end
	end)
end

-- Sync filesystem scaffold only (no network)
P.scaffold = function(path, opts)
	opts = opts or {}
	local mode = opts.mode == "global" and "global" or "instance"
	local version = opts.version or core.DEFAULT_P5_VERSION

	core.mkdir(path)
	core.mkdir(path .. "/assets/libs")
	core.mkdir(path .. "/assets/types")

	P.copy_favicon(path)
	P.copy_types(path)

	vim.fn.writefile(vim.split(INDEX_HTML, "\n"), path .. "/index.html")
	vim.fn.writefile(vim.split(P.sketch_template(mode), "\n"), path .. "/sketch.js")
	vim.fn.writefile(vim.split(TSCONFIG, "\n"), path .. "/tsconfig.json")

	local p5_config = {
		version = version,
		mode = mode,
		libs = vim.empty_dict(),
		includes = { "sketch.js" },
	}
	core.write_json(path .. "/p5.json", p5_config)
	pcall(libraries.generate_libs_js, path)
	return true
end

local function open_project(path, name)
	notify("Sketchspace created: " .. name, "ok")
	vim.api.nvim_set_current_dir(path)
	core.add_ss(path)
	vim.cmd({ cmd = "edit", args = { path .. "/sketch.js" } })
end

local function after_scaffold(path, name, mode, preferred)
	open_project(path, name)
	core.resolve_p5_version({
		preferred = preferred or core.p5_version(),
		prompt = true,
		on_done = function(version)
			local cfg = core.read_json(path .. "/p5.json") or {}
			cfg.version = version
			cfg.mode = mode
			core.write_json(path .. "/p5.json", cfg)
			P.hydrate_assets(path, version)
		end,
	})
end

P.create_project = function(name, opts)
	opts = opts or {}
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
		if parent == search_dir then
			break
		end
		search_dir = parent
	end

	local function run(mode)
		local preferred = (P.config and P.config.p5 and P.config.p5.version) or core.DEFAULT_P5_VERSION
		P.scaffold(path, { mode = mode, version = preferred })
		after_scaffold(path, name, mode, preferred)
	end

	local mode = opts.mode
	if not mode and P.config and P.config.sketch then
		mode = P.config.sketch.mode
	end

	if mode == "global" or mode == "instance" then
		run(mode)
		return true
	end

	vim.ui.select({ "global", "instance" }, {
		prompt = "Sketch mode:",
	}, function(choice)
		if not choice then
			return
		end
		run(choice)
	end)
	return true
end

-- Back-compat for tests / callers that only write skeleton
function P.create_project_continue(name, override_version)
	local path = vim.fn.fnamemodify(name, ":p")
	local mode = "instance"
	if P.config and P.config.sketch and P.config.sketch.mode then
		mode = P.config.sketch.mode
	end
	P.scaffold(path, { mode = mode, version = override_version or core.DEFAULT_P5_VERSION })
	open_project(path, name)
	if override_version then
		P.hydrate_assets(path, override_version)
	end
end

P.ensure_assets = function(project_path, callback)
	local config = core.read_workspace_config()
	local version = (config and config.version) or core.DEFAULT_P5_VERSION
	local p5_file = project_path .. "/assets/libs/p5.js"
	local check = not (P.config and P.config.p5 and P.config.p5.check_update == false)

	local function done()
		P.copy_favicon(project_path)
		P.copy_types(project_path)
		if callback then
			callback()
		end
	end

	local function apply(resolved)
		if config and resolved ~= version then
			config.version = resolved
			core.write_workspace_config(config, project_path)
		end
		if core.is_file(p5_file) and resolved == version then
			done()
			return
		end
		P.hydrate_assets(project_path, resolved, function()
			done()
		end)
	end

	if core.is_file(p5_file) and not check then
		done()
		return
	end

	if core.is_file(p5_file) and check then
		-- still allow upgrade prompt; keep existing file if user declines
		core.resolve_p5_version({
			preferred = version,
			prompt = true,
			on_done = function(resolved)
				if resolved == version then
					done()
				else
					apply(resolved)
				end
			end,
		})
		return
	end

	core.resolve_p5_version({
		preferred = version,
		prompt = check,
		on_done = apply,
	})
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
