#!/bin/sh

export PLAN9=/usr/local/plan9
export PATH=$PATH:$PLAN9/bin
. $HOME/.shrc.d/0dirs.sh

export DISPLAY=${DISPLAY:-:0}

$PLAN9/bin/unmount /mnt/acme 2>/dev/null
mkdir -p /mnt/acme

export NAMESPACE=${NAMESPACE:-$($PLAN9/bin/namespace)}

if ! pgrep -x plumber > /dev/null; then
    $PLAN9/bin/plumber &
    sleep 0.5
fi
cat $PLAN9/plumb/basic | $PLAN9/bin/9p write plumb/rules

SHELL=$PLAN9/bin/rc $PLAN9/bin/acme -l $HOME/acme.dump -m /mnt/acme -f /usr/local/plan9/font/TempleOS/10a/font "$@" &