# nikarh/beets-flask

[beets-flask](https://github.com/metasauce/beets-flask) (web UI for the [beets](https://beets.io) music library manager) with:

- plugin dependencies preinstalled: discogs, fetchart, lyrics, chroma (`fpcalc`), [filetote](https://github.com/gtronset/beets-filetote)
- no root at runtime: runs as uid/gid 1000, works with `read_only: true` and `cap_drop: [ALL]`

Writable paths the container needs:

| path | what |
|---|---|
| `/config` | beets + beets-flask config and databases (volume). `/config/beets` and `/config/beets-flask` must exist and be owned by 1000 |
| `/logs` | logs (tmpfs is fine) |
| `/tmp` | redis, tmux sockets, uploads (tmpfs) |

Unlike the upstream image, `requirements.txt` / `startup.sh` in `/config` are **not** run.

Build args: `BEETS_FLASK_VERSION` (upstream image tag), `BEETS_VERSION` (must match what that beets-flask version pins).
