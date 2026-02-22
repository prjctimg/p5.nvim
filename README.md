# p5.nvim

A Neovim plugin for creative coding with p5.js.

## Features

- **Live server** - Auto-reload preview in browser
- **Package management** - Install 50+ contributor libraries
- **Template project** - Core p5.js + sound addon
- **GitHub Gist** - Share sketches (synced to workspace)
- **Console** - View browser logs in Neovim
- **p5 docs** - Built-in help for p5.js functions

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
:P5Create my-sketch
:P5Server
:P5Console
```

## Commands

| Command | Description |
|---------|-------------|
| `:P5` | Main picker with all options |
| `:P5Create [name]` | Create new p5.js project |
| `:P5Install [libs...]` | Install libraries (picker or direct) |
| `:P5Uninstall [libs...]` | Remove libraries (picker or direct) |
| `:P5Update` | Update all installed libraries |
| `:P5Server [port]` | Start/stop development server (toggle) |
| `:P5Console` | Toggle browser console |
| `:P5Gist [desc]` | Create GitHub Gist |
| `:P5Setup` | Setup environment |

## Library Management

Install contributor libraries:

```vim
:P5Install ml5
:P5Uninstall ml5
```

The plugin automatically:
- Checks for conflicting installations
- Updates index.html with library links
- Removes broken links

## License

MIT
