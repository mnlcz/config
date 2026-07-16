#!/bin/sh

LOG="$HOME/wio.log"

echo "wrapper started $(date)" >> "$LOG"
echo "PATH=$PATH" >> "$LOG"

sleep 2

exec "$HOME/.guix-home/profile/bin/wio" \
    -t "$HOME/.guix-home/profile/bin/havoc" \
    >>"$LOG" 2>&1
