#!/bin/bash
source /home/mnlcz/.profile
export DISPLAY=${DISPLAY:-:0}
fusermount -u /mnt/acme 2>/dev/null
fusermount -u /mnt/font 2>/dev/null
mkdir -p /mnt/acme /mnt/font
if ! pgrep -x fontsrv > /dev/null; then
    fontsrv -m /mnt/font & sleep 0.5
fi
export NAMESPACE=${NAMESPACE:-$($PLAN9/bin/namespace)}
if ! pgrep -x plumber > /dev/null; then
    $PLAN9/bin/plumber & sleep 0.5
fi
cat $PLAN9/plumb/basic | $PLAN9/bin/9p write plumb/rules
# Note: changing font requires ignoring previous dump
# SHELL=$PLAN9/bin/rc $PLAN9/bin/acme -m /mnt/acme -f /mnt/font/TempleOSRegular/10a/font "$@" &
SHELL=$PLAN9/bin/rc $PLAN9/bin/acme -l $CONFIG_DIR/editor/acme.dump -m /mnt/acme -f /mnt/font/TempleOSRegular/10a/font "$@" &
