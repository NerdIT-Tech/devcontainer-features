---
name: author-feature
description: >
  Author a new dev container Feature in this repo (or introspect/extend an
  existing one). Use when the user asks to add, create, or write a Feature /
  "dev container feature" / "devcontainer feature", when they mention
  devcontainer-feature.json, install.sh, a new folder under src/, bumping a
  feature's version, or publishing features to GHCR. Covers the required
  files (devcontainer-feature.json + install.sh), the options->env mechanism,
  local-command (onCreate.sh) hooks, the per-feature release-please/GHCR
  release flow and CI validation this repo enforces. This repo hosts
  centralized NerdIT-Tech features (claude-cache, opencode, opencode-data)
  and follows the conventions below -- match them rather than inventing
  alternatives.
---

# Authoring a Dev Container Feature

A Feature is a self-contained, shareable unit of installation code and dev
container configuration. The full upstream walkthrough is
<https://containers.dev/guide/author-a-feature>; the Feature spec is at
<https://devcontainers.github.io/implementors/features/>. This skill covers
the essentials plus the conventions specific to THIS repo.

## Where features live

Each Feature is a folder under `src/`, e.g. `src/<feature>/`. The folder name
IS the Feature `id` (must match exactly, lowercase). To add a Feature, create
`src/<feature>/`; to work on one, edit inside its folder. This repo keeps all
its Features centralized under `src/` and publishes them all to GHCR.

## Required files

A Feature needs at minimum:

- `devcontainer-feature.json` — metadata (id/version/name are required).
- `install.sh` — the entrypoint script run inside the container.

Optional but used in this repo: `onCreate.sh` (a lifecycle hook --
`onCreateCommand`), `test.sh` (CI smoke test), and `version.txt` (the
release-please version source; see Release flow).

## devcontainer-feature.json

Example matching this repo's style:

```json
{
  "id": "my-feature",
  "version": "1.0.0",
  "name": "My Feature",
  "description": "Installs and configures my-feature",
  "options": {
    "greeting": {
      "type": "string",
      "proposals": ["hey", "hello", "hi"],
      "default": "hey",
      "description": "A user-configurable option"
    },
    "verbose": {
      "type": "boolean",
      "default": false,
      "description": "Enable verbose logging"
    }
  }
}
```

Required properties: `id`, `version`, `name`. `id` must equal the folder
name. Available types for `options.*.type`: `string`, `boolean`, `enum`
(with `enum` values), `number`, `int`. Options can have `default`,
`proposals`, `description`, and (for string) `enum`.

## install.sh: options become environment variables

The dev container runs `install.sh` (not `install.sh`, the name is fixed) in
the target container, and each option is exported as an environment variable
named by UPPERCASING the option key. Read them with a default fallback:

```sh
#!/bin/sh
set -e

echo "Activating feature 'my-feature'"

GREETING=${GREETING:-undefined}
VERBOSE=${VERBOSE:-false}

if [ "$VERBOSE" = "true" ]; then
  echo "greeting: $GREETING"
fi

cat > /usr/local/bin/my-feature <<'EOF'
#!/bin/sh
echo "hello, world"
EOF
chmod +x /usr/local/bin/my-feature
```

Rules:
- `set -e` and quote shell variables (unquoted `$VAR` is an error in CI lint).
- Guard against re-running (this repo's `install.sh` scripts check for an
  EXISTING marker / the binary's presence and skip if already installed).
- The same env-var contract applies to `onCreate.sh`.

## Multiple options in devcontainer.json

To consume several options at once in a devcontainer.json use the `options`
object with `customizations`/`options` per the spec; each option key maps to
its own env var. Array-style `installsAfter`/`dependsOn` let a Feature declare
ordering/sibling dependencies.

## Versioning is per-feature (release-please)

This repo releases each Feature independently with release-please
(`release-type: simple`). For every Feature the current version lives in
**three places that must stay in sync**:

- `src/<feature>/devcontainer-feature.json` → `version` field
- `src/<feature>/version.txt` → the release-please version source
- `.release-please-manifest.json` → the `"src/<feature>"` entry

releases are tagged `src/<feature>`-scoped and published via
`.github/workflows/release-please.yml` + `.github/workflows/release.yml`
(devcontainers/action publish to GHCR + upload of `.tgz` archives). When you
bump a version by hand, update all three; otherwise let release-please open
the version-bump PR and do it for you.

## CI that will run on your change

- `.github/workflows/test.yml` — validates every
  `src/*/devcontainer-feature.json` against the spec schema
  (`devcontainers/action validate-only`) and checks `install.sh` exists and
  `bash -n` clean, and any `onCreate.sh` is syntactically valid.
- `.github/workflows/test-features.yml` — builds each Feature in a container
  and runs its `test.sh` via `@devcontainers/cli features test`, plus scenario
  tests for Features that need volume mounts / lifecycle hooks (`test/`).
- `.github/workflows/actionlint.yml`, `yaml-lint.yml`, `zizmor.yml`,
  `conventional-commits.yml` — lint the workflows and the PR title (must be
  conventional commits like `feat(feature): #N add my-feature`).

Keep `install.sh`/`onCreate.sh` POSIX-`sh` where possible and always
`bash -n`-clean; broken JSON or shell fails the test job.

## Publishing / the metadata package

Publishing is handled by `.github/workflows/release.yml` →
`devcontainers/action` (`base-path-to-features: ./src`,
`publish-features: true`). It pushes each Feature to
`ghcr.io/nerdit-tech/devcontainer-features/<feature>` and a metadata package
at the collection root (the namespace only), which index crawlers need.
Reference a published Feature as `ghcr.io/nerdit-tech/devcontainer-features/<feature>:<major>`,
using the floating major tag (currently `:0` while features are at `0.x`). You
do not normally do this by hand — the release flow does it.

## Checklist for a new feature

1. Create `src/<feature>/`.
2. Write `devcontainer-feature.json` (id == folder name, valid `version`).
3. Write `install.sh` (and `onCreate.sh` if there's a local-command hook).
4. Add `version.txt` matching the json version; add the
   `.release-please-manifest.json` entry.
5. Add a `test.sh` smoke test; keep everything `bash -n`-clean and JSON-valid.
6. Open a PR with a conventional title (scope `feature`, `#N` subject).
