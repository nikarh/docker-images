# nikarh/bazarr-plus

[Bazarr+](https://github.com/LavX/bazarr) (a Bazarr fork: subtitles for Sonarr/Radarr) built
from a pinned commit of its `development` branch, for fixes that no published image has yet.
The build follows upstream's Dockerfile. The image is the same as upstream's apart from where
the source comes from (fetched by commit, with the frontend built in a stage of its own), and
it is amd64 only.

Pinned: [`03127a8`](https://github.com/LavX/bazarr/commit/03127a8732186efd3c0b63bcf0bff6313fb6822c)
(2026-11-19), which includes:

- starting as a non-root user (`user: 1000:1000`) works: the entrypoint checks `/config` and execs
  tini and the supervisor directly ([#876](https://github.com/LavX/bazarr/pull/876))
- x86-64 CPUs without SSE4.2/POPCNT start instead of crashing in numpy
  ([#877](https://github.com/LavX/bazarr/pull/877))

Works with `read_only: true` and `cap_drop: [ALL]` when started as 1000:1000. Writable paths:

| path | what |
|---|---|
| `/config` | config, database, logs, plugins (volume), owned by 1000 |
| `/tmp` | the supervisor's port file (read by the healthcheck), temp files (tmpfs) |

Build args: `BAZARR_REF` (full commit), `BAZARR_VERSION` (shown in System Status), `BUILD_DATE`.
To move to a newer commit, diff upstream's `Dockerfile` between the two commits and carry the
changes over.

## License

Bazarr+ is licensed under the [GNU General Public License v3.0](https://github.com/LavX/bazarr/blob/development/LICENSE);
its source is at the commit above.
