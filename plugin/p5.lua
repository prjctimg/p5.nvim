-- p5.nvim plugin entry point
-- Only load plugin if it hasn't been loaded yet
if vim.g.loaded_p5 then
  return
end
vim.g.loaded_p5 = true

-- Create user commands
vim.api.nvim_create_user_command("P5Create", function()
  require("p5.project.templates").create_project()
end, {
  desc = "Create a new p5.js project"
})

vim.api.nvim_create_user_command("P5Download", function()
  require("p5.libraries.manager").download_libraries()
end, {
  desc = "Download and manage p5.js libraries"
})

vim.api.nvim_create_user_command("P5ListLibs", function()
  require("p5.libraries.manager").list_libraries()
end, {
  desc = "List available p5.js libraries"
})

vim.api.nvim_create_user_command("P5Server", function()
  require("p5.server.init").start_server()
end, {
  desc = "Start p5.js development server"
})

vim.api.nvim_create_user_command("P5Stop", function()
  require("p5.server.init").stop_server()
end, {
  desc = "Stop p5.js development server"
})

vim.api.nvim_create_user_command("P5Console", function()
  require("p5.console.logger").toggle_console()
end, {
  desc = "Toggle browser console logging"
})

vim.api.nvim_create_user_command("P5Gist", function()
  require("p5.gist.push").push_to_gist()
end, {
  desc = "Push current sketch to GitHub Gist"
})

vim.api.nvim_create_user_command("P5UpdateLibs", function()
  require("p5.libraries.updater").update_libraries()
end, {
  desc = "Update all p5.js libraries"
})

-- Setup default configuration
require("p5").setup()