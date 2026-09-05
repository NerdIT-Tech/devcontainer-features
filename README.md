# NerdIT-Tech Dev Container Features

Centralized Dev Container features shared across NerdIT-Tech repositories.
Each feature lives in `src/<feature>/` and can be referenced from any
`devcontainer.json` by its OCI reference under `ghcr.io/nerdit-tech`.

## Available features

| Feature | Description |
|---------|-------------|
| [`claude-cache`](src/claude-cache/README.md) | Persist Claude Code's `~/.claude` data/config |
| [`go-cache`](src/go-cache/README.md) | Persist Go build & module caches |
| [`opencode`](src/opencode/README.md) | Install the OpenCode CLI |
| [`opencode-data`](src/opencode-data/README.md) | Persist OpenCode data/config via named volumes |
| [`podman-remote`](src/podman-remote/README.md) | Install the Podman remote client pointed at the host socket (bind the host socket yourself via `mounts`) |
| [`xdg-utils`](src/xdg-utils/README.md) | Install xdg-utils with a host-browser-pipe xdg-open wrapper (bind the host pipe yourself via `mounts`) |

## Usage

Reference a feature from a `devcontainer.json` by its published OCI name:

```jsonc
{
  "features": {
    "ghcr.io/nerdit-tech/devcontainer-features/opencode:0": {},
    "ghcr.io/nerdit-tech/devcontainer-features/opencode-data:0": {}
  }
}
```

## Development

Features are published to the GitHub Container Registry (`ghcr.io/nerdit-tech`)
by the `release.yml` workflow (`devcontainers/action`), which also generates
each feature's `README.md`. For validation:
- `test.yml` validates every feature's manifest against the containers.dev
  schema (`devcontainers/action validate-only`) and checks that its install
  scripts are syntactically valid.
- `test-features.yml` actually builds each feature in a container and runs its
  `test.sh` via the `@devcontainers/cli` (plus scenario tests under `test/`
  for features that need volume mounts / lifecycle hooks).

To add a new feature:

1. Create `src/<feature>/` with a `devcontainer-feature.json` and `install.sh`.
2. Add a `test.sh` for the feature (runs inside the container during `devcontainer`
   feature testing).
3. Open a PR; on merge to `main`, run the `Release dev container features`
   workflow (`workflow_dispatch`) to publish it.

## License

[MIT](LICENSE)
