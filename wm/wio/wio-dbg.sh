#!/bin/sh

LOG="$HOME/wio.log"

echo "==== wio-dbg session $(date) ====" >> "$LOG"
echo "PATH=$PATH" >> "$LOG"

# Visual cue that the debug variant is running (distinguishes from wio.desktop
# at a glance during login) — not a hardware/DRM wait, safe to remove anytime.
sleep 2

exec "$HOME/.guix-home/profile/bin/wio" \
    -t "$HOME/.guix-home/profile/bin/havoc" \
    >>"$LOG" 2>&1

