-- Enhanced multiselect UI using nui.nvim for library selection
local templates = require("p5.templates")

local M = {}

-- Enhanced multiselect with nui.nvim
function M.select_libraries(on_complete)
	-- Check if nui.nvim Menu is available
	local ok, Menu = pcall(require, "nui.menu")
	if not ok then
		-- Fallback to simple implementation
		return M.select_libraries_fallback(on_complete)
	end

	-- Build menu items with checkboxes
	local menu_items = {
		Menu.item("None", { selected = false, description = "Minimum setup (no additional libraries)" })
	}
	
	-- Add all libraries from catalog
	for _, lib in ipairs(templates.library_catalog) do
		local item_text = string.format("☐ %s - %s", lib.name, lib.description)
		table.insert(menu_items, Menu.item(item_text, { 
			selected = false, 
			lib_data = lib,
			name = lib.name
		}))
	end
	
	-- Create menu
	local menu = Menu({
		position = "50%",
		size = {
			width = math.min(80, vim.o.columns - 4),
			height = math.min(#menu_items + 2, vim.o.lines - 4),
		},
		border = {
			style = "rounded",
			text = {
				top = "Select p5.js Libraries",
				top_align = "center",
			},
		},
		win_options = {
			winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
		},
	}, {
		lines = menu_items,
		max_width = 80,
		keymap = {
			focus_next = { "j", "<Down>", "<Tab>" },
			focus_prev = { "k", "<Up>", "<S-Tab>" },
			close = { "<Esc>", "<C-c>" },
			submit = { "<CR>" },
		},
		on_close = function()
			if on_complete then
				on_complete({})
			end
		end,
		on_submit = function(item)
			-- Handle submit (Enter key) - return the selected item
			if item then
				local selected_libraries = {}
				
				if item._id == 1 then -- "None" selected
					selected_libraries = {}
				elseif item._lib_data then
					table.insert(selected_libraries, {
						name = item._name,
						lib_data = item._lib_data
					})
				end
				
				if on_complete then
					on_complete(selected_libraries)
				end
			end
		end,
	})
	
	-- Add custom toggle functionality for multiselect
	menu:map("n", "<Space>", function()
		if menu.tree and menu.tree:get_node() then
			local current_node = menu.tree:get_node()
			if current_node then
				-- For now, just submit the current item when Space is pressed
				-- This allows selection without needing to press Enter
				menu:unmount()
				if on_complete then
					local selected_libraries = {}
					if current_node._id == 1 then -- "None" selected
						selected_libraries = {}
					elseif current_node._lib_data then
						table.insert(selected_libraries, {
							name = current_node._name,
							lib_data = current_node._lib_data
						})
					end
					on_complete(selected_libraries)
				end
			end
		end
	end, { opts = { nowait = true } })
	
	-- Show the menu
	menu:mount()
end

-- Simple fallback multiselect for when nui.nvim is not available
function M.select_libraries_fallback(on_complete)
	local lib_choices = {{name = "None", description = "Minimum setup (no additional libraries)"}}
	for _, lib in ipairs(templates.library_catalog) do
		table.insert(lib_choices, {
			name = lib.name,
			description = lib.description,
		})
	end
	
	local selected = {}
	local function display_selection()
		local lines = {"Select libraries (Enter to toggle, Space to select/deselect, Escape to finish):", ""}
		for i, lib in ipairs(lib_choices) do
			local marker = (vim.tbl_contains(selected, i) and "✓") or "□"
			local line = string.format("  %s %d. %s - %s", marker, i, lib.name, lib.description)
			table.insert(lines, line)
		end
		return lines
	end
	
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, display_selection())
	vim.api.nvim_buf_set_option(buf, "modifiable", false)
	vim.api.nvim_buf_set_option(buf, "readonly", false)
	
	-- Create window in floating configuration
	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = math.min(80, vim.o.columns - 4),
		height = math.min(#lib_choices + 3, vim.o.lines - 4),
		col = math.floor((vim.o.columns - math.min(80, vim.o.columns - 4)) / 2),
		row = math.floor((vim.o.lines - math.min(#lib_choices + 3, vim.o.lines - 4)) / 2),
		border = "rounded",
		style = "minimal",
	})
	
	-- Key mappings (same as original)
	local function update_display()
		vim.api.nvim_buf_set_option(buf, "modifiable", true)
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, display_selection())
		vim.api.nvim_buf_set_option(buf, "modifiable", false)
	end
	
	local function toggle_item()
		local line = vim.api.nvim_win_get_cursor(win)[1]
		if line > 2 and line <= #lib_choices + 2 then
			local index = line - 2
			if vim.tbl_contains(selected, index) then
				selected = vim.tbl_filter(function(i) return i ~= index end, selected)
			else
				-- If "None" is selected, clear other selections
				if index == 1 then
					selected = {1}
				else
					-- Remove "None" if other libraries are selected
					selected = vim.tbl_filter(function(i) return i ~= 1 end, selected)
					table.insert(selected, index)
				end
			end
			update_display()
		end
	end
	
	vim.api.nvim_buf_set_keymap(buf, "n", "<Enter>", "", {
		callback = toggle_item,
		desc = "Toggle library selection",
	})
	vim.api.nvim_buf_set_keymap(buf, "n", "<Space>", "", {
		callback = toggle_item,
		desc = "Toggle library selection",
	})
	vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", "", {
		callback = function()
			vim.api.nvim_win_close(win, true)
			if on_complete then
				local result = {}
				for _, index in ipairs(selected) do
					if index > 1 then -- Skip "None" option
						table.insert(result, lib_choices[index])
					end
				end
				on_complete(result)
			end
		end,
		desc = "Finish selection",
	})
	vim.api.nvim_buf_set_keymap(buf, "n", "q", "", {
		callback = function()
			vim.api.nvim_win_close(win, true)
			if on_complete then
				on_complete({})
			end
		end,
		desc = "Cancel selection",
	})
	
	-- Set cursor position
	vim.api.nvim_win_set_cursor(win, {3, 0})
end

-- Export both versions
return {
	select_libraries = M.select_libraries,
	select_libraries_fallback = M.select_libraries_fallback,
}