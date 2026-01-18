#!/bin/bash

# Update p5.nvim Assets Script
# This script downloads the latest p5.js assets and updates the repository

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔄 p5.nvim Asset Update Script${NC}"
echo -e "${BLUE}===================================${NC}"

# Get current version
CURRENT_VERSION="unknown"
if [ -f "assets/.version" ]; then
    CURRENT_VERSION=$(cat assets/.version)
fi

echo -e "${YELLOW}Current p5.js version: $CURRENT_VERSION${NC}"

# Get latest versions
echo -e "${BLUE}Fetching latest versions...${NC}"

LATEST_P5=$(curl -s "https://api.github.com/repos/processing/p5.js/releases/latest" | grep '"tag_name"' | sed -E 's/.*"tag_name": ?"([^"]+).*/\1/')
LATEST_TYPES=$(curl -s "https://api.github.com/repos/DefinitelyTyped/DefinitelyTyped/releases/latest" | grep '"tag_name"' | sed -E 's/.*"tag_name": ?"([^"]+).*/\1/' | sed 's/^v//')

echo -e "${GREEN}Latest p5.js version: $LATEST_P5${NC}"
echo -e "${GREEN}Latest @types/p5 version: $LATEST_TYPES${NC}"

# Check if update is needed
if [ "$CURRENT_VERSION" = "$LATEST_P5" ] && [ "$1" != "--force" ]; then
    echo -e "${GREEN}✅ Already up to date!${NC}"
    echo -e "${YELLOW}Use --force to update anyway${NC}"
    exit 0
fi

# Ensure assets directory exists
mkdir -p assets

echo -e "${BLUE}Downloading assets...${NC}"

# Download p5.js core library
P5_VERSION=$(echo "$LATEST_P5" | sed 's/^v//')
echo -e "${BLUE}Downloading p5.js v$P5_VERSION...${NC}"
curl -sL "https://cdn.jsdelivr.net/npm/p5@$P5_VERSION/lib/p5.js" -o assets/p5.js

# Download p5.sound.js (use latest available)
echo -e "${BLUE}Downloading p5.sound.js...${NC}"
curl -sL "https://cdn.jsdelivr.net/npm/p5@latest/lib/addons/p5.sound.js" -o assets/p5.sound.js

# Download TypeScript definitions
echo -e "${BLUE}Downloading TypeScript definitions...${NC}"
curl -sL "https://cdn.jsdelivr.net/npm/@types/p5@$LATEST_TYPES/index.d.ts" -o assets/p5.d.ts
curl -sL "https://cdn.jsdelivr.net/npm/@types/p5@$LATEST_TYPES/constants.d.ts" -o assets/constants.d.ts
curl -sL "https://cdn.jsdelivr.net/npm/@types/p5@$LATEST_TYPES/literals.d.ts" -o assets/literals.d.ts

# Update version file
echo "$LATEST_P5" > assets/.version

# Show summary
echo -e "${BLUE}===================================${NC}"
echo -e "${GREEN}✅ Assets updated successfully!${NC}"
echo -e "${BLUE}Summary:${NC}"
echo -e "  p5.js: $CURRENT_VERSION → $LATEST_P5"
echo -e "  @types/p5: Updated to $LATEST_TYPES"
echo -e ""
echo -e "${BLUE}Downloaded files:${NC}"
ls -la assets/

# Git commands (optional)
if [ "$2" = "--commit" ]; then
    echo -e "${BLUE}Committing changes...${NC}"
    git add assets/
    git commit -m "🔄 Update bundled assets to p5.js $LATEST_P5

    ## Automated Asset Update
    
    - **p5.js**: Updated to $LATEST_P5
    - **@types/p5**: Updated to $LATEST_TYPES
    - **p5.sound.js**: Refreshed from latest available version
    
    This update ensures offline project creation works with latest p5.js versions."
    
    echo -e "${BLUE}Pushing to repository...${NC}"
    git push
    
    echo -e "${GREEN}✅ Changes committed and pushed!${NC}"
fi

echo -e "${GREEN}🎉 p5.nvim assets are now up to date!${NC}"