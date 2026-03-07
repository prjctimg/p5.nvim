# p5.nvim 🎨

> Better editor support for p5.js sketchspaces in Neovim.

[![Release](https://img.shields.io/github/v/release/prjctimg/p5.nvim)](https://github.com/prjctimg/p5.nvim/releases/latest)

## Table of Contents

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

## Features ✨

- **Live Server** 🚀 - Auto-reload preview in browser
- **Package Management** 📦 - Install contributor libraries
- **Sketchspace** 📁 - Minimal project structure
- **GitHub Gist** 🔗 - Share sketches (synced to sketchspace)
- **Console** 📺 - View browser logs in Neovim
- **p5.js Docs** 📖 - Built-in reference via snacks.picker

## Requirements 📋

- Neovim >= 0.9.0
- Python 3.7+ (for development server)
- curl (for console streaming)

## Installation 💾

```lua
-- lazy.nvim (installs latest release)
{
  "prjctimg/p5.nvim",
  version = "v0.3.1",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require("p5").setup({})
  end
}

-- lazy.nvim (development - latest commit on main)
{
  "prjctimg/p5.nvim",
  branch = "main",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require("p5").setup({})
  end
}
```

## Quick Start 🚀

```vim
:P5 create my-sketch
:P5 server
:P5 console
```

Or use the interactive picker:

## Commands 📖

### :P5 create [name]

Create a new sketchspace.

```vim
:P5 create my-sketch
:P5 create
```

[![asciicast](https://asciinema.org/a/795753.svg)](https://asciinema.org/a/795753)

---

### :P5 setup

Setup assets in current sketchspace.

Downloads files from gist (if configured), creates default sketch.js if missing, copies assets, generates libs.js, and installs configured libraries.

```vim
:P5 setup
```

[![asciicast](https://img.shields.io/badge/asciinema-demo-blue)](https://asciinema.org)

---

### :P5 install [libs...]

Install contributor libraries. Use picker or specify directly.

```vim
:P5 install ml5
:P5 install ml5 rita p5play
:P5 install
```

### :P5 uninstall [libs...]

Remove installed libraries.

```vim
:P5 uninstall ml5
:P5 uninstall
```

[![asciicast](https://asciinema.org/a/795789.svg)](https://asciinema.org/a/795789)

---

### :P5 server [port]

Start/stop the development server (toggle). Opens browser automatically and enables live reload.

```vim
:P5 server
:P5 server 8080
```

<a href="https://asciinema.org/a/801610" target="_blank"><img src="https://asciinema.org/a/801610.svg" /></a>

---

### :P5 console

Toggle browser console to view console.log, errors, and warnings in Neovim.

```vim
:P5 console
```

[![asciicast](https://asciinema.org/a/801611.svg)](https://asciinema.org/a/801611)

---

### :P5 sync [gist|libs]

Sync gist or libraries.

```vim
:P5 sync gist
:P5 sync libs
:P5 sync
```

[![asciicast](https://asciinema.org/a/801610.svg)](https://asciinema.org/a/801610)

---

### :P5 gist [desc]

Create a GitHub Gist from your sketchspace.

```vim
:P5 gist "My awesome sketch"
:P5 gist
```

[![asciicast](https://asciinema.org/a/799472.svg)](https://asciinema.org/a/799472)

---

### :P5 docs

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

Auto-start server when opening a sketch.js file:

```lua
-- Auto-start server when opening sketch.js
vim.api.nvim_create_autocmd({ "BufEnter" }, {
  pattern = "sketch.js",
  callback = function()
    vim.cmd("P5 server")
  end
})

-- Auto-open console when server starts
vim.api.nvim_create_autocmd({ "User", "P5ServerStarted" }, {
  callback = function()
    vim.cmd("P5 console")
  end
})
```

## Keyboard Shortcuts ⌨️

Recommended keybindings using `<leader>p` prefix:

```lua
-- General
vim.keymap.set("n", "<leader>p5", ":P5<CR>", { desc = "Open p5.nvim picker" })

-- Project
vim.keymap.set("n", "<leader>pc", ":P5 create ", { desc = "Create project" })
vim.keymap.set("n", "<leader>ps", ":P5 setup<CR>", { desc = "Setup project" })

-- Server
vim.keymap.set("n", "<leader>pss", ":P5 server<CR>", { desc = "Toggle server" })
vim.keymap.set("n", "<leader>pso", ":P5 console<CR>", { desc = "Toggle console" })

-- Libraries
vim.keymap.set("n", "<leader>pi", ":P5 install ", { desc = "Install library" })
vim.keymap.set("n", "<leader>pu", ":P5 uninstall ", { desc = "Uninstall library" })
vim.keymap.set("n", "<leader>pU", ":P5 sync libs<CR>", { desc = "Update libraries" })

-- Gist
vim.keymap.set("n", "<leader>pg", ":P5 gist ", { desc = "Create gist" })
vim.keymap.set("n", "<leader>pgg", ":P5 sync gist<CR>", { desc = "Sync gist" })

-- Docs
vim.keymap.set("n", "<leader>pd", ":P5 docs<CR>", { desc = "Open p5.js docs" })
```

## Troubleshooting 🔧

### Server Won't Start

**Symptoms:** Running `:P5 server` shows an error or nothing happens.

**Solutions:**

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

4. Check Neovim notifications for specific error messages

---

### Downloads Not Working

Library installation fails or downloads timeout.

**Solutions:**

1. Ensure curl is installed:

   ```bash
   curl --version
   ```

2. Check internet connection:

   ```bash
   curl -I https://cdnjs.cloudflare.com
   ```

3. Verify firewall isn't blocking localhost connections

4. Check that you're in a valid sketchspace (has p5.json)

---

### Gist Upload/Sync Fails

`:P5 gist` or `:P5 sync gist` shows an error.

**Solutions:**

1. Ensure GitHub CLI is installed:

   ```bash
   gh --version
   ```

2. Authenticate with GitHub:

   ```bash
   gh auth login
   ```

3. Verify gist URL in p5.json is valid:

   ```vim
   :edit p5.json
   ```

4. For sync failures, the gist may have been deleted - run `:P5 gist` to create a new one

---

### Library Install/Uninstall Fails

`:P5 install` or `:P5 uninstall` shows an error.

**Solutions:**

1. Verify you're in a sketchspace (has p5.json):

   ```bash
   ls p5.json
   ```

2. Check assets/libs directory is writable:

   ```bash
   ls -la assets/libs
   ```

3. Run setup first to initialize:

   ```vim
   :P5 setup
   ```

---

### p5.json Format

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

- `version`: p5.js version to use
- `libs`: Object with library names as keys and their versions as values
- `includes`: Files to include in the Gist (default: `["sketch.js"]`)
- `gist`: URL of associated GitHub Gist (optional)

---

You can also find the project's devlog [here](https://dvlg.prjctimg.me/devlogs/p5.nvim)

> ## License 📜

> (c) 2026, [Dean Tarisai](https://prjctimg.me)
> This is free software, released under the GPL-3.0 license.
