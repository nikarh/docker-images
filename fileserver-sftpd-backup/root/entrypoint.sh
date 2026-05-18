#!/bin/sh
set -eu

BACKUP_ALL_CRON="${BACKUP_ALL_CRON:-0 0 * * *}"

mkdir -p /etc/supercronic
printf '%s /backup.sh backup_all\n' "$BACKUP_ALL_CRON" > /etc/supercronic/backup_all.cron

exec "$@"
