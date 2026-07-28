local C = require("p5.core")

describe("slugify", function()
	it("converts a simple string to lowercase with dashes", function()
		assert.are.equal("my-cool-sketch", C.slugify("My Cool Sketch"))
	end)

	it("handles special characters", function()
		assert.are.equal("hello-world", C.slugify("hello, world!"))
	end)

	it("collapses multiple spaces and dashes", function()
		assert.are.equal("a-b-c", C.slugify("a   b---c"))
	end)

	it("handles leading and trailing symbols", function()
		assert.are.equal("hello", C.slugify("!!!hello???"))
	end)

	it("handles mixed case", function()
		assert.are.equal("hello-world", C.slugify("HELLO World"))
	end)

	it("handles numbers", function()
		assert.are.equal("sketch-42", C.slugify("Sketch 42"))
	end)

	it("returns 'untitled' for non-string input", function()
		assert.are.equal("untitled", C.slugify(nil))
		assert.are.equal("untitled", C.slugify(123))
		assert.are.equal("untitled", C.slugify({}))
	end)

	it("returns 'untitled' for empty or all-symbol strings", function()
		assert.are.equal("untitled", C.slugify(""))
		assert.are.equal("untitled", C.slugify("!!!--???"))
	end)

	it("handles single word", function()
		assert.are.equal("sketch", C.slugify("Sketch"))
	end)

	it("preserves digits", function()
		assert.are.equal("v2-0-test", C.slugify("v2.0 test"))
	end)

	it("handles emoji characters", function()
		assert.are.equal("my-cool-sketch", C.slugify("🎨 My Cool Sketch"))
		assert.are.equal("untitled", C.slugify("🎨🎮🔥"))
		assert.are.equal("a-b", C.slugify("a🎨b"))
	end)
end)

describe("deslugify", function()
	it("converts a slug to a title", function()
		assert.are.equal("My Cool Sketch", C.deslugify("my-cool-sketch"))
	end)

	it("handles single word", function()
		assert.are.equal("Sketch", C.deslugify("sketch"))
	end)

	it("handles empty string", function()
		assert.are.equal("", C.deslugify(""))
	end)

	it("handles numbers in slug", function()
		assert.are.equal("Sketch 42", C.deslugify("sketch-42"))
	end)

	it("handles multiple dashes", function()
		assert.are.equal("A B C", C.deslugify("a---b-----c"))
	end)

	it("handles already title-cased words", function()
		assert.are.equal("Hello World", C.deslugify("hello-world"))
	end)

	it("handles words with digits", function()
		assert.are.equal("V2 0 Test", C.deslugify("v2-0-test"))
	end)
end)

describe("is_cmd", function()
  local orig_executable = vim.fn.executable

  after_each(function()
    vim.fn.executable = orig_executable
  end)

  it("returns true for available commands", function()
    vim.fn.executable = function(cmd)
      if cmd == "python3" then return 1 end
      return 0
    end
    assert.is_true(C.is_cmd("python3"))
  end)

  it("returns false for unavailable commands", function()
    vim.fn.executable = function(_) return 0 end
    assert.is_false(C.is_cmd("nonexistent-cmd-xyz"))
  end)
end)

describe("is_file", function()
  local tmp = vim.fn.tempname()

  it("returns false for nonexistent file", function()
    assert.is_false(C.is_file(tmp .. "/nope.lua"))
  end)

  it("returns true for existing file", function()
    vim.fn.writefile({ "hello" }, tmp)
    assert.is_true(C.is_file(tmp))
    vim.fn.delete(tmp)
  end)
end)

describe("is_dir", function()
  it("returns true for existing directory", function()
    assert.is_true(C.is_dir("/tmp"))
  end)

  it("returns false for nonexistent directory", function()
    assert.is_false(C.is_dir("/nonexistent-dir-xyz"))
  end)
end)

describe("read_json", function()
  local tmp = vim.fn.tempname()

  after_each(function()
    pcall(vim.fn.delete, tmp)
  end)

  it("returns nil for missing file", function()
    local data, err = C.read_json("/nonexistent.json")
    assert.is_nil(data)
    assert.matches("not found", err)
  end)

  it("parses valid JSON", function()
    vim.fn.writefile(vim.split('{"key": "value", "num": 42}', "\n"), tmp)
    local data = C.read_json(tmp)
    assert.are.equal("value", data.key)
    assert.are.equal(42, data.num)
  end)
end)

describe("write_json", function()
  local tmp = vim.fn.tempname()

  after_each(function()
    pcall(vim.fn.delete, tmp)
  end)

  it("writes valid JSON", function()
    C.write_json(tmp, { hello = "world", num = 42 })
    local data = C.read_json(tmp)
    assert.are.equal("world", data.hello)
    assert.are.equal(42, data.num)
  end)
end)

describe("slugify roundtrip", function()
	it("slugify then deslugify preserves meaning", function()
		local original = "My Cool Sketch 42"
		local slug = C.slugify(original)
		local back = C.deslugify(slug)
		assert.are.equal("My Cool Sketch 42", back)
	end)

	it("multiple roundtrips are idempotent", function()
		local slug = C.slugify("Some Sketch Name")
		assert.are.equal(slug, C.slugify(C.deslugify(slug)))
	end)
end)

describe("cmp_version", function()
	it("compares semver numbers", function()
		assert.are.equal(-1, C.cmp_version("2.3.0", "2.3.1"))
		assert.are.equal(1, C.cmp_version("2.4.0", "2.3.1"))
		assert.are.equal(0, C.cmp_version("2.3.1", "2.3.1"))
	end)
end)

describe("meta version cache", function()
	local tmp = vim.fn.tempname()
	local orig_cache_dir = C.cache_dir

	before_each(function()
		vim.fn.mkdir(tmp, "p")
		C.cache_dir = function()
			return tmp
		end
	end)

	after_each(function()
		C.cache_dir = orig_cache_dir
		vim.fn.delete(tmp, "rf")
	end)

	it("round-trips latest version via meta.json", function()
		C.write_meta({ latest = "2.3.1", checked_at = 123 })
		local meta = C.read_meta()
		assert.are.equal("2.3.1", meta.latest)
		assert.are.equal(123, meta.checked_at)
	end)

	it("migrates legacy plain string cache", function()
		vim.fn.writefile({ '"2.2.0"' }, tmp .. "/p5_version")
		local meta = C.read_meta()
		assert.are.equal("2.2.0", meta.latest)
	end)
end)

describe("versioned_p5_path", function()
	it("nests under versions dir", function()
		local p = C.versioned_p5_path("2.3.1")
		assert.matches("versions/2%.3%.1/p5%.js$", p)
	end)
end)
