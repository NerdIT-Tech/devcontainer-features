#!/usr/bin/env bash
set -euo pipefail

if ! command -v curl >/dev/null 2>&1; then
  echo "curl is required to install OpenCode" >&2
  exit 1
fi

install_dir="$(mktemp -d)"

VERSION="${VERSION:-latest}"

if [ "$VERSION" = "latest" ] || [ -z "$VERSION" ]; then
  TAG=$(curl -fsSL "https://api.github.com/repos/anomalyco/opencode/releases/latest" | grep '"tag_name":' | sed 's/.*"tag_name": *"v//;s/".*//')
else
  VERSION_INPUT="${VERSION#v}"
  if [[ "$VERSION_INPUT" =~ ^[0-9]+$ ]]; then
    MAJOR="$VERSION_INPUT"
    TAG=$(curl -fsSL "https://api.github.com/repos/anomalyco/opencode/releases" \
      | grep '"tag_name":' \
      | sed 's/.*"tag_name": *"v//;s/".*//' \
      | grep -E "^${MAJOR}\." \
      | head -n 1)
    if [ -z "$TAG" ]; then
      echo "Unable to find latest release for major version v${MAJOR}" >&2
      exit 1
    fi
  else
    TAG="${VERSION_INPUT}"
  fi
fi

OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)
[ "$ARCH" = "x86_64" ] && ARCH="x64"
[ "$ARCH" = "aarch64" ] && ARCH="arm64"
EXT=".tar.gz"
[ "$OS" = "darwin" ] && EXT=".zip"
[ "$OS" = "windows" ] && EXT=".zip"

URL="https://github.com/anomalyco/opencode/releases/download/v${TAG}/${OS}-${ARCH}${EXT}"
TMPDL=$(mktemp)
curl -fsSL "$URL" -o "$TMPDL"

mkdir -p "$install_dir/bin"
if [ "$EXT" = ".tar.gz" ]; then
  tar -xzf "$TMPDL" -C "$install_dir/bin"
else
  unzip -o "$TMPDL" -d "$install_dir/bin"
fi
rm -f "$TMPDL"

install -m 0755 "$install_dir/bin/opencode" /usr/local/bin/opencode 2>/dev/null || \
  find "$install_dir/bin" -name "opencode" -not -path "*cache*" | xargs -I{} install -m 0755 {} /usr/local/bin/opencode

rm -rf "$install_dir"
opencode --version
