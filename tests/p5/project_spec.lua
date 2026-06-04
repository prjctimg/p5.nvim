local C = require("p5.core")

describe("is_p5_project", function()
  local P = require("p5.project")
  local tmp = vim.fn.tempname()
  local orig_cwd = vim.fn.getcwd()

  before_each(function()
    vim.fn.mkdir(tmp, "p")
    vim.fn.chdir(tmp)
  end)

  after_each(function()
    vim.fn.chdir(orig_cwd)
    vim.fn.delete(tmp, "rf")
  end)

  it("returns false when no p5.json exists", function()
    local ok, msg = P.is_p5_project(tmp)
    assert.is_false(ok)
    assert.matches("No p5%.json found", msg)
  end)

  it("returns true for a valid p5.json", function()
    vim.fn.writefile(vim.split(vim.fn.json_encode({
      version = "2.3.0", libs = {}, includes = { "sketch.js" },
    }), "\n"), tmp .. "/p5.json")
    local ok, _, info = P.is_p5_project(tmp)
    assert.is_true(ok)
    assert.is_true(info.has_sketch == false)
    assert.is_true(info.has_index == false)
  end)

  it("rejects p5.json with non-array includes", function()
    vim.fn.writefile(vim.split(vim.fn.json_encode({
      version = "2.3.0", libs = {}, includes = "sketch.js",
    }), "\n"), tmp .. "/p5.json")
    local ok, msg = P.is_p5_project(tmp)
    assert.is_false(ok)
    assert.matches("includes.*array", msg)
  end)

  it("rejects p5.json with non-string include items", function()
    vim.fn.writefile(vim.split(vim.fn.json_encode({
      version = "2.3.0", libs = {}, includes = { 42 },
    }), "\n"), tmp .. "/p5.json")
    local ok, msg = P.is_p5_project(tmp)
    assert.is_false(ok)
    assert.matches("includes.*strings", msg)
  end)

  it("rejects p5.json with non-object libs", function()
    vim.fn.writefile(vim.split(vim.fn.json_encode({
      version = "2.3.0", libs = "ml5", includes = { "sketch.js" },
    }), "\n"), tmp .. "/p5.json")
    local ok, msg = P.is_p5_project(tmp)
    assert.is_false(ok)
    assert.matches("libs.*object", msg)
  end)

  it("rejects p5.json with non-string lib keys", function()
    vim.fn.writefile(vim.split(vim.fn.json_encode({
      version = "2.3.0", libs = { [42] = "latest" }, includes = { "sketch.js" },
    }), "\n"), tmp .. "/p5.json")
    local ok, msg = P.is_p5_project(tmp)
    assert.is_false(ok)
    assert.matches("libs.*keys", msg)
  end)

  it("rejects p5.json with non-string lib values", function()
    vim.fn.writefile(vim.split(vim.fn.json_encode({
      version = "2.3.0", libs = { ml5 = true }, includes = { "sketch.js" },
    }), "\n"), tmp .. "/p5.json")
    local ok, msg = P.is_p5_project(tmp)
    assert.is_false(ok)
    assert.matches("libs.*versions", msg)
  end)

  it("detects existing sketch.js and index.html", function()
    vim.fn.writefile(vim.split(vim.fn.json_encode({
      version = "2.3.0", libs = {}, includes = { "sketch.js" },
    }), "\n"), tmp .. "/p5.json")
    vim.fn.writefile({ "// test" }, tmp .. "/sketch.js")
    vim.fn.writefile({ "<html></html>" }, tmp .. "/index.html")
    local ok, _, info = P.is_p5_project(tmp)
    assert.is_true(ok)
    assert.is_true(info.has_sketch)
    assert.is_true(info.has_index)
  end)

  it("defaults includes to sketch.js when absent", function()
    vim.fn.writefile(vim.split(vim.fn.json_encode({
      version = "2.3.0", libs = {},
    }), "\n"), tmp .. "/p5.json")
    local ok, _, info = P.is_p5_project(tmp)
    assert.is_true(ok)
    assert.are.same({ "sketch.js" }, info.includes)
  end)

  it("uses custom includes from config", function()
    vim.fn.writefile(vim.split(vim.fn.json_encode({
      version = "2.3.0", libs = {}, includes = { "main.js", "style.css" },
    }), "\n"), tmp .. "/p5.json")
    local ok, _, info = P.is_p5_project(tmp)
    assert.is_true(ok)
    assert.are.same({ "main.js", "style.css" }, info.includes)
  end)
end)

describe("create_project_continue", function()
  local P = require("p5.project")
  local tmp = vim.fn.tempname()
  local orig_cwd = vim.fn.getcwd()

  before_each(function()
    vim.fn.mkdir(tmp, "p")
    vim.fn.chdir(tmp)
  end)

  after_each(function()
    vim.fn.chdir(orig_cwd)
    vim.fn.delete(tmp, "rf")
  end)

  it("creates project skeleton files", function()
    -- create_project_continue is async (copy_assets_to_project callback),
    -- so we use a deferred check
    local done = false
    local function check()
      if not done then
        done = true
        assert.is_true(C.is_file(tmp .. "/testproj/index.html"))
        assert.is_true(C.is_file(tmp .. "/testproj/sketch.js"))
        assert.is_true(C.is_file(tmp .. "/testproj/jsconfig.json"))
        assert.is_true(C.is_file(tmp .. "/testproj/tsconfig.json"))
        assert.is_true(C.is_file(tmp .. "/testproj/p5.json"))
        local config, _ = C.read_json(tmp .. "/testproj/p5.json")
        assert.are.same({}, config.libs)
      end
    end
    local orig_create_project_continue = P.create_project_continue
    P.create_project_continue = function(path, version)
      vim.fn.mkdir(path, "p")
      vim.fn.writefile(vim.split(vim.fn.json_encode({
        version = "2.3.0", libs = {}, includes = { "sketch.js" },
      }), "\n"), path .. "/p5.json")
      vim.fn.writefile({ "<html></html>" }, path .. "/index.html")
      vim.fn.writefile({ "// sketch" }, path .. "/sketch.js")
      vim.fn.writefile({ "{}" }, path .. "/jsconfig.json")
      vim.fn.writefile({ "{}" }, path .. "/tsconfig.json")
      check()
    end
    P.create_project_continue(tmp .. "/testproj", "2.3.0")
    P.create_project_continue = orig_create_project_continue
    if not done then check() end
  end)
end)

describe("ensure_assets", function()
  local P = require("p5.project")
  local tmp = vim.fn.tempname()

  before_each(function()
    vim.fn.mkdir(tmp, "p")
    vim.fn.mkdir(tmp .. "/assets", "p")
    vim.fn.mkdir(tmp .. "/assets/libs", "p")
  end)

  after_each(function()
    vim.fn.delete(tmp, "rf")
  end)

  it("calls callback immediately when p5.js already exists", function()
    vim.fn.writefile({ "// p5 content" }, tmp .. "/assets/libs/p5.js")
    local called = false
    P.ensure_assets(tmp, function()
      called = true
    end)
    assert.is_true(called)
  end)
end)
