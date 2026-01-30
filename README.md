# p5.nvim

A comprehensive Neovim plugin for p5.js development with live preview, library management, and browser console integration.

## Features

- 🚀 **Project Creation**: Create new p5.js projects with proper TypeScript support
- 📦 **Library Management**: Download and manage contributor libraries from CDNs
- 🌐 **Live Server**: Auto-detect and start live servers (Python, Bun, Deno, Node.js)
- 🖥️ **Browser Console**: Real-time browser logs in a toggleable terminal
- 📝 **GitHub Gists**: Upload sketches as GitHub gists using gh CLI
- ⚡ **TypeScript Support**: Full IntelliSense for JavaScript files using p5.d.ts
- 🔄 **Workspace Config**: JSON-based project configuration for reproducible setups

## Requirements

- Neovim >= 0.9.0
- snacks.nvim (required)
- plenary.nvim (required)
- websocket.nvim (optional, for browser console)
- gh CLI (optional, for gist functionality)
- curl or wget (for library downloads)

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  'your-username/p5.nvim',
  dependencies = {
    'folke/snacks.nvim',
    'nvim-lua/plenary.nvim',
    'samsze0/websocket.nvim', -- optional
  },
  config = function()
    require('p5').setup({
      -- your configuration here
    })
  end
}
```

## Configuration

```lua
require('p5').setup({
  server = {
    port = 8000,
    auto_start = false,
    preferred_order = {"python", "bun", "deno", "live-server"}
  },
  console = {
    enabled = true,
    auto_show = true,
    position = "below",  -- "left", "right", "above", "below"
    height = 10
  },
  libraries = {
    cdn_sources = {"jsdelivr", "cdnjs", "unpkg"},
    auto_update = false
  }
})
```

## Commands

### Project Management

- `:P5NewProject [name]` - Create a new p5.js project
- `:P5Setup` - Set up plugin environment

### Server Management

- `:P5StartServer [port]` - Start live server
- `:P5StopServer` - Stop live server

### Library Management

- `:P5InstallLib [library...]` - Install contributor libraries
- `:P5RemoveLib [library...]` - Remove installed libraries  
- `:P5UpdateLibs` - Update all installed libraries

### Console & Gists

- `:P5ToggleConsole` - Toggle browser console terminal
- `:P5CreateGist [description]` - Upload sketch as GitHub gist

## Available Libraries

The plugin supports downloading these popular p5.js contributor libraries:

- **p5.anaglyph** - Create 3D stereoscopic scenes
- **p5.bezier** - Draw complex Bézier curves
- **p5.brush** - Custom brushes and effects
- **p5.fillGradient** - Gradient fills for shapes
- **p5.cmyk** - CMYK color support
- **p5.play** - Game engine with physics
- **p5.collide2d** - 2D collision detection
- **ml5** - Machine learning for web
- **p5.speech** - Speech synthesis and recognition
- **p5.party** - Networked multiplayer support

## Project Structure

When you create a new project, it will have this structure:

```
my-project/
├── index.html      # Main HTML file with p5.js
├── sketch.js       # Your p5.js code  
├── jsconfig.json   # TypeScript configuration
├── p5.json        # Project configuration
└── assets/
    ├── types/      # TypeScript definitions
    └── contrib/   # Downloaded libraries
```

## Workspace Configuration

Each project has a `p5.json` file that tracks libraries and settings:

```json
{
  "name": "my-sketch",
  "version": "1.0.0",
  "p5js_version": "latest",
  "libraries": [
    {
      "name": "p5.play",
      "version": "latest", 
      "cdn": "https://cdn.jsdelivr.net/npm/p5play@latest/lib/p5play.js",
      "local_path": "assets/contrib/p5.play.js"
    }
  ],
  "server": {
    "type": "python",
    "port": 8000
  },
  "console": {
    "enabled": true,
    "position": "below",
    "height": 10
  }
}
```

This file allows you to:
- Share project setups across machines
- Automatically install required libraries
- Configure server and console preferences

## Browser Console Integration

The plugin provides real-time browser console logs through WebSocket:

1. Start a live server with `:P5StartServer`
2. The console window appears automatically (if enabled)
3. Browser logs, errors, and console outputs appear in real-time
4. Use `:P5ToggleConsole` to show/hide the console

## Server Detection

The plugin automatically detects available servers in this order:

1. **Python** - `python3 -m http.server`
2. **Bun** - Custom Bun server script
3. **Deno** - Custom Deno server script  
4. **Node.js** - `npx live-server`

## Gist Integration

If you have `gh` CLI installed, you can:

- Create gists from current project
- Clone existing gists as new projects
- Update existing gists
- Auto-copy gist URLs to clipboard

## TypeScript Support

Every project includes `jsconfig.json` for full TypeScript IntelliSense:

- **Type checking** for JavaScript files
- **Autocomplete** for p5.js functions
- **Parameter hints** and documentation
- **Error checking** with p5.js types

## Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## License

MIT License - see LICENSE file for details.