#!/usr/bin/env bash
set -euo pipefail

# Negative test: the feature should have failed to install with an invalid
# version. If this script runs, the feature incorrectly accepted the invalid
# version.
source dev-container-features-test-lib

check "feature correctly rejected invalid version" test ! -f /usr/local/bin/opencode

reportResults
