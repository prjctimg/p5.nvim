-- GitHub Gist integration for p5.nvim
local G = {}
local core = require("p5.core")

-- Create gist from current project
G.create_gist = function(description)
  if not core.command_exists("gh") then
    core.notify("GitHub CLI (gh) not found. Install gh to use gist functionality", "error")
    return
  end

  -- Find project root and config
  local project_dir, config = core.find_project_root()
  if not config then
    core.notify("Not in a p5.js project", "error")
    return
  end

  local files_to_include = {
    {path = "sketch.js", name = "sketch.js"},
    {path = "index.html", name = "index.html"},
    {path = "p5.json", name = "p5.json"}
  }

  -- Check if all required files exist in the project directory
  for _, file in ipairs(files_to_include) do
    if vim.fn.filereadable(project_dir .. "/" .. file.path) == 0 then
      core.notify("Required file not found: " .. file.path, "error")
      return
    end
  end

  -- Prompt for description if not provided
  local function proceed_with_gist(desc)
    -- Create temporary files for gist
    local temp_files = {}
    local gist_files = {}

    for _, file in ipairs(files_to_include) do
      local temp_path = "/tmp/" .. file.name
      local source_path = vim.fn.fnamemodify(project_dir .. "/" .. file.path, ":p")
      vim.fn.system({"cp", source_path, temp_path})
      
      table.insert(temp_files, temp_path)
      table.insert(gist_files, temp_path)
    end

    -- Build gh command
    local cmd = {"gh", "gist", "create"}
    
    if desc and desc ~= "" then
      table.insert(cmd, "--desc")
      table.insert(cmd, desc)
    else
      table.insert(cmd, "--desc")
      table.insert(cmd, "p5.js sketch from " .. (config.name or "project"))
    end

    table.insert(cmd, "--public")
    for i, file in ipairs(files_to_include) do
      table.insert(cmd, "--filename")
      table.insert(cmd, file.name)
      table.insert(cmd, gist_files[i])
    end

    -- Execute gh command
    local result = vim.fn.system(cmd)
    local exit_code = vim.v.shell_error

    -- Clean up temporary files
    for _, temp_file in ipairs(temp_files) do
      vim.fn.delete(temp_file)
    end

    -- Extract gist URL and ID from result
    local url = result:match("https://gist%.github%.com/%S+")
    local gist_id = url and url:match("/([a-fA-F0-9]+)$")
    
    if url then
      -- Store gist URL in p5.json BEFORE any other operations
      config.gist = url
      core.write_workspace_config(config, project_dir)
      core.notify("Gist URL saved to p5.json", "ok")
      core.notify("🎉 Gist created: " .. url, "ok")
      
      -- Copy URL to clipboard
      vim.fn.setreg("+", url)
      
      -- Open in browser
      vim.fn.system({ "xdg-open", url })
    else
      core.notify("Failed to extract gist URL: " .. result, "error")
    end
  end

  -- If description provided, proceed directly
  if description and description ~= "" then
    proceed_with_gist(description)
  else
    -- Prompt for description
    vim.ui.input({
      prompt = "Gist description: ",
      default = "p5.js sketch from " .. (config.name or "project"),
      completion = "file",
    }, function(input)
      if input and input ~= "" then
        proceed_with_gist(input)
      else
        core.notify("Gist creation cancelled", "info")
      end
    end)
  end
end

-- Update existing gist
G.update_gist = function(gist_id)
  -- Find project root and config
  local project_dir, config = core.find_project_root()
  if not config then
    core.notify("Not in a p5.js project", "error")
    return
  end

  -- Get gist_id from config if not provided
  if not gist_id then
    if config.gist and config.gist.id then
      gist_id = config.gist.id
    else
      core.notify("No gist associated with this project. Run :P5Gist to create one.", "error")
      return
    end
  end

  local temp_sketch = "/tmp/p5_gist_update_sketch.js"
  vim.fn.system({"cp", project_dir .. "/sketch.js", temp_sketch})

  -- Update gist with only sketch.js
  local cmd = {"gh", "gist", "edit", gist_id, "--filename", "sketch.js", temp_sketch}
  local result = vim.fn.system(cmd)
  local exit_code = vim.v.shell_error

  -- Clean up
  vim.fn.delete(temp_sketch)

  if exit_code == 0 then
    core.notify("🎉 Gist updated successfully", "ok")
    
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
      local p5_config = string.format([[{
  "version": "1.0.0",
  "libraries": ["p5", "p5.sound"],
  "gist": {
    "id": "%s",
    "cloned_at": "%s"
  }
}]], gist_id, os.date("%Y-%m-%d"))
      
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
  local _, config = core.find_project_root()
  if not config or not config.gist then
    return nil
  end
  
  -- Handle both string (URL only) and object (legacy) formats
  local gist_url = config.gist
  if type(gist_url) == "table" then
    gist_url = config.gist.url or config.gist.id
  end
  
  if not gist_url then
    return nil
  end
  
  -- Extract gist ID from URL if needed
  local gist_id = gist_url
  if gist_url:match("gist.github.com/") then
    gist_id = gist_url:match("gist.github.com/[^/]+/([a-fA-F0-9]+)$")
    if not gist_id then
      gist_id = gist_url:match("gist.github.com/([a-fA-F0-9]+)$")
    end
  end
  
  return {
    id = gist_id,
    url = gist_url
  }
end

-- Update current project's gist
G.update_current_gist = function()
  local gist_info = G.get_project_gist()
  if not gist_info or not gist_info.id then
    core.notify("No gist associated with current project", "warn")
    return
  end

  G.update_gist(gist_info.id)
end

G.setup = function(config)
  G.config = config
end

return G