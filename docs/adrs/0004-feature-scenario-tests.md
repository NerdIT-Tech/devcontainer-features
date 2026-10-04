---
id: R-TEST-001
applies_to: ["test/**", ".github/workflows/test-features.yml"]
status: accepted
---

# Feature scenarios under test/

MUST: Every feature has a scenario directory `test/<feature>/` with either `test.sh` or `scenarios.json` plus its scripts.
MUST: New scenarios are wired into `.github/workflows/test-features.yml`.

## Why

Features run inside containers; only devcontainer-CLI scenario tests exercise the real mount/onCreate flow.

## Verify

    for d in src/*/; do f=$(basename $d); ls test/$f >/dev/null 2>&1 || echo "FAIL: no test dir for $f"; done
