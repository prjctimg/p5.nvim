describe("cdp", function()
  local cdp = require("p5.cdp")
  local server = require("p5.server")
  local orig_connected = cdp.state.connected
  local orig_port = cdp.state.port
  local orig_server_job = server.server_job
  local orig_server_port = server.port

  before_each(function()
    cdp.config.enabled = true
    cdp.state.buf = nil
    cdp.state.win = nil
    cdp.state.job_id = nil
    cdp.state.active_tab = 1
    cdp.state.connected = false
    cdp.state.port = nil
    cdp.tab_data = {
      console = {},
      network = {},
      eval = {},
      debugger = { event = "resumed", callFrames = {}, reason = "" },
      perf = { fps = {}, heap = 0, nodes = 0, listeners = 0, recording = true },
      info = { symbols = {}, canvas_state = "" },
    }
    server.server_job = 1
    server.port = 9999
  end)

  after_each(function()
    if cdp.state.win and vim.api.nvim_win_is_valid(cdp.state.win) then
      vim.api.nvim_win_close(cdp.state.win, true)
    end
    if cdp.state.job_id then
      vim.fn.jobstop(cdp.state.job_id)
    end
    cdp.state.buf = nil
    cdp.state.win = nil
    cdp.state.job_id = nil
  end)

  describe("switch_tab", function()
    it("switches to tab 1", function()
      cdp.switch_tab(1)
      assert.equals(1, cdp.state.active_tab)
    end)

    it("switches to tab 4", function()
      cdp.switch_tab(4)
      assert.equals(4, cdp.state.active_tab)
    end)

    it("ignores invalid tab index 0", function()
      cdp.switch_tab(0)
      assert.equals(1, cdp.state.active_tab)
    end)

    it("ignores invalid tab index 7", function()
      cdp.switch_tab(7)
      assert.equals(1, cdp.state.active_tab)
    end)
  end)

  describe("_on_event", function()
    it("handles console events", function()
      cdp._on_event({ type = "console", level = "log", message = "hello", timestamp = "12:00:00", stack = {} })
      assert.equals(1, #cdp.tab_data.console)
      assert.equals("hello", cdp.tab_data.console[1].message)
    end)

    it("handles network events", function()
      cdp._on_event({ type = "network", method = "GET", url = "/test.js", status = 200, duration = 1.5 })
      assert.equals(1, #cdp.tab_data.network)
      assert.equals("/test.js", cdp.tab_data.network[1].url)
    end)

    it("handles debugger paused events", function()
      cdp._on_event({ type = "debugger", event = "paused", reason = "breakpoint", callFrames = {} })
      assert.equals("paused", cdp.tab_data.debugger.event)
    end)

    it("handles debugger resumed events", function()
      cdp._on_event({ type = "debugger", event = "resumed" })
      assert.equals("resumed", cdp.tab_data.debugger.event)
    end)

    it("handles status connected events", function()
      cdp._on_event({ type = "status", state = "connected", url = "http://example.com" })
      assert.is_true(cdp.state.connected)
    end)

    it("handles status disconnected events", function()
      cdp._on_event({ type = "status", state = "disconnected" })
      assert.is_false(cdp.state.connected)
    end)

    it("handles perf events", function()
      cdp._on_event({ type = "perf", fps = 60, heap = 1048576, nodes = 42, listeners = 5 })
      assert.equals(60, cdp.tab_data.perf.fps[1])
      assert.equals(1048576, cdp.tab_data.perf.heap)
      assert.equals(42, cdp.tab_data.perf.nodes)
    end)

    it("caps console at 1000 entries", function()
      for i = 1, 1001 do
        cdp._on_event({ type = "console", message = tostring(i), level = "log", timestamp = "12:00:00", stack = {} })
      end
      assert.equals(1000, #cdp.tab_data.console)
    end)

    it("caps network at 500 entries", function()
      for i = 1, 501 do
        cdp._on_event({ type = "network", method = "GET", url = "/" .. i })
      end
      assert.equals(500, #cdp.tab_data.network)
    end)
  end)

  describe("_render_tab_bar", function()
    it("highlights active tab with accent marker", function()
      cdp.state.active_tab = 2
      local bar = cdp._render_tab_bar()
      assert.matches("▎2:Network", bar)
      assert.not_matches("▎1:Console", bar)
    end)

    it("shows connection indicator", function()
      cdp.state.connected = false
      local bar = cdp._render_tab_bar()
      assert.matches("●", bar)
    end)

    it("shows connection indicator when connected", function()
      cdp.state.connected = true
      local bar = cdp._render_tab_bar()
      assert.matches("●", bar)
    end)
  end)

  describe("toggle", function()
    it("creates buffer when toggled on", function()
      cdp.toggle()
      assert.is_not_nil(cdp.state.buf)
      assert.is_not_nil(cdp.state.win)
      assert.is_true(vim.api.nvim_buf_is_valid(cdp.state.buf))
    end)

    it("closes buffer when toggled off", function()
      cdp.toggle()
      assert.is_not_nil(cdp.state.buf)
      cdp.toggle()
      assert.is_nil(cdp.state.buf)
      assert.is_nil(cdp.state.win)
    end)

    it("does not crash without a running server", function()
      server.server_job = nil
      server.port = nil
      local ok, err = pcall(cdp.toggle)
      assert.is_true(ok, "toggle should not crash: " .. tostring(err))
    end)
  end)

  describe("connect", function()
    it("does not crash without a running server", function()
      server.server_job = nil
      server.port = nil
      local ok, err = pcall(cdp.connect)
      assert.is_true(ok, "connect should not crash: " .. tostring(err))
    end)

    it("does not crash with running server (connection will fail gracefully)", function()
      server.server_job = 1
      server.port = 19999
      local ok, err = pcall(cdp.connect)
      assert.is_true(ok, "connect to invalid endpoint should not crash: " .. tostring(err))
    end)
  end)

  describe("disconnect", function()
    it("does not crash when not connected", function()
      cdp.state.port = nil
      local ok, err = pcall(cdp.disconnect)
      assert.is_true(ok, "disconnect without port: " .. tostring(err))
    end)
  end)

  describe("eval", function()
    it("adds eval entry to tab_data", function()
      cdp.state.port = 9999
      cdp.eval("2 + 2")
      assert.equals(1, #cdp.tab_data.eval)
      assert.equals("2 + 2", cdp.tab_data.eval[1].expression)
      assert.equals("pending", cdp.tab_data.eval[1].status)
    end)
  end)

  describe("_render_tab_content", function()
    it("returns console content for tab 1", function()
      cdp.tab_data.console = { { level = "log", message = "test", timestamp = "12:00" } }
      cdp.state.active_tab = 1
      local content = cdp._render_tab_content()
      assert.equals(1, #content)
    end)

    it("returns network content for tab 2", function()
      cdp.state.active_tab = 2
      local content = cdp._render_tab_content()
      assert.is_true(#content > 0)
    end)

    it("returns eval content for tab 3", function()
      cdp.state.active_tab = 3
      local content = cdp._render_tab_content()
      assert.is_true(#content > 0)
    end)

    it("returns debugger content for tab 4", function()
      cdp.state.active_tab = 4
      local content = cdp._render_tab_content()
      assert.is_true(#content > 0)
    end)

    it("shows running status in debugger by default", function()
      cdp.state.active_tab = 4
      cdp.tab_data.debugger = { event = "resumed", callFrames = {}, reason = "" }
      local content = cdp._render_tab_content()
      local full = table.concat(content, " ")
      assert.matches("Running", full)
    end)

    it("shows paused status when debugger paused", function()
      cdp.state.active_tab = 4
      cdp.tab_data.debugger = { event = "paused", reason = "breakpoint", callFrames = {} }
      local content = cdp._render_tab_content()
      local full = table.concat(content, " ")
      assert.matches("PAUSED", full)
    end)

    it("returns perf content for tab 5", function()
      cdp.state.active_tab = 5
      local content = cdp._render_tab_content()
      assert.is_true(#content > 0)
    end)

    it("returns info content for tab 6", function()
      cdp.state.active_tab = 6
      local content = cdp._render_tab_content()
      assert.is_true(#content > 0)
    end)
  end)

  describe("set_breakpoint", function()
    it("does not crash with invalid port", function()
      cdp.state.port = nil
      local ok, err = pcall(cdp.set_breakpoint, "test.js:10")
      assert.is_true(ok, "set_breakpoint without port: " .. tostring(err))
    end)
  end)

  describe("config.enabled gating", function()
    it("open does nothing when disabled and server not running", function()
      cdp.config.enabled = false
      server.server_job = nil
      server.port = nil
      cdp.open()
      assert.is_nil(cdp.state.buf)
    end)

    it("connect does nothing when disabled", function()
      cdp.config.enabled = false
      local called = false
      local notify = require("p5.core").notify
      cdp.connect()
      assert.is_false(cdp.state.connected)
    end)

    it("open works when enabled", function()
      cdp.config.enabled = true
      cdp.open()
      assert.is_not_nil(cdp.state.buf)
      cdp.close()
    end)

    it("connect works when enabled", function()
      cdp.config.enabled = true
      local ok, err = pcall(cdp.connect)
      assert.is_true(ok)
    end)
  end)
end)
