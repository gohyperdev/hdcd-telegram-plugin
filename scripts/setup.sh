#!/bin/bash
# Download hdcd-telegram binary from GitHub Releases.
# Binary is cached in CLAUDE_PLUGIN_DATA so it survives plugin updates.

set -euo pipefail

VERSION="v0.1.1"
REPO="gohyperdev/hdcd-telegram"
DATA_DIR="${CLAUDE_PLUGIN_DATA:-$HOME/.claude/plugins/data/hdcd-telegram}"
BINARY="${DATA_DIR}/hdcd-telegram"
VERSION_FILE="${DATA_DIR}/.version"

# Skip if already installed at correct version
if [ -f "$BINARY" ] && [ -x "$BINARY" ] && [ -f "$VERSION_FILE" ] && [ "$(cat "$VERSION_FILE")" = "$VERSION" ]; then
  exit 0
fi

# Detect platform
OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
ARCH="$(uname -m)"

case "$OS" in
  linux)  PLATFORM="linux" ;;
  darwin) PLATFORM="macos" ;;
  *) echo "Unsupported OS: $OS — use setup.ps1 on Windows" >&2; exit 1 ;;
esac

case "$ARCH" in
  x86_64|amd64)  ARCH_LABEL="amd64" ;;
  aarch64|arm64) ARCH_LABEL="arm64" ;;
  *) echo "Unsupported architecture: $ARCH" >&2; exit 1 ;;
esac

ARCHIVE_NAME="hdcd-telegram-${VERSION}-${PLATFORM}-${ARCH_LABEL}.tar.gz"
DOWNLOAD_URL="https://github.com/${REPO}/releases/download/${VERSION}/${ARCHIVE_NAME}"

mkdir -p "$DATA_DIR"
TMPDIR="$(mktemp -d)"
trap 'rm -rf "$TMPDIR"' EXIT

echo "Downloading hdcd-telegram ${VERSION} for ${PLATFORM}-${ARCH_LABEL}..." >&2
curl -fsSL -o "${TMPDIR}/archive.tar.gz" "$DOWNLOAD_URL"

cd "$TMPDIR"
tar xzf archive.tar.gz

FOUND_BINARY="$(find "$TMPDIR" -name 'hdcd-telegram' -type f | head -1)"
if [ -z "$FOUND_BINARY" ]; then
  echo "Error: binary not found in archive" >&2
  exit 1
fi

cp "$FOUND_BINARY" "$BINARY"
chmod +x "$BINARY"
echo "$VERSION" > "$VERSION_FILE"

echo "hdcd-telegram ${VERSION} installed to ${BINARY}" >&2
