---
id: R-SHELL-001
applies_to: ["src/*/install.sh", "src/*/onCreate.sh", "test/**/*.sh"]
status: accepted
---

# Bash strict mode

MUST: Shell scripts start with `#!/usr/bin/env bash` and `set -euo pipefail`.
MUST NOT: Rely on default bash error semantics (silent failure mid-script).

## Why

Feature install scripts run unattended in image builds; a swallowed error ships a broken feature image.

## Verify

    rg -L "set -euo pipefail" src/*/*.sh test/**/*.sh && echo "FAIL" || echo "OK"
