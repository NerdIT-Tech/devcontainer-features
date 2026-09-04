# NerdIT-Tech Dev Container Features

Centralized Dev Container features shared across NerdIT-Tech repositories.
Each feature lives in `src/<feature>/` and can be referenced from any
`devcontainer.json` by its OCI reference under `ghcr.io/nerdit-tech`.

## Available features

| Feature | Description |
|---------|-------------|
| [`claude-cache`](src/claude-cache/README.md) | Persist Claude Code's `~/.claude` data/config |
| [`opencode`](src/opencode/README.md) | Install the OpenCode CLI |
| [`opencode-data`](src/opencode-data/README.md) | Persist OpenCode data/config via named volumes |

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
each feature's `README.md`. The `test.yml` workflow validates that every
feature's manifest is well-formed and its install scripts are syntactically
valid.

To add a new feature:

1. Create `src/<feature>/` with a `devcontainer-feature.json` and `install.sh`.
2. Add a `test.sh` for the feature (runs inside the container during `devcontainer`
   feature testing).
3. Open a PR; on merge to `main`, run the `Release dev container features`
   workflow (`workflow_dispatch`) to publish it.

## License

[MIT](LICENSE)
