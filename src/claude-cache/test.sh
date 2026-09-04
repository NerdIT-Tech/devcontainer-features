#!/usr/bin/env bash
set -e

# Feature test: verify the ~/.claude symlink points into the mounted volume
# (created by onCreate.sh once the volume mount is applied).
source dev-container-features-test-lib

if [ -L "$HOME/.claude" ]; then
    check "~/.claude is a symlink into the claude-cache volume" test "$(readlink "$HOME/.claude")" = "/mnt/claude-cache"
else
    check "~/.claude directory exists" test -d "$HOME/.claude"
fi

reportResults
