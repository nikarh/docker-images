# Bazarr+ (https://github.com/LavX/bazarr, GPLv3) built from a pinned commit of its
# development branch, for fixes that are not in a published image yet.
#
# Upstream's Dockerfile expects the frontend to be built beforehand by its CI, and copies
# everything else from the build context. Here the source is fetched by commit and the
# frontend is built in its own stage; the stages after that follow upstream's Dockerfile
# at BAZARR_REF, with `COPY --from=src` in place of copies from the context. When moving
# BAZARR_REF, diff upstream's Dockerfile between the two commits and carry the changes over.
ARG BAZARR_REF=03127a8732186efd3c0b63bcf0bff6313fb6822c
# shown in System Status; upstream's `git describe` on development names an old tag
ARG BAZARR_VERSION=2.7.2-dev.03127a8
# the commit's date, so a rebuild of the same commit gets the same stamp
ARG BUILD_DATE=2026-11-19T15:48:16Z
ARG ALASS_CLI_VERSION=2.0.0

# =============================================================================
# Source, with the submodules (translator, binaries, provider catalog)
# =============================================================================
FROM alpine:3.23 AS src
ARG BAZARR_REF
RUN apk add --no-cache git
RUN git init -q /src \
    && git -C /src remote add origin https://github.com/LavX/bazarr.git \
    && git -C /src fetch -q --depth 1 origin "${BAZARR_REF}" \
    && git -C /src checkout -q FETCH_HEAD \
    && git -C /src submodule update -q --init --recursive --depth 1 \
    && rm -rf /src/.git

# =============================================================================
# Frontend (upstream builds it in CI: pnpm from corepack, node from .nvmrc)
# =============================================================================
FROM node:24-trixie-slim AS frontend
ENV CI=true COREPACK_ENABLE_DOWNLOAD_PROMPT=0
COPY --from=src /src/frontend /frontend
WORKDIR /frontend
RUN corepack enable \
    && pnpm install --frozen-lockfile \
    && pnpm run build

# =============================================================================
# Python dependencies
# =============================================================================
FROM python:3.14-slim-trixie AS python-builder

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    git \
    libffi-dev \
    libpq-dev \
    libxml2-dev \
    libxslt1-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY --from=src /src/requirements.txt /src/postgres-requirements.txt ./
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install --prefix=/install --ignore-installed "setuptools>=82.0.1" \
    && pip install --prefix=/install -r requirements.txt -r postgres-requirements.txt \
    && pip install --prefix=/install --no-deps signalrcore==1.0.2

# =============================================================================
# ALASS CLI
# =============================================================================
FROM rust:1.95-slim-trixie AS alass-builder
ARG ALASS_CLI_VERSION

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

RUN --mount=type=cache,target=/usr/local/cargo/registry \
    --mount=type=cache,target=/usr/local/cargo/git \
    cargo install alass-cli --version "${ALASS_CLI_VERSION}" --locked

# =============================================================================
# Provider catalog snapshot, pinned and verified by docker/catalog-pin.lock.json
# =============================================================================
FROM python:3.14-slim-trixie AS catalog-floor

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    git \
    && rm -rf /var/lib/apt/lists/*

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install "cryptography>=50.0.2"

COPY --from=src /src/scripts/release/catalog_floor.py /opt/catalog_floor.py
COPY --from=src /src/bazarr/provider_hub/signing.py /src/bazarr/provider_hub/signing_roots.py /opt/provider_hub/
COPY --from=src /src/docker/catalog-pin.lock.json /opt/catalog-pin.lock.json

RUN python -I /opt/catalog_floor.py build \
        --lock /opt/catalog-pin.lock.json \
        --signing-dir /opt/provider_hub \
        --dest /catalog_floor \
        --expect-root-owner

# =============================================================================
# Image
# =============================================================================
FROM python:3.14-slim-trixie AS production

ARG BAZARR_REF
ARG BAZARR_VERSION
ARG BUILD_DATE

LABEL org.opencontainers.image.title="Bazarr+" \
      org.opencontainers.image.version="${BAZARR_VERSION}" \
      org.opencontainers.image.created="${BUILD_DATE}" \
      org.opencontainers.image.revision="${BAZARR_REF}" \
      org.opencontainers.image.source="https://github.com/LavX/bazarr" \
      org.opencontainers.image.licenses="GPL-3.0"

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update && apt-get install -y --no-install-recommends \
    ffmpeg \
    libxml2 \
    libxslt1.1 \
    libpq5 \
    mediainfo \
    p7zip-full \
    postgresql-client \
    unar \
    bash \
    gosu \
    curl \
    && mkdir -p /config /defaults \
    && groupadd -g 1000 bazarr \
    && useradd -u 1000 -g bazarr -d /config -s /bin/bash bazarr

COPY --from=python-builder /install /usr/local
COPY --from=alass-builder /usr/local/cargo/bin/alass-cli /usr/local/bin/alass-cli
RUN ln -s /usr/local/bin/alass-cli /usr/local/bin/alass

ARG TINI_VERSION=0.19.0-3
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update \
    && tini_re="$(printf '%s' "${TINI_VERSION}" | sed 's/\./\\./g')" \
    && tini_candidate="$(apt-cache policy tini | sed -n 's/^  Candidate: //p')" \
    && printf '%s\n' "${tini_candidate}" | grep -Eq "^${tini_re}(\+b[0-9]+)?\$" \
    && apt-get install -y --no-install-recommends "tini=${tini_candidate}" \
    && test -x /usr/bin/tini \
    && /usr/bin/tini --version

COPY --from=src /src/docker/entrypoint.sh /entrypoint.sh
COPY --from=src /src/docker/supervisor.py /app/bazarr/docker/supervisor.py
RUN chmod +x /entrypoint.sh

WORKDIR /app/bazarr

COPY --from=src /src/custom_libs ./custom_libs
COPY --from=src /src/migrations ./migrations

COPY --from=catalog-floor /catalog_floor ./catalog_floor
RUN chmod 0555 /app/bazarr/catalog_floor \
    && test -z "$(find /app/bazarr/catalog_floor ! -user root -print -quit)" \
    && test -z "$(find /app/bazarr/catalog_floor -type f ! -perm 0444 -print -quit)" \
    && test -z "$(find /app/bazarr/catalog_floor -type d ! -perm 0555 -print -quit)" \
    && test -z "$(find /app/bazarr/catalog_floor ! -type f ! -type d -print -quit)" \
    && test -f /app/bazarr/catalog_floor/catalog.json

COPY --from=src /src/bazarr.py ./
COPY --from=src /src/bazarr ./bazarr

RUN echo "${BAZARR_VERSION}" > /app/bazarr/VERSION \
    && printf 'commit=%s\ndate=%s\n' "${BAZARR_REF}" "${BUILD_DATE}" > /app/bazarr/BUILD

COPY --from=src /src/package_info /app/bazarr/package_info
COPY --from=frontend /frontend/build ./frontend/build

# the application tree belongs to root; everything written at runtime lives under /config
RUN test -z "$(find /app \( ! -user root -o -perm /go=w \) -print -quit)"

ENV HOME="/config" \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    MALLOC_ARENA_MAX=2

VOLUME /config
EXPOSE 6767

HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
    CMD port=$(cat /tmp/bazarr-supervisor.port 2>/dev/null || echo 6767); case "$port" in ""|*[!0-9]*) exit 1 ;; esac; curl -sf "http://localhost:$port/_supervisor/status" | grep -q '"running"' || exit 1

ENTRYPOINT ["/entrypoint.sh"]
CMD ["python", "docker/supervisor.py", "--no-update", "--config", "/config"]
