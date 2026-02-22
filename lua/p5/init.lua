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

  -- P5 (main picker)
  vim.api.nvim_create_user_command("P5", function()
    local srv = require("p5.server")
    local server_status = srv.server_job and "Stop server" or "Start server"
    local options = {
      "Create new project",
      "Install library",
      "Uninstall library",
      server_status,
      "Toggle console",
      "Open docs",
    }
    vim.ui.select(options, { prompt = "p5.nvim:" }, function(choice)
      if choice == "Create new project" then
        vim.cmd("P5Create")
      elseif choice == "Install library" then
        vim.cmd("P5Install")
      elseif choice == "Uninstall library" then
        vim.cmd("P5Uninstall")
      elseif choice == "Start server" or choice == "Stop server" then
        vim.cmd("P5Server")
      elseif choice == "Toggle console" then
        vim.cmd("P5Console")
      elseif choice == "Open docs" then
        vim.cmd("help p5-nvim")
      end
    end)
  end, { nargs = 0 })

  -- P5 create
  vim.api.nvim_create_user_command("P5Create", function(args)
    if not args.fargs[1] then
      vim.ui.input({
        prompt = "Project name: ",
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

  -- P5 install
  vim.api.nvim_create_user_command("P5Install", function(args)
    if #args.fargs == 0 then
      local libs = require("p5.libraries").get_available_libs()
      -- Map to string for display
      local items = {}
      for _, lib in ipairs(libs) do
        local display = lib.name
        if lib.description and lib.description ~= "" then
          display = display .. " - " .. lib.description
        end
        if lib.status and lib.status ~= "" then
          display = display .. " " .. lib.status
        end
        table.insert(items, { display = display, name = lib.name })
      end
      vim.ui.select(items, { prompt = "Select library to install:" }, function(selected)
        if selected then
          require("p5.libraries").install_libs({selected.name})
        end
      end)
    else
      require("p5.libraries").install_libs(args.fargs)
    end
  end, { nargs = "*" })

  -- P5 uninstall
  vim.api.nvim_create_user_command("P5Uninstall", function(args)
    if #args.fargs == 0 then
      local installed = require("p5.libraries").get_installed_libs()
      -- Map to string for display
      local items = {}
      for _, lib in ipairs(installed) do
        table.insert(items, { display = lib.name, name = lib.name })
      end
      vim.ui.select(items, { prompt = "Select library to uninstall:" }, function(selected)
        if selected then
          require("p5.libraries").uninstall_libs({selected.name})
        end
      end)
    else
      require("p5.libraries").uninstall_libs(args.fargs)
    end
  end, { nargs = "*" })

  -- P5 update
  vim.api.nvim_create_user_command("P5Update", function()
    require("p5.libraries").update_libs()
  end, { nargs = 0 })

  -- P5 server (toggle)
  vim.api.nvim_create_user_command("P5Server", function(args)
    local srv = require("p5.server")
    if srv.server_job then
      srv.stop_server()
    else
      srv.start_server(tonumber(args.fargs[1]))
    end
  end, { nargs = "?" })

  -- P5 console (toggle)
  vim.api.nvim_create_user_command("P5Console", function()
    require("p5.console").toggle()
  end, { nargs = 0 })

  -- P5 gist
  vim.api.nvim_create_user_command("P5Gist", function(args)
    require("p5.gist").create_gist(args.fargs[1])
  end, { nargs = "?" })

  -- P5 setup
  vim.api.nvim_create_user_command("P5Setup", function()
    require("p5.core").setup_environment()
  end, { nargs = 0 })
end

return I
