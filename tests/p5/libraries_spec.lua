local C = require("p5.core")
local L = require("p5.libraries")

describe("load", function()
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

  it("includes core libs by default", function()
    local libs = L.load()
    assert.is_true(vim.tbl_contains(libs, "p5"))
    assert.is_true(vim.tbl_contains(libs, "p5.sound"))
  end)

  it("includes contrib libs from config", function()
    vim.fn.writefile(vim.split(vim.fn.json_encode({
      version = "2.0.0", major = 2, libs = { ml5 = "latest" }, includes = { "sketch.js" },
    }), "\n"), tmp .. "/p5.json")
    local libs = L.load()
    assert.is_true(vim.tbl_contains(libs, "ml5"))
  end)

  it("handles missing p5.json gracefully", function()
    local libs = L.load()
    assert.are.same({ "p5", "p5.sound" }, libs)
  end)
end)

describe("get_library_info", function()
  it("returns nil for unknown library", function()
    assert.is_nil(L.get_library_info("nonexistent-lib"))
  end)

  it("returns info for a known library", function()
    local info = L.get_library_info("ml5.js")
    assert.not_nil(info)
    assert.are.equal("ml5.js", info.name)
  end)
end)

describe("validate_download", function()
  local tmp = vim.fn.tempname()

  before_each(function()
    vim.fn.mkdir(tmp, "p")
  end)

  after_each(function()
    vim.fn.delete(tmp, "rf")
  end)

  it("rejects missing file", function()
    assert.is_false(L.validate_download(tmp .. "/nope.js"))
  end)

  it("rejects HTML content", function()
    vim.fn.writefile({ "<!DOCTYPE html><html><body>404</body></html>" }, tmp .. "/test.js")
    assert.is_false(L.validate_download(tmp .. "/test.js"))
  end)

  it("rejects error messages", function()
    vim.fn.writefile({ "Not Found" }, tmp .. "/test.js")
    assert.is_false(L.validate_download(tmp .. "/test.js"))
  end)

  it("accepts valid JS content", function()
    local js = "function setup() { createCanvas(400, 400); }"
    while #js < 100 do js = js .. "\n" .. js end
    vim.fn.writefile(vim.split(js, "\n"), tmp .. "/test.js")
    assert.is_true(L.validate_download(tmp .. "/test.js"))
  end)

  it("rejects very small files", function()
    vim.fn.writefile({ "x" }, tmp .. "/tiny.js")
    assert.is_false(L.validate_download(tmp .. "/tiny.js"))
  end)
end)

describe("add_library", function()
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

  it("creates config with libs when no p5.json exists", function()
    L.add_library("ml5")
    local config = C.read_workspace_config()
    assert.not_nil(config)
    assert.are.equal("latest", config.libs.ml5)
  end)

  it("adds library to existing config", function()
    vim.fn.writefile(vim.split(vim.fn.json_encode({
      version = "2.0.0", major = 2, libs = {}, includes = { "sketch.js" },
    }), "\n"), tmp .. "/p5.json")
    L.add_library("p5play")
    local config = C.read_workspace_config()
    assert.are.equal("latest", config.libs.p5play)
  end)

  it("does not duplicate existing library", function()
    vim.fn.writefile(vim.split(vim.fn.json_encode({
      version = "2.0.0", major = 2, libs = { ml5 = "latest" }, includes = { "sketch.js" },
    }), "\n"), tmp .. "/p5.json")
    L.add_library("ml5")
    local config = C.read_workspace_config()
    assert.are.equal("latest", config.libs.ml5)
  end)
end)

describe("get_installed_libs", function()
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

  it("returns empty when no libs directory", function()
    local installed = L.get_installed_libs()
    assert.are.same({}, installed)
  end)
end)

describe("generate_libs_js", function()
  local tmp = vim.fn.tempname()

  before_each(function()
    vim.fn.mkdir(tmp, "p")
    vim.fn.mkdir(tmp .. "/assets", "p")
    vim.fn.mkdir(tmp .. "/assets/libs", "p")
  end)

  after_each(function()
    vim.fn.delete(tmp, "rf")
  end)

  it("creates libs.js file", function()
    L.generate_libs_js(tmp)
    assert.is_true(C.is_file(tmp .. "/assets/libs/libs.js"))
    local content = vim.fn.readfile(tmp .. "/assets/libs/libs.js")
    assert.is_true(#content > 0)
  end)
end)
