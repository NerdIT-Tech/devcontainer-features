---
id: R-FEAT-001
applies_to: ["src/**"]
status: accepted
---

# One feature per directory

MUST: Each feature is a directory `src/<id>/` containing `devcontainer-feature.json`, `install.sh`, `version.txt`, and `CHANGELOG.md`.
MUST NOT: Add files shared between features at the `src/` root; duplicate per-feature instead.

## Why

The devcontainer feature CLI and release-please config resolve each feature by its directory, and versioning is per-feature.

## Verify

    for d in src/*/; do test -f "$d/devcontainer-feature.json" && test -f "$d/install.sh" || echo "FAIL: $d"; done
