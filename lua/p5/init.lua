-- Iain plugin entry point for p5.nvim
local I = {}

-- Configuration defaults
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

-- Setup function
I.setup = function(opts)
  I.config = vim.tbl_deep_extend("force", I.config, opts or {})

  -- Import modules
  local core = require("p5.core")
  local project = require("p5.project")
  local server = require("p5.server")
  local libraries = require("p5.libraries")
  local console = require("p5.console")
  local gist = require("p5.gist")

  -- Initialize modules
  core.setup(I.config)
  project.setup(I.config)
  server.setup(I.config)
  libraries.setup(I.config)
  console.setup(I.config)
  gist.setup(I.config)

  -- Main P5 command with subcommands
  vim.api.nvim_create_user_command("P5", function(args)
    local core = require("p5.core")
    local snacks = core.require_snacks()
    
    local function run_action(choice)
      if choice == "Create new project" then
        vim.ui.input({
          prompt = "Project name: ",
          default = "p5-sketch",
          completion = "dir",
        }, function(input)
          if input and input ~= "" then
            require("p5.project").create_project(input)
          end
        end)
      elseif choice == "Install library" then
        require("p5.libraries").show_and_install()
      elseif choice == "Start server" then
        require("p5.server").start_server()
      elseif choice == "Stop server" then
        require("p5.server").stop_server()
      elseif choice == "Toggle console" then
        require("p5.console").toggle()
      elseif choice == "Open docs" then
        vim.cmd("echom 'p5.js docs: https://p5js.org/reference/'")
        vim.fn.jobstart({"xdg-open", "https://p5js.org/reference/"}, { detach = true })
      end
    end
    
    if snacks and snacks.picker then
      snacks.picker.pick({
        title = "p5.nvim",
        items = {
          "Create new project",
          "Install library",
          "Start server",
          "Stop server",
          "Toggle console",
          "Open docs",
        },
        format = {
          item = function(item) return item end
        },
        on_submit = function(selected)
          if selected then
            run_action(selected[1])
          end
        end
      })
    else
      vim.ui.select({
        "Create new project",
        "Install library",
        "Start server",
        "Stop server",
        "Toggle console",
        "Open docs",
      }, {
        prompt = "p5.nvim:",
      }, function(choice)
        if choice then
          run_action(choice)
        end
      end)
    end
  end, { nargs = 0 })

  -- P5 install - Install library
  vim.api.nvim_create_user_command("P5Install", function(args)
    if #args.fargs == 0 then
      require("p5.libraries").show_and_install()
    else
      require("p5.libraries").install_libs(args.fargs)
    end
  end, { nargs = "*" })

  -- P5 contrib-lib - Alias for install with picker
  vim.api.nvim_create_user_command("P5ContribLib", function(args)
    if #args.fargs > 0 and args.fargs[1] == "remove" then
      require("p5.libraries").show_uninstall_picker()
    else
      require("p5.libraries").show_and_install()
    end
  end, { nargs = "*" })

  -- P5 uninstall - Show installed libs for uninstall
  vim.api.nvim_create_user_command("P5Uninstall", function(args)
    if #args.fargs == 0 then
      require("p5.libraries").show_uninstall_picker()
    else
      require("p5.libraries").uninstall_libs(args.fargs)
    end
  end, { nargs = "*" })

  -- P5 server start
  vim.api.nvim_create_user_command("P5ServerStart", function(args)
    require("p5.server").start_server(tonumber(args.fargs[1]))
  end, { nargs = "?" })

  -- P5 server stop
  vim.api.nvim_create_user_command("P5ServerStop", function()
    require("p5.server").stop_server()
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
