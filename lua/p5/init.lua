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
    local options = {
      "Create new project",
      "Install library",
      "Uninstall library",
      "Start server",
      "Stop server",
      "Toggle console",
      "Open docs",
    }
    vim.ui.select(options, { prompt = "p5.nvim:" }, function(choice)
      if choice == "Create new project" then
        vim.cmd("P5CreateProject")
      elseif choice == "Install library" then
        vim.cmd("P5InstallLib")
      elseif choice == "Uninstall library" then
        vim.cmd("P5RemoveLib")
      elseif choice == "Start server" then
        vim.cmd("P5StartServer")
      elseif choice == "Stop server" then
        vim.cmd("P5StopServer")
      elseif choice == "Toggle console" then
        vim.cmd("P5ToggleConsole")
      elseif choice == "Open docs" then
        vim.cmd("help p5-nvim")
      end
    end)
  end, { nargs = 0 })

  -- P5 create-project
  vim.api.nvim_create_user_command("P5CreateProject", function(args)
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

  -- P5 install-lib
  vim.api.nvim_create_user_command("P5InstallLib", function(args)
    if #args.fargs == 0 then
      require("p5.libraries").show_and_install()
    else
      require("p5.libraries").install_libs(args.fargs)
    end
  end, { nargs = "*" })

  -- P5 remove-lib
  vim.api.nvim_create_user_command("P5RemoveLib", function(args)
    if #args.fargs == 0 then
      require("p5.libraries").show_uninstall_picker()
    else
      require("p5.libraries").uninstall_libs(args.fargs)
    end
  end, { nargs = "*" })

  -- P5 update-libs
  vim.api.nvim_create_user_command("P5UpdateLibs", function()
    require("p5.libraries").update_libs()
  end, { nargs = 0 })

  -- P5 start-server
  vim.api.nvim_create_user_command("P5StartServer", function(args)
    require("p5.server").start_server(tonumber(args.fargs[1]))
  end, { nargs = "?" })

  -- P5 stop-server
  vim.api.nvim_create_user_command("P5StopServer", function()
    require("p5.server").stop_server()
  end, { nargs = 0 })

  -- P5 toggle-console
  vim.api.nvim_create_user_command("P5ToggleConsole", function()
    require("p5.console").toggle()
  end, { nargs = 0 })

  -- P5 create-gist
  vim.api.nvim_create_user_command("P5CreateGist", function(args)
    require("p5.gist").create_gist(args.fargs[1])
  end, { nargs = "?" })

  -- P5 setup
  vim.api.nvim_create_user_command("P5Setup", function()
    require("p5.core").setup_environment()
  end, { nargs = 0 })
end

return I
