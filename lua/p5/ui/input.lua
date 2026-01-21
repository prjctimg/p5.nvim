local M = {}

-- Check if nui.nvim is available
local function has_nui()
  local ok, nui = pcall(require, "nui")
  return ok and nui
end

-- Fallback input prompt using vim.ui.input
local function fallback_input(prompt, default, on_submit)
  vim.ui.input({
    prompt = prompt,
    default = default or ""
  }, on_submit)
end

-- Create enhanced input dialog
function M.input(opts, on_confirm)
  if not has_nui() then
    return fallback_input(opts.prompt, opts.default, on_confirm)
  end
  
  local Input = require("nui.input")
  
  local input = Input({
    relative = "editor",
    position = "50%",
    size = {
      width = math.max(40, #opts.prompt + 10),
      height = 2
    },
    border = {
      style = "rounded",
      text = {
        top = opts.title or "Input",
        top_align = "center"
      }
    },
    win_options = {
      winhighlight = "Normal:Normal,FloatBorder:FloatBorder"
    }
  }, {
    prompt = opts.prompt,
    default_value = opts.default or "",
    on_close = function()
      if opts.on_close then
        opts.on_close()
      end
    end,
    on_submit = function(value)
      if on_confirm then
        on_confirm(value)
      end
    end
  })
  
  -- Mount the component
  input:mount()
  
  -- Auto-focus the input
  input:map("n", "<Esc>", function()
    input:unmount()
  end, { noremap = true })
  
  input:map("i", "<C-c>", function()
    input:unmount()
  end, { noremap = true })
  
  return input
end

-- Create enhanced confirm dialog
function M.confirm(message, on_confirm, opts)
  opts = opts or {}
  
  if not has_nui() then
    -- Fallback to vim.fn.confirm
    local choices = opts.choices or {"&Yes", "&No"}
    local default = opts.default or 1
    
    local result = vim.fn.confirm(message, table.concat(choices, "\n"), default)
    if on_confirm then
      on_confirm(result == 1)
    end
    return
  end
  
  local event = require("nui.utils.autocmd").buftype
  
  local Input = require("nui.input")
  
  local input = Input({
    relative = "editor",
    position = "50%",
    size = {
      width = math.min(60, #message + 10),
      height = #math.ceil(#message / 50) + 3
    },
    border = {
      style = "rounded",
      text = {
        top = opts.title or "Confirm",
        top_align = "center"
      }
    },
    win_options = {
      winhighlight = "Normal:Normal,FloatBorder:FloatBorder"
    }
  }, {
    prompt = "",
    default_value = "",
    on_close = function()
      if opts.on_cancel then
        opts.on_cancel()
      end
    end,
    on_submit = function(value)
      if on_confirm then
        on_confirm(value:lower():match("^y") ~= nil)
      end
    end
  })
  
  -- Add message text
  local buf = input.bufnr
  local lines = {}
  for line in message:gmatch("[^\r\n]+") do
    table.insert(lines, line)
  end
  
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_lines(buf, #lines, -1, false, {"", "[y/N]: "})
  
  -- Mount the component
  input:mount()
  
  -- Set cursor to input line
  vim.api.nvim_win_set_cursor(input.winid, {#lines + 2, 6})
  
  return input
end

return M