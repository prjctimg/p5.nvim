# p5.nvim

A Neovim plugin for creative coding with p5.js, providing live development server, browser console integration, and project management.

## Features

 - 🚀 **Live Development Server** - Auto-reloading HTTP server with multiple runtime support and smart port management
 - 📡 **Browser Console Integration** - Real-time console log streaming with ANSI color formatting and async communication
- 📝 **TypeScript Support** - Bundled p5.js type definitions with jsconfig.json and tsconfig.json
- 📦 **Library Management** - Install contributor libraries from GitHub releases with CDN fallback
- 🏗️ **Project Templates** - One-command project creation with proper structure
 - 🔧 **Python Async Server** - asyncio-based HTTP server with SSE streaming
- 💾 **Smart Caching** - Host system caching for downloaded libraries
- 📊 **Progress Tracking** - Real-time download progress with coroutines
- 🔔 **Batched Notifications** - Non-intrusive feedback for multiple operations
- 🎨 **Syntax Highlighting** - Console logs with level-based highlighting
- 🔄 **Live Reload** - Automatic page refresh on file changes
- 📋 **GitHub Gist Integration** - Create and share p5.js sketches

## Recent Improvements

### 🎉 Enhanced User Experience (v2.0+)

- **Smart CWD Management**: Project creation automatically changes working directory
- **Enhanced Notifications**: Dual notifications for project creation and detailed port information
- **Console Redesign**: ANSI-formatted logs with colors (no more JSON dumps)
- **Async Communication**: Server-Sent Events with debounced processing eliminates browser lag
- **Port Intelligence**: Automatic port finding, conflict handling, and privileged port validation
- **Performance Optimized**: Batched logging and streaming reduces browser overhead

### 🔄 Workflow Improvements

- `:P5CreateProject` now requires p5.js project context for `:P5StartServer`
- Console shows colored, readable logs with timestamps and sources
- Server automatically finds available ports when conflicts occur
- Better error handling and user feedback throughout

## Requirements

- **Neovim** >= 0.9.0
- **Python** 3.7+ (for development server)
- **System Tools**:
  - `curl` (for console streaming)
  - `xdg-open` (Linux) or equivalent (for auto-opening browser)
- **Required Dependencies**:
  - `chrome-remote.nvim` (for Chrome DevTools Protocol support)
- **Optional Dependencies**:
  - `gh` CLI (for GitHub Gist integration)
  - `snacks.nvim` (for enhanced UI components)

## Installation

### Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "prjctimg/p5.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "akinsho/chrome-remote.nvim", -- Required for Chrome DevTools Protocol support
    optional_dependencies = {
      "folke/snacks.nvim", -- For enhanced UI
      "nvim-neotest/nvim-nio", -- For async operations
    }
  },
  config = function()
    require("p5").setup({
      -- See configuration below
    })
  end
}
```

### Using [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  "prjctimg/p5.nvim",
  requires = {
    "nvim-lua/plenary.nvim",
    "akinsho/chrome-remote.nvim", -- Required for Chrome DevTools Protocol support
    optional_dependencies = {
      "folke/snacks.nvim",
      "nvim-neotest/nvim-nio",
    }
  },
  config = function()
    require("p5").setup({})
  end
}
```

## Configuration

```lua
require("p5").setup({
  server = {
    port = 8000,                    -- Default server port
    auto_start = false,             -- Auto-start server in p5 projects
    live_reload = {
      enabled = true,               -- Enable live reload
      port = 12002,                 -- WebSocket port for live reload
      debounce_ms = 300,            -- Debounce time for file changes
      watch_extensions = {".js", ".css", ".html", ".json"},
      exclude_dirs = {".git", "node_modules", "dist", "build"}
    }
  },
  console = {
    enabled = true,                 -- Enable browser console integration
    auto_show = true,               -- Auto-show console when server starts
    position = "below",             -- Window position: "below", "above", "left", "right"
    height = 10,                    -- Console window height (for horizontal splits)
    buffer_size = 1000,             -- Ring buffer size for console logs
    heartbeat = 15                 -- Heartbeat interval in seconds
  },
  libraries = {
    cdn_sources = {"jsdelivr", "cdnjs", "unpkg"},
    auto_update = false
  }
})
```

## Commands

| Command | Description |
|---------|-------------|
| `:P5CreateProject [name]` | Create new p5.js project (auto-changes directory) |
| `:P5NewProject [name]` | Alias for :P5CreateProject |
| `:P5StartServer [port]` | Start development server (requires p5.js project) |
| `:P5StopServer` | Stop development server |
| `:P5ToggleConsole` | Toggle browser console window with formatted logs |
| `:P5InstallLib [libs...]` | Install contributor libraries |
| `:P5RemoveLib [libs...]` | Remove installed libraries |
| `:P5UpdateLibs` | Update all installed libraries |
| `:P5CreateGist [description]` | Create GitHub Gist from current project |
| `:P5Setup` | Initialize plugin environment |

## Quick Start

1. **Create a new project:**
   ```vim
   :P5CreateProject my-sketch
   ```

   This will:
   - Create a new p5.js project structure
   - Automatically change to the project directory
   - Show start and success notifications
   - Open `sketch.js` for editing

2. **Start the development server:**
   ```vim
   :P5StartServer
   ```

   This will:
   - Detect available Python runtime
   - Find an available port (8000, 8001, etc. if occupied)
   - Show port information and server status
   - Auto-open browser (if configured)

3. **Toggle the browser console (optional):**
   ```vim
   :P5ToggleConsole
   ```

   This will:
   - Show a terminal window with real-time console logs
   - Display logs with color formatting (ERROR, WARN, INFO, LOG)
   - Use async communication to avoid browser lag
   - Show timestamps and source information

4. **Start coding!** The server will auto-reload your browser when you save changes.

## Project Structure

When you create a new project, p5.nvim generates the following structure:

```
my-sketch/
├── assets/
│   ├── libs/
│   │   ├── p5.js          # Bundled p5.js library
│   │   └── p5.sound.js    # Bundled p5.sound library
│   └── types/
│       └── p5.d.ts        # TypeScript definitions
├── index.html             # HTML template
├── sketch.js              # Your p5.js code
├── jsconfig.json          # JavaScript/TypeScript configuration
├── tsconfig.json          # TypeScript configuration
└── p5.json               # Project workspace configuration
```

## Library Management

### Installing Contributor Libraries

p5.nvim supports installing popular p5.js contributor libraries:

```vim
" Install machine learning library
:P5InstallLib ml5

" Install speech synthesis library  
:P5InstallLib p5.speech

" Install multiple libraries at once
:P5InstallLib ml5 p5.speech
```

Libraries are downloaded from GitHub releases with CDN fallback, cached to your system, and automatically added to your project's `index.html`.

### Available Libraries

- **ml5.js** - Machine Learning for creative coding
- **p5.speech** - Speech synthesis and recognition

## Console Integration

The browser console integration streams all console output to a Neovim window:

- **Real-time logs** - See `console.log`, `console.error`, `console.warn`, `console.info`
- **Syntax highlighting** - Color-coded log levels
- **Error tracking** - JavaScript errors with stack traces
- **Interactive controls** - Clear console, hide/show window

### Console Keymaps

- `q` or `<Esc>` - Hide console window
- `c` - Clear console logs

## Server Runtime

p5.nvim uses Python 3 with asyncio for the development server:

- **Python** - Async HTTP server with SSE console streaming
- Zero external dependencies (stdlib only)
- Server-Sent Events (SSE) for real-time console log streaming
- WebSocket-based live reload

The server requires Python 3.7+ for asyncio support.

## TypeScript Support

p5.nvim provides comprehensive TypeScript support:

- **Bundled type definitions** - Complete p5.js API types
- **jsconfig.json** - JavaScript IntelliSense configuration  
- **tsconfig.json** - TypeScript project configuration
- **Path validation** - Ensures type definitions are accessible

## Caching

Downloaded libraries are cached to your system's cache directory:

- **Linux**: `~/.cache/p5.nvim/`
- **macOS**: `~/Library/Caches/p5.nvim/`
- **Windows**: `%LOCALAPPDATA%/p5.nvim/`

This provides:
- **Offline support** - Use cached libraries without internet
- **Performance** - Faster project creation and library installation
- **Bandwidth savings** - Avoid re-downloading the same files

## GitHub Gist Integration

Create and share p5.js sketches directly from Neovim:

```vim
" Create a public gist from current project
:P5CreateGist "My awesome p5.js sketch"

" Create a private gist (requires gh CLI authentication)
:P5CreateGist "Private sketch"
```

## Troubleshooting

### Server Won't Start

1. Check that you have a supported runtime installed:
   ```vim
   :checkhealth p5
   ```

2. Verify the port isn't already in use
3. Check file permissions in your project directory

### Console Not Working

1. Ensure `chrome-remote.nvim` is installed (required dependency)
2. Check that your browser allows HTTP connections to the server
3. Verify the server port (default 8000) isn't blocked
4. Ensure curl is available for console polling

### Library Installation Fails

1. Check internet connection
2. Verify `curl` or `wget` is available
3. Check GitHub API access (for non-CDN downloads)

### TypeScript Errors

1. Verify `assets/types/p5.d.ts` exists in your project
2. Check that your jsconfig.json/tsconfig.json paths are correct
3. Ensure your editor supports TypeScript (Neovim >= 0.9.0)

### Performance Issues

1. Disable live reload for large projects
2. Exclude large directories from file watching
3. Increase debounce_ms in live_reload config

## Health Check

Run the built-in health check to diagnose issues:

```vim
:checkhealth p5
```

This will verify:
- Plugin installation and dependencies
- Server runtime availability
- External tool access (curl, wget, gh)
- Asset integrity and paths
- HTTP console polling functionality

## Contributing

Contributions are welcome! Please see the [contributing guidelines](CONTRIBUTING.md) for details.

## License

MIT License - see the [LICENSE](LICENSE) file for details.

## Credits

- [p5.js](https://p5js.org/) - Creative coding library
- [plenary.nvim](https://github.com/nvim-lua/plenary.nvim) - Lua utilities
- [chrome-remote.nvim](https://github.com/akinsho/chrome-remote.nvim) - Chrome DevTools Protocol support
- [snacks.nvim](https://github.com/folke/snacks.nvim) - Enhanced UI components