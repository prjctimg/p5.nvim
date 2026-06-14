-- vimhelp.lua - Pandoc Lua writer for Vim help file format

local module_tag = ''
local line_buf = {}
local line_width = 0

local function flush_line()
  if #line_buf > 0 then
    io.write(table.concat(line_buf) .. '\n')
    line_buf = {}
    line_width = 0
  end
end

local function write(s)
  io.write(s)
end

-- helpers
local function slug(name)
  return name:lower():gsub('[^%w]+', '-'):gsub('^-*(.-)-*$', '%1')
end

local function tag_name(t)
  return '*' .. t .. '*'
end

local function render_inlines(inlines)
  local parts = {}
  for _, inl in ipairs(inlines or {}) do
    if inl.t == 'Str' then
      table.insert(parts, inl.text)
    elseif inl.t == 'Code' then
      table.insert(parts, '`' .. inl.text .. '`')
    elseif inl.t == 'Space' then
      table.insert(parts, ' ')
    elseif inl.t == 'SoftBreak' or inl.t == 'LineBreak' then
      table.insert(parts, ' ')
    elseif inl.t == 'Emph' then
      table.insert(parts, '_' .. render_inlines(inl.content) .. '_')
    elseif inl.t == 'Strong' then
      table.insert(parts, render_inlines(inl.content))
    elseif inl.t == 'Link' then
      table.insert(parts, render_inlines(inl.content))
    elseif inl.t == 'Underline' then
      table.insert(parts, render_inlines(inl.content))
    elseif inl.t == 'SmallCaps' then
      table.insert(parts, render_inlines(inl.content))
    elseif inl.t == 'Strikeout' then
      table.insert(parts, render_inlines(inl.content))
    elseif inl.t == 'Superscript' then
      table.insert(parts, render_inlines(inl.content))
    elseif inl.t == 'Subscript' then
      table.insert(parts, render_inlines(inl.content))
    else
      table.insert(parts, pandoc.utils.stringify(inl) or '')
    end
  end
  return table.concat(parts)
end

---@param h pandoc.Header
function Header(h)
  local text = render_inlines(h.content)
  local lvl = h.level

  if lvl == 1 then
    -- Module heading: # ModuleName
    module_tag = 'p5-' .. slug(text)
    write(tag_name(module_tag) .. '                                              ' .. tag_name(module_tag) .. '\n')
    write(text .. ' documentation\n')
    write('\n')
    write(string.rep('=', 78) .. '\n')
    write('\n')
  elseif lvl == 2 then
    -- Item heading: ## itemName
    if module_tag ~= '' then
      local item_slug = module_tag .. '-' .. slug(text)
      write('\n')
      write(tag_name(item_slug) .. '\n')
      write(string.rep('-', 78) .. '\n')
      write('\n')
      write('`' .. text .. '`' .. '\n')
      write('\n')
    end
  elseif lvl == 3 then
    -- Subsection: ### Parameters / Properties / Returns / Examples
    write(string.upper(text) .. ':\n')
    write('\n')
  end
end

---@param p pandoc.Para
function Para(p)
  local text = render_inlines(p.content)
  if text ~= '' then
    write(text .. '\n')
  end
  write('\n')
end

---@param cb pandoc.CodeBlock
function CodeBlock(cb)
  for line in (cb.text .. '\n'):gmatch('(.-)\n') do
    write('  ' .. line .. '\n')
  end
  write('\n')
end

---@param bl pandoc.BulletList
function BulletList(bl)
  for _, item in ipairs(bl.content) do
    for i, block in ipairs(item) do
      if block.t == 'Plain' or block.t == 'Para' then
        local text = render_inlines(block.content)
        write('  - ' .. text .. '\n')
      elseif block.t == 'CodeBlock' then
        write('    ' .. block.text:gsub('\n', '\n    ') .. '\n')
      end
    end
  end
  write('\n')
end

---@param ol pandoc.OrderedList
function OrderedList(ol)
  for idx, item in ipairs(ol.content) do
    for _, block in ipairs(item) do
      if block.t == 'Plain' or block.t == 'Para' then
        local text = render_inlines(block.content)
        write('  ' .. idx .. '. ' .. text .. '\n')
      end
    end
  end
  write('\n')
end

---@param t pandoc.Table
function Table(t)
  local function render_cell(cell)
    local inlines = {}
    if cell.content then
      for _, block in ipairs(cell.content) do
        if block.t == 'Plain' and block.content then
          for _, inline in ipairs(block.content) do
            table.insert(inlines, inline)
          end
        elseif block.t == 'Str' or block.t == 'Code' or block.t == 'Emph' or block.t == 'Strong' then
          table.insert(inlines, block)
        end
      end
    end
    if #inlines > 0 then
      return render_inlines(inlines)
    end
    return ''
  end

  local function render_row(row)
    local parts = {}
    if row.cells then
      for _, cell in ipairs(row.cells) do
        table.insert(parts, render_cell(cell))
      end
    end
    return '| ' .. table.concat(parts, ' | ') .. ' |'
  end

  -- header row (from t.head.rows)
  if t.head and t.head.rows then
    local hdr = t.head.rows[1]
    if hdr then
      local hdr_parts = {}
      if hdr.cells then
        for _, cell in ipairs(hdr.cells) do
          table.insert(hdr_parts, render_cell(cell))
        end
      end
      write('| ' .. table.concat(hdr_parts, ' | ') .. ' |\n')
      write('|' .. string.rep('-', #hdr_parts * 6) .. '|\n')
    end
  end

  -- body rows (from t.bodies)
  if t.bodies then
    for _, body in ipairs(t.bodies) do
      if body.body then
        for _, row in ipairs(body.body) do
          write(render_row(row) .. '\n')
        end
      end
    end
  end
  write('\n')
end

---@param hr pandoc.HorizontalRule
function HorizontalRule()
  write(string.rep('-', 78) .. '\n')
  write('\n')
end

---@param s pandoc.Str
function Str(s)
  return s.text
end

---@param c pandoc.Code
function Code(c)
  return '`' .. c.text .. '`'
end

---@param sp pandoc.Space
function Space()
  return ' '
end

---@param lb pandoc.LineBreak
function LineBreak()
  return '\n'
end

---@param sb pandoc.SoftBreak
function SoftBreak()
  return ' '
end

---@param st pandoc.Strong
function Strong(st)
  return render_inlines(st.content)
end

---@param em pandoc.Emph
function Emph(em)
  return render_inlines(em.content)
end

---@param link pandoc.Link
function Link(link)
  return render_inlines(link.content)
end

function Plain(p)
  local text = render_inlines(p.content)
  if text ~= '' then
    write(text .. '\n')
  end
  write('\n')
end

---@param div pandoc.Div
function Div(d)
  for _, b in ipairs(d.content) do
    -- blocks within div are handled recursively by pandoc
  end
end

-- Entry point
function Writer(doc, opts)
  -- Set output encoding
  io.output():setvbuf('line')

  for _, b in ipairs(doc.blocks) do
    -- blocks are dispatched automatically by pandoc
  end
end
