# Changelog

All notable changes since v0.5.0.

---

## Unreleased

### Highlights
- Bidirectional gist sync with per-item conflict prompts
- Gist `p5.json` stores metadata as an object (`url`, `title`, `description`) instead of a plain URL string
- Gist edit command updates both remote (GitHub) and local (`p5.json`) metadata
- Console insert mode disabled — terminal mode is blocked on focus
- **100+ p5.js code snippets** in VS Code JSON format, auto-discovered from runtimepath
- Codebase-wide cleanup: modernized APIs (`vim.system`), removed dead code, normalized notification levels

### Features
- `:P5 gist edit` — edit gist title or first comment; changes sync to both remote and `p5.json`
- `:P5 sync gist` — bidirectional sync with per-item prompts (title, description, source files)
- **Snippets** — 100+ p5.js snippets in `snippets/p5.js.json` with `p5-` prefix trigger convention
  - Lifecycle (setup, draw, preload, full sketch skeleton)
  - Paired constructs (push/pop, beginShape/endShape, loadPixels/updatePixels, createGraphics)
  - All vertex call types (vertex, curveVertex, bezierVertex, quadraticVertex)
  - Basic shapes, color & style, transformations, math & vector
  - Typography, images, events, 3D/WebGL, DOM, sound, IO
  - Common idioms (grid loop, polar loop, particles, bounce, fadeout, color palette)
  - Works with LuaSnip (from_vscode loader), blink.cmp (default/ luasnip preset), nvim-cmp

### Gist URL format change

The `gist` field in `p5.json` now stores an object instead of a plain URL string:

```diff
- "gist": "https://gist.github.com/user/abc123"
+ "gist": {
+   "url": "user/abc123",
+   "title": "My Sketch",
+   "description": "First comment body"
+ }
```

Legacy string-format gists are still read correctly on upgrade.

### Gist Sync Flow

```mermaid
flowchart TD
    A[P5 sync gist] --> B[Fetch remote gist + first comment]
    B --> C[Compare local vs remote for title, desc, each file]
    C --> D{Build diff summary}
    D --> E{Any diffs?}
    E -->|No| F[Up to date]
    E -->|Yes| G[Single prompt: Apply all remote / Apply all local / Skip]
    G --> H[Apply chosen direction]
    H --> I[Write pulled files to disk + update p5.json]
    H --> J[Push local files to remote + update title/comment]
    I --> K[Done]
    J --> K
```

### Gist Create Flow

```mermaid
flowchart LR
    A[P5 gist] --> B[Copy includes to temp dir]
    B --> C[gh gist create --public --desc]
    C --> D[Extract gist ID from URL]
    D --> E[Fetch gist description via GH API]
    D --> F[Fetch first comment body]
    E --> G[Store gist = {url, title, desc} in p5.json]
    F --> G
    G --> H[Upload p5.json to gist via gh gist edit]
    H --> I[Done]
```

### Refactoring
- **gist.lua**:
  - `G.sync` replaces `G.update` — bidirectional comparison with prompts
  - `G.current` returns `{ id, url, title, description }` from object format
  - `G.create` stores full gist object with title and description metadata
  - `G.edit` updates both remote API and local `p5.json`
  - `clone_gist` writes gist metadata into cloned project's `p5.json`
  - Added missing `list_user_gists` and `clone_gist` helper functions
  - Removed redundant `G.skchbk_browse_remote` (unified into `G.clone`)
  - `G.update` → `G.sync` converted to async `vim.system` with recursive callback chaining
- **console.lua**: Disabled terminal/insert mode on console buffer; fixed `connected` variable scope; added cleanup on hide (jobstop + term close)
- **core.lua**: Removed dead `require_snacks`, redundant nil checks, cleaned up comments
- **health.lua**: Expanded checks (bundled libs, server script, websockets, gist metadata fields, python detection)
- **server.lua**: Removed duplicated validation checks, normalized notification levels
- **init.lua**: `handlers.sync` calls `gist.sync()` instead of `gist.update()`
- Normalized non-fatal notification levels from `"error"` to `"warn"` across all modules

---

## v0.6.0

> Tag: `3d11940` — feat: add skchbk command for cloning gist-based sketchbooks

### Features
- `:P5 skchbk` — clone all gists from a GitHub user's sketchbook into a local `skchbk/` directory
- `:P5 skchbk list` — browse local sketches or prompt to clone from remote
- Gists are organized into subdirectories named by slugified description
- Each cloned gist includes a `README.md` with the first comment body
- `skchbk/` directory is automatically excluded from gist uploads

### Sketchbook Clone Flow

```mermaid
flowchart TD
    A[P5 skchbk] --> B{User configured?}
    B -->|Yes| C[Clone all gists from user]
    B -->|No| D[Prompt for username]
    D --> C
    C --> E[gh api /users/user/gists --paginate]
    E --> F[For each gist]
    F --> G[Slugify description → directory name]
    G --> H{Directory exists?}
    H -->|Yes| I[Skip]
    H -->|No| J[gh api /gists/id → get files]
    J --> K[Write files to directory]
    J --> L[Fetch first comment body]
    L --> M[Write README.md]
    K --> F
    M --> F
    F --> N[Report: cloned / skipped / errors]
```

### Fixes
- Fixed issues with `:P5 create` and console commands (`b6626ea`)

---

## v0.5.1

> Tag: `60ae1af` — fix: resolve issues with create console commands

### Fixes
- Resolved timing/interaction issues between project creation and console initialization
- Fixed release workflow to properly commit version bumps in help files
- Updated release workflow and help file content

---

## v0.5.0

> Tag: `1937008` — feat: add integrity check for downloaded assets (#23)

### Features
- SHA256 integrity verification for downloaded p5.js assets
- Automatic retry on integrity check failure
- Cache layer for asset downloads with hash verification

### Changes
- `core.fetch` now supports `expected_hash` option for integrity verification
- Asset download in `P.create_project` validates hashes before proceeding
- Cache system uses `fs_copyfile` for efficient cache restoration
