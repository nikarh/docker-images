#!/bin/sh
set -e
set -x

cp /etc/samba/smb-base.conf /etc/samba/smb.conf

/scripts/create-users.sh
/scripts/create-shares.sh >> /etc/samba/smb.conf

$@
