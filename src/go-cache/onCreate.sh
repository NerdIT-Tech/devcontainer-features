#!/usr/bin/env bash
set -euo pipefail

# Runs as the remote user once the named volumes declared by this feature are
# mounted. The volumes are mounted at /mnt; we own them and point Go's build
# cache and module-cache directories at them via symlinks so recompiles and
# re-downloads are avoided across container rebuilds.
build_mount=/mnt/go-build
pkg_mount=/mnt/go-pkg

user_home="${HOME:-$_REMOTE_USER_HOME}"
# Go's build cache lives under $XDG_CACHE_HOME/go-build (default ~/.cache/go-build).
user_build_dir="${XDG_CACHE_HOME:-$user_home/.cache}/go-build"
# Go's module cache lives under $GOPATH/pkg/mod; GOPATH defaults to $HOME/go.
user_gopath="${GOPATH:-$user_home/go}"
pkg_dir="$user_gopath/pkg"

sudo() {
    if [ "$(id -u)" -eq 0 ]; then
        "$@"
    else
        command sudo "$@"
    fi
}

# The mount points belong to the container user; make sure they are writable.
sudo chown "$(id -u)":"$(id -g)" "$build_mount" "$pkg_mount"

# Redirect Go's build-cache directory into the mounted volume. Move any
# pre-existing data out of the way first so the symlink lands cleanly.
if [ -e "$user_build_dir" ] && [ ! -L "$user_build_dir" ]; then
    mv "$user_build_dir" "$user_build_dir-old"
fi
mkdir -p "$(dirname "$user_build_dir")"
ln -sfn "$build_mount" "$user_build_dir"

# Redirect Go's module-cache (pkg) directory into the mounted volume.
if [ -e "$pkg_dir" ] && [ ! -L "$pkg_dir" ]; then
    mv "$pkg_dir" "$pkg_dir-old"
fi
mkdir -p "$(dirname "$pkg_dir")"
ln -sfn "$pkg_mount" "$pkg_dir"
