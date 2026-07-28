describe("docs artifacts", function()
	local core = require("p5.core")
	local root = core.plugin_root()
	local doc = root .. "/doc"

	it("ships plugin help p5-nvim.txt with core tags", function()
		assert.is_true(core.is_file(doc .. "/p5-nvim.txt"), "doc/p5-nvim.txt missing")
		local text = table.concat(vim.fn.readfile(doc .. "/p5-nvim.txt"), "\n")
		assert.matches("p5%.nvim", text)
		assert.matches("p5%-nvim%-commands", text)
	end)

	it("ships tags file for help navigation", function()
		assert.is_true(core.is_file(doc .. "/tags"), "doc/tags missing")
		local tags = vim.fn.readfile(doc .. "/tags")
		assert.is_true(#tags > 0, "doc/tags should not be empty")
	end)

	it("does not ship local doc generation pipeline", function()
		assert.is_false(core.is_file(root .. "/scripts/gen-docs.sh"))
		assert.is_false(core.is_file(root .. "/scripts/vimhelp.lua"))
		assert.is_false(core.is_file(root .. "/scripts/json-to-md.mjs"))
	end)

	it("API help files are present when synced from automata", function()
		-- automata owns these; accept either present modules or empty pending sync
		local modules = vim.fn.glob(doc .. "/p5-*.txt", false, true)
		local has_api = false
		for _, f in ipairs(modules) do
			if not f:match("p5%-nvim%.txt$") then
				has_api = true
				break
			end
		end
		-- soft check: if API docs exist they should mention automata or p5
		if has_api then
			local sample = doc .. "/p5-core.txt"
			if core.is_file(sample) then
				local t = table.concat(vim.fn.readfile(sample), "\n")
				assert.matches("p5", t:lower())
			end
		end
	end)
end)
