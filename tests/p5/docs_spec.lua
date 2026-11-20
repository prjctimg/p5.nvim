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

	it("does not ship generated tags file and help tags can be generated", function()
		-- Generated doc/tags should not be tracked (avoids stale/duplicate tag conflicts on update)
		local tracked = vim.fn.system({ "git", "-C", root, "ls-files", "--error-unmatch", "doc/tags" })
		assert.is_true(vim.v.shell_error ~= 0, "doc/tags should not be tracked in git")

		-- Help navigation should work via generated tags without duplicate tag errors
		local tmp = vim.fn.tempname()
		vim.fn.mkdir(tmp .. "/doc", "p")
		for _, f in ipairs(vim.fn.glob(doc .. "/*.txt", false, true)) do
			vim.fn.writefile(vim.fn.readfile(f), tmp .. "/doc/" .. vim.fn.fnamemodify(f, ":t"))
		end
		vim.cmd("silent! helptags " .. vim.fn.fnameescape(tmp .. "/doc"))
		assert.is_true(core.is_file(tmp .. "/doc/tags"), "generated doc/tags missing")
		local tags = vim.fn.readfile(tmp .. "/doc/tags")
		assert.is_true(#tags > 0, "generated doc/tags should not be empty")
		vim.fn.delete(tmp, "rf")
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
