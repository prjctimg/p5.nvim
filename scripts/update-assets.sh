#!/bin/bash
# Asset update script for p5.nvim

set -e

P5_VERSION="${1:-latest}"
TYPES_VERSION="${2:-latest}"

echo "Updating p5.js assets..."
echo "p5.js version: $P5_VERSION"
echo "@types/p5 version: $TYPES_VERSION"

# Get plugin root
PLUGIN_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ASSETS_DIR="$PLUGIN_ROOT/assets"

# Create directories
mkdir -p "$ASSETS_DIR/core"
mkdir -p "$ASSETS_DIR/types"
mkdir -p "$ASSETS_DIR/contrib"

# Clean version string
if [ "$P5_VERSION" != "latest" ]; then
    P5_CLEAN=$(echo "$P5_VERSION" | sed 's/^v//')
else
    P5_CLEAN="latest"
fi

echo "Downloading core libraries..."

# Download core libraries
if command -v curl &> /dev/null; then
    curl -sL "https://cdn.jsdelivr.net/npm/p5@$P5_CLEAN/lib/p5.js" -o "$ASSETS_DIR/core/p5.js"
    curl -sL "https://cdn.jsdelivr.net/npm/p5@$P5_CLEAN/lib/p5.min.js" -o "$ASSETS_DIR/core/p5.min.js"
    curl -sL "https://cdn.jsdelivr.net/npm/p5@$P5_CLEAN/lib/addons/p5.sound.js" -o "$ASSETS_DIR/core/p5.sound.js"
    curl -sL "https://cdn.jsdelivr.net/npm/p5@$P5_CLEAN/lib/addons/p5.sound.min.js" -o "$ASSETS_DIR/core/p5.sound.min.js"
elif command -v wget &> /dev/null; then
    wget -q -O "$ASSETS_DIR/core/p5.js" "https://cdn.jsdelivr.net/npm/p5@$P5_CLEAN/lib/p5.js"
    wget -q -O "$ASSETS_DIR/core/p5.min.js" "https://cdn.jsdelivr.net/npm/p5@$P5_CLEAN/lib/p5.min.js"
    wget -q -O "$ASSETS_DIR/core/p5.sound.js" "https://cdn.jsdelivr.net/npm/p5@$P5_CLEAN/lib/addons/p5.sound.js"
    wget -q -O "$ASSETS_DIR/core/p5.sound.min.js" "https://cdn.jsdelivr.net/npm/p5@$P5_CLEAN/lib/addons/p5.sound.min.js"
else
    echo "Error: Neither curl nor wget found"
    exit 1
fi

echo "Downloading TypeScript definitions..."

# Download TypeScript definitions
if [ "$TYPES_VERSION" != "latest" ]; then
    TYPES_CLEAN="$TYPES_VERSION"
else
    TYPES_CLEAN="latest"
fi

if command -v curl &> /dev/null; then
    curl -sL "https://cdn.jsdelivr.net/npm/@types/p5@$TYPES_CLEAN/index.d.ts" -o "$ASSETS_DIR/types/p5.d.ts"
    curl -sL "https://cdn.jsdelivr.net/npm/@types/p5@$TYPES_CLEAN/constants.d.ts" -o "$ASSETS_DIR/types/constants.d.ts" 2>/dev/null || echo "constants.d.ts not found"
    curl -sL "https://cdn.jsdelivr.net/npm/@types/p5@$TYPES_CLEAN/literals.d.ts" -o "$ASSETS_DIR/types/literals.d.ts" 2>/dev/null || echo "literals.d.ts not found"
elif command -v wget &> /dev/null; then
    wget -q -O "$ASSETS_DIR/types/p5.d.ts" "https://cdn.jsdelivr.net/npm/@types/p5@$TYPES_CLEAN/index.d.ts"
    wget -q -O "$ASSETS_DIR/types/constants.d.ts" "https://cdn.jsdelivr.net/npm/@types/p5@$TYPES_CLEAN/constants.d.ts" 2>/dev/null || echo "constants.d.ts not found"
    wget -q -O "$ASSETS_DIR/types/literals.d.ts" "https://cdn.jsdelivr.net/npm/@types/p5@$TYPES_CLEAN/literals.d.ts" 2>/dev/null || echo "literals.d.ts not found"
fi

# Get actual version if "latest"
if [ "$P5_VERSION" = "latest" ]; then
    if command -v curl &> /dev/null; then
        ACTUAL_VERSION=$(curl -s "https://api.github.com/repos/processing/p5.js/releases/latest" | grep '"tag_name"' | sed -E 's/.*"tag_name": ?"([^"]+).*/\1/')
    elif command -v wget &> /dev/null; then
        ACTUAL_VERSION=$(wget -q -O - "https://api.github.com/repos/processing/p5.js/releases/latest" | grep '"tag_name"' | sed -E 's/.*"tag_name": ?"([^"]+).*/\1/')
    fi
else
    ACTUAL_VERSION="$P5_VERSION"
fi

# Get actual types version
if [ "$TYPES_VERSION" = "latest" ]; then
    if command -v curl &> /dev/null; then
        ACTUAL_TYPES_VERSION=$(curl -s "https://registry.npmjs.org/@types/p5/latest" | grep '"version"' | sed -E 's/.*"version": ?"([^"]+).*/\1/')
    elif command -v wget &> /dev/null; then
        ACTUAL_TYPES_VERSION=$(wget -q -O - "https://registry.npmjs.org/@types/p5/latest" | grep '"version"' | sed -E 's/.*"version": ?"([^"]+).*/\1/')
    fi
else
    ACTUAL_TYPES_VERSION="$TYPES_VERSION"
fi

# Update version file
cat > "$ASSETS_DIR/version.json" << EOF
{
  "p5js": "$ACTUAL_VERSION",
  "p5js_semver": "${ACTUAL_VERSION#v}",
  "types": "$ACTUAL_TYPES_VERSION",
  "updated_at": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "assets": {
    "core": [
      "p5.js",
      "p5.min.js",
      "p5.sound.js",
      "p5.sound.min.js"
    ],
    "types": [
      "p5.d.ts",
      "constants.d.ts",
      "literals.d.ts"
    ]
  }
}
EOF

# Create legacy .version file
echo "$ACTUAL_VERSION" > "$ASSETS_DIR/.version"

echo "Assets updated successfully!"
echo "Assets directory: $ASSETS_DIR"
echo "p5.js version: $ACTUAL_VERSION"
echo "@types/p5 version: $ACTUAL_TYPES_VERSION"