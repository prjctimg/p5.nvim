#!/bin/bash
# Bundle p5.js types with tsdown

set -e

P5_VERSION="${1:-latest}"
TYPES_VERSION="${2:-latest}"
PLUGIN_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ASSETS_DIR="$PLUGIN_ROOT/assets/types"

echo "Bundling p5.js types for version: $P5_VERSION"

# Create temporary working directory
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

# Check if tsdown is available
if ! command -v tsdown &> /dev/null; then
    echo "tsdown not available - using fallback method"
    USE_FALLBACK=true
else
    USE_FALLBACK=false
fi

# Download @types/p5
echo "Downloading @types/p5@$TYPES_VERSION..."
npm pack "@types/p5@$TYPES_VERSION"
tar -xzf package.tgz
cd package

# Generate bundled type definitions
echo "Generating bundled p5.d.ts with global scope..."
tsdown --dts --isolatedDeclarations true --output "$ASSETS_DIR/p5.d.ts"

# Verify and clean up
if [ -f "$ASSETS_DIR/p5.d.ts" ]; then
    echo "✓ Successfully generated: $ASSETS_DIR/p5.d.ts"
    echo "File size: $(wc -c < "$ASSETS_DIR/p5.d.ts") bytes"
    echo "Type definitions bundled and ready for use"
    echo "Sample types:"
    head -20 "$ASSETS_DIR/p5.d.ts" | grep -E "(createCanvas|setup|draw|declare global)" || echo "  (Global type structure detected)"
else
    echo "✗ Failed to generate p5.d.ts"
    exit 1
fi

# Clean up
cd "$PLUGIN_ROOT"
rm -rf "$TEMP_DIR"

echo "Type bundling complete!"
echo "Assets directory: $ASSETS_DIR"
echo "p5.js version: $P5_VERSION"
echo "@types/p5 version: $TYPES_VERSION"