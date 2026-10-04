#!/usr/bin/env bash
set -euo pipefail

if ! command -v curl >/dev/null 2>&1; then
  echo "curl is required to install OpenCode" >&2
  exit 1
fi

# Install the CLI onto the system PATH (/usr/local/bin) so it is available
# to every shell in the container without editing any user's rc files. The
# official installer hard-codes its install dir to $HOME/.opencode/bin, so we
# point HOME at a scratch dir and --no-modify-path to avoid touching rc files,
# then move the freshly-downloaded binary onto the PATH.
install_dir="$(mktemp -d)"

# Capture the requested version to pass through to the installer.
VERSION="${VERSION:-latest}"

if [ "$VERSION" = "latest" ] || [ -z "$VERSION" ]; then
  HOME="$install_dir" curl -fsSL https://opencode.ai/install | bash -s -- --no-modify-path >/dev/null 2>&1 || true
else
  # If only a major version (e.g., "2", "1", "v2") is provided, resolve to the
  # latest patch of that major from the anomalyco/opencode releases.
  VERSION_INPUT="${VERSION#v}"
  if [[ "$VERSION_INPUT" =~ ^[0-9]+$ ]]; then
    MAJOR="$VERSION_INPUT"
    LATEST_PATCH=$(curl -fsSL "https://api.github.com/repos/anomalyco/opencode/releases" \
      | grep '"tag_name":' \
      | sed 's/.*"tag_name": *"v//;s/".*//' \
      | grep -E "^${MAJOR}\." \
      | head -n 1)
    if [ -z "$LATEST_PATCH" ]; then
      echo "Unable to find latest release for major version v${MAJOR}" >&2
      exit 1
    fi
    RESOLVED_VERSION="$LATEST_PATCH"
  else
    RESOLVED_VERSION="${VERSION_INPUT#v}"
  fi
  HOME="$install_dir" curl -fsSL https://opencode.ai/install | bash -s -- --no-modify-path --version "$RESOLVED_VERSION" >/dev/null 2>&1 || true
fi

# Ensure binary is in expected location
if [ ! -f "$install_dir/.opencode/bin/opencode" ]; then
  # Try to find it elsewhere
  find "$install_dir" -name "opencode" -type f 2>/dev/null | head -n 1 | xargs -I{} cp {} "$install_dir/.opencode/bin/opencode" 2>/dev/null || true
fi

mkdir -p "$install_dir/.opencode/bin" 2>/dev/null || true
if [ ! -f "$install_dir/.opencode/bin/opencode" ]; then
  # Fallback: download directly if installer had issues
  if [ "$VERSION" = "latest" ] || [ -z "$VERSION" ]; then
    API_URL="https://api.github.com/repos/anomalyco/opencode/releases/latest"
  else
    VERSION_INPUT="${VERSION#v}"
    if [[ "$VERSION_INPUT" =~ ^[0-9]+$ ]]; then
      MAJOR="$VERSION_INPUT"
      LATEST_PATCH=$(curl -fsSL "https://api.github.com/repos/anomalyco/opencode/releases" \
        | grep '"tag_name":' \
        | sed 's/.*"tag_name": *"v//;s/".*//' \
        | grep -E "^${MAJOR}\." \
        | head -n 1)
      [ -n "$LATEST_PATCH" ] && VERSION_TO_USE="$LATEST_PATCH" || VERSION_TO_USE="$VERSION_INPUT"
    else
      VERSION_TO_USE="${VERSION_INPUT#v}"
    fi
    API_URL="https://api.github.com/repos/anomalyco/opencode/releases/tags/v${VERSION_TO_USE}"
  fi
  TAG=$(curl -fsSL "$API_URL" | grep '"tag_name":' | sed 's/.*"tag_name": *"v//;s/".*//' | head -n 1)
  OS=$(uname -s | tr '[:upper:]' '[:lower:]')
  ARCH=$(uname -m)
  [ "$ARCH" = "x86_64" ] && ARCH="x64"
  [ "$ARCH" = "aarch64" ] && ARCH="arm64"
  EXT=".tar.gz"
  [ "$OS" = "darwin" ] && EXT=".zip"
  [ "$OS" = "windows" ] && EXT=".zip"
  URL="https://github.com/anomalyco/opencode/releases/download/v${TAG}/${OS}-${ARCH}${EXT}"
  TMPDL=$(mktemp)
  curl -fsSL "$URL" -o "$TMPDL" 2>&1 || true
  mkdir -p "$install_dir/.opencode/bin"
  if [ "$EXT" = ".tar.gz" ]; then
    tar -xzf "$TMPDL" -C "$install_dir/.opencode/bin" 2>&1 || true
  else
    unzip -o "$TMPDL" -d "$install_dir/.opencode/bin" 2>&1 || true
  fi
  rm -f "$TMPDL"
fi

install -m 0755 "$install_dir/.opencode/bin/opencode" /usr/local/bin/opencode 2>&1 || cp "$install_dir/.opencode/bin/opencode" /usr/local/bin/opencode 2>&1 || true
chmod +x /usr/local/bin/opencode 2>&1 || true

rm -rf "$install_dir"

opencode --version
