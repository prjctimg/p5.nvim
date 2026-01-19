#!/bin/bash
# Asset verification script for p5.nvim
# 
# Usage: ./scripts/verify-assets.sh
# Checks the current state of bundled p5.js assets

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_header() {
    echo -e "${BLUE}=== $1 ===${NC}"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

# Start verification
print_header "p5.nvim Asset Verification"

# Check if assets directory exists
if [ ! -d "assets" ]; then
    print_error "assets directory not found"
    exit 1
fi

print_success "assets directory exists"

# Check directory structure
print_header "Directory Structure"

required_dirs=("assets/core" "assets/types")
for dir in "${required_dirs[@]}"; do
    if [ -d "$dir" ]; then
        print_success "$dir exists"
    else
        print_error "$dir is missing"
    fi
done

# Check core files
print_header "Core Libraries"

core_files=("p5.js" "p5.min.js" "p5.sound.js" "p5.sound.min.js")
missing_files=0

for file in "${core_files[@]}"; do
    filepath="assets/core/$file"
    if [ -f "$filepath" ]; then
        if [ -s "$filepath" ]; then
            size=$(stat -c%s "$filepath" 2>/dev/null || stat -f%z "$filepath" 2>/dev/null || echo "unknown")
            print_success "$file (${size} bytes)"
        else
            print_error "$file is empty"
            ((missing_files++))
        fi
    else
        print_warning "$file not found"
        ((missing_files++))
    fi
done

# Check TypeScript files
print_header "TypeScript Definitions"

type_files=("p5.d.ts")
optional_files=("constants.d.ts" "literals.d.ts")

for file in "${type_files[@]}"; do
    filepath="assets/types/$file"
    if [ -f "$filepath" ]; then
        if [ -s "$filepath" ]; then
            size=$(stat -c%s "$filepath" 2>/dev/null || stat -f%z "$filepath" 2>/dev/null || echo "unknown")
            print_success "$file (${size} bytes)"
        else
            print_error "$file is empty"
            ((missing_files++))
        fi
    else
        print_error "$file is missing"
        ((missing_files++))
    fi
done

for file in "${optional_files[@]}"; do
    filepath="assets/types/$file"
    if [ -f "$filepath" ]; then
        if [ -s "$filepath" ]; then
            size=$(stat -c%s "$filepath" 2>/dev/null || stat -f%z "$filepath" 2>/dev/null || echo "unknown")
            print_success "$file (${size} bytes) [optional]"
        else
            print_warning "$file is empty [optional]"
        fi
    else
        print_info "$file not found [optional]"
    fi
done

# Check version files
print_header "Version Information"

if [ -f "assets/.version" ]; then
    version=$(cat assets/.version)
    print_success ".version: $version"
else
    print_warning ".version not found"
fi

if [ -f "assets/version.json" ]; then
    if command -v jq >/dev/null 2>&1; then
        if jq empty assets/version.json 2>/dev/null; then
            print_success "version.json is valid JSON"
            
            # Extract version info
            p5_version=$(jq -r '.p5js // "unknown"' assets/version.json)
            types_version=$(jq -r '.types // "unknown"' assets/version.json)
            updated_at=$(jq -r '.updated_at // "unknown"' assets/version.json)
            
            print_info "p5.js: $p5_version"
            print_info "@types/p5: $types_version"
            print_info "Updated: $updated_at"
        else
            print_error "version.json is invalid JSON"
            ((missing_files++))
        fi
    else
        print_warning "jq not available, skipping JSON validation"
    fi
else
    print_warning "version.json not found"
fi

# Syntax checks
print_header "Syntax Validation"

# Check JavaScript files
js_files=$(find assets/core -name "*.js" 2>/dev/null || true)
for file in $js_files; do
    if command -v node >/dev/null 2>&1; then
        if node --check "$file" 2>/dev/null; then
            print_success "$(basename "$file") has valid syntax"
        else
            print_error "$(basename "$file") has syntax errors"
            ((missing_files++))
        fi
    else
        print_warning "node not available, skipping syntax check"
        break
    fi
done

# Check if update script exists
print_header "Update Script"

if [ -f "scripts/update-assets.sh" ]; then
    if [ -x "scripts/update-assets.sh" ]; then
        print_success "update-assets.sh is executable"
        
        # Check bash syntax
        if bash -n scripts/update-assets.sh 2>/dev/null; then
            print_success "update-assets.sh has valid bash syntax"
        else
            print_error "update-assets.sh has syntax errors"
            ((missing_files++))
        fi
    else
        print_warning "update-assets.sh is not executable"
    fi
else
    print_warning "update-assets.sh not found"
fi

# Summary
print_header "Summary"

total_files=$((${#core_files[@]} + ${#type_files[@]}))
present_files=$((total_files - missing_files))

echo "Files checked: $total_files"
echo "Files present: $present_files"
echo "Files missing/invalid: $missing_files"

if [ $missing_files -eq 0 ]; then
    echo ""
    print_success "All assets are valid and complete!"
    echo ""
    print_info "You can use these assets for offline p5.js development."
    exit 0
else
    echo ""
    print_error "Some assets are missing or invalid."
    echo ""
    print_info "To fix this, run:"
    echo "  ./scripts/update-assets.sh"
    exit 1
fi