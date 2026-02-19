-- GitHub Gist integration for p5.nvim
local G = {}
local core = require("p5.core")

-- Create gist from current project
G.create_gist = function(description)
  if not core.command_exists("gh") then
    core.notify("GitHub CLI (gh) not found. Install gh to use gist functionality", "error")
    return
  end

  local config = core.read_workspace_config()
  if not config then
    core.notify("Not in a p5.js project", "error")
    return
  end

  local project_path = vim.fn.getcwd()
  local files_to_include = {
    {path = "sketch.js", name = "sketch.js"},
    {path = "index.html", name = "index.html"},
    {path = "p5.json", name = "p5.json"}
  }

  -- Check if all required files exist
  for _, file in ipairs(files_to_include) do
    if vim.fn.filereadable(project_path .. "/" .. file.path) == 0 then
      core.notify("Required file not found: " .. file.path, "error")
      return
    end
  end

  -- Create temporary files for gist
  local temp_files = {}
  local gist_files = {}

  for _, file in ipairs(files_to_include) do
    local temp_path = "/tmp/p5_gist_" .. file.name
    vim.fn.system("cp '" .. project_path .. "/" .. file.path .. "' '" .. temp_path .. "'")
    
    table.insert(temp_files, temp_path)
    table.insert(gist_files, temp_path)
  end

  -- Build gh command
  local cmd = {"gh", "gist", "create"}
  
  if description and description ~= "" then
    table.insert(cmd, "--desc")
    table.insert(cmd, description)
  else
    table.insert(cmd, "--desc")
    table.insert(cmd, "p5.js sketch from " .. config.name)
  end

  table.insert(cmd, "--public")
  for _, file in ipairs(gist_files) do
    table.insert(cmd, file)
  end

  -- Execute gh command
  local result = vim.fn.system(cmd)
  local exit_code = vim.v.shell_error

  -- Clean up temporary files
  for _, temp_file in ipairs(temp_files) do
    vim.fn.delete(temp_file)
  end

  if exit_code == 0 then
    -- Extract gist URL from result
    local url = result:match("https://gist%.github%.com/%S+")
    if url then
      core.notify("Gist created: " .. url, "ok")
      
      -- Copy URL to clipboard
      vim.fn.setreg("+", url)
      
      -- Open in browser
      vim.fn.system({ "xdg-open", url })
    else
      core.notify("Gist created (could not extract URL)", "ok")
    end
  else
    core.notify("Failed to create gist: " .. result, "error")
  end
end

-- Update existing gist
G.update_gist = function(gist_id)
  if not gist_id then
    core.notify("Gist ID required for update", "error")
    return
  end

  if not core.command_exists("gh") then
    core.notify("GitHub CLI (gh) not found", "error")
    return
  end

  local project_path = vim.fn.getcwd()
  
  -- Create temporary file for updated sketch
  local temp_sketch = "/tmp/p5_gist_update_sketch.js"
  vim.fn.system("cp '" .. project_path .. "/sketch.js' '" .. temp_sketch .. "'")

  -- Update gist with only sketch.js
  local cmd = {"gh", "gist", "edit", gist_id, temp_sketch}
  local result = vim.fn.system(cmd)
  local exit_code = vim.v.shell_error

  -- Clean up
  vim.fn.delete(temp_sketch)

  if exit_code == 0 then
    core.notify("Gist updated successfully", "ok")
    
    -- Extract URL
    local url = result:match("https://gist%.github%.com/%S+")
    if url then
      -- Open in browser
      vim.fn.system({ "xdg-open", url })
    end
  else
    core.notify("Failed to update gist: " .. result, "error")
  end
end

-- List gists
G.list_gists = function()
  if not core.command_exists("gh") then
    core.notify("GitHub CLI (gh) not found", "error")
    return
  end

  local cmd = {"gh", "gist", "list", "--limit", "20"}
  local result = vim.fn.system(cmd)
  local exit_code = vim.v.shell_error

  if exit_code == 0 then
    -- Create a new buffer to display gists
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(result, "\n"))
    vim.api.nvim_buf_set_name(buf, "p5-gists")
    vim.api.nvim_set_option_value("filetype", "text", { buf = buf })

    -- Show in new window
    vim.cmd("split")
    local win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(win, buf)
    
    -- Set up keymaps to open gist
    vim.api.nvim_buf_set_keymap(buf, "n", "<CR>", "", {
      callback = function()
        local line = vim.api.nvim_get_current_line()
        local gist_id = line:match("(%w+)")
        if gist_id then
          vim.cmd("bdelete")
          G.open_gist(gist_id)
        end
      end,
      desc = "Open p5 gist"
    })
  else
    core.notify("Failed to list gists: " .. result, "error")
  end
end

-- Open gist in browser
G.open_gist = function(gist_id)
  if not gist_id then
    core.notify("Gist ID required", "error")
    return
  end

  local cmd = {"gh", "gist", "view", gist_id, "--web"}
  local result = vim.fn.system(cmd)
  local exit_code = vim.v.shell_error

  if exit_code ~= 0 then
    core.notify("Failed to open gist: " .. result, "error")
  end
end

-- Clone gist as new p5 project
G.clone_gist = function(gist_id)
  if not gist_id then
    core.notify("Gist ID required", "error")
    return
  end

  if not core.command_exists("gh") then
    core.notify("GitHub CLI (gh) not found", "error")
    return
  end

  -- Get gist info
  local cmd = {"gh", "gist", "view", gist_id}
  local result = vim.fn.system(cmd)
  local exit_code = vim.v.shell_error

  if exit_code ~= 0 then
    core.notify("Failed to get gist info: " .. result, "error")
    return
  end

  -- Extract description for project name
  local description = result:match("# ([^\n]+)") or "p5-sketch-from-gist"
  local project_name = description:gsub("%s+", "-"):lower()

  -- Create project directory
  if vim.fn.isdirectory(project_name) ~= 0 then
    core.notify("Directory '" .. project_name .. "' already exists", "error")
    return
  end

  vim.fn.mkdir(project_name, "p")
  local project_path = vim.fn.fnamemodify(project_name, ":p")

  -- Clone gist files
  cmd = {"gh", "gist", "clone", gist_id, project_path}
  result = vim.fn.system(cmd)
  exit_code = vim.v.shell_error

  if exit_code == 0 then
    -- Create p5.json if not exists
    if vim.fn.filereadable(project_path .. "/p5.json") == 0 then
      local p5_config = string.format([[
{
  "name": "%s",
  "version": "1.0.0", 
  "p5js_version": "latest",
  "libraries": [],
  "server": {
    "type": "python",
    "port": 8000
  },
  "console": {
    "enabled": true,
    "position": "below",
    "height": 10
  },
  "gist": {
    "id": "%s",
    "cloned_at": "%s"
  }
}]], project_name, gist_id, os.date("%Y-%m-%d"))
      
      vim.fn.writefile(vim.split(p5_config, "\n"), project_path .. "/p5.json")
    end

    -- Open project
    vim.cmd("edit " .. project_path .. "/sketch.js")
    core.notify("Cloned gist as p5 project: " .. project_name, "ok")
  else
    -- Clean up failed clone
    vim.fn.delete(project_path, "rf")
    core.notify("Failed to clone gist: " .. result, "error")
  end
end

-- Get current gist info from project
G.get_project_gist = function()
  local config = core.read_workspace_config()
  if not config or not config.gist or not config.gist.id then
    return nil
  end
  
  return config.gist
end

-- Update current project's gist
G.update_current_gist = function()
  local gist_info = G.get_project_gist()
  if not gist_info then
    core.notify("No gist associated with current project", "warn")
    return
  end

  G.update_gist(gist_info.id)
end

G.setup = function(config)
  G.config = config
end

return G