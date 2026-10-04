#!/usr/bin/env bash
# Shared helpers for volume-mount features. Sourced by onCreate.sh after
# install.sh copies it to /usr/local/share/<feature>/.

sudo() {
    if [ "$(id -u)" -eq 0 ]; then
        "$@"
    else
        command sudo "$@"
    fi
}

# chown_mount <mount-point>...
chown_mount() {
    sudo chown "$(id -u)":"$(id -g)" "$@"
}

# link_mount <mount-point> <user-dir>
# Moves any pre-existing user-dir out of the way, then symlinks it into the
# named volume mounted at mount-point.
link_mount() {
    local mount_point="$1"
    local user_dir="$2"

    if [ -e "$user_dir" ] && [ ! -L "$user_dir" ]; then
        mv "$user_dir" "$user_dir-old"
    fi
    mkdir -p "$(dirname "$user_dir")"
    ln -sfn "$mount_point" "$user_dir"
}
