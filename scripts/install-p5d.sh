#!/usr/bin/env bash
set -euo pipefail

PLUGIN_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BIN_NAME="p5d"
INSTALL_DIR="${HOME}/.local/bin"

log() { printf '[p5.nvim] %s\n' "$*" >&2; }

have() { command -v "$1" >/dev/null 2>&1; }

detect_platform() {
  local os arch musl uname_s
  uname_s="$(uname -s 2>/dev/null || echo unknown)"
  case "$uname_s" in
    Linux*)   os="Linux" ;;
    Darwin*)  os="Darwin" ;;
    MINGW*|MSYS*|CYGWIN*) os="Windows" ;;
    *)        os="$uname_s" ;;
  esac
  arch="$(uname -m 2>/dev/null || echo unknown)"
  case "$arch" in
    amd64|x86_64) arch="x86_64" ;;
    arm64|aarch64) arch="aarch64" ;;
  esac
  musl=""
  if [ "$os" = "Linux" ]; then
    if have ldd && ldd --version 2>&1 | grep -qi musl; then
      musl="1"
    elif ls /lib/ld-musl-* >/dev/null 2>&1; then
      musl="1"
    fi
  fi

  case "$os:$arch:$musl" in
    Linux:x86_64:1)  echo "x86_64-linux-musl" ;;
    Linux:x86_64:)   echo "x86_64-linux" ;;
    Linux:aarch64:1) echo "aarch64-linux-musl" ;;
    Linux:aarch64:)  echo "aarch64-linux" ;;
    Darwin:aarch64:) echo "aarch64-darwin" ;;
    Windows:x86_64:) echo "x86_64-windows" ;;
    *)               echo "" ;;
  esac
}

EXE_SUFFIX=""
case "$(uname -s 2>/dev/null || echo unknown)" in
  MINGW*|MSYS*|CYGWIN*) EXE_SUFFIX=".exe" ;;
esac
DEST_LOCAL="$PLUGIN_ROOT/${BIN_NAME}${EXE_SUFFIX}"
DEST_PATH="$INSTALL_DIR/${BIN_NAME}${EXE_SUFFIX}"

install_copy() {
  local src="$1"
  chmod +x "$src" 2>/dev/null || true
  mkdir -p "$INSTALL_DIR"
  rm -f "$DEST_PATH" "$DEST_LOCAL"
  cp "$src" "$DEST_PATH"
  cp "$src" "$DEST_LOCAL"
  chmod +x "$DEST_PATH" "$DEST_LOCAL" 2>/dev/null || true
  log "Installed ${BIN_NAME}${EXE_SUFFIX} to $DEST_PATH and $DEST_LOCAL"
}

download_prebuilt() {
  local platform="$1"
  [ -n "$platform" ] || return 1

  local ext="tar.gz"
  if [[ "$platform" == *windows* ]]; then
    ext="zip"
  fi
  local archive="${BIN_NAME}-${platform}.${ext}"
  local url="https://github.com/prjctimg/p5.nvim/releases/latest/download/${archive}"
  local tmp
  tmp="$(mktemp -d 2>/dev/null || mktemp -d -t p5d)"

  cleanup() { rm -rf "$tmp"; }
  trap cleanup RETURN

  log "Trying prebuilt binary: $platform"
  if have curl; then
    curl -fsSL "$url" -o "$tmp/$archive" || return 1
  elif have wget; then
    wget -qO "$tmp/$archive" "$url" || return 1
  else
    return 1
  fi

  if [[ "$ext" == "zip" ]]; then
    if have unzip; then
      unzip -q "$tmp/$archive" -d "$tmp" || return 1
    elif have 7z; then
      7z x "$tmp/$archive" -o"$tmp" >/dev/null || return 1
    else
      return 1
    fi
  else
    have tar || return 1
    tar -xzf "$tmp/$archive" -C "$tmp" || return 1
  fi

  local binfile="${BIN_NAME}${EXE_SUFFIX}"
  local extracted="$tmp/${BIN_NAME}-${platform}/${binfile}"
  if [ ! -f "$extracted" ]; then
    # fallback: search for binary in extracted contents
    extracted="$(find "$tmp" -type f \( -name "$BIN_NAME" -o -name "${BIN_NAME}.exe" \) | head -n 1 || true)"
  fi
  [ -n "$extracted" ] && [ -f "$extracted" ] || return 1

  install_copy "$extracted"
  return 0
}

build_local() {
  log "Building $BIN_NAME locally (cargo build --release)..."
  if ! have cargo; then
    log "cargo not found and no prebuilt binary available for this platform."
    exit 1
  fi
  (cd "$PLUGIN_ROOT/srv" && cargo build --release)
  local binfile="${BIN_NAME}${EXE_SUFFIX}"
  if [ ! -f "$PLUGIN_ROOT/srv/target/release/$binfile" ]; then
    log "Build finished but binary not found at srv/target/release/$binfile"
    exit 1
  fi
  install_copy "$PLUGIN_ROOT/srv/target/release/$binfile"
}

main() {
  local platform
  platform="$(detect_platform)"

  if [ -n "$platform" ] && download_prebuilt "$platform"; then
    exit 0
  fi

  if [ -z "$platform" ]; then
    log "No prebuilt binary mapping for $(uname -s)/$(uname -m); falling back to local build."
  else
    log "Prebuilt binary unavailable for $platform; falling back to local build."
  fi
  build_local
}

main "$@"
