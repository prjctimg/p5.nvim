# p5.nvim

A Neovim plugin for creative coding with p5.js.

## Features

- **Live server** - Auto-reload preview in browser
- **Package management** - Install contributor libraries
- **Sketchspace** - Minimal project structure (p5.json + sketch.js)
- **GitHub Gist** - Share sketches (synced to sketchspace)
- **Console** - View browser logs in Neovim
- **p5 docs** - Built-in help via snacks.picker

## Requirements

- Neovim >= 0.9.0
- Python 3.7+ (for development server)
- curl (for console streaming)

## Installation

```lua
-- lazy.nvim
{
  "prjctimg/p5.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require("p5").setup({})
  end
}
```

## Quick Start

```vim
:P5 create my-sketch
:P5 server
:P5 console
```

Or use the interactive picker:

```vim
:P5
:P5 menu
```

## Commands

| Command | Description |
|---------|-------------|
| `:P5` or `:P5 menu` | Interactive picker with all options |
| `:P5 create [name]` | Create new sketchspace |
| `:P5 setup` | Setup assets in current sketchspace |
| `:P5 install [libs...]` | Install libraries (picker or direct, requires sketchspace) |
| `:P5 uninstall [libs...]` | Remove libraries (picker or direct, requires sketchspace) |
| `:P5 sync [gist|libs]` | Sync gist or libraries |
| `:P5 server [port]` | Start/stop development server (toggle) |
| `:P5 console` | Toggle browser console |
| `:P5 docs` | Open p5.js docs via snacks.picker |
| `:P5 gist [desc]` | Create GitHub Gist (requires sketchspace) |
| `:P5 update` | Update installed libraries |

## Sketchspace Structure

A sketchspace is a directory containing:

```
my-sketch/
├── p5.json       # Configuration (version, libs, includes)
├── sketch.js     # Your p5.js code
└── assets/       # Library files (auto-managed)
```

### p5.json Format

```json
{
  "version": "1.9.0",
  "libs": {
    "ml5": "1.0.0"
  },
  "includes": ["sketch.js"]
}
```

- `version`: p5.js version to use
- `libs`: Object with library names as keys and versions as values
- `includes`: Files to include in Gist (default: `["sketch.js"]`)

## Library Management

Install contributor libraries:

```vim
:P5 install ml5
:P5 uninstall ml5
:P5 sync libs
```

### Install Multiple Libraries

```vim
:P5 install ml5 rita p5play
```

### Available Libraries

| Category | Libraries |
|----------|-----------|
| **AI/ML** | ml5 |
| **Sound** | Tone, XSound, p5.spatial, p5.speech, rita |
| **Physics/Game** | p5play, planck, matter, p5.play |
| **UI** | dat.gui, p5.gui, p5.touchgui, fez-ui |
| **Data Viz** | d3 |
| **3D/Camera** | p5.easycam, p5.anaglyph |
| **Drawing** | p5.bezier, p5.brush |
| **Image Processing** | p5.FIP |
| **Core Alternative** | q5 |

## Gist Integration

Create a Gist from your sketchspace:

```vim
:P5 gist "My awesome sketch"
:P5 sync gist  "Update existing gist"
```

The Gist will include files specified in `p5.json` `includes` array. Assets directory is automatically excluded.

## License

MIT
