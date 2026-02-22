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
:P5CreateProject my-sketch
:P5StartServer
:P5ToggleConsole
```

## Commands

| Command | Description |
|---------|-------------|
| `:P5` | Main picker with all options |
| `:P5CreateProject [name]` | Create new p5.js project |
| `:P5InstallLib [libs...]` | Install libraries (picker or direct) |
| `:P5RemoveLib [libs...]` | Remove libraries (picker or direct) |
| `:P5UpdateLibs` | Update all installed libraries |
| `:P5StartServer [port]` | Start development server |
| `:P5StopServer` | Stop development server |
| `:P5ToggleConsole` | Toggle browser console |
| `:P5CreateGist [desc]` | Create GitHub Gist |
| `:P5Setup` | Setup environment |

## Library Management

Install contributor libraries with autocomplete:

```vim
:P5InstallLib ml5
:P5InstallLib ml5 p5.speech
:P5RemoveLib ml5
```

The plugin automatically:
- Checks for conflicting installations
- Updates index.html with library links
- Removes broken links

## License

MIT
