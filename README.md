# p5.nvim 🌃

> Better editor support for p5.js in Neovim.

> [!caution]
>
> This plugin is in early development and may contain bugs or breaking changes.

## Requirements 📋

- Neovim >= 0.11.0
- `curl` (for contributor library downloads)
- `python3` (for development server)
- `git`

> [!NOTE]
> **Offline Capable**: Core p5.js functionality works offline. Only contributor library downloads require internet access.

## Installation 📦

### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  'prjctimg/p5.nvim',
  config = function()
    require('p5').setup()
  end
}
```

### [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  'prjctimg/p5.nvim',
  config = function()
    require('p5').setup()
  end
}
```

### [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'prjctimg/p5.nvim'
lua require('p5').setup()
```

## Features ✨

- **🔄 Offline-First**: Core p5.js libraries bundled for complete offline project creation
- **📦 Smart Caching**: Contributor libraries cached locally after first download
- **🎯 Multi-Selection**: Interactive UI for selecting multiple libraries simultaneously
- **📋 Version Selection**: Choose between p5.js 1.9.x (legacy) and 2.x.x (latest)
- **📚 In-editor documentation**: Manpages available via `:help p5.[module/symbol]`
- **⚡ Zero Network Dependency**: Create projects anywhere, anytime without internet

### Creates a p5.js project (Offline-First)

> [!IMPORTANT]
> **Dynamic Asset Management**: Core p5.js libraries are automatically fetched and cached, so project creation works offline after first use. Assets are updated by GitHub Actions when new releases are available.

```
your-sketch/
├── lib/
│ ├── p5.js # Core library (cached locally, works offline)
│ ├── p5.sound.js # Sound addon (cached locally, works offline)
│ └── types/ # TypeScript definitions (cached locally)
├── index.html # Auto-generated HTML
├── style.css # Sketch styles
└── sketch.js # Your p5.js code
```

```sh
:P5Create
```

### Downloads and caches contributor libraries

> [!NOTE]
> **Smart Caching**: Downloaded contributor libraries are cached locally for offline use. Network requests only needed for first-time downloads.

> [!IMPORTANT]
> **Multi-Selection UI**: Use the new interactive selection interface to choose multiple libraries with Enter/Space keys.

```sh
:P5Download
```

**Features:**
- ✅ **Dynamic Core Libraries**: p5.js and p5.sound.js fetched once, work offline thereafter
- ✅ **Local Caching**: Once downloaded, contributor libraries work offline
- ✅ **Multi-Selection**: Choose multiple libraries in an interactive UI
- ✅ **Minimal Setup**: Select "None" for bare minimum p5.js setup
- ✅ **Smart Fallback**: Automatically uses cached assets when available
- ✅ **Auto-Updates**: GitHub Actions keep assets current with new releases

### **Live reload for development**

> [!IMPORTANT]
> Auto-detects [`live-server`](), [`Python HTTP server`](), or static fallback

```sh
:P5Server   # Start development server
:P5Stop     # Stop server

```

video sample goes here

### **Read p5.js reference as manpages**

> [!IMPORTANT]
> [`snacks.nvim`]() has a nice picker that makes browsing help/manpages easier.

video sample goes here

### Configuration ⚙️

```lua
require('p5').setup({
  port = 8000,                    -- Server port
  default_version = "2.0.5",      -- Default p5.js version
  server_type = "auto",           -- auto, live-server, python, static
  libraries = {                   -- Default library selection
    sound = true,
    dom = false,
    ml5 = false,
    collide2d = false
  },
  auto_open = true                -- Auto-open browser on server start
})
```

### 🔄 Asset Updates

The bundled p5.js libraries and TypeScript definitions are automatically managed via GitHub Actions:

#### Automated Updates
- **Release Monitoring**: Checks every 2 hours for new p5.js releases
- **Automatic Updates**: Assets updated when new versions are detected
- **Issue Creation**: Creates GitHub issues for new releases requiring attention
- **Testing**: Validates all downloaded assets for correctness

#### Manual Updates
```sh
# Update to latest versions
./scripts/update-assets.sh

# Update to specific p5.js version
./scripts/update-assets.sh v1.9.0

# Update both p5.js and types to specific versions
./scripts/update-assets.sh v1.9.0 1.9.0

# Verify current assets
./scripts/verify-assets.sh
```

#### Asset Structure
```
assets/
├── core/                    # p5.js libraries
│   ├── p5.js              # Full development version
│   ├── p5.min.js          # Minified production version
│   ├── p5.sound.js        # Sound library
│   └── p5.sound.min.js    # Minified sound library
├── types/                  # TypeScript definitions
│   ├── p5.d.ts           # Main type definitions
│   ├── constants.d.ts    # P5 constants
│   └── literals.d.ts     # Type literals
├── .version               # Legacy version file
└── version.json           # Complete version info
```

#### GitHub Actions Workflows
- **🔄 Update Assets on Release**: Main workflow for automated asset updates
- **🧪 Test Assets**: Validates downloaded assets and runs tests
- **📡 Monitor Releases**: Monitors p5.js repository for new releases
- **📚 Generate Docs**: Updates Neovim help documentation

See [`.github/WORKFLOWS.md`](.github/WORKFLOWS.md) for detailed workflow documentation.

> **License ⚖️**
>
> (c) [Dean Tarisai](https://prjctimg.me)
> Released under the [GPL-3.0](LICENSE) License.
