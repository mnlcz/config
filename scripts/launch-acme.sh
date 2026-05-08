#!/bin/bash

export PLAN9=/home/mnlcz/Projects/plan9port
export PATH=$PATH:$PLAN9/bin
source /home/mnlcz/.bashrc.d/0dirs.sh

export DISPLAY=${DISPLAY:-:0}
fusermount -u /mnt/acme 2>/dev/null
fusermount -u /mnt/font 2>/dev/null
mkdir -p /mnt/acme /mnt/font
if ! pgrep -x fontsrv > /dev/null; then
    fontsrv -m /mnt/font &
    timeout 5 sh -c 'until ls /mnt/font/* 2>/dev/null | grep -q .; do sleep 0.1; done'
fi

export NAMESPACE=${NAMESPACE:-$($PLAN9/bin/namespace)}

if ! pgrep -x plumber > /dev/null; then
    $PLAN9/bin/plumber &
    sleep 0.5
fi
cat $PLAN9/plumb/basic | $PLAN9/bin/9p write plumb/rules

# Note: changing font requires ignoring previous dump
SHELL=$PLAN9/bin/rc $PLAN9/bin/acme -l $HOME/acme.dump -m /mnt/acme -f /mnt/font/TempleOSRegular/10a/font "$@" &

