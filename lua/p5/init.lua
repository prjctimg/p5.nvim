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

  -- Helper to check if in sketchspace
  local function in_sketchspace()
    local is_proj, _, _ = project.is_p5_project()
    return is_proj
  end

  -- Helper to require sketchspace
  local function require_sketchspace(action)
    if not in_sketchspace() then
      core.notify(action .. " requires a sketchspace (p5.json)", "error")
      return false
    end
    return true
  end

  -- P5 (main picker)
  vim.api.nvim_create_user_command("P5", function()
    local srv = require("p5.server")
    local is_proj = in_sketchspace()
    local server_status = srv.server_job and "Stop server" or "Start server"
    
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

  -- P5 create [name]
  vim.api.nvim_create_user_command("P5Create", function(args)
    if not args.fargs[1] then
      vim.ui.input({
        prompt = "Sketchspace name: ",
        default = "p5-sketch",
        completion = "dir",
      }, function(input)
        if input and input ~= "" then
          require("p5.project").create_project(input)
        end
      end)
    else
      require("p5.project").create_project(args.fargs[1])
    end
  end, { nargs = "?" })

  -- P5 install [libs...]
  vim.api.nvim_create_user_command("P5Install", function(args)
    if not require_sketchspace("Install") then return end
    
    if #args.fargs == 0 then
      local libs = require("p5.libraries").get_available_libs()
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
          require("p5.libraries").install_libs({lib_name})
        end
      end)
    else
      require("p5.libraries").install_libs(args.fargs)
    end
  end, { nargs = "*" })

  -- P5 uninstall [libs...]
  vim.api.nvim_create_user_command("P5Uninstall", function(args)
    if not require_sketchspace("Uninstall") then return end
    
    if #args.fargs == 0 then
      local installed = require("p5.libraries").get_installed_libs()
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
          require("p5.libraries").uninstall_libs({lib_name})
        end
      end)
    else
      require("p5.libraries").uninstall_libs(args.fargs)
    end
  end, { nargs = "*" })

  -- P5 docs
  vim.api.nvim_create_user_command("P5Docs", function()
    local snacks = core.require_snacks()
    if snacks and snacks.picker then
      snacks.picker({
        source = {
          name = "Help",
        },
        search = "p5",
      })
    else
      vim.cmd("help p5-nvim")
    end
  end, { nargs = 0 })

  -- P5 sync [gist|libs]
  vim.api.nvim_create_user_command("P5Sync", function(args)
    local target = args.fargs[1]
    
    if not target then
      vim.ui.select({"Gist", "Libraries"}, { prompt = "What to sync:" }, function(choice)
        if choice == "Gist" then
          require("p5.gist").update_current_gist()
        elseif choice == "Libraries" then
          require("p5.libraries").update_libs()
        end
      end)
    elseif target == "gist" then
      if not require_sketchspace("Sync gist") then return end
      require("p5.gist").update_current_gist()
    elseif target == "libs" or target == "libraries" then
      if not require_sketchspace("Sync libraries") then return end
      require("p5.libraries").update_libs()
    else
      core.notify("Unknown sync target: " .. target .. ". Use 'gist' or 'libs'", "warn")
    end
  end, { nargs = "?" })

  -- P5 update (legacy, use P5Sync libs instead)
  vim.api.nvim_create_user_command("P5Update", function()
    require("p5.libraries").update_libs()
  end, { nargs = 0 })

  -- P5 server [port]
  vim.api.nvim_create_user_command("P5Server", function(args)
    local srv = require("p5.server")
    if srv.server_job then
      srv.stop_server()
    else
      srv.start_server(tonumber(args.fargs[1]))
    end
  end, { nargs = "?" })

  -- P5 console
  vim.api.nvim_create_user_command("P5Console", function()
    require("p5.console").toggle()
  end, { nargs = 0 })

  -- P5 gist [description]
  vim.api.nvim_create_user_command("P5Gist", function(args)
    if not require_sketchspace("Gist") then return end
    require("p5.gist").create_gist(args.fargs[1])
  end, { nargs = "?" })

  -- P5 gist-update (legacy, use P5Sync gist instead)
  vim.api.nvim_create_user_command("P5GistUpdate", function()
    require("p5.gist").update_current_gist()
  end, { nargs = 0 })

  -- P5 setup - Setup assets in current sketchspace
  vim.api.nvim_create_user_command("P5Setup", function()
    if not require_sketchspace("Setup") then return end
    
    local project_mod = require("p5.project")
    local libs_mod = require("p5.libraries")
    local cwd = vim.fn.getcwd()
    
    -- Copy assets to project
    project_mod.copy_assets_to_project(cwd, function(err)
      if err then
        core.notify("Failed to copy assets: " .. err, "error")
        return
      end
      
      core.notify("Assets copied successfully", "info")
      
      -- Generate libs.js
      libs_mod.generate_libs_js(cwd)
      
      -- Install libraries from p5.json
      local config = core.read_workspace_config()
      if config and config.libs then
        local lib_names = vim.tbl_keys(config.libs)
        if #lib_names > 0 then
          libs_mod.install_libs(lib_names)
        end
      end
      
      core.notify("Sketchspace setup complete", "ok")
    end)
  end, { nargs = 0 })
end

return I
