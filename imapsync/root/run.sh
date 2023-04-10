#!/bin/sh

sed -i 's/${USERNAME}/'"$USERNAME"'/g' /mbsync.conf

mbsync -LV -c /mbsync.conf gmail
goimapnotify -debug -conf /imapnotify.conf
