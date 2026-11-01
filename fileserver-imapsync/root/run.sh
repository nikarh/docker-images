#!/bin/sh

# The root filesystem may be read-only, so the rendered config lives in /tmp
sed 's/${USERNAME}/'"$USERNAME"'/g' /mbsync.conf > /tmp/mbsync.conf

mbsync -LV -c /tmp/mbsync.conf gmail
exec goimapnotify -log-level debug -conf /imapnotify.yaml
