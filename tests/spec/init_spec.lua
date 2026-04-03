local helpers = require("tests.helpers")
local init = helpers.load_module("p5.init")

describe("p5.init", function()
  describe("config", function()
    it("has default configuration", function()
      assert.is_table(init.config)
    end)

    it("has server configuration", function()
      assert.is_table(init.config.server)
      assert.is_number(init.config.server.port)
    end)

    it("has console configuration", function()
      assert.is_table(init.config.console)
      assert.is_string(init.config.console.position)
    end)

    it("has libraries configuration", function()
      assert.is_table(init.config.libraries)
      assert.is_table(init.config.libraries.cdn_sources)
    end)
  end)

  describe("setup", function()
    it("merges user config with defaults", function()
      init.setup({})
      
      local custom_config = {
        server = {port = 9000},
        console = {position = "above"}
      }
      
      init.setup(custom_config)
      
      assert.are.equal(9000, init.config.server.port)
      assert.are.equal("above", init.config.console.position)
    end)

    it("preserves default values for unspecified options", function()
      init.setup({})
      
      local custom_config = {
        server = {port = 9000}
      }
      
      init.setup(custom_config)
      
      assert.is_number(init.config.console.height)
    end)

    it("creates :P5 command", function()
      init.setup({})
      local exists = vim.api.nvim_get_commands({})["P5"]
      assert.is_table(exists)
    end)
  end)

  describe("server config", function()
    it("has live_reload configuration", function()
      init.setup({})
      
      assert.is_table(init.config.server.live_reload)
      assert.is_boolean(init.config.server.live_reload.enabled)
      assert.is_number(init.config.server.live_reload.port)
      assert.is_number(init.config.server.live_reload.debounce_ms)
      assert.is_table(init.config.server.live_reload.watch_extensions)
      assert.is_table(init.config.server.live_reload.exclude_dirs)
    end)

    it("has auto_open_browser setting", function()
      init.setup({})
      
      assert.is_boolean(init.config.server.auto_open_browser)
    end)
  end)

  describe("console config", function()
    it("has position setting", function()
      init.setup({})
      
      local pos = init.config.console.position
      assert.is_string(pos)
    end)

    it("has height setting", function()
      init.setup({})
      
      assert.is_number(init.config.console.height)
      assert.is_true(init.config.console.height > 0)
    end)
  end)

  describe("libraries config", function()
    it("has cdn_sources", function()
      init.setup({})
      
      assert.is_table(init.config.libraries.cdn_sources)
      assert.is_true(#init.config.libraries.cdn_sources > 0)
    end)

    it("has auto_update setting", function()
      init.setup({})
      
      assert.is_boolean(init.config.libraries.auto_update)
    end)
  end)
end)
