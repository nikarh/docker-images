# beets (music library manager) with its plugin dependencies, ffmpeg and fpcalc,
# running entirely as an unprivileged user on a read-only root filesystem.
FROM python:3.13-slim

ARG BEETS_VERSION=2.14.1
ARG FILETOTE_VERSION=1.3.7

# ffmpeg: convert plugin and audio checks; fpcalc: acoustic fingerprints (chroma);
# tini: reaps the background jobs beets plugins start
RUN apt-get update \
    && apt-get install -y --no-install-recommends ffmpeg libchromaprint-tools tini \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir \
        "beets[chroma,discogs,fetchart,lyrics]==${BEETS_VERSION}" \
        "beets-filetote==${FILETOTE_VERSION}"

ENV HOME=/tmp \
    BEETSDIR=/config/beets \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

USER 1000:1000
WORKDIR /music
ENTRYPOINT ["tini", "--"]
# Keep the container up for `docker exec ... beet`; the deployment sets its own command.
CMD ["sleep", "infinity"]
