local orig_health = vim.health
local logged = {}

describe("health", function()
  local H

  before_each(function()
    logged = {}
    vim.health = {
      start = function(_) end,
      ok = function(msg) table.insert(logged, { level = "ok", msg = msg }) end,
      error = function(msg) table.insert(logged, { level = "error", msg = msg }) end,
      warn = function(msg) table.insert(logged, { level = "warn", msg = msg }) end,
      info = function(msg) table.insert(logged, { level = "info", msg = msg }) end,
    }
    package.loaded["p5.health"] = nil
    H = require("p5.health")
  end)

  after_each(function()
    vim.health = orig_health
  end)

  describe("check_neovim", function()
    it("reports neovim version", function()
      H.check_neovim()
      local found = false
      for _, entry in ipairs(logged) do
        if entry.level == "ok" and entry.msg:match("Neovim version") then
          found = true
        end
      end
      assert.is_true(found, "should report neovim version")
    end)
  end)
end)
