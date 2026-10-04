#!/usr/bin/env bash
set -euo pipefail

# Scenario test: verify Go's build-cache and module-cache dirs are symlinked
# into the mounted volumes. This scenario supplies the named volumes so the
# symlink paths can be asserted.
source dev-container-features-test-lib

home="${HOME:-$(getent passwd "$(id -u)" | cut -d: -f6)}"
build_dir="${XDG_CACHE_HOME:-$home/.cache}/go-build"
gopath="${GOPATH:-$home/go}"
pkg_dir="$gopath/pkg"

check "build cache dir is a symlink" test -L "$build_dir"
check "build cache symlinks to /mnt/go-build" test "$(readlink "$build_dir")" = "/mnt/go-build"
check "build cache is writable through the symlink" test -w "$build_dir"

check "module cache dir is a symlink" test -L "$pkg_dir"
check "module cache symlinks to /mnt/go-pkg" test "$(readlink "$pkg_dir")" = "/mnt/go-pkg"
check "module cache is writable through the symlink" test -w "$pkg_dir"

reportResults
