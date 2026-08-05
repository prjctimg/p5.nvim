describe("spawn guard", function()
	it("drops chrome browser spawns", function()
		assert.are.equal(1, vim.fn.jobstart({ "google-chrome", "http://localhost:8000" }))
	end)

	it("drops curl spawns", function()
		assert.are.equal(1, vim.fn.jobstart({ "curl", "-s", "http://localhost:8000/api/cdp/status" }))
	end)

	it("drops xdg-open spawns", function()
		assert.are.equal("", vim.fn.system({ "xdg-open", "http://localhost:8000" }))
	end)

	it("fails vim.system browser spawns through the callback", function()
		local done, res
		vim.system({ "google-chrome", "http://localhost:8000" }, nil, function(r)
			res = r
			done = true
		end)
		assert.is_true(done, "callback should fire synchronously")
		assert.are.equal(1, res.code)
	end)

	it("never invokes the real process for allowed commands", function()
		local exited = false
		vim.fn.jobstart({ "true" }, {
			on_exit = function()
				exited = true
			end,
		})
		assert.is_true(exited, "on_exit should fire synchronously without spawning")
	end)
end)
