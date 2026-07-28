# Configuration Tips

## Basic Setup

```lua
require("p5").setup({
  -- Server configuration
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

  -- Library management
  libraries = {
    cdn_sources = { "jsdelivr", "cdnjs", "unpkg" },
    auto_update = false,
  },

  -- Sketch template (nil = prompt on :P5 create)
  sketch = {
    mode = nil, -- "global" | "instance"
  },

  -- p5.js runtime defaults
  p5 = {
    version = nil,
    check_update = true,
  },

  -- GitHub sketchbook
  sketchbook = {
    user = "your-github-username",
  },

  -- Chrome DevTools Protocol
  cdp = {
    enabled = false,
    remote_debugging_port = 9222,
  },

  -- LSP hover (6s delay)
  hover = {
    enabled = false,
    delay_ms = 6000,
  },
})
```

## Live Reload

The live reload server watches your project files and auto-reloads the browser on changes.

```lua
live_reload = {
  enabled = true,
  debounce_ms = 300,       -- Wait 300ms after last change
  watch_extensions = { ".js", ".css", ".html", ".json" },
  exclude_dirs = { ".git", "node_modules" },
}
```

## CDP Panel

Enable CDP for the full debugging panel (Console, Network, Eval, Debugger, Performance, Info):

```lua
cdp = {
  enabled = true,
  remote_debugging_port = 9222,
  browser_flags = {
    "--no-first-run",
    "--no-default-browser-check",
    "--enable-gpu-rasterization",
    "--disable-frame-rate-limit",
  },
}
```

Start Chrome with `--remote-debugging-port=9222` to use CDP features.

## Hover Documentation

Enable the 6-second hover to see p5.js documentation via LSP:

```lua
hover = {
  enabled = true,
  delay_ms = 6000,  -- Hover for 6s to trigger LSP hover
}
```

## View Layout

```lua
view = {
  position = "below",  -- "below" | "above" | "left" | "right"
  height = 10,          -- Panel height in rows
}
```

## Library CDN Sources

```lua
libraries = {
  cdn_sources = { "jsdelivr", "cdnjs", "unpkg" },
}
```

Sources are tried in order; if one fails, the next is used.
