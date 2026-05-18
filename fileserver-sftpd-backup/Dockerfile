FROM alpine

ARG TARGETARCH

RUN set -eux; \
  apk add --no-cache openssh lftp xz; \
  apk add --no-cache --virtual .supercronic-fetch-deps ca-certificates curl jq; \
  case "${TARGETARCH:-$(uname -m)}" in \
    amd64|x86_64) supercronic_arch=amd64 ;; \
    arm64|aarch64) supercronic_arch=arm64 ;; \
    arm|armv7l) supercronic_arch=arm ;; \
    386|i386|i686) supercronic_arch=386 ;; \
    *) echo "Unsupported architecture: ${TARGETARCH:-$(uname -m)}" >&2; exit 1 ;; \
  esac; \
  supercronic="supercronic-linux-${supercronic_arch}"; \
  release_json="$(curl -fsSL https://api.github.com/repos/aptible/supercronic/releases/latest)"; \
  supercronic_url="$(printf '%s' "$release_json" | jq -r --arg name "$supercronic" '.assets[] | select(.name == $name) | .browser_download_url')"; \
  supercronic_sha256="$(printf '%s' "$release_json" | jq -r --arg name "$supercronic" '.assets[] | select(.name == $name) | .digest | sub("^sha256:"; "")')"; \
  test -n "$supercronic_url"; \
  test -n "$supercronic_sha256"; \
  curl -fsSLo /usr/local/bin/supercronic "$supercronic_url"; \
  echo "$supercronic_sha256  /usr/local/bin/supercronic" | sha256sum -c -; \
  chmod +x /usr/local/bin/supercronic; \
  apk del .supercronic-fetch-deps
COPY ./root/ /

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "supercronic", "/etc/supercronic/backup_all.cron" ]
