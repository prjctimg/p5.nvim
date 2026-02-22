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
      vim.cmd("help p5-nvim")
    end
  end

  local function show_main_picker()
    local snacks = core.require_snacks()
    
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
        format = function(item) return item end,
        on_submit = function(selected)
          if selected then run_action(selected) end
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
      }, { prompt = "p5.nvim:" }, function(choice)
        if choice then run_action(choice) end
      end)
    end
  end

  local function complete_p5(arg_lead, cmd_lead, cursor_pos)
    local args = vim.split(cmd_lead, "%s+")
    local partial = args[#args] or ""

    if #args == 1 then
      return {"install", "uninstall", "server", "console", "docs", "gist"}
    end

    if args[2] == "install" then
      local libs = require("p5.libraries").get_available_libs()
      local names = vim.tbl_map(function(l) return l.name end, libs)
      if partial == "" then return names end
      return vim.fn.matchfuzzy(names, partial) or names
    end

    if args[2] == "uninstall" then
      local installed = require("p5.libraries").get_installed_libs()
      local names = vim.tbl_map(function(l) return l.name end, installed)
      if partial == "" then return names end
      return vim.fn.matchfuzzy(names, partial) or names
    end

    if args[2] == "server" and #args == 2 then
      return {"start", "stop"}
    end

    return {}
  end

  vim.api.nvim_create_user_command("P5", function(args)
    local fargs = args.fargs
    
    if #fargs == 0 then
      show_main_picker()
      return
    end

    local subcmd = fargs[1]
    local subarg = fargs[2]

    if subcmd == "install" then
      if not subarg then
        require("p5.libraries").show_and_install()
      else
        local libs = {}
        for i = 2, #fargs do table.insert(libs, fargs[i]) end
        require("p5.libraries").install_libs(libs)
      end
    elseif subcmd == "uninstall" then
      if not subarg then
        require("p5.libraries").show_uninstall_picker()
      else
        local libs = {}
        for i = 2, #fargs do table.insert(libs, fargs[i]) end
        require("p5.libraries").uninstall_libs(libs)
      end
    elseif subcmd == "server" then
      if subarg == "start" then
        require("p5.server").start_server(tonumber(fargs[3]))
      elseif subarg == "stop" then
        require("p5.server").stop_server()
      else
        require("p5.server").start_server()
      end
    elseif subcmd == "console" then
      require("p5.console").toggle()
    elseif subcmd == "docs" then
      vim.cmd("help p5-nvim")
    elseif subcmd == "gist" then
      local desc = table.concat(vim.list_slice(fargs, 2), " ")
      require("p5.gist").create_gist(desc)
    end
  end, {
    nargs = "*",
    complete = complete_p5
  })
end

return I
