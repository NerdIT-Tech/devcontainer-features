#!/usr/bin/env bash
set -euo pipefail

source dev-container-features-test-lib

check "opencode binary exists" command -v opencode
check "opencode binary is executable" test -x "$(command -v opencode)"
check "opencode --version works" opencode --version
check "version output is non-empty" sh -c 'opencode --version | grep -q "."'

reportResults
