-- p5.nvim entry point
local I = {}

I.config = {
  server = {
    port = 8000,
    auto_start = false,
    auto_open_browser = true,
    preferred_order = {"python"},
    ready_timeout = 5000,
    fallback_ports = {8001, 8002, 8003},
    live_reload = {
      enabled = true,
      port = 12002,
      debounce_ms = 300,
      watch_extensions = {".js", ".css", ".html", ".json"},
      exclude_dirs = {".git", "node_modules", "dist", "build"}
    }
  },
  console = {
    enabled = true,
    auto_show = true,
    position = "below",
    height = 10,
    buffer_size = 1000,
    heartbeat = 15
  },
  libraries = {
    cdn_sources = {"jsdelivr", "cdnjs", "unpkg"},
    auto_update = false
  }
}

I.setup = function(opts)
  I.config = vim.tbl_deep_extend("force", I.config, opts or {})

  local core = require("p5.core")
  local project = require("p5.project")
  local server = require("p5.server")
  local libraries = require("p5.libraries")
  local console = require("p5.console")
  local gist = require("p5.gist")

  core.setup(I.config)
  project.setup(I.config)
  server.setup(I.config)
  libraries.setup(I.config)
  console.setup(I.config)
  gist.setup(I.config)

  local function in_sketchspace()
    local is_proj = project.is_p5_project()
    return is_proj
  end

  local function require_sketchspace(action)
    if not in_sketchspace() then
      core.notify(action .. " requires a sketchspace (p5.json)", "error")
      return false
    end
    return true
  end

  vim.api.nvim_create_user_command("P5", function()
    local server_status = server.server_job and "Stop server" or "Start server"
    
    local options = {
      "Create new sketchspace",
      "Setup sketchspace",
      "Install library",
      "Uninstall library",
      server_status,
      "Toggle console",
      "Open docs",
      "Sync",
      "Create/update Gist",
    }
    
    vim.ui.select(options, { prompt = "p5.nvim:" }, function(choice)
      if choice == "Create new sketchspace" then
        vim.cmd("P5Create")
      elseif choice == "Setup sketchspace" then
        vim.cmd("P5Setup")
      elseif choice == "Install library" then
        vim.cmd("P5Install")
      elseif choice == "Uninstall library" then
        vim.cmd("P5Uninstall")
      elseif choice == "Start server" or choice == "Stop server" then
        vim.cmd("P5Server")
      elseif choice == "Toggle console" then
        vim.cmd("P5Console")
      elseif choice == "Open docs" then
        vim.cmd("P5Docs")
      elseif choice == "Sync" then
        vim.cmd("P5Sync")
      elseif choice == "Create/update Gist" then
        vim.cmd("P5Gist")
      end
    end)
  end, { nargs = 0 })

  vim.api.nvim_create_user_command("P5Create", function(opts)
    local name = opts.args and #opts.args > 0 and opts.args[1] or nil
    if not name then
      vim.ui.input({
        prompt = "Sketchspace name: ",
        default = "p5-sketch",
        completion = "dir",
      }, function(input)
        if input and input ~= "" then
          project.create_project(input)
        end
      end)
    else
      project.create_project(name)
    end
  end, { nargs = "?" })

  vim.api.nvim_create_user_command("P5Install", function(opts)
    if not require_sketchspace("Install") then return end
    
    local lib_names = opts.args and #opts.args > 0 and opts.args or nil
    if not lib_names then
      local libs = libraries.get_available_libs()
      if not libs or #libs == 0 then
        core.notify("No libraries available", "warn")
        return
      end
      local items = {}
      local lib_map = {}
      for _, lib in ipairs(libs) do
        local display = lib.name
        if lib.description and lib.description ~= "" then
          display = display .. " - " .. lib.description
        end
        if lib.status and lib.status ~= "" then
          display = display .. " " .. lib.status
        end
        table.insert(items, display)
        lib_map[display] = lib.name
      end
      vim.ui.select(items, { prompt = "Select library to install:" }, function(selected)
        if selected then
          local lib_name = lib_map[selected] or selected
          libraries.install_libs({lib_name})
        end
      end)
    else
      libraries.install_libs(lib_names)
    end
  end, { nargs = "*" })

  vim.api.nvim_create_user_command("P5Uninstall", function(opts)
    if not require_sketchspace("Uninstall") then return end
    
    local lib_names = opts.args and #opts.args > 0 and opts.args or nil
    if not lib_names then
      local installed = libraries.get_installed_libs()
      if #installed == 0 then
        core.notify("No contrib libraries installed", "warn")
        return
      end
      local items = {}
      local lib_map = {}
      for _, lib in ipairs(installed) do
        table.insert(items, lib.name)
        lib_map[lib.name] = lib.name
      end
      vim.ui.select(items, { prompt = "Select library to uninstall:" }, function(selected)
        if selected then
          local lib_name = lib_map[selected] or selected
          libraries.uninstall_libs({lib_name})
        end
      end)
    else
      libraries.uninstall_libs(lib_names)
    end
  end, { nargs = "*" })

  vim.api.nvim_create_user_command("P5Docs", function()
    local snacks = core.require_snacks()
    if snacks and snacks.picker then
      snacks.picker({
        source = "help",
        search = "p5",
      })
    else
      vim.cmd("help p5-nvim")
    end
  end, { nargs = 0 })

  vim.api.nvim_create_user_command("P5Sync", function(opts)
    local target = opts.args and opts.args[1] or nil
    
    if not target then
      vim.ui.select({"Gist", "Libraries"}, { prompt = "What to sync:" }, function(choice)
        if choice == "Gist" then
          gist.update_current_gist()
        elseif choice == "Libraries" then
          libraries.update_libs()
        end
      end)
    elseif target == "gist" then
      if not require_sketchspace("Sync gist") then return end
      gist.update_current_gist()
    elseif target == "libs" or target == "libraries" then
      if not require_sketchspace("Sync libraries") then return end
      libraries.update_libs()
    else
      core.notify("Unknown sync target: " .. target .. ". Use 'gist' or 'libs'", "warn")
    end
  end, { nargs = "?" })

  vim.api.nvim_create_user_command("P5Update", function()
    libraries.update_libs()
  end, { nargs = 0 })

  vim.api.nvim_create_user_command("P5Server", function(opts)
    if server.server_job then
      server.stop_server()
    else
      local port = nil
      if opts.args and opts.args[1] then
        port = tonumber(opts.args[1])
      end
      server.start_server(port)
    end
  end, { nargs = "?" })

  vim.api.nvim_create_user_command("P5Console", function()
    console.toggle()
  end, { nargs = 0 })

  vim.api.nvim_create_user_command("P5Gist", function(opts)
    if not require_sketchspace("Gist") then return end
    local desc = opts.args and opts.args[1] or nil
    gist.create_gist(desc)
  end, { nargs = "?" })

  vim.api.nvim_create_user_command("P5GistUpdate", function()
    gist.update_current_gist()
  end, { nargs = 0 })

  vim.api.nvim_create_user_command("P5Setup", function()
    if not require_sketchspace("Setup") then return end
    
    local cwd = vim.fn.getcwd()
    
    project.copy_assets_to_project(cwd, function(err)
      if err then
        core.notify("Failed to copy assets: " .. err, "error")
        return
      end
      
      core.notify("Assets copied successfully", "info")
      
      libraries.generate_libs_js(cwd)
      
      local config = core.read_workspace_config()
      if config and config.libs then
        local lib_names = vim.tbl_keys(config.libs)
        if #lib_names > 0 then
          libraries.install_libs(lib_names)
        end
      end
      
      core.notify("Sketchspace setup complete", "ok")
    end)
  end, { nargs = 0 })
end

return I
