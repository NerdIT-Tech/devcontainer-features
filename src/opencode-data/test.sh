#!/usr/bin/env bash
set -e

# Feature test: verify OpenCode's XDG data/config dirs are symlinked into the
# mounted volumes (created by onCreate.sh once the volume mounts are applied).
source dev-container-features-test-lib

data_dir="${XDG_DATA_HOME:-$HOME/.local/share}/opencode"
config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/opencode"

if [ -L "$data_dir" ]; then
    check "data dir symlinks to opencode-data volume" test "$(readlink "$data_dir")" = "/mnt/opencode-data"
else
    check "data dir exists" test -d "$data_dir"
fi

if [ -L "$config_dir" ]; then
    check "config dir symlinks to opencode-config volume" test "$(readlink "$config_dir")" = "/mnt/opencode-config"
else
    check "config dir exists" test -d "$config_dir"
fi

reportResults
