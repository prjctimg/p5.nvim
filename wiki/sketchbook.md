# Sketchbook Workflow

Keep your p5.js sketches organized with the sketchbook pattern.

## What is a Sketchbook?

A sketchbook is a local directory (`skchbk/`) containing cloned p5.js gists. It lets you browse, clone, and organize sketches from any GitHub user.

## Setup

Set your GitHub username in the config:

```lua
require("p5").setup({
  sketchbook = {
    user = "your-github-username",
  },
})
```

Or provide it when prompted by `:P5 skchbk`.

## Commands

### List local sketches

```vim
:P5 skchbk list
```

Shows all locally cloned sketches in `skchbk/`. Select one to jump to it.

### Clone all gists

```vim
:P5 skchbk clone
```

Clones all public gists from your configured user into `skchbk/`.

### Clone a specific gist

```vim
:P5 skchbk
```

Prompts to either clone all gists or pick one interactively.

## Workflow Ideas

### Daily sketching

```vim
" Start a new sketch
:P5 create daily-2026-06-12

" Work on it, then share
:P5 gist "Daily sketch 2026-06-12"
```

### Curating a collection

```
skchbk/
├── generative-forest/
├── particle-system/
├── waving-flag/
└── audio-visualizer/
```

Clone individual gists by selecting them interactively. Each clone preserves the gist link so you can sync changes back.

### Syncing changes

```vim
" Inside a cloned sketchspace
:P5 gist sync
```

Shows a diff of local vs remote changes. Choose to apply local changes, pull remote changes, or skip.

### Sharing feedback

```vim
:P5 gist edit
```

Edit the gist description or the first comment (sketch details). This is useful for adding notes, attributions, or documentation.

## Organization Tips

- Use descriptive gist descriptions — they become directory names when cloned
- The first comment on each gist serves as sketch notes/README
- Run `:P5 skchbk list` to quickly switch between sketches
- The `skchbk/` directory is excluded from gist uploads (`.gitignore` handles this)
