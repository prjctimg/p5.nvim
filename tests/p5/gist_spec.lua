local C = require("p5.core")

local orig_is_cmd = C.is_cmd
C.is_cmd = function(cmd) return cmd == "gh" end

package.loaded["p5.gist"] = nil
local G = require("p5.gist")

describe("G.includes", function()
  it("includes sketch.js by default", function()
    local r = G.includes({})
    assert.are.same({ "sketch.js", "p5.json" }, r)
  end)

  it("includes explicitly listed files", function()
    local r = G.includes({ includes = { "foo.js", "bar.js" } })
    assert.are.same({ "foo.js", "bar.js", "p5.json" }, r)
  end)

  it("excludes skchbk/ directory entries", function()
    local r = G.includes({ includes = { "sketch.js", "skchbk/test.js" } })
    assert.are.same({ "sketch.js", "p5.json" }, r)
  end)

  it("excludes assets/ directory entries", function()
    local r = G.includes({ includes = { "sketch.js", "assets/lib.js", "assets" } })
    assert.are.same({ "sketch.js", "p5.json" }, r)
  end)

  it("always includes p5.json", function()
    local r = G.includes({ includes = { "sketch.js" } })
    local has_p5 = false
    for _, f in ipairs(r) do
      if f == "p5.json" then has_p5 = true end
    end
    assert.is_true(has_p5)
  end)

  it("skips non-string includes with warning", function()
    local r = G.includes({ includes = { "sketch.js", 42, true } })
    assert.are.same({ "sketch.js", "p5.json" }, r)
  end)

  it("skips unsafe paths (path traversal, absolute paths)", function()
    local r = G.includes({ includes = { "../escape.js", "/abs.js", "~user.js", "sketch.js" } })
    assert.are.same({ "sketch.js", "p5.json" }, r)
  end)
end)

describe("G.get_comment", function()
  local orig_system = vim.fn.system

  after_each(function() vim.fn.system = orig_system end)

  it("returns the first comment when comments exist", function()
    vim.fn.system = function(cmd)
      if cmd[1] == "gh" and cmd[2] == "api" and cmd[3]:match("^/gists/.*/comments$") then
        return vim.fn.json_encode({
          { id = 1, body = "This is a sketch detail comment" },
          { id = 2, body = "Another comment" },
        })
      end
      return ""
    end
    local cm = G.get_comment("abc123")
    assert.are.same({ id = 1, body = "This is a sketch detail comment" }, cm)
  end)

  it("returns nil when no comments exist", function()
    vim.fn.system = function(cmd)
      if cmd[1] == "gh" and cmd[2] == "api" and cmd[3]:match("^/gists/.*/comments$") then
        return "[]"
      end
      return ""
    end
    assert.is_nil(G.get_comment("abc123"))
  end)

  it("returns nil on API failure", function()
    vim.fn.system = function(_) return "" end
    assert.is_nil(G.get_comment("abc123"))
  end)
end)

describe("G.edit", function()
  local orig_system = vim.fn.system
  local orig_select = vim.ui.select

  before_each(function()
    vim.ui.select = function(items, _, cb) cb(items[1]) end
  end)

  after_each(function()
    vim.fn.system = orig_system
    vim.ui.select = orig_select
  end)

  it("warns when no gist is associated", function()
    vim.fn.system = function(_) return "" end
    local ok, err = pcall(G.edit)
    assert.is_true(ok, "edit should not crash: " .. tostring(err))
  end)
end)

describe("G.skchbk_clone", function()
  local tmp_dir
  local orig_system

  before_each(function()
    tmp_dir = vim.fn.tempname()
    vim.fn.mkdir(tmp_dir, "p")
    orig_system = vim.fn.system
  end)

  after_each(function()
    vim.fn.system = orig_system
    vim.fn.delete(tmp_dir, "rf")
  end)

  it("reports when no gists are found", function()
    vim.fn.system = function(cmd)
      if cmd[1] == "gh" and cmd[2] == "api" and cmd[3]:match("^/users/") then
        return "[]"
      end
      return orig_system(cmd)
    end
    G.skchbk_clone("testuser", tmp_dir)
    local count = 0
    for _, _ in vim.fs.dir(tmp_dir) do count = count + 1 end
    assert.are.equal(0, count)
  end)

  it("clones gists into subdirectories with README.md from comments", function()
    vim.fn.system = function(cmd)
      local joined = table.concat(cmd, " ")
      if joined:match("api /users/") then
        return vim.fn.json_encode({
          { id = "abc123", description = "My First Sketch" },
          { id = "def456", description = "Cool Demo" },
        })
      end
      if joined:match("api /gists/.+/comments") then
        if cmd[3]:match("abc123") then
          return vim.fn.json_encode({
            { id = 99, body = "A p5 sketch that does cool things" },
          })
        end
        return "[]"
      end
      if joined:match("api /gists/") then
        local files = {}
        if cmd[3]:match("abc123") then
          files["sketch.js"] = { content = "function setup() {\n  createCanvas(400, 400);\n}\n" }
          files["style.css"] = { content = "body { margin: 0; }\n" }
        else
          files["sketch.js"] = { content = "function draw() {\n  background(220);\n}\n" }
        end
        return vim.fn.json_encode({ files = files })
      end
      return orig_system(cmd)
    end

    G.skchbk_clone("testuser", tmp_dir)

    local dirs = {}
    for entry, type in vim.fs.dir(tmp_dir) do
      if type == "directory" then table.insert(dirs, entry) end
    end
    table.sort(dirs)

    assert.are.same({ "cool-demo", "my-first-sketch" }, dirs)
    assert.is_true(C.is_file(tmp_dir .. "/my-first-sketch/sketch.js"))
    assert.is_true(C.is_file(tmp_dir .. "/my-first-sketch/style.css"))
    assert.is_true(C.is_file(tmp_dir .. "/my-first-sketch/README.md"))
    assert.is_true(C.is_file(tmp_dir .. "/cool-demo/sketch.js"))
    assert.is_false(C.is_file(tmp_dir .. "/cool-demo/README.md"))
    local readme = vim.fn.readfile(tmp_dir .. "/my-first-sketch/README.md")
    assert.are.same({ "A p5 sketch that does cool things" }, readme)
    assert.are.equal(2, #dirs)
  end)

  it("skips existing directories", function()
    vim.fn.mkdir(tmp_dir .. "/cool-demo", "p")
    vim.fn.writefile({ "old content" }, tmp_dir .. "/cool-demo/sketch.js")
    vim.fn.system = function(cmd)
      local joined = table.concat(cmd, " ")
      if joined:match("api /users/") then
        return vim.fn.json_encode({
          { id = "abc123", description = "My First Sketch" },
          { id = "def456", description = "Cool Demo" },
        })
      end
      if joined:match("api /gists/.+/comments") then
        return "[]"
      end
      if joined:match("api /gists/") then
        return vim.fn.json_encode({
          files = { ["sketch.js"] = { content = "// new content\n" } },
        })
      end
      return orig_system(cmd)
    end
    G.skchbk_clone("testuser", tmp_dir)
    local content = vim.fn.readfile(tmp_dir .. "/cool-demo/sketch.js")
    assert.are.same({ "old content" }, content,
      "existing dir should not be overwritten")
  end)

  it("handles empty descriptions", function()
    vim.fn.system = function(cmd)
      local joined = table.concat(cmd, " ")
      if joined:match("api /users/") then
        return vim.fn.json_encode({
          { id = "abc123", description = vim.NIL },
          { id = "def456", description = "" },
        })
      end
      if joined:match("api /gists/.+/comments") then
        return "[]"
      end
      if joined:match("api /gists/") then
        return vim.fn.json_encode({
          files = { ["sketch.js"] = { content = "" } },
        })
      end
      return orig_system(cmd)
    end
    G.skchbk_clone("testuser", tmp_dir)
    local dirs = {}
    for entry, type in vim.fs.dir(tmp_dir) do
      if type == "directory" then
        table.insert(dirs, entry)
      end
    end
    assert.is_true(#dirs >= 1, "Expected at least 1 directory, got " .. #dirs)
  end)

  it("does not crash on API failure", function()
    vim.fn.system = function(cmd)
      if cmd[1] == "gh" and cmd[2] == "api" and cmd[3]:match("^/users/") then
        return "Not Found"
      end
      return orig_system(cmd)
    end
    G.skchbk_clone("nonexistent-user", tmp_dir)
  end)
end)

C.is_cmd = orig_is_cmd
