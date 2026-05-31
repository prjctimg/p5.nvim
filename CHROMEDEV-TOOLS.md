# Chrome DevTools Protocol integration

Integrating [Chrome DevTools Protocol](https://chromedevtools.github.io/devtools-protocol/) (CDP) into p5.nvim would bring browser debugging capabilities directly into Neovim — no separate DevTools window needed.

## Current state

p5.nvim already captures `console.log`/`warn`/`error`/`info` calls from the browser via a JS injection script that POSTs to the Python server's `/api/console/log` endpoint. The server buffers logs and streams them over SSE to a Neovim terminal window (snacks.terminal or plain `curl` job).

This is a one-way firehose: browser → server → Neovim. There's no protocol-level interaction, no request inspection, no DOM tree, and no debugger.

## CDP overview

Chrome DevTools Protocol is a WebSocket-based RPC protocol. Any Chrome/Chromium instance started with `--remote-debugging-port=9222` exposes a WebSocket endpoint. Key capabilities:

| Domain | What it gives you |
|---|---|
| `Console` | `messageAdded` events (same as current but structured) |
| `Network` | `requestWillBeSent`, `responseReceived`, `loadingFailed` |
| `DOM` | `documentUpdated`, `childNodeInserted`, getDocument |
| `Runtime` | `consoleAPICalled`, `exceptionThrown`, evaluate JS |
| `Debugger` | `scriptParsed`, `paused`, setBreakpoint, stepOver |
| `Performance` | `enable`, `getMetrics`, FPS data |
| `Overlay` | highlight DOM nodes, show rulers |
| `Page` | `navigatedWithinDocument`, `screencastFrame` (headless rendering) |
| `CSS` | `styleSheetAdded`, getMatchedStylesForNode |
| `Memory` | `getDOMCounters`, `prepareForLeakDetection` |
| `Profiler` | `start`, `stop`, CPU profile data |
| `Target` | attach to tabs, frames, workers |

## Architecture

The existing SSE pipeline is a good foundation. CDP would add a second channel:

```
┌─────────────────────────────────────────────────────────────┐
│  Browser (Chrome with --remote-debugging-port=9222)          │
│  ┌──────────────────────────┐   CDP WebSocket               │
│  │  Injected console.js     │─── (ws://localhost:9222/...)   │
│  │  (POST → /api/console/log)│                               │
│  └──────────┬───────────────┘                               │
│             │                                                │
└─────────────┼────────────────────────────────────────────────┘
              │                  ▲
         POST /api/console/log   │ CDP WS (Python → Chrome)
              │                  │
              ▼                  │
┌─────────────────────────────────────────────────────────────┐
│  Python server (server.py)                                   │
│  ┌────────────────────┐  ┌──────────────────────────────┐    │
│  │  ConsoleBuffer      │  │  CDP client (websockets)     │   │
│  │  (SSE stream)       │  │  ┌────────────────────────┐ │   │
│  │                     │  │  │ NetworkMonitor         │ │   │
│  │                     │  │  │ ConsoleRelay           │ │   │
│  │                     │  │  │ RuntimeEvaluator       │ │   │
│  │                     │  │  │ DebuggerController     │ │   │
│  │                     │  │  │ PerformanceCollector   │ │   │
│  │                     │  │  │ DOMInspector           │ │   │
│  │                     │  │  └────────────────────────┘ │   │
│  └──────────┬──────────┘  └──────────────┬───────────────┘   │
│             │                             │                   │
└─────────────┼─────────────────────────────┼───────────────────┘
              │                             │
         SSE /api/console/stream       JSON-RPC (Neovim ↔ Python)
              │                             │
              ▼                             ▼
┌─────────────────────────────────────────────────────────────┐
│  Neovim                                                      │
│  ┌────────────────────┐  ┌──────────────────────────────┐    │
│  │  Console window     │  │  CDP panels (buffers)        │   │
│  │  (snacks.terminal   │  │  ┌────────────────────────┐ │   │
│  │   or curl job)      │  │  │  :P5 cdp network       │ │   │
│  │                     │  │  │  :P5 cdp dom           │ │   │
│  │                     │  │  │  :P5 cdp evaluate      │ │   │
│  │                     │  │  │  :P5 cdp perf          │ │   │
│  │                     │  │  │  :P5 cdp debug         │ │   │
│  │                     │  │  └────────────────────────┘ │   │
│  └────────────────────┘  └──────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

The Python server acts as a CDP proxy: it opens a WebSocket to Chrome, translates CDP events into structured JSON, and forwards them over a new `cdp` HTTP endpoint. Neovim's console module gains a new `cdp` submodule that manages CDP-specific buffers and commands.

## Phased implementation plan

### Phase 1: CDP transport layer

**Goal:** Establish a WebSocket connection to Chrome and verify bi-directional communication.

1. Add a `--remote-debugging-port` option to `CONFIG` in `server.py` (default: `9222`)
2. Create a `CDPClient` class in `server.py` that:
   - Discovers debuggable pages via `GET /json` on the debugging port
   - Connects to the first available page via `websockets.connect()`
   - Sends a `Runtime.enable` command
   - Receives and logs `Runtime.consoleAPICalled` events
3. Add a `/api/cdp/status` HTTP endpoint returning connection state and connected page URL
4. Add a Lua `cdp` module (`lua/p5/cdp.lua`) with:
   - `cdp.connect()` — sends an HTTP request to the Python server to initiate CDP connection
   - `cdp.status()` — queries `/api/cdp/status`
   - `cdp.disconnect()` — tears down the CDP WebSocket

**Deliverables:** A `:P5 cdp connect` command that links p5.nvim's server to Chrome's debugger. `:P5 cdp status` shows the connected tab.

**Testing:** Mock the `websockets.connect` in server_spec.lua. Verify CDPClient sends `Runtime.enable` on connect.

### Phase 2: Console relay via CDP

**Goal:** Replace the injected JS `console.js` with structured CDP `Runtime.consoleAPICalled` events for richer console output.

1. In `CDPClient`, subscribe to `Runtime.consoleAPICalled` events
2. Map CDP event types to log levels: `warning` → WARN, `error` → ERROR, `log` → LOG, `info` → INFO
3. Forward formatted entries into the existing `ConsoleBuffer`
4. Add `Runtime.exceptionThrown` subscription for uncaught exceptions
5. Enrich the SSE stream with stack trace data (`callFrames` from CDP)

**Why:** CDP gives structured data (stack traces, object previews, timestamps) that the current injected `console.log` interception can't provide. It also removes the need for the injected script entirely (one less moving part).

**Testing:** Mock CDP events and verify they appear in `ConsoleBuffer` with correct levels and stack data.

### Phase 3: Network inspection

**Goal:** Display network requests in a Neovim buffer (similar to Chrome's Network tab).

1. In `CDPClient`, subscribe to `Network.requestWillBeSent` and `Network.responseReceived`
2. Buffer request/response pairs with timing, status, method, URL, and size
3. Add a `/api/cdp/network` SSE endpoint that streams network events
4. Add `handlers.cdp_network` in `lua/p5/commands.lua` that opens a terminal buffer connected to the SSE stream
5. Use ANSI color coding: `200` in green, `4xx` in yellow, `5xx` in red

**Deliverables:** `:P5 cdp network` toggles a live network log. Shows method, URL, status, and duration for each request.

**Buffer layout:**
```
GET  200  /sketch.js          2.3ms
GET  200  https://cdnjs.cloudflare.com/ajax/libs/p5.js/2.0.0/p5.min.js  142ms
GET  404  /favicon.ico        0.8ms
```

### Phase 4: Runtime evaluation

**Goal:** Evaluate arbitrary JavaScript in the browser context and see results in Neovim.

1. Add a `/api/cdp/evaluate` JSON endpoint that accepts `{expression: "..."}` and returns `{result, exceptionDetails}`
2. Add `cdp.evaluate(expression)` in the Lua module that POSTs to this endpoint
3. Add `handlers.cdp_eval = function(args)` that takes the expression from command args and prints the result
4. Support `vim.ui.input` for multi-line expressions when no args given

**Deliverables:** `:P5 cdp eval "document.title"` prints the page title. `:P5 cdp eval` prompts for an expression.

### Phase 5: DOM inspector

**Goal:** View and navigate the DOM tree from Neovim.

1. In `CDPClient`, implement `DOM.getDocument` and cache the node tree
2. Add `/api/cdp/dom/snapshot` returning the flattened DOM as JSON
3. Add `/api/cdp/dom/select` accepting a CSS selector and returning node info
4. Add a `lua/p5/dom.lua` module that:
   - Queries the snapshot
   - Renders a tree view in a scratch buffer (indented tags with attributes)
   - Maps `<CR>` to expand/collapse children, `r` to refresh, `/` to search
5. Highlight the element in the browser using `Overlay.highlightNode`

**Deliverables:** `:P5 cdp dom` opens a DOM tree buffer. Moving the cursor highlights the corresponding element in Chrome.

### Phase 6: Debugger integration

**Goal:** Set breakpoints and step through p5.js sketch code from Neovim.

1. In `CDPClient`, implement `Debugger.enable`, `Debugger.setBreakpointByUrl`, `Debugger.stepOver`, `Debugger.resume`
2. Add commands:
   - `:P5 cdp break "sketch.js:12"` — set breakpoint at line 12
   - `:P5 cdp continue` — resume execution
   - `:P5 cdp step` — step over
   - `:P5 cdp stepIn` — step into
   - `:P5 cdp stepOut` — step out
3. When a breakpoint hits:
   - `CDPClient` sends a `Debugger.paused` event to a new SSE endpoint
   - Neovim displays the call stack and current scope variables in a buffer
   - A sign is placed in the sketch.js buffer at the breakpoint line
4. Use `Debugger.evaluateOnCallFrame` to inspect variables in the current scope

**Deliverables:** Source-level debugging of p5.js sketches from Neovim. No browser DevTools window needed.

### Phase 7: Performance monitoring

**Goal:** Track FPS, memory usage, and draw call timing.

1. Subscribe to `Performance.metrics` events
2. Buffer FPS samples and compute rolling averages
3. Add `/api/cdp/perf` SSE endpoint
4. Add a performance HUD in the console or a dedicated buffer that shows:
   - FPS (instant, 1s avg, 10s avg)
   - JS heap size
   - DOM node count
   - Event listener count
5. Optional: track `requestAnimationFrame` callback duration via `Runtime.evaluate` wrapping

**Deliverables:** `:P5 cdp perf` toggles a live performance dashboard.

### Phase 8: Advanced features

**Goal:** Polish and add power-user features.

- **`logpoint`** — Non-breaking breakpoints that log to console (`:P5 cdp logpoint "sketch.js:15" "mouse @ (${mouseX}, ${mouseY})"`)
- **Screenshot** — Capture the current canvas (`:P5 cdp screenshot` → saves to sketchspace)
- **Coverage** — Track which lines of `sketch.js` executed using `Profiler.startPreciseCoverage` (`:P5 cdp coverage`)
- **CSS live edit** — Apply CSS changes from Neovim to the browser in real-time using `CSS.setStyleTexts`
- **Export HAR** — Save network log as a HAR file
- **Event breakpoints** — Break on `mouse.click`, `touchstart`, `requestAnimationFrame`, etc.

## Technical considerations

### Changing `Console` in `p5.json`

No change needed. CDP features are opt-in via the command palette, not via sketchspace config.

### Requirements

- Chrome/Chromium or any CDP-compatible browser (Edge, Brave, etc.) launched with `--remote-debugging-port=9222`
- The existing `websockets` Python dependency covers both the live reload WS server and the CDP client
- No new Python packages needed (`websockets` is already required)
- The injected `console.js` script can be deprecated once CDP console relay (Phase 2) is stable

### Security

- The CDP WebSocket should only connect to `localhost` — no remote debugging by default
- The `/api/cdp/evaluate` endpoint should reject expressions containing dangerous patterns (e.g. `file://` URLs, `fs` module access in Node.js)
- Consider adding a `cdp.enabled` config flag (default `false`) so the server doesn't attempt CDP connections unless explicitly opted in

### Fallback

If Chrome is not running with `--remote-debugging-port`, CDP commands should show a clear message:

```
:P5 cdp network
→ CDP: No debuggable browser found.
  Start Chrome with: chromium --remote-debugging-port=9222
```

The existing SSE console (via injected `console.js`) remains the fallback when CDP is unavailable.
