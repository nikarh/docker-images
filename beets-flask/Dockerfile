# beets-flask (web UI for beets) with the beets plugin dependencies preinstalled,
# running entirely as an unprivileged user on a read-only root filesystem.
ARG BEETS_FLASK_VERSION=v2.0.0-rc5
FROM pspitzner/beets-flask:${BEETS_FLASK_VERSION}

# beets-flask pins this exact version and hooks into the beets importer;
# change only together with BEETS_FLASK_VERSION, and test an import.
ARG BEETS_VERSION=2.11.0

USER root

# fpcalc for acoustic fingerprints (chroma plugin, CLI imports)
RUN apt-get update \
    && apt-get install -y --no-install-recommends libchromaprint-tools \
    && rm -rf /var/lib/apt/lists/*

RUN uv pip install --python /venv/bin/python --no-cache \
        "beets[chroma,discogs,fetchart,lyrics]==${BEETS_VERSION}" \
        "beets-filetote==1.3.7"

# The default polars runtime needs AVX2 and friends and dies with SIGILL on
# older CPUs. The compat runtime works everywhere and polars prefers it when
# installed; it must match the polars version exactly.
RUN POLARS_VERSION=$(/venv/bin/python -c 'import importlib.metadata as m; print(m.version("polars"))') \
    && uv pip install --python /venv/bin/python --no-cache "polars-runtime-compat==${POLARS_VERSION}" \
    && uv pip uninstall --python /venv/bin/python polars-runtime-32

# The upstream entrypoint starts as root, fixes permissions, pip-installs
# requirements and drops to uid 1000. Here everything is baked in, so its
# unprivileged part is used directly. Redis is kept in memory only, and the
# server is exec'd so it gets SIGTERM (run with an init, e.g. compose `init: true`).
RUN sed -i \
        -e 's|redis-server --daemonize yes|redis-server --daemonize yes --save "" --appendonly no --dir /tmp|' \
        -e 's|^python ./launch_server.py|exec python ./launch_server.py|' \
        /repo/entrypoint.sh \
    && grep -q -- '--save ""' /repo/entrypoint.sh \
    && grep -q '^exec python ./launch_server.py' /repo/entrypoint.sh

ENV PATH=/venv/bin:$PATH \
    VIRTUAL_ENV=/venv \
    HOME=/tmp \
    PYTHONDONTWRITEBYTECODE=1

USER 1000:1000
WORKDIR /repo
ENTRYPOINT ["/bin/bash", "/repo/entrypoint.sh"]
