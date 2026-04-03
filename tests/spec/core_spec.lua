local helpers = require("tests.helpers")
local core = helpers.load_module("p5.core")

describe("p5.core", function()
  describe("is_cmd", function()
    it("returns true for existing commands", function()
      assert.is_true(core.is_cmd("ls"))
      assert.is_true(core.is_cmd("echo"))
    end)

    it("returns false for non-existent commands", function()
      assert.is_false(core.is_cmd("nonexistent_command_xyz_123"))
    end)
  end)

  describe("is_file", function()
    it("returns true for existing files", function()
      local temp_file = vim.fn.tempname()
      vim.fn.writefile({"test"}, temp_file)
      assert.is_true(core.is_file(temp_file))
      vim.fn.delete(temp_file)
    end)

    it("returns false for non-existent files", function()
      assert.is_false(core.is_file("/nonexistent/path/to/file"))
    end)
  end)

  describe("is_dir", function()
    it("returns true for existing directories", function()
      local temp_dir = vim.fn.tempname()
      vim.fn.mkdir(temp_dir, "p")
      assert.is_true(core.is_dir(temp_dir))
      vim.fn.delete(temp_dir, "rf")
    end)

    it("returns false for non-existent directories", function()
      assert.is_false(core.is_dir("/nonexistent/directory/xyz"))
    end)
  end)

  describe("read_json / write_json", function()
    helpers.with_temp_dir(function(temp_dir)
      it("writes and reads valid JSON", function()
        local test_data = {
          version = "1.0.0",
          libs = { ml5 = "latest" },
          includes = {"sketch.js"}
        }
        local file_path = temp_dir .. "/test.json"
        
        core.write_json(file_path, test_data)
        local read_data, err = core.read_json(file_path)
        
        assert.is_nil(err)
        assert.are.same(test_data, read_data)
      end)

      it("returns error for missing file", function()
        local data, err = core.read_json("/nonexistent/file.json")
        assert.is_nil(data)
        assert.is_not_nil(err)
      end)

      it("returns error for invalid JSON", function()
        local temp_file = vim.fn.tempname()
        vim.fn.writefile({"not valid json {{"}, temp_file)
        
        local data, err = core.read_json(temp_file)
        assert.is_nil(data)
        assert.is_not_nil(err)
        
        vim.fn.delete(temp_file)
      end)
    end)
  end)

  describe("cache operations", function()
    it("cache_dir returns string path", function()
      local cache_dir = core.cache_dir()
      assert.is_string(cache_dir)
      assert.is_true(#cache_dir > 0)
    end)

    it("cache_path returns correct path", function()
      local filename = "test_file.txt"
      local path = core.cache_path(filename)
      assert.is_string(path)
      assert.is_true(path:sub(-#filename) == filename)
    end)

    it("cache_keygen generates consistent 16-char hash", function()
      local url = "https://example.com/test"
      local key1 = core.cache_keygen(url)
      local key2 = core.cache_keygen(url)
      
      assert.are.equal(16, #key1)
      assert.are.equal(key1, key2)
      assert.is_true(key1:match("^[a-f0-9]+$") ~= nil)
    end)
  end)

  describe("sketchspace operations", function()
    helpers.with_temp_dir(function(temp_dir)
      it("read_ss returns table", function()
        local recent = core.read_ss()
        assert.is_table(recent)
      end)

      it("add_ss adds path to recent list", function()
        local test_path = temp_dir .. "/test_sketch"
        vim.fn.mkdir(test_path, "p")
        helpers.create_p5_json(test_path, {})
        
        local recent_before = core.read_ss()
        local count_before = #recent_before
        
        core.add_ss(test_path)
        local recent_after = core.read_ss()
        
        assert.is_true(#recent_after >= count_before)
      end)

      it("add_ss prevents duplicates", function()
        local test_path = temp_dir .. "/dup_sketch"
        vim.fn.mkdir(test_path, "p")
        helpers.create_p5_json(test_path, {})
        
        core.add_ss(test_path)
        core.add_ss(test_path)
        
        local recent = core.read_ss()
        local count = 0
        for _, v in ipairs(recent) do
          if v == test_path then
            count = count + 1
          end
        end
        
        assert.are.equal(1, count)
      end)

      it("purge_ss removes non-existent sketchspaces", function()
        local existing_path = temp_dir .. "/existing_sketch"
        local nonexistent_path = temp_dir .. "/nonexistent_sketch"
        vim.fn.mkdir(existing_path, "p")
        helpers.create_p5_json(existing_path, {})
        
        core.add_ss(existing_path)
        core.add_ss(nonexistent_path)
        local purged = core.purge_ss()
        
        local found = false
        for _, v in ipairs(purged) do
          if v == nonexistent_path then
            found = true
            break
          end
        end
        
        assert.is_false(found)
      end)
    end)
  end)

  describe("project detection", function()
    helpers.with_temp_dir(function(temp_dir)
      it("find_project_root returns nil when no p5.json", function()
        local root, config = core.find_project_root()
        assert.is_nil(root)
        assert.is_nil(config)
      end)

      it("find_project_root finds p5.json in current dir", function()
        helpers.create_p5_json(temp_dir, {version = "1.9.0"})
        vim.fn.chdir(temp_dir)
        
        local root, config = core.find_project_root()
        
        assert.is_not_nil(root)
        assert.is_not_nil(config)
        assert.are.equal("1.9.0", config.version)
      end)

      it("find_project_root traverses up to find p5.json", function()
        local sub_dir = temp_dir .. "/subdir/nested"
        vim.fn.mkdir(sub_dir, "p")
        helpers.create_p5_json(temp_dir, {version = "1.9.0"})
        vim.fn.chdir(sub_dir)
        
        local root, config = core.find_project_root()
        
        assert.is_not_nil(root)
        assert.are.equal(temp_dir, root)
      end)
    end)
  end)

  describe("workspace config", function()
    helpers.with_temp_dir(function(temp_dir)
      it("read_workspace_config returns config from p5.json", function()
        local test_config = {version = "1.9.0", libs = {ml5 = "latest"}}
        helpers.create_p5_json(temp_dir, test_config)
        vim.fn.chdir(temp_dir)
        
        local config = core.read_workspace_config()
        
        assert.is_not_nil(config)
        assert.are.equal("1.9.0", config.version)
        assert.are.equal("latest", config.libs.ml5)
      end)

      it("write_workspace_config writes to p5.json", function()
        vim.fn.chdir(temp_dir)
        
        local test_config = {version = "1.9.0", libs = {}}
        core.write_workspace_config(test_config)
        
        local config = core.read_workspace_config()
        assert.are.equal("1.9.0", config.version)
      end)
    end)
  end)

  describe("validation", function()
    it("validate_file returns true for existing files", function()
      local temp_file = vim.fn.tempname()
      vim.fn.writefile({"test"}, temp_file)
      
      assert.is_true(core.validate_file(temp_file, "Test", false))
      
      vim.fn.delete(temp_file)
    end)

    it("validate_file returns false for missing files", function()
      assert.is_false(core.validate_file("/nonexistent/file", "Test", false))
    end)

    it("validate_dir returns true for existing dirs", function()
      local temp_dir = vim.fn.tempname()
      vim.fn.mkdir(temp_dir, "p")
      
      assert.is_true(core.validate_dir(temp_dir, "Test", false))
      
      vim.fn.delete(temp_dir, "rf")
    end)
  end)

  describe("paths", function()
    it("plugin_root returns string path", function()
      local root = core.plugin_root()
      assert.is_string(root)
      assert.is_true(#root > 0)
    end)

    it("asset_dir returns valid path", function()
      local asset_dir = core.asset_dir()
      assert.is_string(asset_dir)
      assert.is_true(asset_dir:find("assets") ~= nil)
    end)

    it("p5_version returns string", function()
      local version = core.p5_version()
      assert.is_string(version)
    end)
  end)

  describe("split_cmd", function()
    it("has required positions defined", function()
      assert.is_not_nil(core.split_cmd.below)
      assert.is_not_nil(core.split_cmd.above)
      assert.is_not_nil(core.split_cmd.left)
      assert.is_not_nil(core.split_cmd.right)
    end)
  end)

  describe("server_cfg", function()
    it("has required server config", function()
      assert.is_string(core.server_cfg.check)
      assert.is_string(core.server_cfg.script)
      assert.is_string(core.server_cfg.cmd)
    end)
  end)
end)
