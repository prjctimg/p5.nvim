local I = {}

local core = require("p5.core")
local project = require("p5.project")
local server = require("p5.server")
local libraries = require("p5.libraries")
local gist = require("p5.gist")
local cdp = require("p5.cdp")
local commands = require("p5.commands")

I.config = {
	server = {
		port = 8000,
		auto_start = false,
		auto_open_browser = true,
		live_reload = {
			enabled = true,
			port = 12002,
			debounce_ms = 300,
			watch_extensions = { ".js", ".css", ".html", ".json" },
			exclude_dirs = { ".git", "node_modules", "dist", "build" },
		},
	},
	libraries = {
		cdn_sources = { "jsdelivr", "cdnjs", "unpkg" },
		auto_update = false,
	},
	sketchbook = {
		user = "",
	},
	cdp = {
		enabled = false,
		remote_debugging_port = 9222,
		browser_flags = {
			"--no-first-run",
			"--no-default-browser-check",
			"--enable-gpu-rasterization",
			"--disable-frame-rate-limit",
			"--disable-gpu-driver-bug-workarounds",
			"--enable-precise-memory-info",
			"--disable-software-rasterizer",
		},
	},
	view = {
		position = "below",
		height = 10,
	},
	hover = {
		enabled = false,
		delay_ms = 6000,
	},
}

I.setup = function(opts)
	I.config = vim.tbl_deep_extend("force", I.config, opts or {})

	core.config = I.config
	project.config = I.config
	server.config = vim.tbl_deep_extend("force", server.config, I.config)
	libraries.config = vim.tbl_deep_extend("force", libraries.config, I.config)
	gist.config = I.config
	cdp.config = vim.tbl_deep_extend("force", cdp.config, I.config.cdp or {})
	cdp.config.view = vim.tbl_deep_extend("force", cdp.config.view or {}, I.config.view or {})
	if cdp.config.browser_flags then
		local user_flags = cdp.config.browser_flags
		cdp.config.browser_flags = vim.tbl_deep_extend("force", {}, I.config.cdp.browser_flags or {}, user_flags)
	end

	local hl = vim.api.nvim_set_hl
	hl(0, "P5CDPActiveTab", { bold = true, reverse = true })
	hl(0, "P5CDPTab", {})
	hl(0, "P5CDPDebugPaused", { fg = "#ff5555", bold = true })
	hl(0, "P5CDPConnected", { fg = "#50fa7b", bold = true })
	hl(0, "P5CDPDisconnected", { fg = "#ff5555", bold = true })
	hl(0, "P5CDPClose", { fg = "#ff5555" })
	hl(0, "P5CDPConsoleError", { fg = "#ff5555", bold = true })
	hl(0, "P5CDPConsoleWarn", { fg = "#ffb86c" })
	hl(0, "P5CDPConsoleInfo", { fg = "#8be9fd" })
	hl(0, "P5CDPConsoleLog", { fg = "#6272a4" })
	hl(0, "P5CDPNetwork2xx", { fg = "#50fa7b" })
	hl(0, "P5CDPNetwork3xx", { fg = "#8be9fd" })
	hl(0, "P5CDPNetwork4xx", { fg = "#ffb86c" })
	hl(0, "P5CDPNetwork5xx", { fg = "#ff5555", bold = true })
	hl(0, "P5CDPEvalSuccess", { fg = "#50fa7b" })
	hl(0, "P5CDPEvalError", { fg = "#ff5555", bold = true })
	hl(0, "P5CDPDebugCurrentLine", { bold = true, sp = "#f1fa8c", underline = true })
	hl(0, "P5CDPDebugSign", { fg = "#f1fa8c", bold = true })
	hl(0, "P5CDPPerfFPS", { fg = "#50fa7b", bold = true })
	hl(0, "P5CDPPerfMem", { fg = "#8be9fd" })
	hl(0, "P5CDPInfoSymbol", { fg = "#bd93f9" })
	hl(0, "P5CDPInfoLabel", { fg = "#6272a4" })

	local has_snacks, snacks = pcall(require, "snacks")
	if has_snacks then
		snacks.toggle.new({
			name = "p5cdp",
			get = function()
				return cdp.state.win and vim.api.nvim_win_is_valid(cdp.state.win) or false
			end,
			set = function(state)
				if state then
					cdp.open()
				else
					cdp.close()
				end
			end,
		})
	end

	vim.api.nvim_create_autocmd("DirChanged", {
		callback = function()
			local dir = vim.fn.getcwd()
			if core.is_file(dir .. "/p5.json") then
				core.add_ss(dir)
			end
		end,
	})

	if I.config.hover.enabled then
		local hover_timer
		local group = vim.api.nvim_create_augroup("P5Hover", { clear = true })
		vim.api.nvim_create_autocmd("CursorMoved", {
			group = group,
			callback = function()
				if hover_timer then
					hover_timer:close()
				end
				hover_timer = vim.defer_fn(function()
					vim.lsp.buf.hover()
				end, I.config.hover.delay_ms)
			end,
		})
	end

	commands.setup({
		require_sketchspace = function(action)
			if not project.is_p5_project() then
				core.notify(action .. " requires a sketchspace (p5.json)", "warn")
				return false
			end
			return true
		end,
		config = I.config,
	})
end

return I
