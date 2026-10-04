#!/usr/bin/env bash
set -euo pipefail

# Runs as the remote user once the named volume declared by this feature is
# mounted. The volume is mounted at /mnt; we own it and point Claude Code's
# expected ~/.claude location at it via a symlink so settings, credentials,
# and memory persist across container rebuilds.
source "$(dirname "$0")/volume-mount.sh"

claude_mount=/mnt/claude-cache

user_home="${HOME:-$_REMOTE_USER_HOME}"
user_dir="$user_home/.claude"

chown_mount "$claude_mount"
link_mount "$claude_mount" "$user_dir"
