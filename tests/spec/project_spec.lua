local helpers = require("tests.helpers")
local core = helpers.load_module("p5.core")
local project = helpers.load_module("p5.project")

describe("p5.project", function()
  describe("validate_bundled_assets", function()
    it("returns boolean", function()
      local result = project.validate_bundled_assets()
      assert.is_boolean(result)
    end)
  end)

  describe("is_p5_project", function()
    helpers.with_temp_dir(function(temp_dir)
      it("returns false when no p5.json", function()
        local is_project = project.is_p5_project(temp_dir)
        assert.is_false(is_project)
      end)

      it("returns true with valid p5.json", function()
        helpers.create_p5_json(temp_dir)
        
        local is_project, msg, info = project.is_p5_project(temp_dir)
        
        assert.is_true(is_project)
        assert.is_not_nil(info)
        assert.is_table(info)
      end)

      it("validates p5.json structure", function()
        helpers.create_p5_json(temp_dir, {
          version = "1.9.0",
          libs = {ml5 = "latest"},
          includes = {"sketch.js"}
        })
        
        local is_project, msg, info = project.is_p5_project(temp_dir)
        
        assert.is_true(is_project)
        assert.are.equal("1.9.0", info.config.version)
      end)

      it("rejects invalid includes type", function()
        helpers.create_p5_json(temp_dir, {
          version = "1.9.0",
          includes = "not_an_array"
        })
        
        local is_project = project.is_p5_project(temp_dir)
        assert.is_false(is_project)
      end)

      it("rejects invalid libs type", function()
        helpers.create_p5_json(temp_dir, {
          version = "1.9.0",
          libs = "not_an_object"
        })
        
        local is_project = project.is_p5_project(temp_dir)
        assert.is_false(is_project)
      end)

      it("checks for sketch.js existence", function()
        helpers.create_p5_json(temp_dir)
        helpers.create_sketch_js(temp_dir)
        
        local _, _, info = project.is_p5_project(temp_dir)
        
        assert.is_true(info.has_sketch)
      end)
    end)
  end)

  describe("create_files", function()
    helpers.with_temp_dir(function(temp_dir)
      it("creates index.html", function()
        local project_path = temp_dir .. "/test_project"
        vim.fn.mkdir(project_path, "p")
        
        project.create_files(project_path, function() end)
        
        local index_path = project_path .. "/index.html"
        assert.is_true(core.is_file(index_path))
        
        local content = vim.fn.readfile(index_path)
        local html = table.concat(content, "\n")
        assert.is_true(html:find("p5.js"))
        assert.is_true(html:find("sketch.js"))
      end)

      it("creates sketch.js", function()
        local project_path = temp_dir .. "/sketch_project"
        vim.fn.mkdir(project_path, "p")
        
        project.create_files(project_path, function() end)
        
        local sketch_path = project_path .. "/sketch.js"
        assert.is_true(core.is_file(sketch_path))
        
        local content = vim.fn.readfile(sketch_path)
        local sketch = table.concat(content, "\n")
        assert.is_true(sketch:find("function setup"))
        assert.is_true(sketch:find("function draw"))
      end)

      it("creates p5.json", function()
        local project_path = temp_dir .. "/p5json_project"
        vim.fn.mkdir(project_path, "p")
        
        project.create_files(project_path, function() end)
        
        local p5_path = project_path .. "/p5.json"
        assert.is_true(core.is_file(p5_path))
        
        local config = core.read_json(p5_path)
        assert.is_not_nil(config)
        assert.is_not_nil(config.version)
      end)

      it("creates jsconfig.json", function()
        local project_path = temp_dir .. "/jsconfig_project"
        vim.fn.mkdir(project_path, "p")
        
        project.create_files(project_path, function() end)
        
        local jsconfig_path = project_path .. "/jsconfig.json"
        assert.is_true(core.is_file(jsconfig_path))
        
        local jsconfig = core.read_json(jsconfig_path)
        assert.is_not_nil(jsconfig)
        assert.is_not_nil(jsconfig.compilerOptions)
      end)

      it("creates tsconfig.json", function()
        local project_path = temp_dir .. "/tsconfig_project"
        vim.fn.mkdir(project_path, "p")
        
        project.create_files(project_path, function() end)
        
        local tsconfig_path = project_path .. "/tsconfig.json"
        assert.is_true(core.is_file(tsconfig_path))
        
        local tsconfig = core.read_json(tsconfig_path)
        assert.is_not_nil(tsconfig)
      end)

      it("creates assets directories", function()
        local project_path = temp_dir .. "/assets_project"
        vim.fn.mkdir(project_path, "p")
        
        project.create_files(project_path, function() end)
        
        assert.is_true(core.is_dir(project_path .. "/assets"))
        assert.is_true(core.is_dir(project_path .. "/assets/libs"))
        assert.is_true(core.is_dir(project_path .. "/assets/types"))
      end)

      it("generates libs.js", function()
        local project_path = temp_dir .. "/libs_project"
        vim.fn.mkdir(project_path, "p")
        
        project.create_files(project_path, function() end)
        
        local libs_path = project_path .. "/assets/libs/libs.js"
        assert.is_true(core.is_file(libs_path))
      end)
    end)
  end)

  describe("validate_asset_paths", function()
    helpers.with_temp_dir(function(temp_dir)
      it("validates existing asset paths", function()
        local project_path = temp_dir .. "/validate_project"
        vim.fn.mkdir(project_path, "p")
        project.create_files(project_path, function() end)
        
        local result = project.validate_asset_paths(project_path)
        assert.is_boolean(result)
      end)
    end)
  end)

  describe("setup", function()
    it("stores config", function()
      local config = {server = {port = 9000}}
      project.setup(config)
      assert.is_not_nil(project.config)
    end)
  end)
end)
