#!/bin/sh

get_network() {
    if ip route get 1.1.1.1 &>/dev/null 2>&1; then
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
    echo "^fg(ee0000)$(get_network)  $(get_memory)  $(get_clock)^fg()"
    sleep 5
done
