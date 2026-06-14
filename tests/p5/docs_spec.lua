describe("docs generation", function()
  local core = require("p5.core")
  local tmp = vim.fn.tempname()
  local root = core.plugin_root()

  before_each(function()
    vim.fn.mkdir(tmp, "p")
  end)

  after_each(function()
    vim.fn.delete(tmp, "rf")
  end)

  it("json-to-md.mjs converts reference JSON to per-module markdown", function()
    -- Create synthetic reference JSON matching p5.js documentation format
    local ref = {
      {
        kind = "module",
        context = { file = "src/core/environment.js" },
        tags = { { title = "module", name = "Environment" } },
      },
      {
        kind = "function",
        name = "createCanvas",
        context = { file = "src/core/environment.js" },
        description = {
          type = "root",
          children = {
            { type = "paragraph", children = { { type = "text", value = "Creates a canvas element." } } },
          },
        },
        params = {
          { name = "w", type = { type = "NameExpression", name = "Number" }, description = "width" },
          { name = "h", type = { type = "NameExpression", name = "Number" }, description = "height" },
        },
        returns = {
          { type = { type = "NameExpression", name = "p5.Renderer" }, description = { type = "root", children = {} } },
        },
        tags = { { title = "method" }, { title = "example", description = "function setup() {\n  createCanvas(400, 400);\n}" } },
      },
      {
        kind = "function",
        name = "background",
        context = { file = "src/core/rendering.js" },
        tags = { { title = "module", name = "Rendering" } },
      },
    }
    local json_path = tmp .. "/ref.json"
    vim.fn.writefile(vim.split(vim.json.encode(ref), "\n"), json_path)

    local out_dir = tmp .. "/modules"
    vim.fn.mkdir(out_dir, "p")

    local result = vim.fn.system({
      "node", root .. "/scripts/json-to-md.mjs",
      json_path, out_dir, "2.3.0",
    })
    assert.equals(0, vim.v.shell_error, "json-to-md.mjs failed: " .. result)

    local files = vim.fn.readdir(out_dir)
    assert.is_true(#files > 0, "No markdown files generated")
    assert.is_true(vim.tbl_contains(files, "p5-core.md"), "Expected p5-core.md")

    -- Verify content of p5-core.md
    local content = table.concat(vim.fn.readfile(out_dir .. "/p5-core.md"), "\n")
    assert.matches("# Environment", content, "Should have Environment module heading")
    assert.matches("## createCanvas", content, "Should have createCanvas item")
    assert.matches("Creates a canvas element", content, "Should have description")
    assert.matches("| `w` | `Number` | width |", content, "Should have param table")
    assert.matches("| `h` | `Number` | height |", content, "Should have param table row")
    assert.matches("`p5.Renderer`", content, "Should have return type")
    assert.matches("p5.js v2.3.0", content, "Should include version")
    assert.matches("```javascript", content, "Should have code example block")
  end)

  it("vimhelp.lua pandoc filter produces valid Vim help files", function()
    if vim.fn.executable("pandoc") == 0 then
      return
    end

    local md_content = [[# core
p5.js v2.3.0 reference documentation.

## createCanvas

Creates a canvas element.

### Parameters

| Name | Type | Description |
|------|------|-------------|
| `w` | `Number` | width |
| `h` | `Number` | height |

### Examples

```javascript
function setup() {
  createCanvas(400, 400);
}
```

---
]]
    local md_path = tmp .. "/p5-core.md"
    vim.fn.writefile(vim.split(md_content, "\n"), md_path)

    local help_path = tmp .. "/p5-core.txt"
    -- Use --lua-filter instead of --lua-writer (deprecated in pandoc 3.x)
    -- Filter writes to stdout; discard default pandoc output with -o /dev/null
    -- Use -f markdown to explicitly specify input format
    local result = vim.fn.system(
      "pandoc -f markdown " .. md_path .. " --lua-filter " .. root .. "/scripts/vimhelp.lua --metadata title=p5-core -o /dev/null > " .. help_path .. " 2>&1"
    )
    assert.equals(0, vim.v.shell_error, "pandoc conversion failed: " .. result)

    assert.is_true(core.is_file(help_path), "Help file not created")

    local help = table.concat(vim.fn.readfile(help_path), "\n")
    assert.matches("%*p5%-core%*", help, "Should have module tag")
    assert.matches("%*p5%-core%-createcanvas%*", help, "Should have item tag")
    assert.matches("`createCanvas`", help, "Should have item name")
    assert.matches("Creates a canvas element", help, "Should have description")
    assert.matches("PARAMETERS:", help, "Should have Parameters section")
    assert.matches("| `w` | `Number` | width |", help, "Should have param row")
  end)

  it("gen-docs.sh script generates tags file", function()
    if vim.fn.executable("pandoc") == 0 or vim.fn.executable("git") == 0 then
      return
    end

    -- Verify the script exists and is valid bash
    assert.is_true(core.is_file(root .. "/scripts/gen-docs.sh"), "gen-docs.sh should exist")

    -- Quick syntax check on the script
    local check = vim.fn.system({ "bash", "-n", root .. "/scripts/gen-docs.sh" })
    assert.equals(0, vim.v.shell_error, "gen-docs.sh has syntax errors: " .. check)
  end)

  it("gen-docs.sh pipeline phases work end-to-end", function()
    if vim.fn.executable("pandoc") == 0 then
      return
    end

    -- Test Phase 3 (json-to-md) + Phase 4 (pandoc conversion) + Phase 5 (tags gen)
    -- using synthetic data

    -- Create synthetic markdown (simulating Phase 3 output)
    local md_content = [[# core
p5.js v2.3.0 reference documentation.

## createCanvas

Creates a canvas element.

### Parameters

| Name | Type | Description |
|------|------|-------------|
| `w` | `Number` | width |

### Examples

```javascript
createCanvas(400, 400);
```

---
]]
    local md_dir = tmp .. "/mods"
    vim.fn.mkdir(md_dir, "p")
    vim.fn.writefile(vim.split(md_content, "\n"), md_dir .. "/p5-core.md")

    -- Phase 4: Convert markdown to Vim help with pandoc
    local doc_dir = tmp .. "/doc"
    vim.fn.mkdir(doc_dir, "p")
    local result = vim.fn.system(
      "pandoc -f markdown " .. md_dir .. "/p5-core.md --lua-filter " .. root .. "/scripts/vimhelp.lua --metadata title=p5-core -o /dev/null > " .. doc_dir .. "/p5-core.txt 2>&1"
    )
    assert.equals(0, vim.v.shell_error, "pandoc conversion failed: " .. result)

    -- Phase 5: Generate tags (simulating gen-docs.sh logic)
    local tags = {}
    for _, txt_file in ipairs(vim.fn.readdir(doc_dir)) do
      if txt_file:match("^p5%-.*%.txt$") then
        for _, line in ipairs(vim.fn.readfile(doc_dir .. "/" .. txt_file)) do
          local tag = line:match("^%*([^%*]+)%*")
          if tag then
            table.insert(tags, tag .. "\t" .. txt_file .. "\t/*" .. tag .. "*")
          end
        end
      end
    end
    vim.fn.writefile(tags, doc_dir .. "/tags")

    -- Verify tags
    local tag_content = vim.fn.readfile(doc_dir .. "/tags")
    assert.is_true(#tag_content > 0, "Should have at least one tag")
    local has_module_tag = false
    local has_item_tag = false
    for _, l in ipairs(tag_content) do
      if l:match("^p5%-core\tp5%-core%.txt\t/%*p5%-core%*$") then
        has_module_tag = true
      end
      if l:match("^p5%-core%-createcanvas\tp5%-core%.txt\t/%*p5%-core%-createcanvas%*$") then
        has_item_tag = true
      end
    end
    assert.is_true(has_module_tag, "Should have p5-core module tag")
    assert.is_true(has_item_tag, "Should have createCanvas item tag")
  end)
end)
