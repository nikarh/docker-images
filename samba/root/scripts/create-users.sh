#!/bin/sh

groupadd -g 1000 files || true;
useradd -MNo -u 1000 -g 1000 -s /usr/bin/nologin files || true;

for f in /home/*; do
  username="$(basename $f)"
  useradd -MNo -u $UID -g $GID -s /usr/bin/nologin "$username" || true;
  usermod -p "*" "$username"

  echo -e "$username\n$username\n" | smbpasswd -a -s "$username"
done
