local M = {}

-- Check if nui.nvim is available
local function has_nui()
  local ok, nui = pcall(require, "nui")
  return ok and nui
end

-- Fallback menu using vim.ui.select
local function fallback_select(items, on_select, opts)
  local format_item = opts.format_item or function(item)
    return item.name or tostring(item)
  end
  
  vim.ui.select(items, {
    prompt = opts.prompt or "Select item",
    format_item = format_item
  }, function(choice)
    if choice and on_select then
      on_select({choice})
    end
  end)
end

-- Create multi-select menu
function M.multi_select(items, on_confirm, opts)
  opts = opts or {}
  
  if not has_nui() then
    -- Fallback to single select
    return fallback_select(items, on_confirm, opts)
  end
  
  local Menu = require("nui.menu")
  
  -- Create menu items
  local menu_items = {}
  for _, item in ipairs(items) do
    local text = opts.format_item and opts.format_item(item) or item.name or tostring(item)
    table.insert(menu_items, Menu.item(text, item))
  end
  
  -- Add confirm and cancel options
  table.insert(menu_items, Menu.item(""))
  table.insert(menu_items, Menu.item("✓ Confirm Selection"))
  table.insert(menu_items, Menu.item("✗ Cancel"))
  
  local selected_items = {}
  local current_selection = {}
  
  local menu = Menu({
    relative = "editor",
    position = "50%",
    size = {
      width = math.min(80, opts.width or 60),
      height = math.min(20, #menu_items + 2)
    },
    border = {
      style = "rounded",
      text = {
        top = opts.title or "Select Items (Space to toggle)",
        top_align = "center"
      }
    },
    win_options = {
      winhighlight = "Normal:Normal,FloatBorder:FloatBorder"
    }
  }, {
    lines = menu_items,
    on_close = function()
      if opts.on_cancel then
        opts.on_cancel()
      end
    end,
    on_submit = function(item)
      if item.text == "✓ Confirm Selection" then
        -- Return selected items
        if on_confirm then
          on_confirm(selected_items)
        end
        menu:unmount()
      elseif item.text == "✗ Cancel" then
        menu:unmount()
      elseif item.text ~= "" then
        -- Toggle selection
        local key = item.text
        
        if current_selection[key] then
          current_selection[key] = nil
          -- Remove from selected_items
          for i, selected in ipairs(selected_items) do
            if selected.text == key then
              table.remove(selected_items, i)
              break
            end
          end
        else
          current_selection[key] = item
          table.insert(selected_items, item)
        end
        
        -- Update menu to show selection status
        local new_items = {}
        for _, menu_item in ipairs(menu_items) do
          if menu_item.text == item.text and menu_item.text ~= "" and 
             menu_item.text ~= "✓ Confirm Selection" and 
             menu_item.text ~= "✗ Cancel" then
            local prefix = current_selection[menu_item.text] and "✓ " or "  "
            table.insert(new_items, Menu.item(prefix .. menu_item.text, menu_item._data))
          else
            table.insert(new_items, menu_item)
          end
        end
        
        menu:update(new_items)
      end
    end
  })
  
  -- Map keys
  menu:map("n", "<Space>", function()
    local item = menu.tree:get_node()
    if item and item.text ~= "" and 
       item.text ~= "✓ Confirm Selection" and 
       item.text ~= "✗ Cancel" then
      
      -- Simulate submit for current item
      local current_item = {
        text = item.text:gsub("^[%s%*%-]*", ""),  -- Remove prefix
        _data = item._data
      }
      
      menu._on_submit(current_item)
    end
  end, { noremap = true })
  
  menu:map("i", "<Space>", function()
    local item = menu.tree:get_node()
    if item and item.text ~= "" and 
       item.text ~= "✓ Confirm Selection" and 
       item.text ~= "✗ Cancel" then
      
      -- Simulate submit for current item
      local current_item = {
        text = item.text:gsub("^[%s%*%-]*", ""),  -- Remove prefix
        _data = item._data
      }
      
      menu._on_submit(current_item)
    end
  end, { noremap = true })
  
  menu:map("n", "<CR>", function()
    local item = menu.tree:get_node()
    if item then
      menu._on_submit(item)
    end
  end, { noremap = true })
  
  menu:map("i", "<CR>", function()
    local item = menu.tree:get_node()
    if item then
      menu._on_submit(item)
    end
  end, { noremap = true })
  
  menu:map("n", "<Esc>", function()
    menu:unmount()
  end, { noremap = true })
  
  menu:map("i", "<C-c>", function()
    menu:unmount()
  end, { noremap = true })
  
  -- Mount the menu
  menu:mount()
  
  return menu
end

-- Create single-select menu
function M.single_select(items, on_confirm, opts)
  opts = opts or {}
  
  if not has_nui() then
    return fallback_select(items, on_confirm, opts)
  end
  
  local Menu = require("nui.menu")
  
  -- Create menu items
  local menu_items = {}
  for _, item in ipairs(items) do
    local text = opts.format_item and opts.format_item(item) or item.name or tostring(item)
    table.insert(menu_items, Menu.item(text, item))
  end
  
  local menu = Menu({
    relative = "editor", 
    position = "50%",
    size = {
      width = math.min(80, opts.width or 60),
      height = math.min(20, #menu_items + 2)
    },
    border = {
      style = "rounded",
      text = {
        top = opts.title or "Select Item",
        top_align = "center"
      }
    },
    win_options = {
      winhighlight = "Normal:Normal,FloatBorder:FloatBorder"
    }
  }, {
    lines = menu_items,
    on_close = function()
      if opts.on_cancel then
        opts.on_cancel()
      end
    end,
    on_submit = function(item)
      if item and on_confirm then
        on_confirm({item._data})
      end
      menu:unmount()
    end
  })
  
  -- Map keys
  menu:map("n", "<CR>", function()
    local item = menu.tree:get_node()
    if item then
      menu._on_submit(item)
    end
  end, { noremap = true })
  
  menu:map("i", "<CR>", function()
    local item = menu.tree:get_node()
    if item then
      menu._on_submit(item)
    end
  end, { noremap = true })
  
  menu:map("n", "<Esc>", function()
    menu:unmount()
  end, { noremap = true })
  
  menu:map("i", "<C-c>", function()
    menu:unmount()
  end, { noremap = true })
  
  -- Mount the menu
  menu:mount()
  
  return menu
end

return M