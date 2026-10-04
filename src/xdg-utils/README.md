# XDG Utils with host browser pipe

Installs xdg-utils and wraps `xdg-open` to forward URLs to the host browser through a unix pipe. When the pipe is absent, `xdg-open` falls back to the real `/usr/bin/xdg-open`.

## Usage

```jsonc
{
  "features": {
    "ghcr.io/nerdit-tech/devcontainer-features/xdg-utils:0": {
      "hostBrowserPipePath": "/tmp/hostbrowserpipe",
      "containerBrowserPipePath": "/tmp/hostbrowserpipe"
    }
  },
  "mounts": [
    "source=/tmp/hostbrowserpipe,target=/tmp/hostbrowserpipe,type=bind"
  ]
}
```

## Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `hostBrowserPipePath` | string | `/tmp/hostbrowserpipe` | Path of the host browser pipe. Bind this path into the container via a `mounts` entry in `devcontainer.json`. |
| `containerBrowserPipePath` | string | `/tmp/hostbrowserpipe` | Path inside the container where the host browser pipe is mounted. The `xdg-open` wrapper sends URLs to this path. |

## How it works

The host browser pipe is a host bind mount that this feature does not declare (paths are machine-specific). The consuming `devcontainer.json` must bind the host pipe to the container pipe path. The wrapper at `/usr/local/bin/xdg-open` checks for the pipe and falls back to the real `xdg-open` when it is absent.

## License

[MIT](https://github.com/NerdIT-Tech/devcontainer-features/blob/main/LICENSE)
