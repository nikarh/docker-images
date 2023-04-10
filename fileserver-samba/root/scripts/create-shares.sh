#!/bin/sh

for f in /home/*; do
  username="$(basename "$f")"

  echo "[$username]"
  echo "  comment = $username's files"
  echo "  valid users = $username"
  echo "  path = /home/$username"
  echo "  writeable = yes"
done
