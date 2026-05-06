#!/bin/sh

get_layout() {
    cat /tmp/dwl-layout 2>/dev/null || echo "LATAM"
}

get_network() {
    if ip route show default 2>/dev/null | grep -q .; then
        echo "󰈀"
    else
        echo "󰈁"
    fi
}

get_memory() {
    free -h | awk '/Mem:/ {print $3"/"$2}'
}

get_clock() {
    date '+%a %d %b %H:%M'
}

while true; do
    dwlb -status HDMI-A-1 "^fg(ffffff)$(get_memory)  $(get_layout)  $(get_clock)"
    sleep 1
done

