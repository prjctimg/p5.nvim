# GitHub Actions Workflows

This repository uses automated GitHub Actions to keep p5.js assets and TypeScript definitions up-to-date.

## Workflows

### 1. Update Assets on Release (`.github/workflows/update-on-release.yml`)

The main workflow that monitors and updates assets when new p5.js releases are available.

**Triggers:**
- **Schedule**: Every 2 hours to check for new releases
- **Manual**: Can be triggered manually with specific version
- **Webhook**: Responds to repository dispatch events for p5.js releases

**Features:**
- Downloads latest p5.js core libraries (both full and minified versions)
- Downloads TypeScript definitions from DefinitelyTyped
- Creates structured asset directory (`assets/core/`, `assets/types/`)
- Generates `version.json` with complete version information
- Creates GitHub releases for major/minor versions
- Maintains backward compatibility with `.version` file

**Manual Usage:**
```bash
# Trigger from GitHub Actions UI with:
# version: v1.9.0 (optional specific version)
# update_types: true (update TypeScript definitions)
```

### 2. Test Assets (`.github/workflows/test-assets.yml`)

Validates that downloaded assets are correct and functional.

**Triggers:**
- On any push/PR that changes `assets/**`
- Manual dispatch

**Tests:**
- ✅ Directory structure validation
- ✅ Core library file presence and size checks
- ✅ TypeScript definition validation
- ✅ JavaScript syntax verification
- ✅ TypeScript compilation test
- ✅ Update script syntax check
- ✅ Generates asset summary in PR

### 3. Update Assets (Legacy) (`.github/workflows/update-assets.yml`)

Legacy workflow maintained for backward compatibility. Use `update-on-release.yml` for new features.

### 4. Generate Docs (`.github/workflows/docs.yml`)

Updates Neovim help documentation when README.md changes.

## Asset Structure

```
assets/
├── core/                          # Core p5.js libraries
│   ├── p5.js                     # Full development version
│   ├── p5.min.js                 # Minified production version
│   ├── p5.sound.js               # Sound library (full)
│   └── p5.sound.min.js           # Sound library (minified)
├── types/                         # TypeScript definitions
│   ├── p5.d.ts                   # Main type definitions
│   ├── constants.d.ts            # P5 constants (optional)
│   └── literals.d.ts             # Type literals (optional)
├── .version                       # Legacy version file
└── version.json                   # Complete version info
```

## Version Information

The `assets/version.json` file contains comprehensive version information:

```json
{
  "p5js": "v1.9.0",
  "p5js_semver": "1.9.0", 
  "types": "1.9.0",
  "updated_at": "2024-01-15T10:30:00Z",
  "assets": {
    "core": ["p5.js", "p5.min.js", "p5.sound.js", "p5.sound.min.js"],
    "types": ["p5.d.ts", "constants.d.ts", "literals.d.ts"]
  }
}
```

## Local Development

### Manual Asset Updates

Use the provided update script for local development:

```bash
# Update to latest versions
./scripts/update-assets.sh

# Update to specific versions
./scripts/update-assets.sh v1.9.0 1.9.0
```

### Testing Local Changes

1. Modify assets
2. Commit changes
3. GitHub Actions will automatically run tests
4. Check the Actions tab for validation results

## Asset URLs

The workflows use these CDN URLs for downloads:

- **Core Libraries**: `https://cdn.jsdelivr.net/npm/p5@{version}/lib/`
- **TypeScript Definitions**: `https://cdn.jsdelivr.net/npm/@types/p5@{version}/`
- **Release API**: `https://api.github.com/repos/processing/p5.js/releases/latest`

## Security Considerations

- All downloads use HTTPS with CDN verification
- File integrity is validated through size and syntax checks
- TypeScript definitions are verified for compilation compatibility
- No external scripts are executed - only curl and standard tools

## Troubleshooting

### Asset Update Fails
1. Check if p5.js CDN is accessible
2. Verify version format (should be like `v1.9.0`)
3. Check GitHub API rate limits
4. Review workflow logs for specific error messages

### TypeScript Definition Issues
1. DefinitelyTyped might have different versioning than p5.js
2. Some type files are optional and may not exist
3. Check the workflow logs for download failures

### Test Failures
1. JavaScript syntax errors indicate corrupted downloads
2. TypeScript compilation issues may be version mismatches
3. Missing files indicate network or CDN problems

## Contributing

When modifying workflows:
1. Test changes in a feature branch first
2. Ensure all workflow syntax is valid
3. Verify that secrets and permissions are correctly configured
4. Update this documentation for any workflow changes