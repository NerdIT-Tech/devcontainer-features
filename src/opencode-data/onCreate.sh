#!/usr/bin/env bash
set -euo pipefail

# Runs as the remote user once the named volumes declared by this feature are
# mounted. The volumes are mounted at /mnt; we own them and point OpenCode's
# expected XDG locations at them via symlinks so sessions/state/config persist
# across container rebuilds.
source "$(dirname "$0")/volume-mount.sh"

data_mount=/mnt/opencode-data
config_mount=/mnt/opencode-config

user_home="${HOME:-$_REMOTE_USER_HOME}"
user_data_dir="${XDG_DATA_HOME:-$user_home/.local/share}/opencode"
user_config_dir="${XDG_CONFIG_HOME:-$user_home/.config}/opencode"

chown_mount "$data_mount" "$config_mount"
link_mount "$data_mount" "$user_data_dir"
link_mount "$config_mount" "$user_config_dir"
