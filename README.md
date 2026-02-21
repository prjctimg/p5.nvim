# p5.nvim

A Neovim plugin for creative coding with p5.js.

## Features

- Live development server with auto-reload
- Browser console integration with ANSI color formatting
- Library management (50+ p5.js contributor libraries)
- Project templates with TypeScript support
- GitHub Gist integration

## Requirements

- Neovim >= 0.9.0
- Python 3.7+ (for development server)
- curl (for console streaming)
- `chrome-remote.nvim` dependency

## Installation

```lua
-- lazy.nvim
{
  "prjctimg/p5.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "akinsho/chrome-remote.nvim",
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
| `:P5CreateProject [name]` | Create new p5.js project |
| `:P5StartServer [port]` | Start development server |
| `:P5StopServer` | Stop development server |
| `:P5ToggleConsole` | Toggle browser console |
| `:P5InstallLib <libs...>` | Install libraries |
| `:P5RemoveLib <libs...>` | Remove libraries |
| `:P5UpdateLibs` | Update all libraries |
| `:P5CreateGist` | Create GitHub Gist |

## Configuration

```lua
require("p5").setup({
  server = {
    port = 8000,
    auto_start = false,
  },
  console = {
    enabled = true,
    position = "below",
    height = 10,
  }
})
```

## License

MIT
