-- Integration tests for p5.gist using real GitHub API
-- Requires authenticated `gh` CLI with `gist` scope.
-- Gists are created and deleted for each test.
--
-- Run: nvim --headless -c "PlenaryBustedDirectory tests/p5/gist_integration_spec.lua {sequential=true}" -c "qa!"

local C = require("p5.core")
local orig_is_cmd = C.is_cmd
C.is_cmd = function(cmd) return cmd == "gh" end

package.loaded["p5.gist"] = nil
local G = require("p5.gist")

local test_gist_id = nil
local temp_dir = nil
local orig_dir = vim.fn.getcwd()
local ts = tostring(os.time())

local function create_gist(desc, files)
	local cmd = { "gh", "gist", "create", "--public", "--desc", desc }
	for _, f in ipairs(files) do
		table.insert(cmd, f)
	end
	local result = vim.fn.system(cmd)
	if vim.v.shell_error ~= 0 then
		return nil, nil, result
	end
	local url = result:match("https://gist%.github%.com/%S+")
	local id = url and url:match("/([a-fA-F0-9]+)$")
	return id, url
end

local function delete_gist(id)
	if not id or id == "" then
		return
	end
	vim.fn.system({ "gh", "api", "/gists/" .. id, "-X", "DELETE" })
end

local function setup_sketchspace(files)
	local dir = vim.fn.tempname()
	vim.fn.mkdir(dir, "p")
	local config = { version = "2.0.0", major = 2, libs = {}, includes = files or { "sketch.js" } }
	vim.fn.writefile(vim.split(vim.fn.json_encode(config), "\n"), dir .. "/p5.json")
	return dir
end

local function teardown(dir)
	if dir and vim.fn.isdirectory(dir) == 1 then
		vim.fn.delete(dir, "rf")
	end
end

describe("gist integration (real API)", function()

	after_each(function()
		if test_gist_id then
			delete_gist(test_gist_id)
			test_gist_id = nil
		end
		teardown(temp_dir)
		temp_dir = nil
		vim.fn.chdir(orig_dir)
	end)

	it("G.fetch downloads files from a real gist", function()
		-- Create a real gist with known files
		temp_dir = setup_sketchspace({ "sketch.js", "style.css" })
		vim.fn.writefile({ "// integration test sketch" }, temp_dir .. "/sketch.js")
		vim.fn.writefile({ "body { color: blue; }" }, temp_dir .. "/style.css")

		test_gist_id, _ = create_gist("p5-integration-fetch-" .. ts, {
			temp_dir .. "/sketch.js",
			temp_dir .. "/style.css",
		})
		assert.not_nil(test_gist_id, "Failed to create test gist — check gh auth status")

		-- Fetch into a fresh directory
		local fetch_dir = temp_dir .. "/fetched"
		vim.fn.mkdir(fetch_dir, "p")
		local ok, err, done
		G.fetch(test_gist_id, fetch_dir, function(ok_result, err_result)
			ok, err = ok_result, err_result
			done = true
		end)
		vim.wait(15000, function() return done end)
		assert.is_true(ok, "fetch should succeed: " .. tostring(err))
		assert.is_true(C.is_file(fetch_dir .. "/sketch.js"), "should download sketch.js")
		assert.is_true(C.is_file(fetch_dir .. "/style.css"), "should download style.css")

		local content = table.concat(vim.fn.readfile(fetch_dir .. "/sketch.js") or {}, "\n")
		assert.are.equal("// integration test sketch\n", content)
	end)

	it("G.fetch skips files that already exist locally", function()
		temp_dir = setup_sketchspace({ "sketch.js", "data.json" })
		vim.fn.writefile({ "// original" }, temp_dir .. "/sketch.js")
		vim.fn.writefile({ '{"key": "value"}' }, temp_dir .. "/data.json")

		test_gist_id, _ = create_gist("p5-integration-fetch-skip-" .. ts, {
			temp_dir .. "/sketch.js",
			temp_dir .. "/data.json",
		})
		assert.not_nil(test_gist_id)

		-- Pre-create data.json locally with different content
		vim.fn.writefile({ "// existing, should not be overwritten" }, temp_dir .. "/data.json")

		local ok, err, done
		G.fetch(test_gist_id, temp_dir, function(ok_result, err_result)
			ok, err = ok_result, err_result
			done = true
		end)
		vim.wait(15000, function() return done end)
		assert.is_true(ok, "fetch should succeed: " .. tostring(err))
		-- Existing file should retain original content (not overwritten)
		local content = table.concat(vim.fn.readfile(temp_dir .. "/data.json") or {}, "\n")
		assert.are.equal("// existing, should not be overwritten", content,
			"existing file should not be overwritten")
	end)

	it("G.get_comment returns the first comment on a gist", function()
		temp_dir = setup_sketchspace()
		vim.fn.writefile({ "// comment test" }, temp_dir .. "/sketch.js")

		test_gist_id, _ = create_gist("p5-integration-comment-" .. ts, { temp_dir .. "/sketch.js" })
		assert.not_nil(test_gist_id)

		-- Initially no comments
		local cm, done
		G.get_comment(test_gist_id, function(r) cm = r; done = true end)
		vim.wait(15000, function() return done end)
		assert.is_nil(cm, "new gist should have no comments")

		-- Create a comment directly via the API
		local tmpf = temp_dir .. "/cm.json"
		vim.fn.writefile(vim.split(vim.fn.json_encode({ body = "Integration test description" }), "\n"), tmpf)
		vim.fn.system({ "gh", "api", "/gists/" .. test_gist_id .. "/comments", "--input", tmpf })
		assert.are.equal(0, vim.v.shell_error, "should create comment via API")

		-- Now get_comment should return it
		done = nil; cm = nil
		G.get_comment(test_gist_id, function(r) cm = r; done = true end)
		vim.wait(15000, function() return done end)
		assert.are.same("Integration test description", cm.body)
	end)

	it("G.create_comment creates a comment via the API", function()
		temp_dir = setup_sketchspace()
		vim.fn.writefile({ "// create comment test" }, temp_dir .. "/sketch.js")

		test_gist_id, _ = create_gist("p5-integration-create-comment-" .. ts, { temp_dir .. "/sketch.js" })
		assert.not_nil(test_gist_id)

		local ok, done
		G.create_comment(test_gist_id, "Created from integration test", function(ok_result)
			ok = ok_result; done = true
		end)
		vim.wait(15000, function() return done end)
		assert.is_true(ok, "create_comment should succeed")

		local cm
		G.get_comment(test_gist_id, function(r) cm = r; done = true end)
		vim.wait(15000, function() return done end)
		assert.are.same("Created from integration test", cm.body)
	end)

	it("G.update_comment updates an existing comment", function()
		temp_dir = setup_sketchspace()
		vim.fn.writefile({ "// update comment test" }, temp_dir .. "/sketch.js")

		test_gist_id, _ = create_gist("p5-integration-update-comment-" .. ts, { temp_dir .. "/sketch.js" })
		assert.not_nil(test_gist_id)

		-- Create initial comment
		local ok, done
		G.create_comment(test_gist_id, "Original comment body", function(ok_result)
			ok = ok_result; done = true
		end)
		vim.wait(15000, function() return done end)
		assert.is_true(ok)

		local cm
		G.get_comment(test_gist_id, function(r) cm = r; done = true end)
		vim.wait(15000, function() return done end)
		assert.not_nil(cm)

		-- Update it
		done = nil; ok = nil
		G.update_comment(test_gist_id, cm.id, "Updated comment body", function(ok_result)
			ok = ok_result; done = true
		end)
		vim.wait(15000, function() return done end)
		assert.is_true(ok, "update_comment should succeed")

		G.get_comment(test_gist_id, function(r) cm = r; done = true end)
		vim.wait(15000, function() return done end)
		assert.are.same("Updated comment body", cm.body)
	end)

	it("G.clone downloads gists for a user", function()
		local clone_dir = vim.fn.tempname()
		vim.fn.mkdir(clone_dir, "p")

		-- Create a gist under our user so there is something to clone
		local src = vim.fn.tempname()
		vim.fn.writefile({ "// clone integration test sketch" }, src)
		local cid, _ = create_gist("p5-integration-clone-" .. ts, { src })
		assert.not_nil(cid, "should create gist for clone test")

		-- Clone the current user's gists
		G.clone("prjctimg", clone_dir, "all")

		-- Wait for async clone to finish
		vim.wait(30000, function()
			for _, etype in vim.fs.dir(clone_dir) do
				if etype == "directory" then return true end
			end
		end)

		-- Cleanup the test gist
		delete_gist(cid)

		-- After clone, we should find at least one directory with sketch.js
		local found = false
		for entry, etype in vim.fs.dir(clone_dir) do
			if etype == "directory"
				and C.is_file(clone_dir .. "/" .. entry .. "/sketch.js")
			then
				found = true
				break
			end
		end
		assert.is_true(found, "should clone at least one gist with sketch.js")
		teardown(clone_dir)
	end)
end)

C.is_cmd = orig_is_cmd
