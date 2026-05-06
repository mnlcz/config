#!/bin/sh

get_layout() {
    LAYOUT="$(cat /tmp/dwl-layout 2>/dev/null)"
    if [ $? -eq 0 ]; then
        echo "Layout:$LAYOUT"
    else
        echo "Layout:LATAM"
    fi
}

get_memory() {
    free -h | awk '/Mem:/ {print "Mem:"$3}'
}

get_clock() {
    date '+%a %d %b %H:%M'
}

while true; do
    dwlb -status HDMI-A-1 "^fg(ffffff)$(get_clock)  $(get_memory)  $(get_layout)"
    sleep 1
done
