-- Main plugin entry point for p5.nvim
local M = {}

-- Configuration defaults
M.config = {
  server = {
    port = 8000,
    auto_start = false,
    auto_open_browser = true,
    preferred_order = {"python", "bun", "deno", "node"},
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
    height = 10
  },
  libraries = {
    cdn_sources = {"jsdelivr", "cdnjs", "unpkg"},
    auto_update = false
  }
}

-- Setup function
M.setup = function(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})

  -- Import modules
  local core = require("p5.core")
  local project = require("p5.project")
  local server = require("p5.server")
  local libraries = require("p5.libraries")
  local console = require("p5.console")
  local gist = require("p5.gist")

  -- Initialize modules
  core.setup(M.config)
  project.setup(M.config)
  server.setup(M.config)
  libraries.setup(M.config)
  console.setup(M.config)
  gist.setup(M.config)

  -- Create commands
  vim.api.nvim_create_user_command("P5NewProject", function(args)
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

  vim.api.nvim_create_user_command("P5StartServer", function(args)
    require("p5.server").start_server(tonumber(args.fargs[1]))
  end, { nargs = "?" })

  vim.api.nvim_create_user_command("P5StopServer", function()
    require("p5.server").stop_server()
  end, { nargs = 0 })

  vim.api.nvim_create_user_command("P5InstallLib", function(args)
    require("p5.libraries").install_libs(args.fargs)
  end, { nargs = "*" })

  vim.api.nvim_create_user_command("P5RemoveLib", function(args)
    require("p5.libraries").remove_libs(args.fargs)
  end, { nargs = "*" })

  vim.api.nvim_create_user_command("P5UpdateLibs", function()
    require("p5.libraries").update_libs()
  end, { nargs = 0 })

  vim.api.nvim_create_user_command("P5ToggleConsole", function()
    require("p5.console").toggle()
  end, { nargs = 0 })

  vim.api.nvim_create_user_command("P5CreateGist", function(args)
    require("p5.gist").create_gist(args.fargs[1])
  end, { nargs = "?" })

  vim.api.nvim_create_user_command("P5Setup", function()
    require("p5.core").setup_environment()
  end, { nargs = 0 })
end

return M