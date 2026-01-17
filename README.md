# p5.nvim 🌃

> Better editor support for p5.js in Neovim.

> [!caution]
>
> This plugin is in early development and may contain bugs or breaking changes.

## Requirements 📋

- Neovim >= 0.11.0
- `curl`
- `python3`
- `git`

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

- **Version Selection**: Choose between p5.js 1.9.x (legacy) and 2.x.x (latest)
- In-editor documentation (manpages) available via `:help p5.[module/symbol]`

### Creates a p5.js project

> [!IMPORTANT]
> Avoids CDN use so that project creation can work offline.

```
your-sketch/
├── lib/
│ ├── p5.js # Core library
│ ├── p5.sound.js # Sound addon
│ └── types/ # TypeScript definitions
├── index.html # Auto-generated HTML
├── style.css # Sketch styles
└── sketch.js # Your p5.js code
```

```sh
:P5Create
```

 video sample goes here

### Browses and installs third-party p5.js libraries

> [!important]
>
> This requires an active internet connection because the bare setup only has `p5.js` and `p5.sound` .
>
> The script tags are automatically updated when a new library is installed to the index.html file after the library has been successfully downloaded.
> No need to manually change the markup after you download the library 🙃 .

```sh
 :P5Download
```

 video sample goes here

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

> #### License ⚖️
>
> (c) [Dean Tarisai](https://prjctimg.me)
> Released under the [GPL-3.0](LICENSE) License.

```

```
