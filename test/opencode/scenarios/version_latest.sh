#!/usr/bin/env bash
set -e

source dev-container-features-test-lib

check "opencode binary exists" command -v opencode
check "opencode --version works" opencode --version

reportResults
