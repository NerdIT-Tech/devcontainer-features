#!/bin/bash
set -e

# Scenario test: verify Go's build-cache and module-cache dirs are symlinked
# into the mounted volumes. This scenario supplies the named volumes so the
# symlink paths can be asserted.
source dev-container-features-test-lib

home="${HOME:-$(getent passwd "$(id -u)" | cut -d: -f6)}"
build_dir="${XDG_CACHE_HOME:-$home/.cache}/go-build"
gopath="${GOPATH:-$home/go}"
pkg_dir="$gopath/pkg"

if [ -L "$build_dir" ]; then
    check "build cache symlinks to go-build volume" test "$(readlink "$build_dir")" = "/mnt/go-build"
else
    check "build cache dir exists" test -d "$build_dir"
fi

if [ -L "$pkg_dir" ]; then
    check "module cache symlinks to go-pkg volume" test "$(readlink "$pkg_dir")" = "/mnt/go-pkg"
else
    check "module cache dir exists" test -d "$pkg_dir"
fi

reportResults
