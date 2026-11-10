# nikarh/beets

[beets](https://beets.io) music library manager with:

- plugin dependencies preinstalled: musicbrainz, discogs, fetchart, lyrics, chroma (`fpcalc`), convert (`ffmpeg`), [filetote](https://github.com/gtronset/beets-filetote)
- no root at runtime: runs as uid/gid 1000, works with `read_only: true` and `cap_drop: [ALL]`
- `tini` as init, so background jobs started by plugins are reaped

`BEETSDIR` is `/config/beets` (config, library database, state). Writable paths the container needs:

| path | what |
|---|---|
| `/config/beets` | config and library database (volume), owned by 1000 |
| `/tmp` | home directory, caches (tmpfs) |

## Secrets from files

beets merges the YAML files listed under `include` into its config (only in
`$BEETSDIR/config.yaml`, not in a file given with `-c`). Keep plugin credentials in a secret
and include it: they stay in beets' config, out of the environment, `docker inspect` and
the container list.

```yaml
# config.yaml
include:
  - /run/secrets/beets.yaml
```

```yaml
# the secret mounted at /run/secrets/beets.yaml
discogs:
  user_token: ...
fetchart:
  fanarttv_key: ...
  lastfm_key: ...
acoustid:
  apikey: ...
```

The default command only keeps the container running (`docker exec <container> beet ...`); set
your own, e.g. an inbox watcher.

Build args: `BEETS_VERSION`, `FILETOTE_VERSION`.
