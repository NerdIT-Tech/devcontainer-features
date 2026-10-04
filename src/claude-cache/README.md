# Persist Claude Code data

Provides persistent data and configuration for [Claude Code](https://claude.ai/code) via a self-declared named-volume mount. Mounts a `claude-cache` volume, then sets up a symlink so Claude Code's `~/.claude` directory points into the volume, surviving container rebuilds.

## Usage

```jsonc
{
  "features": {
    "ghcr.io/nerdit-tech/devcontainer-features/claude-cache:0": {}
  }
}
```

## Options

None.

## How it works

The feature declares a named volume `claude-cache-${devcontainerId}` mounted at `/mnt/claude-cache`. On container creation, `onCreate.sh` runs as the remote user, chowns the mount point, and symlinks `~/.claude` to `/mnt/claude-cache`. Settings, credentials, and memory persist across rebuilds.

## License

[MIT](https://github.com/NerdIT-Tech/devcontainer-features/blob/main/LICENSE)
