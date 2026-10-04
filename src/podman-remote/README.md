# Podman Remote Client

Installs the Podman CLI and sets `CONTAINER_HOST` to `unix:///tmp/podman.sock` so podman commands talk to the host's Podman socket (Docker-outside-of-Docker).

## Usage

```jsonc
{
  "features": {
    "ghcr.io/nerdit-tech/devcontainer-features/podman-remote:0": {
      "hostSocketPath": "/var/run/user/1000/podman/podman.sock"
    }
  },
  "mounts": [
    "source=/var/run/user/1000/podman/podman.sock,target=/tmp/podman.sock,type=bind"
  ]
}
```

## Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `hostSocketPath` | string | `/var/run/user/1000/podman/podman.sock` | Path of the host Podman socket. Bind this path into the container (to `/tmp/podman.sock`) via a `mounts` entry in `devcontainer.json`. |

## How it works

The host socket is a host bind mount that this feature does not declare (the path is machine-specific). The consuming `devcontainer.json` must bind the host socket to `/tmp/podman.sock`, which `CONTAINER_HOST` points at.

## License

[MIT](https://github.com/NerdIT-Tech/devcontainer-features/blob/main/LICENSE)
