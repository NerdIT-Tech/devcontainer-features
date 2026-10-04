#!/usr/bin/env bash
set -euo pipefail

# Runs as the remote user once the named volumes declared by this feature are
# mounted. The volumes are mounted at /mnt; we own them and point Go's build
# cache and module-cache directories at them via symlinks so recompiles and
# re-downloads are avoided across container rebuilds.
source "$(dirname "$0")/volume-mount.sh"

build_mount=/mnt/go-build
pkg_mount=/mnt/go-pkg

user_home="${HOME:-$_REMOTE_USER_HOME}"
# Go's build cache lives under $XDG_CACHE_HOME/go-build (default ~/.cache/go-build).
user_build_dir="${XDG_CACHE_HOME:-$user_home/.cache}/go-build"
# Go's module cache lives under $GOPATH/pkg/mod; GOPATH defaults to $HOME/go.
user_gopath="${GOPATH:-$user_home/go}"
pkg_dir="$user_gopath/pkg"

chown_mount "$build_mount" "$pkg_mount"
link_mount "$build_mount" "$user_build_dir"
link_mount "$pkg_mount" "$pkg_dir"
