#!/bin/sh

echo "$(sed 's/${USERNAME}/'"$USERNAME"'/g' /mbsync.conf)" > /mbsync.conf

mbsync -LV -c /mbsync.conf gmail
goimapnotify -debug -conf /imapnotify.conf
