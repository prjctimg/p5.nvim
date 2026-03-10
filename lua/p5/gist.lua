-- GitHub Gist integration for p5.nvim
local G = {}
local core = require("p5.core")

local gh_available = nil

local function check_gh()
  if gh_available == nil then
    gh_available = core.command_exists("gh")
  end
  return gh_available
end

local function get_gist_temp_dir()
  local temp_base = vim.fn.stdpath("cache") or (vim.uv.os_tmpdir() or "/tmp")
  return temp_base .. "/p5_gist"
end

-- Get files to include in gist from p5.json config
G.get_includes = function(proj_dir, config)
  local includes = config.includes or {"sketch.js"}
  
  -- Filter out assets/ directory with warning and validate paths
  local filtered = {}
  local has_assets = false
  for _, file in ipairs(includes) do
    -- Ensure file is a string
    if type(file) ~= "string" then
      core.notify("Skipping non-string include: " .. tostring(file), "error")
    else
      -- Validate path for security (prevent path traversal)
      local is_unsafe = false
      
      -- Check for path traversal patterns
      if file:match("%.%.") then
        core.notify("Skipping unsafe path (parent dir reference): " .. file, "error")
        is_unsafe = true
      -- Check for absolute paths
      elseif file:match("^/") then
        core.notify("Skipping absolute path: " .. file, "error")
        is_unsafe = true
      -- Check for home directory expansion
      elseif file:match("^~") then
        core.notify("Skipping home dir path: " .. file, "error")
        is_unsafe = true
      -- Check for Windows drive letters
      elseif file:match("^[A-Za-z]:") then
        core.notify("Skipping drive letter path: " .. file, "error")
        is_unsafe = true
      -- Check for NUL bytes
      elseif file:match("%z") then
        core.notify("Skipping path with null byte: " .. file, "error")
        is_unsafe = true
      end
      
      if is_unsafe then
        -- Skip this entry
      elseif file:match("^assets/") or file:match("^assets$") then
        has_assets = true
      else
        table.insert(filtered, file)
      end
    end
  end
  
  if has_assets then
    core.notify("Note: assets/ directory excluded from gist (not needed for sketchspace)", "warn")
  end
  
  -- Always include p5.json
  table.insert(filtered, "p5.json")
  
  return filtered
end

-- Create gist from current project
G.create_gist = function(description)
  if not check_gh() then
    core.notify("GitHub CLI (gh) not found. Install gh to use gist functionality", "error")
    return
  end

  local project_dir, config = core.find_project_root()
  if not config then
    core.notify("Not in a sketchspace (p5.json required)", "error")
    return
  end

  local files_to_include_names = G.get_includes(project_dir, config)

  local missing_files = {}
  for _, file_name in ipairs(files_to_include_names) do
    if not core.file_exists(project_dir .. "/" .. file_name) then
      table.insert(missing_files, file_name)
    end
  end

  if #missing_files > 0 then
    core.notify("Missing files: " .. table.concat(missing_files, ", "), "error")
    return
  end

  local function proceed_with_gist(desc, proj_dir, proj_config)
    local temp_files = {}
    local gist_files = {}

    local gist_temp_dir = get_gist_temp_dir()
    vim.fn.mkdir(gist_temp_dir, "p")

    local unique_dir = gist_temp_dir .. "/" .. os.time() .. "_" .. vim.fn.getpid()
    vim.fn.mkdir(unique_dir, "p")

    for _, file_name in ipairs(files_to_include_names) do
      local target_path = unique_dir .. "/" .. file_name
      local source_path = vim.fn.fnamemodify(proj_dir .. "/" .. file_name, ":p")

      local parent_dir = vim.fn.fnamemodify(target_path, ":h")
      if parent_dir ~= unique_dir then
        vim.fn.mkdir(parent_dir, "p")
      end

      vim.fn.system({"cp", source_path, target_path})
      if vim.v.shell_error ~= 0 then
        core.notify("Failed to copy file: " .. file_name, "error")
        vim.fn.delete(unique_dir, "rf")
        return
      end

      table.insert(temp_files, target_path)
      table.insert(gist_files, target_path)
    end

    local cmd = {"gh", "gist", "create"}

    if desc and desc ~= "" then
      table.insert(cmd, "--desc")
      table.insert(cmd, desc)
    else
      table.insert(cmd, "--desc")
      table.insert(cmd, "p5.js sketch from " .. (proj_config.name or "sketchspace"))
    end

    table.insert(cmd, "--public")
    for _, file_path in ipairs(gist_files) do
      table.insert(cmd, file_path)
    end

    local result = vim.fn.system(cmd)
    local exit_code = vim.v.shell_error

    vim.fn.delete(unique_dir, "rf")

    if exit_code ~= 0 then
      core.notify("Failed to create gist: " .. result, "error")
      return
    end

    local url = result:match("https://gist%.github%.com/%S+")

    if url then
      proj_config.gist = url
      core.write_workspace_config(proj_config, proj_dir)
      core.notify("Gist created: " .. url, "ok")
    else
      core.notify("Failed to extract gist URL: " .. result, "error")
    end
  end

  -- If description provided, proceed directly
  if description and description ~= "" then
    proceed_with_gist(description, project_dir, config)
  else
    -- Prompt for description
    vim.ui.input({
      prompt = "Gist description: ",
      default = "p5.js sketch from " .. (config.name or "sketchspace"),
      completion = "file",
    }, function(input)
      if input and input ~= "" then
        proceed_with_gist(input, project_dir, config)
      else
        core.notify("Gist creation cancelled", "info")
      end
    end)
  end
end

-- Update existing gist
G.update_gist = function(gist_id)
  local project_dir, config = core.find_project_root()
  if not config then
    core.notify("Not in a sketchspace", "error")
    return
  end

  if not gist_id then
    if config.gist then
      if type(config.gist) == "table" then
        gist_id = config.gist.id
      else
        gist_id = config.gist:match("/([a-fA-F0-9]+)$")
      end
    end

    if not gist_id then
      core.notify("No gist associated with this sketchspace. Run :P5Gist to create one.", "error")
      return
    end
  end

  local files_to_update = G.get_includes(project_dir, config)

  local temp_base = vim.fn.stdpath("cache") or (vim.uv.os_tmpdir() or "/tmp")
  local gist_temp_dir = temp_base .. "/p5_gist_update"
  vim.fn.mkdir(gist_temp_dir, "p")

  local update_errors = {}
  for _, file_name in ipairs(files_to_update) do
    if file_name ~= "p5.json" then
      local temp_file = gist_temp_dir .. "/" .. os.time() .. "_" .. vim.fn.getpid() .. "_" .. vim.fn.fnamemodify(file_name, ":t")
      local source_path = project_dir .. "/" .. file_name

      vim.fn.system({"cp", source_path, temp_file})
      if vim.v.shell_error ~= 0 then
        table.insert(update_errors, "Failed to copy: " .. file_name)
      else
        local cmd = {"gh", "gist", "edit", gist_id, "--filename", file_name, temp_file}
        vim.fn.system(cmd)
        if vim.v.shell_error ~= 0 then
          table.insert(update_errors, "Failed to update: " .. file_name)
        end

        vim.fn.delete(temp_file)
      end
    end
  end

  if #update_errors > 0 then
    core.notify("Gist update partially failed: " .. table.concat(update_errors, ", "), "error")
    return
  end

  core.notify("Gist updated successfully", "ok")

  if config.gist then
    local url = type(config.gist) == "string" and config.gist or config.gist.url
    if url then
      if vim.ui and vim.ui.open then
        vim.ui.open(url)
      else
        local open_cmd
        if vim.fn.has("mac") == 1 then
          open_cmd = {"open", url}
        elseif vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
          open_cmd = {"cmd", "/c", "start", "", url}
        else
          open_cmd = {"xdg-open", url}
        end
        vim.fn.system(open_cmd)
      end
    end
  end
end

-- List gists
G.list_gists = function()
  if not check_gh() then
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

  if not check_gh() then
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
      local p5_config = {
        version = "1.9.0",
        libs = {},
        includes = {"sketch.js"},
        gist = {
          id = gist_id,
          cloned_at = os.date("%Y-%m-%d")
        }
      }
      
      vim.fn.writefile(vim.split(vim.fn.json_encode(p5_config), "\n"), project_path .. "/p5.json")
    end

    -- Open project
    vim.cmd("edit " .. project_path .. "/sketch.js")
    core.notify("Cloned gist as sketchspace: " .. project_name, "ok")
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
    core.notify("No gist associated with current sketchspace", "warn")
    return
  end

  G.update_gist(gist_info.id)
end

-- Download gist files to current project
G.download_gist = function(gist_id, project_dir)
  project_dir = vim.fs.normalize(project_dir or vim.fn.getcwd())

  if not gist_id then
    return false, "No gist ID provided"
  end

  if not check_gh() then
    return false, "GitHub CLI (gh) not found"
  end

  -- Get gist files in JSON format
  local cmd = {"gh", "gist", "view", gist_id, "--json", "files"}
  local result = vim.fn.system(cmd)
  local exit_code = vim.v.shell_error

  if exit_code ~= 0 then
    return false, "Gist not found or no longer exists: " .. result
  end

  -- Parse JSON response
  local ok, gist_data = pcall(vim.fn.json_decode, result)
  if not ok or not gist_data.files then
    return false, "Failed to parse gist data"
  end

  local files = gist_data.files
  local downloaded = {}
  local skipped = {}

  for filename, filedata in pairs(files) do
    local target_path = project_dir .. "/" .. filename

    if core.file_exists(target_path) then
      table.insert(skipped, filename)
    else
      local content = filedata.content or ""
      vim.fn.writefile(vim.split(content, "\n"), target_path)
      table.insert(downloaded, filename)
    end
  end

  local msg = {}
  if #downloaded > 0 then
    table.insert(msg, "Downloaded: " .. table.concat(downloaded, ", "))
  end
  if #skipped > 0 then
    table.insert(msg, "Skipped (exists): " .. table.concat(skipped, ", "))
  end

  if #msg > 0 then
    core.notify(table.concat(msg, " | "), "info")
  end

  return true, nil
end

G.setup = function(config)
  G.config = config
end

return G
