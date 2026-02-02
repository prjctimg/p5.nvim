#!/bin/bash
# Asset update script for local development

set -e

P5_VERSION="${1:-latest}"
TYPES_VERSION="${2:-latest}"

echo "Updating p5.js assets..."
echo "p5.js version: $P5_VERSION"
echo "@types/p5 version: $TYPES_VERSION"

# Create directories
mkdir -p assets/core
mkdir -p assets/types

# Clean version string
if [ "$P5_VERSION" != "latest" ]; then
  P5_CLEAN=$(echo "$P5_VERSION" | sed 's/^v//')
else
  P5_CLEAN="latest"
fi

# Download core libraries
echo "Downloading core libraries..."
curl -sL "https://cdn.jsdelivr.net/npm/p5@$P5_CLEAN/lib/p5.js" -o assets/core/p5.js
curl -sL "https://cdn.jsdelivr.net/npm/p5@$P5_CLEAN/lib/p5.min.js" -o assets/core/p5.min.js
curl -sL "https://cdn.jsdelivr.net/npm/p5@$P5_CLEAN/lib/addons/p5.sound.js" -o assets/core/p5.sound.js
curl -sL "https://cdn.jsdelivr.net/npm/p5@$P5_CLEAN/lib/addons/p5.sound.min.js" -o assets/core/p5.sound.min.js

# Download TypeScript definitions
echo "Downloading TypeScript definitions..."
curl -sL "https://cdn.jsdelivr.net/npm/@types/p5@$TYPES_VERSION/index.d.ts" -o assets/types/p5.d.ts
curl -sL "https://cdn.jsdelivr.net/npm/@types/p5@$TYPES_VERSION/constants.d.ts" -o assets/types/constants.d.ts 2>/dev/null || true
curl -sL "https://cdn.jsdelivr.net/npm/@types/p5@$TYPES_VERSION/literals.d.ts" -o assets/types/literals.d.ts 2>/dev/null || true

# Update version file
if [ "$P5_VERSION" != "latest" ]; then
  echo "$P5_VERSION" > assets/.version
else
  # Get actual latest version
  ACTUAL_VERSION=$(curl -s "https://api.github.com/repos/processing/p5.js/releases/latest" | grep '"tag_name"' | sed -E 's/.*"tag_name": ?"([^"]+).*/\1/')
  echo "$ACTUAL_VERSION" > assets/.version
fi

echo "Assets updated successfully!"
ls -la assets/
