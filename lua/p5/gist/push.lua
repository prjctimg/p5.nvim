local M = {}

-- Check if gh CLI is available
local function check_gh_cli()
  return vim.fn.executable("gh") == 1
end

-- Get current project files
local function get_project_files()
  local files = {}
  local project_dir = vim.fn.getcwd()
  
  -- Core p5.js files to include
  local core_files = {"sketch.js", "index.html", "style.css", "README.md"}
  
  for _, filename in ipairs(core_files) do
    local filepath = project_dir .. "/" .. filename
    if vim.fn.filereadable(filepath) == 1 then
      local content = vim.fn.readfile(filepath)
      table.insert(files, {
        name = filename,
        content = table.concat(content, "\n")
      })
    end
  end
  
  -- Also include any additional .js files
  local js_files = vim.fn.glob(project_dir .. "/*.js", false, true)
  for _, filepath in ipairs(js_files) do
    local filename = vim.fn.fnamemodify(filepath, ":t")
    if filename ~= "sketch.js" and not files[filename] then
      local content = vim.fn.readfile(filepath)
      table.insert(files, {
        name = filename,
        content = table.concat(content, "\n")
      })
    end
  end
  
  return files
end

-- Create gist description
local function create_gist_description(project_name)
  local timestamp = os.date("%Y-%m-%d %H:%M:%S")
  return "p5.js sketch - " .. project_name .. " (" .. timestamp .. ")"
end

-- Use UI for gist options
local function get_gist_options()
  local input = require("p5.ui.input")
  
  -- Get project name from directory
  local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
  
  return vim.schedule(function()
    input.input({
      title = "GitHub Gist Options",
      prompt = "Gist description: ",
      default = create_gist_description(project_name)
    }, function(description)
      if description and description ~= "" then
        M.create_gist(description)
      else
        vim.notify("Gist creation cancelled", vim.log.levels.INFO)
      end
    end)
  end)
end

-- Create and push gist
function M.create_gist(description)
  if not check_gh_cli() then
    vim.notify("GitHub CLI (gh) not found. Install with: https://cli.github.com/", vim.log.levels.ERROR)
    return
  end
  
  local files = get_project_files()
  if #files == 0 then
    vim.notify("No p5.js files found in current directory", vim.log.levels.ERROR)
    return
  end
  
  -- Create temporary directory for gist
  local temp_dir = vim.fn.tempname()
  vim.fn.mkdir(temp_dir, "p")
  
  -- Write files to temp directory
  for _, file in ipairs(files) do
    local filepath = temp_dir .. "/" .. file.name
    local file_handle = io.open(filepath, "w")
    if file_handle then
      file_handle:write(file.content)
      file_handle:close()
    end
  end
  
  -- Create gist using gh CLI
  local cmd = string.format('cd "%s" && gh gist create %s --desc "%s" --public', 
                           temp_dir, 
                           table.concat(vim.fn.glob(temp_dir .. "/*", false, true), " "),
                           description)
  
  vim.notify("Creating GitHub Gist...", vim.log.levels.INFO)
  
  local result = vim.fn.system(cmd)
  
  if vim.v.shell_error == 0 then
    -- Extract URL from result
    local gist_url = result:match("https://gist%.github%.com/%S+")
    if gist_url then
      vim.notify("✅ Gist created successfully!", vim.log.levels.INFO)
      vim.notify("🔗 " .. gist_url, vim.log.levels.INFO)
      
      -- Copy URL to clipboard
      vim.fn.setreg('+', gist_url)
      vim.notify("📋 URL copied to clipboard", vim.log.levels.INFO)
      
      -- Open in browser if configured
      local config = require("p5.config")
      if config.auto_open_enabled() then
        vim.fn.jobstart("xdg-open " .. gist_url, { detach = true })
      end
    else
      vim.notify("✅ Gist created, but couldn't extract URL", vim.log.levels.WARN)
      vim.notify("Output: " .. result, vim.log.levels.INFO)
    end
  else
    vim.notify("❌ Failed to create gist: " .. result, vim.log.levels.ERROR)
  end
  
  -- Cleanup temp directory
  vim.fn.delete(temp_dir, "rf")
end

-- Main gist push function
function M.push_to_gist()
  -- Check if we're in a p5.js project
  local index_file = vim.fn.getcwd() .. "/index.html"
  if vim.fn.filereadable(index_file) ~= 1 then
    vim.notify("Not in a p5.js project (index.html not found)", vim.log.levels.ERROR)
    return
  end
  
  get_gist_options()
end

-- List gists (bonus feature)
function M.list_gists()
  if not check_gh_cli() then
    vim.notify("GitHub CLI (gh) not found", vim.log.levels.ERROR)
    return
  end
  
  vim.notify("Fetching your p5.js gists...", vim.log.levels.INFO)
  
  local cmd = 'gh gist list --limit 10'
  local result = vim.fn.system(cmd)
  
  if vim.v.shell_error == 0 then
    vim.notify("Your recent p5.js gists:", vim.log.levels.INFO)
    vim.notify(result, vim.log.levels.INFO)
  else
    vim.notify("❌ Failed to list gists: " .. result, vim.log.levels.ERROR)
  end
end

return M