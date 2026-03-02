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
    position = "below",
    height = 10,
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

  local handlers = {}

  handlers.create = function(args)
    local name = args[1]
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
  end

  handlers.setup = function()
    if not require_sketchspace("Setup") then return end

    local cwd = vim.fn.getcwd()
    local config = core.read_workspace_config()

    -- Step 1: Handle gist download if gistUrl exists
    if config and config.gist then
      local gist_info = gist.get_project_gist()
      if gist_info and gist_info.id then
        local ok, err = gist.download_gist(gist_info.id, cwd)
        if not ok then
          core.notify("Gist download failed: " .. err .. ". Removing invalid gist URL.", "warn")
          config.gist = nil
          core.write_workspace_config(config)
        end
      end
    end

    -- Step 2: Create default sketch.js if not exists
    local sketch_file = cwd .. "/sketch.js"
    if vim.fn.filereadable(sketch_file) == 0 then
      local sketch_js = [[function setup() {
  createCanvas(400, 400);
}

function draw() {
  background(220);
  circle(mouseX, mouseY, 50);
}
]]
      vim.fn.writefile(vim.split(sketch_js, "\n"), sketch_file)
      core.notify("Created default sketch.js", "info")
    end

    -- Step 3: Copy assets, generate libs.js, install libs
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
  end

  handlers.install = function(args)
    if not require_sketchspace("Install") then return end

    local lib_names = #args > 0 and args or nil
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
  end

  handlers.uninstall = function(args)
    if not require_sketchspace("Uninstall") then return end

    local lib_names = #args > 0 and args or nil
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
  end

  handlers.server = function(args)
    if server.server_job then
      server.stop_server()
    else
      local port = #args > 0 and tonumber(args[1]) or nil
      server.start_server(port)
    end
  end

  handlers.console = function()
    console.toggle()
  end

  handlers.docs = function()
    vim.cmd("help p5.nvim")
  end

  handlers.sync = function(args)
    local target = args[1]

    if not target then
      vim.ui.select({"Gist", "Libraries"}, { prompt = "What to sync:" }, function(choice)
        if choice == "Gist" then
          if not require_sketchspace("Sync gist") then return end
          gist.update_current_gist()
        elseif choice == "Libraries" then
          if not require_sketchspace("Sync libraries") then return end
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
  end

  handlers.update = function()
    libraries.update_libs()
  end

  handlers.gist = function(args)
    if not require_sketchspace("Gist") then return end
    local desc = args[1]
    gist.create_gist(desc)
  end

  handlers.gistupdate = function()
    gist.update_current_gist()
  end

  handlers.menu = function()
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
        handlers.create({})
      elseif choice == "Setup sketchspace" then
        handlers.setup()
      elseif choice == "Install library" then
        handlers.install({})
      elseif choice == "Uninstall library" then
        handlers.uninstall({})
      elseif choice == "Start server" or choice == "Stop server" then
        handlers.server({})
      elseif choice == "Toggle console" then
        handlers.console()
      elseif choice == "Open docs" then
        handlers.docs()
      elseif choice == "Sync" then
        handlers.sync({})
      elseif choice == "Create/update Gist" then
        handlers.gist({})
      end
    end)
  end

  local subcommands = vim.tbl_keys(handlers)

  local function get_completion(line)
    local args = vim.split(line, "%s+")
    local cmd_pos = 1
    while args[cmd_pos] and args[cmd_pos] ~= "P5" do
      cmd_pos = cmd_pos + 1
    end
    local subcmd_pos = cmd_pos + 1

    if #args <= subcmd_pos then
      return subcommands
    end

    local subcmd = args[subcmd_pos]
    if subcmd == "install" or subcmd == "uninstall" then
      local libs = libraries.get_available_libs()
      return vim.tbl_map(function(l) return l.name end, libs or {})
    elseif subcmd == "server" then
      return {"8000", "8001", "8002", "8003"}
    elseif subcmd == "sync" then
      return {"gist", "libs", "libraries"}
    end

    return {}
  end

  vim.api.nvim_create_user_command("P5", function(cmd)
    local args = {}
    for match in vim.gsplit(vim.trim(cmd.args), "%s+") do
      if match and match ~= "" then
        table.insert(args, match)
      end
    end
    local subcmd = #args > 0 and args[1] or "menu"

    table.remove(args, 1)

    local handler = handlers[subcmd]
    if handler then
      handler(args)
    else
      core.notify("Unknown P5 command: " .. subcmd .. ". Run :P5 for interactive picker", "warn")
    end
  end, {
    nargs = "*",
    bar = true,
    desc = "p5.nvim commands",
    complete = function(_, line)
      return get_completion(line)
    end,
  })
end

return I
