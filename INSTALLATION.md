# Plugin Installation Guide

## ⚠️ Important Note About Installation

**Do NOT copy files manually to your Neovim config directory.** 

The plugin should be managed by your plugin manager (lazy.nvim, packer, vim-plug, etc.) to avoid:

1. **Update Hassles**: Manual copying makes updates difficult
2. **Sync Issues**: Changes in workspace won't be reflected
3. **Version Conflicts**: Risk of mixed versions
4. **Path Problems**: Potential loading order issues

## Recommended Installation Methods

### Using lazy.nvim (Recommended)
```lua
{
  "prjctimg/p5.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "akinsho/chrome-remote.nvim"
  }
}
```

### Using packer.nvim
```lua
use {
  "prjctimg/p5.nvim",
  requires = {
    "nvim-lua/plenary.nvim",
    "akinsho/chrome-remote.nvim"
  }
}
```

## Development Workflow

If you're developing the plugin:

1. **Make changes** in `/home/prjctimg/workspace/p5.nvim/`
2. **Test changes** by manually updating your installed copy
3. **Commit changes** to the repository
4. **Pull updates** through your plugin manager

### Testing Changes During Development
```bash
# Only copy for testing - NOT for production
cp -r /home/prjctimg/workspace/p5.nvim/* ~/.local/share/nvim/lazy/p5.nvim/
```

## Current Status

✅ **All critical issues resolved:**
- Plugin loads without startup errors
- Console logs show proper formatting with colors
- Server behavior matches requirements (no unwanted prompts)
- CWD management works correctly

✅ **Codebase compliance:**
- Module exports use filename-first letter (S, C, P)
- Core module maintained as 'M' for dependency stability
- No test files in repository
- README updated with user-facing changes

## Restart Required

After fixing the loading order issues, **restart Neovim completely** to ensure all changes are loaded properly.