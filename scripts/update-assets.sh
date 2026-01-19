#!/bin/bash
# Asset update script for p5.nvim
# 
# Usage: ./scripts/update-assets.sh [p5_version] [types_version]
# Examples:
#   ./scripts/update-assets.sh                    # Update to latest versions
#   ./scripts/update-assets.sh v1.9.0            # Update to specific p5.js version
#   ./scripts/update-assets.sh v1.9.0 1.9.0      # Update both to specific versions

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Default values
P5_VERSION="${1:-latest}"
TYPES_VERSION="${2:-latest}"

print_status "Updating p5.js assets..."
echo "  📦 p5.js version: $P5_VERSION"
echo "  📝 @types/p5 version: $TYPES_VERSION"

# Create directories if they don't exist
mkdir -p assets/core
mkdir -p assets/types

# Clean version string
if [ "$P5_VERSION" != "latest" ]; then
    P5_CLEAN=$(echo "$P5_VERSION" | sed 's/^v//')
else
    P5_CLEAN="latest"
fi

if [ "$TYPES_VERSION" != "latest" ]; then
    TYPES_CLEAN=$(echo "$TYPES_VERSION" | sed 's/^v//')
else
    TYPES_CLEAN="latest"
fi

# Function to download with error handling
download_file() {
    local url="$1"
    local output="$2"
    local description="$3"
    
    print_status "Downloading $description..."
    
    if curl --silent --fail --location --output "$output" "$url"; then
        local size=$(stat -c%s "$output" 2>/dev/null || stat -f%z "$output" 2>/dev/null || echo "unknown")
        print_success "✓ $description (${size} bytes)"
        return 0
    else
        print_error "✗ Failed to download $description from $url"
        return 1
    fi
}

# Download core libraries
print_status "Downloading core libraries..."

CORE_FILES=(
    "p5.js|https://cdn.jsdelivr.net/npm/p5@$P5_CLEAN/lib/p5.js|p5.js core library"
    "p5.min.js|https://cdn.jsdelivr.net/npm/p5@$P5_CLEAN/lib/p5.min.js|p5.js minified library"
    "p5.sound.js|https://cdn.jsdelivr.net/npm/p5@$P5_CLEAN/lib/addons/p5.sound.js|p5.sound.js library"
    "p5.sound.min.js|https://cdn.jsdelivr.net/npm/p5@$P5_CLEAN/lib/addons/p5.sound.min.js|p5.sound.js minified library"
)

DOWNLOAD_SUCCESS=true

for file_info in "${CORE_FILES[@]}"; do
    IFS='|' read -r filename url description <<< "$file_info"
    if ! download_file "$url" "assets/core/$filename" "$description"; then
        DOWNLOAD_SUCCESS=false
    fi
done

# Download TypeScript definitions
print_status "Downloading TypeScript definitions..."

TYPE_FILES=(
    "p5.d.ts|https://cdn.jsdelivr.net/npm/@types/p5@$TYPES_CLEAN/index.d.ts|Main p5.js types"
    "constants.d.ts|https://cdn.jsdelivr.net/npm/@types/p5@$TYPES_CLEAN/constants.d.ts|P5 constants types"
    "literals.d.ts|https://cdn.jsdelivr.net/npm/@types/p5@$TYPES_CLEAN/literals.d.ts|P5 literal types"
)

for file_info in "${TYPE_FILES[@]}"; do
    IFS='|' read -r filename url description <<< "$file_info"
    if ! download_file "$url" "assets/types/$filename" "$description"; then
        print_warning "⚠ Optional type file $filename not found (this is normal for some versions)"
    fi
done

# Determine actual versions
if [ "$P5_VERSION" = "latest" ]; then
    ACTUAL_P5_VERSION=$(curl --silent "https://api.github.com/repos/processing/p5.js/releases/latest" | \
        grep '"tag_name"' | sed -E 's/.*"tag_name": ?"([^"]+).*/\1/' || echo "unknown")
else
    ACTUAL_P5_VERSION="$P5_VERSION"
fi

if [ "$TYPES_VERSION" = "latest" ]; then
    ACTUAL_TYPES_VERSION=$(curl --silent "https://registry.npmjs.org/@types/p5/latest" | \
        jq -r '.version' 2>/dev/null || echo "unknown")
else
    ACTUAL_TYPES_VERSION="$TYPES_VERSION"
fi

# Create version.json file
print_status "Creating version information file..."
cat > assets/version.json << EOF
{
  "p5js": "$ACTUAL_P5_VERSION",
  "p5js_semver": "$(echo "$ACTUAL_P5_VERSION" | sed 's/^v//')",
  "types": "$ACTUAL_TYPES_VERSION",
  "updated_at": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "updated_by": "local-script",
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

# Create legacy .version file for backward compatibility
echo "$ACTUAL_P5_VERSION" > assets/.version

# Verify downloaded files
print_status "Verifying downloaded files..."

# Check core files
REQUIRED_CORE_FILES=("p5.js" "p5.sound.js")
for file in "${REQUIRED_CORE_FILES[@]}"; do
    filepath="assets/core/$file"
    if [ -f "$filepath" ] && [ -s "$filepath" ]; then
        size=$(stat -c%s "$filepath" 2>/dev/null || stat -f%z "$filepath" 2>/dev/null || echo "unknown")
        print_success "✓ core/$file (${size} bytes)"
    else
        print_error "✗ core/$file is missing or empty"
        DOWNLOAD_SUCCESS=false
    fi
done

# Check type files
if [ -f "assets/types/p5.d.ts" ] && [ -s "assets/types/p5.d.ts" ]; then
    size=$(stat -c%s "assets/types/p5.d.ts" 2>/dev/null || stat -f%z "assets/types/p5.d.ts" 2>/dev/null || echo "unknown")
    print_success "✓ types/p5.d.ts (${size} bytes)"
else
    print_error "✗ types/p5.d.ts is missing or empty"
    DOWNLOAD_SUCCESS=false
fi

# Display summary
echo ""
print_status "Asset Update Summary:"
echo "  📁 Directory structure: assets/ (core/, types/)"
echo "  📦 p5.js version: $ACTUAL_P5_VERSION"
echo "  📝 @types/p5 version: $ACTUAL_TYPES_VERSION"
echo "  📅 Updated at: $(date -u +%Y-%m-%dT%H:%M:%SZ)"

echo ""
print_status "Downloaded files:"
find assets -type f \( -name "*.js" -o -name "*.d.ts" \) | sort | while read -r file; do
    size=$(stat -c%s "$file" 2>/dev/null || stat -f%z "$file" 2>/dev/null || echo "unknown")
    echo "  ✓ $file (${size} bytes)"
done

if [ "$DOWNLOAD_SUCCESS" = true ]; then
    echo ""
    print_success "Assets updated successfully!"
    echo ""
    print_status "Next steps:"
    echo "  1. Commit the changes: git add assets/ && git commit -m 'Update assets to p5.js $ACTUAL_P5_VERSION'"
    echo "  2. Push to repository: git push"
    echo "  3. GitHub Actions will run tests automatically"
else
    echo ""
    print_error "Asset update completed with errors. Please check the messages above."
    exit 1
fi