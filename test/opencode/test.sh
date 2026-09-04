#!/usr/bin/env bash
set -e

# Feature test: verify the OpenCode CLI is installed and on the PATH.
source dev-container-features-test-lib

check "opencode binary exists" command -v opencode
check "opencode --version works" opencode --version

reportResults
