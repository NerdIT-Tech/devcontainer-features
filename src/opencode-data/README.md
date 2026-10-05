# Persist OpenCode data

Provides persistent data and configuration for [OpenCode](https://opencode.ai) via self-declared named-volume mounts. Mounts `opencode-data` and `opencode-config` volumes, then sets up symlinks so OpenCode's XDG data (`~/.local/share/opencode`) and config (`~/.config/opencode`) directories point into the volumes, surviving container rebuilds.

## Usage

```jsonc
{
  "features": {
    "ghcr.io/nerdit-tech/devcontainer-features/opencode-data:0": {}
  }
}
```

## Options

None.

## How it works

The feature declares two named volumes:
- `opencode-data-${devcontainerId}` mounted at `/mnt/opencode-data`
- `opencode-config-${devcontainerId}` mounted at `/mnt/opencode-config`

On container creation, `onCreate.sh` runs as the remote user, chowns the mount points, and symlinks:
- `~/.local/share/opencode` (or `$XDG_DATA_HOME/opencode`) to `/mnt/opencode-data`
- `~/.config/opencode` (or `$XDG_CONFIG_HOME/opencode`) to `/mnt/opencode-config`

## License

[MIT](https://github.com/NerdIT-Tech/devcontainer-features/blob/main/LICENSE)
