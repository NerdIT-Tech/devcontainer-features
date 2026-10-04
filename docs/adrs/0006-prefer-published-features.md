---
id: R-DEV-001
applies_to: [".devcontainer/devcontainer.json"]
status: accepted
---

# Prefer published devcontainer features over inline install commands

MUST: Wire devcontainer tooling through a published feature in `devcontainer.json` (e.g. `"ghcr.io/atty303/devcontainer-features/mise:1"` for mise) before writing scripts.
MUST NOT: Re-implement tool setup as inline `postCreateCommand` installers (e.g. `curl ... | sh`).
SHOULD: Create our own feature under `src/` only when no published feature exists or its options (activation, trust, post-create hooks) cannot meet the need.

## Why

Inline installers drift from the tool's supported setup path and cannot be versioned per feature. Published features pin a version, document options, and may handle shell activation and post-create steps; re-adding that inline duplicates them.

## Verify

    rg "postCreateCommand.*curl" .devcontainer/devcontainer.json && echo "FAIL" || echo "OK"
