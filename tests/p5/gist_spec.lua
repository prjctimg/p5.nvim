local C = require("p5.core")

local orig_is_cmd = C.is_cmd
C.is_cmd = function(cmd) return cmd == "gh" end

package.loaded["p5.gist"] = nil
local G = require("p5.gist")

describe("G.includes", function()
	it("includes sketch.js by default", function()
		local r = G.includes({})
		assert.are.same({ "sketch.js", "p5.json" }, r)
	end)

	it("includes explicitly listed files", function()
		local r = G.includes({ includes = { "foo.js", "bar.js" } })
		assert.are.same({ "foo.js", "bar.js", "p5.json" }, r)
	end)

	it("excludes skchbk/ directory entries", function()
		local r = G.includes({ includes = { "sketch.js", "skchbk/test.js" } })
		assert.are.same({ "sketch.js", "p5.json" }, r)
	end)

	it("excludes assets/ directory entries", function()
		local r = G.includes({ includes = { "sketch.js", "assets/lib.js", "assets" } })
		assert.are.same({ "sketch.js", "p5.json" }, r)
	end)

	it("always includes p5.json", function()
		local r = G.includes({ includes = { "sketch.js" } })
		local has_p5 = false
		for _, f in ipairs(r) do
			if f == "p5.json" then has_p5 = true end
		end
		assert.is_true(has_p5)
	end)

	it("skips non-string includes with warning", function()
		local r = G.includes({ includes = { "sketch.js", 42, true } })
		assert.are.same({ "sketch.js", "p5.json" }, r)
	end)

	it("skips unsafe paths (path traversal, absolute paths)", function()
		local r = G.includes({ includes = { "../escape.js", "/abs.js", "~user.js", "sketch.js" } })
		assert.are.same({ "sketch.js", "p5.json" }, r)
	end)
end)

describe("G.skchbk_clone", function()
	local tmp_dir

	before_each(function()
		tmp_dir = vim.fn.tempname()
		vim.fn.mkdir(tmp_dir, "p")
	end)

	after_each(function()
		vim.fn.delete(tmp_dir, "rf")
	end)

	it("reports when no gists are found", function()
		local orig_system = vim.fn.system
		vim.fn.system = function(cmd)
			if cmd[1] == "gh" and cmd[2] == "api" then
				return "[]"
			end
			return orig_system(cmd)
		end

		local ok, err = pcall(G.skchbk_clone, "testuser", tmp_dir)
		vim.fn.system = orig_system
		if not ok then
			error(err)
		end

		local count = 0
		for _, t in vim.fs.dir(tmp_dir) do
			count = count + 1
		end
		assert.are.equal(0, count)
	end)

	it("clones gists into subdirectories", function()
		local orig_system = vim.fn.system
		local call_count = 0
		vim.fn.system = function(cmd)
			call_count = call_count + 1
			if cmd[1] == "gh" and cmd[2] == "api" then
				return vim.fn.json_encode({
					{
						id = "abc123",
						description = "My First Sketch",
					},
					{
						id = "def456",
						description = "Cool Demo",
					},
				})
			end
			if cmd[1] == "gh" and cmd[2] == "gist" and cmd[3] == "view" then
				local files = {}
				if cmd[4] == "abc123" then
					files["sketch.js"] = { content = "function setup() {\n  createCanvas(400, 400);\n}\n" }
					files["style.css"] = { content = "body { margin: 0; }\n" }
				elseif cmd[4] == "def456" then
					files["sketch.js"] = { content = "function draw() {\n  background(220);\n}\n" }
				end
				return vim.fn.json_encode({ files = files })
			end
			return orig_system(cmd)
		end

		G.skchbk_clone("testuser", tmp_dir)
		vim.fn.system = orig_system

		local dirs = {}
		for entry, type in vim.fs.dir(tmp_dir) do
			if type == "directory" then
				table.insert(dirs, entry)
			end
		end
		table.sort(dirs)

		assert.are.same({ "cool-demo", "my-first-sketch" }, dirs)
		assert.is_true(C.is_file(tmp_dir .. "/my-first-sketch/sketch.js"))
		assert.is_true(C.is_file(tmp_dir .. "/my-first-sketch/style.css"))
		assert.is_true(C.is_file(tmp_dir .. "/cool-demo/sketch.js"))
		assert.are.equal(2, #dirs)
	end)

	it("skips existing directories", function()
		local orig_system = vim.fn.system
		vim.fn.mkdir(tmp_dir .. "/cool-demo", "p")
		vim.fn.writefile({ "old content" }, tmp_dir .. "/cool-demo/sketch.js")

		vim.fn.system = function(cmd)
			if cmd[1] == "gh" and cmd[2] == "api" then
				return vim.fn.json_encode({
					{
						id = "abc123",
						description = "My First Sketch",
					},
					{
						id = "def456",
						description = "Cool Demo",
					},
				})
			end
			if cmd[1] == "gh" and cmd[2] == "gist" and cmd[3] == "view" then
				return vim.fn.json_encode({
					files = {
						["sketch.js"] = { content = "// new content\n" },
					},
				})
			end
			return orig_system(cmd)
		end

		G.skchbk_clone("testuser", tmp_dir)
		vim.fn.system = orig_system

		local content = vim.fn.readfile(tmp_dir .. "/cool-demo/sketch.js")
		assert.are.same({ "old content" }, content,
			"existing dir should not be overwritten")
	end)

	it("handles empty descriptions", function()
		local orig_system = vim.fn.system
		vim.fn.system = function(cmd)
			if cmd[1] == "gh" and cmd[2] == "api" then
				return vim.fn.json_encode({
					{ id = "abc123", description = vim.NIL },
					{ id = "def456", description = "" },
				})
			end
			if cmd[1] == "gh" and cmd[2] == "gist" and cmd[3] == "view" then
				return vim.fn.json_encode({
					files = { ["sketch.js"] = { content = "" } },
				})
			end
			return orig_system(cmd)
		end

		G.skchbk_clone("testuser", tmp_dir)
		vim.fn.system = orig_system

		local dirs = {}
		for entry, type in vim.fs.dir(tmp_dir) do
			if type == "directory" then
				table.insert(dirs, entry)
			end
		end
		table.sort(dirs)
		assert.is_true(#dirs >= 1)
	end)

	it("does not crash on API failure", function()
		local orig_system = vim.fn.system
		vim.fn.system = function(cmd)
			if cmd[1] == "gh" and cmd[2] == "api" then
				return "Not Found"
			end
			return orig_system(cmd)
		end

		G.skchbk_clone("nonexistent-user", tmp_dir)
		vim.fn.system = orig_system
	end)
end)

C.is_cmd = orig_is_cmd
