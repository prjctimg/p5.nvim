local helpers = require("tests.helpers")
local core = helpers.load_module("p5.core")
local gist = helpers.load_module("p5.gist")

describe("p5.gist", function()
  describe("includes (security filtering)", function()
    it("filters path traversal patterns", function()
      local config = {
        includes = {"../secret", "sketch.js", "config.json"}
      }
      
      local files = gist.includes(config)
      
      assert.is_table(files)
      local has_sketch = false
      for _, f in ipairs(files) do
        if f == "sketch.js" then has_sketch = true end
      end
      assert.is_true(has_sketch)
    end)

    it("filters absolute paths", function()
      local config = {
        includes = {"/etc/passwd", "sketch.js"}
      }
      
      local files = gist.includes(config)
      
      local has_sketch = false
      for _, f in ipairs(files) do
        if f == "sketch.js" then has_sketch = true end
        if f == "/etc/passwd" then
          assert.is_true(false, "Should not include absolute path")
        end
      end
      assert.is_true(has_sketch)
    end)

    it("filters home directory paths", function()
      local config = {
        includes = {"~/secrets", "sketch.js"}
      }
      
      local files = gist.includes(config)
      
      local has_sketch = false
      for _, f in ipairs(files) do
        if f == "sketch.js" then has_sketch = true end
      end
      assert.is_true(has_sketch)
    end)

    it("filters Windows drive letters", function()
      local config = {
        includes = {"C:\\Windows\\System32\\config", "sketch.js"}
      }
      
      local files = gist.includes(config)
      
      local has_sketch = false
      for _, f in ipairs(files) do
        if f == "sketch.js" then has_sketch = true end
      end
      assert.is_true(has_sketch)
    end)

    it("excludes assets/ directory", function()
      local config = {
        includes = {"assets/image.png", "sketch.js", "assets"}
      }
      
      local files = gist.includes(config)
      
      local has_sketch = false
      local has_assets = false
      for _, f in ipairs(files) do
        if f == "sketch.js" then has_sketch = true end
        if f == "assets" or f == "assets/image.png" then has_assets = true end
      end
      assert.is_true(has_sketch)
      assert.is_false(has_assets)
    end)

    it("always includes p5.json", function()
      local config = {
        includes = {"sketch.js"}
      }
      
      local files = gist.includes(config)
      
      local has_p5json = false
      for _, f in ipairs(files) do
        if f == "p5.json" then has_p5json = true end
      end
      assert.is_true(has_p5json)
    end)

    it("handles default includes", function()
      local config = {}
      
      local files = gist.includes(config)
      
      local has_sketch = false
      local has_p5json = false
      for _, f in ipairs(files) do
        if f == "sketch.js" then has_sketch = true end
        if f == "p5.json" then has_p5json = true end
      end
      assert.is_true(has_sketch)
      assert.is_true(has_p5json)
    end)
  end)

  describe("current", function()
    helpers.with_temp_dir(function(temp_dir)
      it("returns nil when no gist in config", function()
        vim.fn.chdir(temp_dir)
        helpers.create_p5_json(temp_dir, {version = "1.9.0"})
        
        local info = gist.current()
        assert.is_nil(info)
      end)

      it("extracts ID from URL", function()
        vim.fn.chdir(temp_dir)
        helpers.create_p5_json(temp_dir, {
          version = "1.9.0",
          gist = "https://gist.github.com/user/abc123def456"
        })
        
        local info = gist.current()
        
        assert.is_not_nil(info)
        assert.are.equal("abc123def456", info.id)
        assert.are.equal("https://gist.github.com/user/abc123def456", info.url)
      end)

      it("handles legacy object format", function()
        vim.fn.chdir(temp_dir)
        helpers.create_p5_json(temp_dir, {
          version = "1.9.0",
          gist = {
            id = "legacy123",
            url = "https://gist.github.com/user/legacy123"
          }
        })
        
        local info = gist.current()
        
        assert.is_not_nil(info)
        assert.are.equal("legacy123", info.id)
      end)
    end)
  end)

  describe("fetch", function()
    helpers.with_temp_dir(function(temp_dir)
      it("returns error when no gist ID provided", function()
        local ok, err = gist.fetch(nil, temp_dir)
        assert.is_false(ok)
        assert.is_not_nil(err)
      end)
    end)
  end)

  describe("setup", function()
    it("stores config", function()
      local config = {test = true}
      gist.setup(config)
      assert.is_not_nil(gist.config)
    end)
  end)
end)
