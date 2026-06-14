# Sketchspaces

A **sketchspace** is a directory containing a `p5.json` file that p5.nvim uses to manage your p5.js projects.

## Structure

```
my-sketch/
├── p5.json          # Project configuration
├── sketch.js        # Main sketch file
├── index.html       # Generated HTML page
├── tsconfig.json    # TypeScript configuration
├── assets/
│   ├── favicon.ico
│   ├── libs/
│   │   ├── p5.js        # p5.js core library
│   │   └── libs.js      # Runtime library loader
│   └── types/
│       └── p5.d.ts      # p5.js type definitions
└── skchbk/              # Optional: cloned sketches
```

## p5.json Configuration

```json
{
  "version": "2.3.0",
  "libs": {},
  "includes": ["sketch.js"],
  "gist": {
    "url": "username/gistId",
    "title": "My Sketch"
  }
}
```

| Field | Description |
|-------|-------------|
| `version` | p5.js version to use (only v2.x is supported) |
| `libs` | Contributor libraries to install (`{ "name": "version" }`) |
| `includes` | Files to include in Gist uploads |
| `gist` | Optional Gist metadata for sync |

## Creating a Sketchspace

```vim
:P5 create my-sketch
```

Without arguments, prompts for a name.

## Lifecycle

1. **Create** — `:P5 create` generates the skeleton
2. **Setup** — `:P5 setup` downloads assets and installs libraries
3. **Develop** — Run `:P5` and select "Start server" for live preview
4. **Share** — `:P5 gist "description"` uploads to GitHub Gist
5. **Sync** — `:P5 gist sync` reconciles local vs remote changes
