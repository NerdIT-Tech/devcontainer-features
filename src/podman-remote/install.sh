#!/usr/bin/env bash
set -euo pipefail

# Install the Podman remote client so it can talk to the host's Podman socket,
# which this feature bind-mounts into the container (see CONTAINER_HOST).
# Guard against re-running: skip if podman is already present.
if command -v podman >/dev/null 2>&1; then
    echo "podman already installed"
    exit 0
fi

echo "Updating package lists..."
apt-get update

echo "Installing Podman client..."
apt-get install -y --no-install-recommends podman
rm -rf /var/lib/apt/lists/*

echo "Podman remote client installed."