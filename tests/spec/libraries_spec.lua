local helpers = require("tests.helpers")
local core = helpers.load_module("p5.core")
local libraries = helpers.load_module("p5.libraries")

describe("p5.libraries", function()
  describe("load_libs_json", function()
    it("returns a table", function()
      local libs = libraries.load_libs_json()
      assert.is_table(libs)
    end)
  end)

  describe("load", function()
    helpers.with_temp_dir(function(temp_dir)
      it("includes core modules", function()
        vim.fn.chdir(temp_dir)
        helpers.create_p5_json(temp_dir, {version = "1.9.0"})
        
        local libs = libraries.load()
        
        assert.is_true(vim.tbl_contains(libs, "p5"))
        assert.is_true(vim.tbl_contains(libs, "p5.sound"))
      end)

      it("includes contrib libs from config", function()
        vim.fn.chdir(temp_dir)
        helpers.create_p5_json(temp_dir, {
          version = "1.9.0",
          libs = {ml5 = "latest", rita = "latest"}
        })
        
        local libs = libraries.load()
        
        assert.is_true(vim.tbl_contains(libs, "ml5"))
        assert.is_true(vim.tbl_contains(libs, "rita"))
      end)
    end)
  end)

  describe("get_library_info", function()
    it("returns nil for non-existent library", function()
      local info = libraries.get_library_info("nonexistent_library_xyz")
      assert.is_nil(info)
    end)

    it("returns library info when found", function()
      local info = libraries.get_library_info("ml5")
      if info then
        assert.is_string(info.name)
      end
    end)
  end)

  describe("get_available_libs", function()
    it("returns a table of libraries", function()
      local libs = libraries.get_available_libs()
      assert.is_table(libs)
    end)

    it("includes status field", function()
      local libs = libraries.get_available_libs()
      for _, lib in ipairs(libs) do
        assert.is_string(lib.name)
        assert.is_string(lib.status)
        assert.is_boolean(lib.installed)
      end
    end)
  end)

  describe("get_installed_libs", function()
    helpers.with_temp_dir(function(temp_dir)
      it("returns empty when no libs directory", function()
        vim.fn.chdir(temp_dir)
        
        local installed = libraries.get_installed_libs()
        assert.is_table(installed)
        assert.are.equal(0, #installed)
      end)

      it("returns installed libraries", function()
        vim.fn.chdir(temp_dir)
        vim.fn.mkdir("assets/libs", "p")
        vim.fn.writefile({"// test"}, "assets/libs/ml5.js")
        
        local installed = libraries.get_installed_libs()
        
        assert.is_true(#installed > 0)
        local found = false
        for _, lib in ipairs(installed) do
          if lib.name == "ml5" then
            found = true
            break
          end
        end
        assert.is_true(found)
      end)
    end)
  end)

  describe("validate_libs", function()
    helpers.with_temp_dir(function(temp_dir)
      it("returns 0 cleaned when no index.html", function()
        vim.fn.chdir(temp_dir)
        
        local result = libraries.validate_libs()
        
        assert.are.equal(0, result.cleaned)
      end)
    end)
  end)

  describe("add_library", function()
    helpers.with_temp_dir(function(temp_dir)
      it("adds library to config", function()
        vim.fn.chdir(temp_dir)
        helpers.create_p5_json(temp_dir, {version = "1.9.0", libs = {}})
        
        libraries.add_library("ml5", "latest")
        
        local config = core.read_workspace_config()
        assert.are.equal("latest", config.libs.ml5)
      end)

      it("warns when library already exists", function()
        vim.fn.chdir(temp_dir)
        helpers.create_p5_json(temp_dir, {
          version = "1.9.0",
          libs = {ml5 = "1.0.0"}
        })
        
        local warned = false
        local original_notify = core.notify
        core.notify = function(msg, level)
          if msg:find("already exists") then
            warned = true
          end
        end
        
        libraries.add_library("ml5", "latest")
        
        core.notify = original_notify
        assert.is_true(warned)
      end)

      it("creates config if not exists", function()
        vim.fn.chdir(temp_dir)
        
        libraries.add_library("ml5", "latest")
        
        local config = core.read_workspace_config()
        assert.is_not_nil(config)
        assert.are.equal("latest", config.libs.ml5)
      end)
    end)
  end)

  describe("uninstall_libs", function()
    helpers.with_temp_dir(function(temp_dir)
      it("warns when no libraries specified", function()
        local warned = false
        local original_notify = core.notify
        core.notify = function(msg, level)
          if msg:find("No libraries specified") then
            warned = true
          end
        end
        
        libraries.uninstall_libs(nil)
        
        core.notify = original_notify
        assert.is_true(warned)
      end)
    end)
  end)

  describe("generate_libs_js", function()
    helpers.with_temp_dir(function(temp_dir)
      it("creates libs.js file", function()
        vim.fn.chdir(temp_dir)
        vim.fn.mkdir("assets/libs", "p")
        
        libraries.generate_libs_js(temp_dir)
        
        local libs_path = "assets/libs/libs.js"
        assert.is_true(core.is_file(libs_path))
      end)

      it("libs.js contains runtime fetch logic", function()
        vim.fn.chdir(temp_dir)
        vim.fn.mkdir("assets/libs", "p")
        
        libraries.generate_libs_js(temp_dir)
        
        local content = vim.fn.readfile("assets/libs/libs.js")
        local code = table.concat(content, "\n")
        
        assert.is_true(code:find("p5.json"))
        assert.is_true(code:find("fetch"))
      end)
    end)
  end)

  describe("validate_download", function()
    helpers.with_temp_dir(function(temp_dir)
      it("returns false for missing file", function()
        local valid = libraries.validate_download("/nonexistent/file.js")
        assert.is_false(valid)
      end)

      it("returns false for file too small", function()
        local file_path = temp_dir .. "/tiny.js"
        vim.fn.writefile({"x"}, file_path)
        
        local valid = libraries.validate_download(file_path)
        assert.is_false(valid)
      end)

      it("returns false for HTML error pages", function()
        local file_path = temp_dir .. "/error.html"
        vim.fn.writefile({"<!DOCTYPE html><html><body>404 Not Found</body></html>"}, file_path)
        
        local valid = libraries.validate_download(file_path)
        assert.is_false(valid)
      end)

      it("returns true for valid JavaScript", function()
        local file_path = temp_dir .. "/valid.js"
        local content = "function test() { return true; }"
        vim.fn.writefile({string.rep(content, 10)}, file_path)
        
        local valid = libraries.validate_download(file_path)
        assert.is_true(valid)
      end)
    end)
  end)

  describe("install_libs", function()
    helpers.with_temp_dir(function(temp_dir)
      it("warns when no libraries selected", function()
        vim.fn.chdir(temp_dir)
        
        local warned = false
        local original_notify = core.notify
        core.notify = function(msg, level)
          if msg:find("No libraries selected") then
            warned = true
          end
        end
        
        libraries.install_libs(nil)
        
        core.notify = original_notify
        assert.is_true(warned)
      end)
    end)
  end)

  describe("update_libs", function()
    helpers.with_temp_dir(function(temp_dir)
      it("warns when no libraries installed", function()
        vim.fn.chdir(temp_dir)
        helpers.create_p5_json(temp_dir, {version = "1.9.0", libs = {}})
        
        local warned = false
        local original_notify = core.notify
        core.notify = function(msg, level)
          if msg:find("No libraries installed") then
            warned = true
          end
        end
        
        libraries.update_libs()
        
        core.notify = original_notify
        assert.is_true(warned)
      end)
    end)
  end)

  describe("setup", function()
    it("merges config with defaults", function()
      local config = {
        libraries_dir = "custom/libs",
        types_dir = "custom/types"
      }
      libraries.setup(config)
      
      assert.is_not_nil(libraries.config)
      assert.are.equal("custom/libs", libraries.config.libraries_dir)
      assert.are.equal("custom/types", libraries.config.types_dir)
    end)
  end)
end)
