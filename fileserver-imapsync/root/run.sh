#!/bin/sh

echo "$(sed 's/${USERNAME}/'"$USERNAME"'/g' /mbsync.conf)" > /mbsync.conf

mbsync -LV -c /mbsync.conf gmail
goimapnotify -log-level debug -conf /imapnotify.conf
