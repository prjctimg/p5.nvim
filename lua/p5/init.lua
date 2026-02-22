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

  local snacks = core.require_snacks()

  local function notify(msg, level)
    vim.schedule(function()
      core.notify(msg, level or "info")
    end)
  end

  local function create_project()
    if not snacks then
      vim.ui.input({
        prompt = "Create new project: ",
        default = "p5-sketch",
        completion = "dir",
      }, function(input)
        if input and input ~= "" then
          require("p5.project").create_project(input)
        end
      end)
      return
    end

    snacks.input({
      prompt = "Create new project",
      placeholder = "Enter project name",
      on_confirm = function(name)
        if not name or name == "" then
          notify("Project creation cancelled", "warn")
          return
        end
        require("p5.project").create_project(name)
      end,
    })
  end

  local function open_libs_picker(action)
    local title = (action == "install") and "Install contributor libraries" or "Uninstall contributor libraries"
    local libs = (action == "install") and require("p5.libraries").get_available_libs() or require("p5.libraries").get_installed_libs()

    if not snacks then
      vim.ui.select(libs, { prompt = title }, function(selected)
        if not selected then return end
        if action == "install" then
          require("p5.libraries").install_libs({selected.name})
        else
          require("p5.libraries").uninstall_libs({selected.name})
        end
      end)
      return
    end

    local items = vim.tbl_map(function(lib)
      local detail = lib.description or ""
      local status = lib.status or ""
      if status ~= "" then
        detail = detail .. " " .. status
      end
      return {
        label = lib.name,
        detail = detail,
        value = lib.name,
      }
    end, libs)

    snacks.picker({
      prompt = title,
      items = items,
      multi = true,
      on_confirm = function(selected)
        if not selected or vim.tbl_isempty(selected) then
          notify("No libraries selected", "warn")
          return
        end

        local names = {}
        for _, item in ipairs(selected) do
          table.insert(names, item.value or item.label)
        end

        if action == "install" then
          require("p5.libraries").install_libs(names)
        else
          require("p5.libraries").uninstall_libs(names)
        end
      end,
    })
  end

  local function start_server()
    require("p5.server").start_server()
  end

  local function stop_server()
    require("p5.server").stop_server()
  end

  local function toggle_console()
    require("p5.console").toggle()
  end

  local function show_docs()
    vim.cmd("help p5-nvim")
  end

  local function create_gist()
    if not snacks then
      vim.ui.input({
        prompt = "Create Gist (description): ",
      }, function(desc)
        if desc then
          require("p5.gist").create_gist(desc)
        end
      end)
      return
    end

    snacks.input({
      prompt = "Create Gist",
      placeholder = "Enter description (optional)",
      on_confirm = function(desc)
        require("p5.gist").create_gist(desc or "")
      end,
    })
  end

  local function open_main_picker()
    local options = {
      { label = "Create a new project", action = "create" },
      { label = "Install contributor libraries", action = "install_libs" },
      { label = "Uninstall contributor libraries", action = "uninstall_libs" },
      { label = "Create a Gist for the sketchspace", action = "create_gist" },
      { label = "Start live server", action = "start_server" },
      { label = "Stop live server", action = "stop_server" },
      { label = "Show docs", action = "show_docs" },
      { label = "Toggle console", action = "toggle_console" },
    }

    if not snacks then
      vim.ui.select(options, { prompt = "p5.nvim:" }, function(choice)
        if not choice then return end
        local action = choice.action
        if action == "create" then
          create_project()
        elseif action == "install_libs" then
          open_libs_picker("install")
        elseif action == "uninstall_libs" then
          open_libs_picker("uninstall")
        elseif action == "create_gist" then
          create_gist()
        elseif action == "start_server" then
          start_server()
        elseif action == "stop_server" then
          stop_server()
        elseif action == "show_docs" then
          show_docs()
        elseif action == "toggle_console" then
          toggle_console()
        end
      end)
      return
    end

    local items = vim.tbl_map(function(opt)
      return { label = opt.label, value = opt.action }
    end, options)

    snacks.picker({
      prompt = "p5.nvim",
      items = items,
      multi = false,
      on_confirm = function(item)
        local action = item.value
        if action == "create" then
          create_project()
        elseif action == "install_libs" then
          open_libs_picker("install")
        elseif action == "uninstall_libs" then
          open_libs_picker("uninstall")
        elseif action == "create_gist" then
          create_gist()
        elseif action == "start_server" then
          start_server()
        elseif action == "stop_server" then
          stop_server()
        elseif action == "show_docs" then
          show_docs()
        elseif action == "toggle_console" then
          toggle_console()
        else
          notify("Unknown action: " .. tostring(action), "error")
        end
      end,
    })
  end

  local function complete_p5(arg_lead, cmd_lead, cursor_pos)
    local args = vim.split(cmd_lead, "%s+")
    local partial = args[#args] or ""

    if #args == 1 then
      return {"create", "install", "uninstall", "server", "console", "docs", "gist"}
    end

    if args[2] == "create" then
      return {}
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
      return{"start", "stop"}
    end

    return {}
  end

  vim.api.nvim_create_user_command("P5", function(args)
    local fargs = args.fargs

    if #fargs == 0 then
      open_main_picker()
      return
    end

    local subcmd = fargs[1]
    local subarg = fargs[2]

    if subcmd == "create" then
      local name = subarg or fargs[3]
      if name then
        require("p5.project").create_project(name)
      else
        create_project()
      end
    elseif subcmd == "install" then
      if not subarg then
        open_libs_picker("install")
      else
        local libs = {}
        for i = 2, #fargs do table.insert(libs, fargs[i]) end
        require("p5.libraries").install_libs(libs)
      end
    elseif subcmd == "uninstall" then
      if not subarg then
        open_libs_picker("uninstall")
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
