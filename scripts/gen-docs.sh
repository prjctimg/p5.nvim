#!/usr/bin/env bash
set -euo pipefail

P5_REPO_URL="https://github.com/processing/p5.js.git"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CACHE_DIR="$SCRIPT_DIR/../.cache/p5-src"
DOC_DIR="$SCRIPT_DIR/../doc"
P5_REF_JSON="/tmp/p5-ref.json"
P5_MODULES_MD="/tmp/p5-modules"

usage() {
  echo "Usage: $0 [--force]"
  echo "  --force    Force regeneration even if p5.js version hasn't changed"
  exit 1
}

FORCE=0
while [[ $# -gt 0 ]]; do
  case "$1" in
    --force) FORCE=1; shift ;;
    *) usage ;;
  esac
done

if ! command -v pandoc &>/dev/null; then
  echo "Error: pandoc is required. Install it first."
  exit 1
fi

if ! command -v npx &>/dev/null; then
  echo "Error: Node.js/npx is required. Install it first."
  exit 1
fi

fetch_p5_source() {
  echo "==> Fetching p5.js source..."
  mkdir -p "$(dirname "$CACHE_DIR")"

  if [ -d "$CACHE_DIR/.git" ]; then
    echo "    Updating existing clone..."
    git -C "$CACHE_DIR" fetch --depth=1 origin main 2>/dev/null || true
    git -C "$CACHE_DIR" reset --hard origin/main 2>/dev/null || true
  else
    echo "    Cloning p5.js repository..."
    git clone --depth=1 --single-branch --branch main "$P5_REPO_URL" "$CACHE_DIR"
  fi
}

# --- version checking ---
VERSION_FILE="$CACHE_DIR/.gen-version"
CURRENT_VERSION=""

if [ -f "$CACHE_DIR/package.json" ]; then
  CURRENT_VERSION=$(node -e "console.log(JSON.parse(require('fs').readFileSync('$CACHE_DIR/package.json','utf8')).version||'')")
fi

PREV_VERSION=""
if [ -f "$VERSION_FILE" ]; then
  PREV_VERSION=$(cat "$VERSION_FILE")
fi

if [ "$FORCE" -eq 0 ] && [ -n "$CURRENT_VERSION" ] && [ "$CURRENT_VERSION" = "$PREV_VERSION" ]; then
  echo "==> p5.js v$CURRENT_VERSION docs are up to date. Use --force to regenerate."
  exit 0
fi

fetch_p5_source
CURRENT_VERSION=$(node -e "console.log(JSON.parse(require('fs').readFileSync('$CACHE_DIR/package.json','utf8')).version||'')")
echo "    p5.js version: $CURRENT_VERSION"

# --- phase 2: generate reference JSON ---
echo "==> Generating reference JSON with documentation..."
npx --yes documentation build \
  "$CACHE_DIR/src/core/"*.js \
  "$CACHE_DIR/src/color/"*.js \
  "$CACHE_DIR/src/data/"*.js \
  "$CACHE_DIR/src/dom/"*.js \
  "$CACHE_DIR/src/events/"*.js \
  "$CACHE_DIR/src/image/"*.js \
  "$CACHE_DIR/src/io/"*.js \
  "$CACHE_DIR/src/math/"*.js \
  "$CACHE_DIR/src/shape/"*.js \
  "$CACHE_DIR/src/typography/"*.js \
  "$CACHE_DIR/src/utilities/"*.js \
  "$CACHE_DIR/src/webgl/"*.js \
  "$CACHE_DIR/src/webgpu/"*.js \
  "$CACHE_DIR/src/accessibility/"*.js \
  "$CACHE_DIR/src/foundation/"*.js \
  --shallow -o "$P5_REF_JSON"

echo "    JSON generated ($(wc -c < "$P5_REF_JSON") bytes)"

# --- phase 3: convert JSON to per-module markdown ---
echo "==> Converting JSON to per-module markdown..."
rm -rf "$P5_MODULES_MD"
mkdir -p "$P5_MODULES_MD"

node "$SCRIPT_DIR/json-to-md.mjs" "$P5_REF_JSON" "$P5_MODULES_MD" "$CURRENT_VERSION"

echo "    Markdown files: $(ls "$P5_MODULES_MD"/*.md 2>/dev/null | wc -l)"

# --- phase 4: convert markdown to Vim help with pandoc ---
echo "==> Converting markdown to Vim help files..."
for md_file in "$P5_MODULES_MD"/*.md; do
  base=$(basename "$md_file" .md)
  txt_file="$DOC_DIR/$base.txt"
  echo "    $base.txt"
  pandoc -f markdown "$md_file" \
    --lua-filter "$SCRIPT_DIR/vimhelp.lua" \
    --metadata title="$base" \
    -o /dev/null \
    > "$txt_file"
done

echo "    Help files generated in $DOC_DIR"

# --- phase 5: generate tags ---
echo "==> Generating doc/tags..."
TAGS_FILE="$DOC_DIR/tags"
>"$TAGS_FILE"

for txt_file in "$DOC_DIR"/p5-*.txt; do
  fname=$(basename "$txt_file")
  while IFS= read -r line; do
    if [[ "$line" =~ ^\*([^*]+)\* ]]; then
      tag="${BASH_REMATCH[1]}"
      printf '%s\t%s\t/*%s*\n' "$tag" "$fname" "$tag" >> "$TAGS_FILE"
    fi
  done < "$txt_file"
done

if [ -f "$DOC_DIR/p5-nvim.txt" ]; then
  while IFS= read -r line; do
    if [[ "$line" =~ ^\*([^*]+)\* ]]; then
      tag="${BASH_REMATCH[1]}"
      printf '%s\tp5-nvim.txt\t/*%s*\n' "$tag" "$tag" >> "$TAGS_FILE"
    fi
  done < "$DOC_DIR/p5-nvim.txt"
fi

echo "    Tags: $(wc -l < "$TAGS_FILE") entries"

# --- phase 6: save version ---
echo "$CURRENT_VERSION" > "$VERSION_FILE"

echo "==> Done! Generated docs for p5.js v$CURRENT_VERSION"
