# OpenCode CLI

Installs the [OpenCode](https://opencode.ai) CLI onto the system PATH so it is available to the remote user.

## Usage

```jsonc
{
  "features": {
    "ghcr.io/nerdit-tech/devcontainer-features/opencode:0": {
      "version": "latest"
    }
  }
}
```

## Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `version` | string | `latest` | OpenCode release version to install. Can be `latest`, a major version like `2` or `1`, or a specific version like `1.18.34` or `0.0.55`. |

## How it works

Uses the official installer (`https://opencode.ai/install`). The binary is installed to `/usr/local/bin` so it works for any shell in the container without modifying rc files.

## License

[MIT](https://github.com/NerdIT-Tech/devcontainer-features/blob/main/LICENSE)
