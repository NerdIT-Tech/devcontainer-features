---
id: R-FEAT-002
applies_to: ["src/*/install.sh", "src/*/onCreate.sh"]
status: accepted
---

# Build-time vs onCreate split

MUST: `install.sh` runs as root at image build and only places files (e.g. copies `onCreate.sh` to `/usr/local/share/<feature>/`).
MUST: Remote-user setup (symlinks into volumes, XDG wiring) runs in `onCreate.sh`, referenced from `devcontainer-feature.json` via `onCreateCommand`.
MUST NOT: Touch the remote user's home directory or mounted volumes from `install.sh`.

## Why

`install.sh` runs before volumes are mounted and as root; user-scoped setup there silently fails or lands in the wrong home.

## Verify

    rg "/home/|/mnt/" src/*/install.sh && echo "FAIL" || echo "OK"
