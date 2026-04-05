local helpers = require("tests.helpers")
local core = helpers.load_module("p5.core")
local project = helpers.load_module("p5.project")

describe("p5.project", function()
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

  describe("create_project", function()
    helpers.with_temp_dir(function(temp_dir)
      it("creates project with all files", function()
        local project_path = temp_dir .. "/test_project"
        
        project.create_project(project_path)
        
        assert.is_true(core.is_file(project_path .. "/index.html"))
        assert.is_true(core.is_file(project_path .. "/sketch.js"))
        assert.is_true(core.is_file(project_path .. "/p5.json"))
        assert.is_true(core.is_file(project_path .. "/jsconfig.json"))
        assert.is_true(core.is_file(project_path .. "/tsconfig.json"))
      end)

      it("creates assets directories", function()
        local project_path = temp_dir .. "/assets_project"
        
        project.create_project(project_path)
        
        assert.is_true(core.is_dir(project_path .. "/assets"))
        assert.is_true(core.is_dir(project_path .. "/assets/libs"))
        assert.is_true(core.is_dir(project_path .. "/assets/types"))
      end)

      it("generates libs.js", function()
        local project_path = temp_dir .. "/libs_project"
        
        project.create_project(project_path)
        
        assert.is_true(core.is_file(project_path .. "/assets/libs/libs.js"))
      end)
    end)
  end)

  describe("copy_assets_to_project", function()
    helpers.with_temp_dir(function(temp_dir)
      it("copies assets to project directory", function()
        local project_path = temp_dir .. "/copy_project"
        core.mkdir(project_path)
        
        project.copy_assets_to_project(project_path, function(err)
          assert.is_nil(err)
        end)
      end)
    end)
  end)
end)
