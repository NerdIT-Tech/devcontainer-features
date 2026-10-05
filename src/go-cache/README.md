# Persist Go build & module caches

Persists the Go build cache and module cache across container rebuilds via self-declared named-volume mounts. Mounts `go-build` and `go-pkg` volumes, then symlinks Go's XDG build-cache dir (`~/.cache/go-build`) and module-cache dir (`$GOPATH/pkg`) into them so recompiles and re-downloads are avoided across rebuilds.

## Usage

```jsonc
{
  "features": {
    "ghcr.io/nerdit-tech/devcontainer-features/go-cache:0": {}
  }
}
```

## Options

None.

## How it works

The feature declares two named volumes:
- `go-build-${devcontainerId}` mounted at `/mnt/go-build`
- `go-pkg-${devcontainerId}` mounted at `/mnt/go-pkg`

On container creation, `onCreate.sh` runs as the remote user, chowns the mount points, and symlinks:
- `~/.cache/go-build` (or `$XDG_CACHE_HOME/go-build`) to `/mnt/go-build`
- `$GOPATH/pkg` (or `~/go/pkg`) to `/mnt/go-pkg`

## License

[MIT](https://github.com/NerdIT-Tech/devcontainer-features/blob/main/LICENSE)
