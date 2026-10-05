#!/usr/bin/env bash
set -euo pipefail

# Place the onCreate script and shared library so they survive into the
# running container. The devcontainer CLI runs install.sh as root during the
# image build; onCreate runs later, as the remote user, once the named volume
# is mounted.
feature_dir=/usr/local/share/claude-cache

mkdir -p "$feature_dir"
cp onCreate.sh "$feature_dir/onCreate.sh"
cp volume-mount.sh "$feature_dir/volume-mount.sh"
chmod +x "$feature_dir/onCreate.sh"
