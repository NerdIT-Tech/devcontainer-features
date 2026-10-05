#!/usr/bin/env bash
set -euo pipefail

if ! command -v curl >/dev/null 2>&1; then
  echo "curl is required to install OpenCode" >&2
  exit 1
fi

if ! command -v jq >/dev/null 2>&1; then
  echo "jq is required to install OpenCode" >&2
  exit 1
fi

install_dir="$(mktemp -d)"

VERSION="${VERSION:-latest}"

if [ "$VERSION" = "latest" ] || [ -z "$VERSION" ]; then
  HOME="$install_dir" bash -c "unset VERSION; curl -fsSL https://opencode.ai/install | bash -s -- --no-modify-path"
else
  VERSION_INPUT="${VERSION#v}"
  if [[ "$VERSION_INPUT" =~ ^[0-9]+$ ]]; then
    MAJOR="$VERSION_INPUT"
    RESOLVED_VERSION=$(curl -fsSL "https://api.github.com/repos/anomalyco/opencode/releases" \
      | jq -r --arg major "$MAJOR" '.[] | .tag_name | select(startswith("v" + $major + ".")) | sub("^v"; "")' \
      | head -n 1)
    if [ -z "$RESOLVED_VERSION" ]; then
      echo "Unable to find latest release for major version v${MAJOR}" >&2
      exit 1
    fi
  else
    RESOLVED_VERSION="${VERSION_INPUT}"
  fi
  HOME="$install_dir" bash -c "curl -fsSL https://opencode.ai/install | VERSION='$RESOLVED_VERSION' bash -s -- --no-modify-path"
fi

if [ -f "$install_dir/.opencode/bin/opencode" ]; then
  install -m 0755 "$install_dir/.opencode/bin/opencode" /usr/local/bin/opencode
else
  binary=$(find "$install_dir" -type f -name "opencode" -executable 2>/dev/null | head -n 1)
  if [ -z "$binary" ]; then
    echo "Could not find opencode binary in $install_dir" >&2
    exit 1
  fi
  install -m 0755 "$binary" /usr/local/bin/opencode
fi

rm -rf "$install_dir"
opencode --version
