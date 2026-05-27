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
