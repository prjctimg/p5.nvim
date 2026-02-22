# p5.nvim

A Neovim plugin for creative coding with p5.js.

## Features

- **p5 reference as manpages** - Built-in help for p5.js functions
- **Live server** - Auto-reload preview in browser
- **Package management** - Install 50+ contributor libraries
- **Template sketchspace** - Core p5.js + sound addon
- **GitHub Gist** - Share sketches (synced to workspace)
- **Console** - View browser logs in Neovim

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
    "L3MON4D3/snacks.nvim",
  },
  config = function()
    require("p5").setup({})
  end
}
```

## Quick Start

```vim
:P5 install
:P5 server start
```

## Commands

| Command | Description |
|---------|-------------|
| `:P5` | Main picker with all options |
| `:P5 install [libs...]` | Install libraries (picker or direct) |
| `:P5 uninstall [libs...]` | Uninstall libraries |
| `:P5 server start [port]` | Start live server |
| `:P5 server stop` | Stop server |
| `:P5 console` | Toggle browser console |
| `:P5 docs` | Open p5.nvim help |
| `:P5 gist [desc]` | Create GitHub Gist |

### Autocomplete

Tab completion works for:
- Subcommands: install, uninstall, server, console, docs, gist
- Library names when installing/uninstalling

## Configuration

```lua
require("p5").setup({
  server = {
    port = 8000,
    auto_start = false,
    auto_open_browser = true,
  },
  console = {
    enabled = true,
    position = "below",
    height = 10,
  }
})
```

## Library Management

Install contributor libraries with autocomplete:

```vim
:P5 install ml5
:P5 install ml5 p5.speech
:P5 uninstall ml5
```

The plugin automatically:
- Checks for conflicting installations
- Updates index.html with library links
- Removes broken links

## License

MIT
