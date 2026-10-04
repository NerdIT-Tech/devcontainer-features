#!/usr/bin/env bash
set -e

source dev-container-features-test-lib

check "opencode binary exists" command -v opencode
check "opencode --version works" opencode --version
check "version is 1.18.34" sh -c 'opencode --version | grep -q "1.18.34"'

reportResults
