# p5.nvim 🎨

> Better editor support for p5.js sketchspaces in Neovim.

[![Release](https://img.shields.io/github/v/release/prjctimg/p5.nvim)](https://github.com/prjctimg/p5.nvim/releases/latest)

## On this page

- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Commands](#commands)
- [Configuration](#configuration)
- [Auto Commands](#auto-commands)
- [Keyboard Shortcuts](#keyboard-shortcuts)
- [Troubleshooting](#troubleshooting)
- [License](#license)

## Features

- **Live Server** 🛰️ - Auto-reload preview in browser
- **Package Management** 📦 - Install [contributor libraries]()
- **Sketchspace** 📁 - Minimal project structure
- **GitHub Gist** 🔗 - Share sketches (synced to sketchspace)
- **Console** 📺 - View browser logs in Neovim
- **p5.js Docs** 📖 - Manpages generated from the reference.

## Requirements

- Neovim >= 0.11.0
- Python 3.7+ (for live server) & [websockets](https://pypi.org/project/websockets/) package.
- curl (for console streaming)

## Installation

```lua
-- lazy.nvim (installs latest release)
{
  "prjctimg/p5.nvim",
  version = "*",
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

## Commands

### `create [name]`

Create a new sketchspace.

```vim
:P5 create my-sketch
:P5 create
```

[![asciicast](https://asciinema.org/a/795753.svg)](https://asciinema.org/a/795753)

---

### `setup`

Setup assets in current sketchspace.

Downloads files from gist (if configured), creates default sketch.js if missing, copies assets, generates libs.js, and installs configured libraries.

```vim
:P5 setup
```

[![asciicast](https://img.shields.io/badge/asciinema-demo-blue)](https://asciinema.org)

---

### `install [libs...]`

Install contributor libraries. Use picker or specify directly.

```vim
:P5 install ml5
:P5 install ml5 rita p5play
:P5 install
```

### `uninstall [libs...]`

Remove installed libraries.

```vim
:P5 uninstall ml5
:P5 uninstall
```

[![asciicast](https://asciinema.org/a/795789.svg)](https://asciinema.org/a/795789)

---

### `server [port]`

Start/stop the development server (toggle). Opens browser automatically and enables live reload.

```vim
:P5 server
:P5 server 8080
```

<a href="https://asciinema.org/a/801610" target="_blank"><img src="https://asciinema.org/a/801610.svg" /></a>

---

### `console`

Toggle browser console to view console.log, errors, and warnings in Neovim.

```vim
:P5 console
```

[![asciicast](https://asciinema.org/a/801611.svg)](https://asciinema.org/a/801611)

---

### `sync [gist|libs]`

Sync gist or libraries.

```vim
:P5 sync gist
:P5 sync libs
:P5 sync
```

[![asciicast](https://asciinema.org/a/801610.svg)](https://asciinema.org/a/801610)

---

### `gist [desc]`

Create a GitHub Gist from your sketchspace.

```vim
:P5 gist "My awesome sketch"
:P5 gist
```

[![asciicast](https://asciinema.org/a/799472.svg)](https://asciinema.org/a/799472)

---

### `docs`

Open p5.js documentation via snacks.picker.

```vim
:P5 docs
```

<a href="https://asciinema.org/a/799478" target="_blank"><img src="https://asciinema.org/a/799478.svg" /></a>

---

## Configuration ⚡

```lua
require("p5").setup({
  -- Server settings
  server = {
    port = 8000,                    -- Server port
    auto_start = false,             -- Auto start server when opening sketch.js
    auto_open_browser = true,      -- Open browser automatically
    ready_timeout = 5000,           -- Server ready timeout (ms)
    fallback_ports = {8001, 8002, 8003},  -- Ports to try if default is busy

    -- Live reload settings
    live_reload = {
      enabled = true,               -- Enable live reload
      port = 12002,                -- Live reload port
      debounce_ms = 300,           -- Debounce delay
      watch_extensions = {".js", ".css", ".html", ".json"},  -- Files to watch
      exclude_dirs = {".git", "node_modules", "dist", "build"}  -- Exclude directories
    }
  },

  -- Console settings
  console = {
    position = "below",             -- Window position: below, above, left, right
    height = 10,                    -- Window height (lines)
  },

  -- Library settings
  libraries = {
    auto_update = false            -- Auto update libraries on setup
  }
})
```

## Auto Commands 🔌

Auto commands can be used to customize how sketchspaces are handled. Below are a few examples but you can always do your own thing here.

### Auto-start server when opening a `sketch.js` file

```lua
-- Auto-start server when opening sketch.js
vim.api.nvim_create_autocmd({ "BufEnter" }, {
  pattern = "sketch.js",
  callback = function()
    vim.cmd("P5 server")
  end
})
```

### Open console when server starts

```lua

-- vim.api.nvim_create_autocmd({ "User", "P5ServerStarted" }, {
  callback = function()
    vim.cmd("P5 console")
  end
})
```

## Keyboard Shortcuts ⌨️

These are just example keybindings using `<leader>p` prefix. You can make `nvim` load a "special" set of p5.nvim related keymaps when it detects that you are in a sketchspace:

```lua

local keymap = vim.keymap.set

-- General
keymap("n", "<leader>p5", ":P5<CR>", { desc = "Open p5.nvim picker" })

-- Project
keymap("n", "<leader>pc", ":P5 create ", { desc = "Create a new sketchspace" })
keymap("n", "<leader>ps", ":P5 setup<CR>", { desc = "Setup sketchspace." })

-- Server
keymap("n", "<leader>pss", ":P5 server<CR>", { desc = "Toggle server (on/off") })
keymap("n", "<leader>pso", ":P5 console<CR>", { desc = "Toggle console (show/hide) " })

-- Libraries
keymap("n", "<leader>pi", ":P5 install ", { desc = "Install an addon library" })
keymap("n", "<leader>pu", ":P5 uninstall ", { desc = "Uninstall  an addon library" })
keymap("n", "<leader>pU", ":P5 sync libs<CR>", { desc = "Update installed addon libraries." })

-- Gist
keymap("n", "<leader>pg", ":P5 gist ", { desc = "Create a GitHub gist for the current sketchspace." })
keymap("n", "<leader>pgg", ":P5 sync gist<CR>", { desc = "Sync gist" })

-- Docs
keymap("n", "<leader>pd", ":P5 docs<CR>", { desc = "Open p5.js docs" })
```

## Troubleshooting

### Server Won't Start

1. Ensure Python 3 is installed:

   ```bash
   python3 --version
   ```

2. Check if the port is already in use:

   ```bash
   lsof -i :8000
   ```

3. Try a different port:

   ```vim
   :P5 server 8080
   ```

4. Run `:checkhealth p5.nvim` for better diagnostics

---

### Downloads Not Working

Library installation fails or downloads timeout.

1. Ensure curl is installed (I'm looking at you Windows):

   ```bash
   curl --version
   ```

2. If `curl` is installed, check internet connection:

   ```bash
   curl -I https://cdnjs.cloudflare.com
   ```

3. Verify firewall isn't blocking `localhost` connections

---

### Gist Upload/Sync Fails

`:P5 gist` or `:P5 sync gist` shows an error.

**Solutions:**

1. Ensure GitHub CLI is installed:

   ```bash
   gh --version
   ```

2. If it is installed, ensure you're logged in:

   ```bash
   gh auth status
   ```

3. Verify gist URL in the `p5.json` is valid:

   ```vim
   :edit p5.json
   ```

> [!note]
>
> For sync failures, the gist may have been deleted - run `:P5 gist` to create a new one.

---

### Library Install/Uninstall Fails

`:P5 install` or `:P5 uninstall` shows an error.

1. Verify you're in a sketchspace (has p5.json):

   ```bash
   ls p5.json
   ```

2. If `p5.json` exists check if assets/libs directory is writable:

   ```bash
   ls -la assets/libs
   ```

```

```

---

### `p5.json`

> [!note]
>
> The goal of the `p5.json` file is to make it easy to setup a sketchspace from a single file with a single command.

This file contains information about a sketchspace namely:

- `version`: p5.js version to use
- `libs`: Object with library names as keys and their versions as values
- `includes`: Files to include in the Gist (default: `["sketch.js"]`)
- `gist`: URL of associated GitHub Gist (optional)

```json
{
  "version": "1.9.0",
  "libs": {
    "ml5": "latest"
  },
  "includes": ["sketch.js"],
  "gist": "https://gist.github.com/..."
}
```

You may be wondering why the `sketch.js` is the only file uploaded to the gist and how the other files needed for the sketchspace are initialized:

#### `index.html`

The server will generate one if it does not exist.It only has two import scripts, one for `p5.js` and the other for contributor libraries (`libs.js`)

#### `assets/`

The plugin will copy the template assets and then check if the `p5.json` has any addon libraries.
If it does, then the libraries are installed, if the specified versions cannot be found it will attempt to just get the latest release of the same major version else the latest version as a final resolution.

---

You can also find the project's devlog [here](https://dvlg.prjctimg.me/devlogs/p5.nvim)

> ## License 📜
>
> (c) 2026, [Dean Tarisai](https://prjctimg.me)
>
> This is free software, released under the GPL-3.0 license.
