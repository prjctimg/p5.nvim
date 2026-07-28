local C = require("p5.core")

describe("is_p5_project", function()
	local P = require("p5.project")
	local tmp = vim.fn.tempname()
	local orig_cwd = vim.fn.getcwd()

	before_each(function()
		vim.fn.mkdir(tmp, "p")
		vim.fn.chdir(tmp)
	end)

	after_each(function()
		vim.fn.chdir(orig_cwd)
		vim.fn.delete(tmp, "rf")
	end)

	it("returns false when no p5.json exists", function()
		local ok, msg = P.is_p5_project(tmp)
		assert.is_false(ok)
		assert.matches("No p5%.json found", msg)
	end)

	it("returns true for a valid p5.json", function()
		vim.fn.writefile(vim.split(vim.fn.json_encode({
			version = "2.3.1",
			libs = {},
			includes = { "sketch.js" },
		}), "\n"), tmp .. "/p5.json")
		local ok, _, info = P.is_p5_project(tmp)
		assert.is_true(ok)
		assert.is_true(info.has_sketch == false)
		assert.is_true(info.has_index == false)
	end)

	it("rejects p5.json with non-array includes", function()
		vim.fn.writefile(vim.split(vim.fn.json_encode({
			version = "2.3.1",
			libs = {},
			includes = "sketch.js",
		}), "\n"), tmp .. "/p5.json")
		local ok, msg = P.is_p5_project(tmp)
		assert.is_false(ok)
		assert.matches("includes.*array", msg)
	end)

	it("rejects p5.json with non-string include items", function()
		vim.fn.writefile(vim.split(vim.fn.json_encode({
			version = "2.3.1",
			libs = {},
			includes = { 42 },
		}), "\n"), tmp .. "/p5.json")
		local ok, msg = P.is_p5_project(tmp)
		assert.is_false(ok)
		assert.matches("includes.*strings", msg)
	end)

	it("rejects p5.json with non-object libs", function()
		vim.fn.writefile(vim.split(vim.fn.json_encode({
			version = "2.3.1",
			libs = "ml5",
			includes = { "sketch.js" },
		}), "\n"), tmp .. "/p5.json")
		local ok, msg = P.is_p5_project(tmp)
		assert.is_false(ok)
		assert.matches("libs.*object", msg)
	end)

	it("rejects p5.json with non-string lib keys", function()
		vim.fn.writefile(vim.split(vim.fn.json_encode({
			version = "2.3.1",
			libs = { [42] = "latest" },
			includes = { "sketch.js" },
		}), "\n"), tmp .. "/p5.json")
		local ok, msg = P.is_p5_project(tmp)
		assert.is_false(ok)
		assert.matches("libs.*keys", msg)
	end)

	it("rejects p5.json with non-string lib values", function()
		vim.fn.writefile(vim.split(vim.fn.json_encode({
			version = "2.3.1",
			libs = { ml5 = true },
			includes = { "sketch.js" },
		}), "\n"), tmp .. "/p5.json")
		local ok, msg = P.is_p5_project(tmp)
		assert.is_false(ok)
		assert.matches("libs.*versions", msg)
	end)

	it("detects existing sketch.js and index.html", function()
		vim.fn.writefile(vim.split(vim.fn.json_encode({
			version = "2.3.1",
			libs = {},
			includes = { "sketch.js" },
		}), "\n"), tmp .. "/p5.json")
		vim.fn.writefile({ "// test" }, tmp .. "/sketch.js")
		vim.fn.writefile({ "<html></html>" }, tmp .. "/index.html")
		local ok, _, info = P.is_p5_project(tmp)
		assert.is_true(ok)
		assert.is_true(info.has_sketch)
		assert.is_true(info.has_index)
	end)

	it("defaults includes to sketch.js when absent", function()
		vim.fn.writefile(vim.split(vim.fn.json_encode({
			version = "2.3.1",
			libs = {},
		}), "\n"), tmp .. "/p5.json")
		local ok, _, info = P.is_p5_project(tmp)
		assert.is_true(ok)
		assert.are.same({ "sketch.js" }, info.includes)
	end)

	it("uses custom includes from config", function()
		vim.fn.writefile(vim.split(vim.fn.json_encode({
			version = "2.3.1",
			libs = {},
			includes = { "main.js", "style.css" },
		}), "\n"), tmp .. "/p5.json")
		local ok, _, info = P.is_p5_project(tmp)
		assert.is_true(ok)
		assert.are.same({ "main.js", "style.css" }, info.includes)
	end)
end)

describe("scaffold", function()
	local P = require("p5.project")
	local tmp = vim.fn.tempname()

	after_each(function()
		vim.fn.delete(tmp, "rf")
	end)

	it("creates project skeleton without network", function()
		local path = tmp .. "/skel"
		assert.is_true(P.scaffold(path, { mode = "instance", version = "2.3.1" }))
		assert.is_true(C.is_file(path .. "/index.html"))
		assert.is_true(C.is_file(path .. "/sketch.js"))
		assert.is_true(C.is_file(path .. "/tsconfig.json"))
		assert.is_true(C.is_file(path .. "/p5.json"))
		local config = C.read_json(path .. "/p5.json")
		assert.are.equal("2.3.1", config.version)
		assert.are.equal("instance", config.mode)
		local sketch = table.concat(vim.fn.readfile(path .. "/sketch.js"), "\n")
		assert.matches("new p5%(sketch%)", sketch)
	end)

	it("writes global mode template", function()
		local path = tmp .. "/global"
		P.scaffold(path, { mode = "global", version = "2.3.1" })
		local sketch = table.concat(vim.fn.readfile(path .. "/sketch.js"), "\n")
		assert.matches("function setup%(%)", sketch)
		assert.matches("function draw%(%)", sketch)
		assert.are.equal("global", C.read_json(path .. "/p5.json").mode)
	end)
end)

describe("create_project_continue", function()
	local P = require("p5.project")
	local tmp = vim.fn.tempname()
	local orig_cwd = vim.fn.getcwd()

	before_each(function()
		vim.fn.mkdir(tmp, "p")
		vim.fn.chdir(tmp)
	end)

	after_each(function()
		vim.fn.chdir(orig_cwd)
		vim.fn.delete(tmp, "rf")
	end)

	it("creates project skeleton files", function()
		local name = tmp .. "/testproj"
		-- stub hydrate to avoid network
		local orig = P.hydrate_assets
		P.hydrate_assets = function(_, _, cb)
			if cb then cb(true) end
		end
		P.create_project_continue(name, "2.3.1")
		P.hydrate_assets = orig
		assert.is_true(C.is_file(name .. "/index.html"))
		assert.is_true(C.is_file(name .. "/sketch.js"))
		assert.is_true(C.is_file(name .. "/tsconfig.json"))
		assert.is_true(C.is_file(name .. "/p5.json"))
		local config = C.read_json(name .. "/p5.json")
		assert.are.same({}, config.libs)
	end)
end)

describe("ensure_assets", function()
	local P = require("p5.project")
	local tmp = vim.fn.tempname()

	before_each(function()
		vim.fn.mkdir(tmp, "p")
		vim.fn.mkdir(tmp .. "/assets", "p")
		vim.fn.mkdir(tmp .. "/assets/libs", "p")
	end)

	after_each(function()
		vim.fn.delete(tmp, "rf")
	end)

	it("calls callback immediately when p5.js already exists", function()
		vim.fn.writefile({ "// p5 content" }, tmp .. "/assets/libs/p5.js")
		P.config = { p5 = { check_update = false } }
		local called = false
		P.ensure_assets(tmp, function()
			called = true
		end)
		assert.is_true(called)
		P.config = {}
	end)
end)

describe("create_project", function()
	local P = require("p5.project")
	local tmp = vim.fn.tempname()
	local orig_cwd = vim.fn.getcwd()

	before_each(function()
		vim.fn.mkdir(tmp, "p")
		vim.fn.chdir(tmp)
	end)

	after_each(function()
		vim.fn.chdir(orig_cwd)
		vim.fn.delete(tmp, "rf")
	end)

	it("prevents creating project inside existing p5 project", function()
		vim.fn.writefile(vim.split(vim.fn.json_encode({
			version = "2.3.1",
			libs = {},
			includes = { "sketch.js" },
		}), "\n"), tmp .. "/p5.json")
		local ok = P.create_project("child")
		assert.is_false(ok)
	end)

	it("prevents creating deeply nested project", function()
		vim.fn.mkdir(tmp .. "/sub", "p")
		vim.fn.writefile(vim.split(vim.fn.json_encode({
			version = "2.3.1",
			libs = {},
			includes = { "sketch.js" },
		}), "\n"), tmp .. "/p5.json")
		local ok = P.create_project("sub/deep")
		assert.is_false(ok)
	end)

	it("scaffolds immediately with explicit mode", function()
		local orig_resolve = C.resolve_p5_version
		local orig_hydrate = P.hydrate_assets
		C.resolve_p5_version = function(opts)
			if opts and opts.on_done then opts.on_done("2.3.1", false) end
		end
		P.hydrate_assets = function(_, _, cb)
			if cb then cb(true) end
		end
		local ok = P.create_project("fresh", { mode = "global" })
		assert.is_true(ok)
		assert.is_true(C.is_file(tmp .. "/fresh/sketch.js"))
		local sketch = table.concat(vim.fn.readfile(tmp .. "/fresh/sketch.js"), "\n")
		assert.matches("function setup", sketch)
		C.resolve_p5_version = orig_resolve
		P.hydrate_assets = orig_hydrate
		vim.fn.delete(tmp .. "/fresh", "rf")
	end)
end)

describe("sketch_template", function()
	local P = require("p5.project")

	it("returns instance and global templates", function()
		assert.matches("new p5", P.sketch_template("instance"))
		assert.matches("function setup", P.sketch_template("global"))
		assert.matches("new p5", P.sketch_template(nil))
	end)
end)
