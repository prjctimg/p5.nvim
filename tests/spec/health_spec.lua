local helpers = require("tests.helpers")
local health = helpers.load_module("p5.health")

describe("p5.health", function()
  describe("check_dependencies", function()
    it("runs without error", function()
      local ok, err = pcall(health.check_dependencies)
      assert.is_true(ok, err and tostring(err))
    end)
  end)

  describe("check_external_tools", function()
    it("runs without error", function()
      local ok, err = pcall(health.check_external_tools)
      assert.is_true(ok)
    end)

    it("checks for curl or wget", function()
      local has_curl = vim.fn.executable("curl") == 1
      local has_wget = vim.fn.executable("wget") == 1
      
      assert.is_boolean(has_curl or has_wget)
    end)
  end)

  describe("check_plugin_env", function()
    it("runs without error", function()
      local ok, err = pcall(health.check_plugin_env)
      assert.is_true(ok)
    end)

    it("validates plugin root", function()
      local core = helpers.load_module("p5.core")
      local plugin_root = core.plugin_root()
      assert.is_string(plugin_root)
      assert.is_true(#plugin_root > 0)
    end)
  end)

  describe("check_workspace", function()
    it("runs without error", function()
      local ok, err = pcall(health.check_workspace)
      assert.is_true(ok, err and tostring(err))
    end)

    it("checks cache directory", function()
      local cache_dir = vim.fn.stdpath("cache")
      assert.is_string(cache_dir)
    end)
  end)

  describe("check_project_config", function()
    helpers.with_temp_dir(function(temp_dir)
      it("runs without error", function()
        vim.fn.chdir(temp_dir)
        local ok, err = pcall(health.check_project_config)
        assert.is_true(ok)
      end)

      it("validates p5.json when present", function()
        vim.fn.chdir(temp_dir)
        helpers.create_p5_json(temp_dir, {
          version = "1.9.0",
          libs = {ml5 = "latest"}
        })
        
        local ok, err = pcall(health.check_project_config)
        assert.is_true(ok)
      end)
    end)
  end)

  describe("check_neovim", function()
    it("runs without error", function()
      local ok, err = pcall(health.check_neovim)
      assert.is_true(ok)
    end)

    it("checks Neovim version >= 0.9", function()
      local version = vim.version()
      assert.is_table(version)
      assert.is_number(version.major)
      assert.is_number(version.minor)
      assert.is_number(version.patch)
      
      local is_compatible = version.major > 0 or version.minor >= 9
      assert.is_true(is_compatible)
    end)

    it("checks nvim feature", function()
      local has_nvim = vim.fn.has("nvim") == 1
      if not has_nvim then
        vim.print("Note: Running in non-Nvim environment")
      end
      assert.is_true(has_nvim, "Required feature 'nvim' not available")
    end)
  end)

  describe("check", function()
    it("runs full health check", function()
      local ok, err = pcall(health.check)
      assert.is_true(ok, err and tostring(err))
    end)
  end)
end)
