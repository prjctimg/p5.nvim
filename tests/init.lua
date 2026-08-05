-- Minimal init for plenary test harness
vim.g.mapleader = " "

local root = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h:h")
vim.opt.rtp:prepend(root)

-- ==========================================================================
-- Spawn guard
-- Tests must never launch real browser windows or spawn curl/server/network
-- processes (this caused machine lag from many orphaned Chrome tabs).
-- Specs that need process behaviour install their own vim.fn.jobstart /
-- vim.system / vim.fn.system stubs in before_each (temporarily overriding
-- this guard) and restore it in after_each — restoring the guard, because
-- specs capture these functions after this file has already run.
-- Blocked commands are dropped deterministically so deferred callbacks that
-- fire after a test's after_each (e.g. cdp.open -> defer(launch_browser))
-- can never reach the real process. The remaining 2+ tests can use
-- `:set P5_NETWORK_TESTS=1` to run gist_integration_spec.lua.
-- ==========================================================================

local blocked = {
	chrome = true,
	chromium = true,
	["google-chrome"] = true,
	["chromium-browser"] = true,
	["microsoft-edge"] = true,
	["xdg-open"] = true,
	["open"] = true,
	curl = true,
	wget = true,
	python3 = "server.py",
}

local function spawn_kind(cmd)
	if type(cmd) ~= "table" then
		cmd = { cmd }
	end
	local head = cmd[1]
	if type(head) ~= "string" then
		return nil
	end
	if blocked[head] == true then
		return head
	end
	if blocked[head] == "server.py" and table.concat(cmd, " "):match("server%.py") then
		return head
	end
	return nil
end

local function drop(cmd)
	local flat = type(cmd) == "table" and table.concat(cmd, " ") or tostring(cmd)
	io.stderr:write("[tests] blocked real spawn: " .. flat .. "\n")
end

local orig_jobstart = vim.fn.jobstart
vim.fn.jobstart = function(cmd, opts)
	if spawn_kind(cmd) then
		drop(cmd)
		if opts and opts.on_exit then
			opts.on_exit(1, 0)
		end
		return 1
	end
	if opts and opts.on_exit then
		opts.on_exit(0, 0)
	end
	return 1
end

local orig_system = vim.fn.system
vim.fn.system = function(cmd, ...)
	if spawn_kind(cmd) then
		drop(cmd)
		return ""
	end
	return orig_system(cmd, ...)
end

local orig_vim_system = vim.system
if orig_vim_system then
	vim.system = function(cmd, opts, cb)
		if spawn_kind(cmd) then
			drop(cmd)
			if type(cb) == "function" then
				cb({ code = 1, stdout = "", stderr = "blocked by test spawn guard" })
			end
			return nil
		end
		return orig_vim_system(cmd, opts, cb)
	end
end
