#!/usr/bin/env bash
set -euo pipefail

# Runs as the remote user once the named volume declared by this feature is
# mounted. The volume is mounted at /mnt; we own it and point Claude Code's
# expected ~/.claude location at it via a symlink so settings, credentials,
# and memory persist across container rebuilds.
claude_mount=/mnt/claude-cache

user_home="${HOME:-$_REMOTE_USER_HOME}"
user_dir="$user_home/.claude"

sudo() {
    if [ "$(id -u)" -eq 0 ]; then
        "$@"
    else
        command sudo "$@"
    fi
}

sudo chown "$(id -u)":"$(id -g)" "$claude_mount"

if [ -e "$user_dir" ] && [ ! -L "$user_dir" ]; then
    mv "$user_dir" "$user_dir-old"
fi
mkdir -p "$(dirname "$user_dir")"
ln -sfn "$claude_mount" "$user_dir"
