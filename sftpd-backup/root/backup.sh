#!/bin/sh -xe

MAXIMUM_BACKUP_NUMBER="${MAXIMUM_BACKUP_NUMBER:-2}"
SFTP_SERVER="${SFTP_SERVER:-files}"
SFTP_USER="${SFTP_USER:-backup}"
SFTP_ROOT="${SFTP_ROOT:-/data}"
VOLUMES="${VOLUMES:-/volumes}"

function backup {
  local VOLUME="$1"
  local TARGET="$SFTP_ROOT/$VOLUME"
  local DATE="$(date +"%FT%H-%M-%S%z")"

  if [ -z "$VOLUME" ]; then
    echo "Volume is required"
    exit 1
  fi

  local COMMANDS="$(tar -C "$VOLUMES/$VOLUME" -Jcf - . | \
    lftp -c "
      open -p 2222 -u \"$SFTP_USER,\" \"sftp://$SFTP_SERVER\";
      mkdir -pf \"$TARGET\";
      put /dev/stdin -o \"$TARGET/.$DATE.tar.xz.part\";
      mv \"$TARGET/.$DATE.tar.xz.part\" \"$TARGET/$DATE.tar.xz\";
      cls -1 --sort=name \"$TARGET\"
    " | \
    head -n "-$MAXIMUM_BACKUP_NUMBER" | \
    sed 's/^\(.*\)$/rm \1;/')"

  lftp -c "
    open -p 2222 -u \"$SFTP_USER,\" \"sftp://$SFTP_SERVER\";
    $COMMANDS
  "
}

function restore {
  local VOLUME="$1"
  local SFTP_ROOT="${2:-$SFTP_ROOT}"
  local SOURCE="$SFTP_ROOT/$VOLUME"

  if [ -z "$VOLUME" ]; then
    echo "Volume is required"
    exit 1
  fi

  if [ ! -d "$VOLUMES/$VOLUME" ]; then
    echo "$VOLUME volume is not mounted"
    exit 1
  fi

  local LATEST=$(lftp -c "
    open -p 2222 -u \"$SFTP_USER,\" \"sftp://$SFTP_SERVER\";
    cls -1 --sort=name \"$SOURCE\"
  " | tail -n "1")

  if [ -z "$LATEST" ]; then
    echo "$VOLUME does not have backups in $SFTP_ROOT"
    exit 1
  fi

  local LATEST_FILENAME="$(basename -- "$LATEST")"

  lftp -c "
    open -p 2222 -u \"$SFTP_USER,\" \"sftp://$SFTP_SERVER\";
    get \"$LATEST\" -o \"$VOLUMES/$VOLUME-$LATEST_FILENAME\";
  "

  tar -C "$VOLUMES/$VOLUME" -Jxf "$VOLUMES/$VOLUME-$LATEST_FILENAME"
  rm "$VOLUMES/$VOLUME-$LATEST_FILENAME"
}

function backup_all {
  cd "$VOLUMES";
  for f in *; do
    if [ ! -d "$VOLUMES/$f" ]; then
      continue
    fi
    backup "$f"
  done;
}

function restore_all {
  cd "$VOLUMES";
  for f in *; do
    if [ ! -d "$VOLUMES/$f" ]; then
      continue
    fi
    restore "$f" "$1"
  done;
}

case "$1" in
  backup_all)
    backup_all;;
  restore_all)
    restore_all "$2";;
  backup)
    backup "$2";;
  restore)
    restore "$2" "$3";;
  *)
    echo "Unknown command";;
esac
