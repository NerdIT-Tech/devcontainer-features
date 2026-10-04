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
  HOME="$install_dir" curl -fsSL https://opencode.ai/install | bash -s -- --no-modify-path
else
  # If only a major version (e.g., "2", "1", "v2") is provided, resolve to the
  # latest patch of that major from the anomalyco/opencode releases API.
  VERSION_INPUT="${VERSION#v}"
  if [[ "$VERSION_INPUT" =~ ^[0-9]+$ ]]; then
    MAJOR="$VERSION_INPUT"
    # Fetch releases and find latest for this major
    RESOLVED_VERSION=$(curl -fsSL "https://api.github.com/repos/anomalyco/opencode/releases" 2>/dev/null \
      | grep -o '"tag_name": *"v[^"]*"' \
      | sed 's/.*"v//' \
      | sed 's/"//' \
      | grep -E "^${MAJOR}\." \
      | head -n 1)
    if [ -z "$RESOLVED_VERSION" ]; then
      echo "Unable to find latest release for major version v${MAJOR}" >&2
      exit 1
    fi
  else
    RESOLVED_VERSION="${VERSION_INPUT}"
  fi
  HOME="$install_dir" curl -fsSL https://opencode.ai/install | bash -s -- --no-modify-path --version "$RESOLVED_VERSION"
fi

if [ -f "$install_dir/.opencode/bin/opencode" ]; then
  install -m 0755 "$install_dir/.opencode/bin/opencode" /usr/local/bin/opencode
else
  find "$install_dir" -name "opencode" -not -path "*cache*" 2>/dev/null | head -n 1 | xargs -I{} install -m 0755 {} /usr/local/bin/opencode
fi

rm -rf "$install_dir"

opencode --version
