#!/bin/sh

get_layout() {
    LAYOUT="$(cat /tmp/dwl-layout 2>/dev/null)"
    if [ $? -eq 0 ]; then
        echo "Layout:$LAYOUT"
    else
        echo "Layout:LATAM"
    fi
}

get_temp() {
    temp=$(( $(cat /sys/class/thermal/thermal_zone2/temp) / 1000 ))
    echo "Tmp:${temp}°C"
}

get_memory() {
    free -h | awk '/Mem:/ {print "Mem:"$3}'
}

get_network() {
    state=$(cat /sys/class/net/enp3s0/operstate 2>/dev/null)
    if [ "$state" = "up" ]; then
        echo "Net:Up"
    else
        echo "Net:Down"
    fi
}

get_disk() {
    df /home --output=pcent | awk 'NR==2 {gsub(/%/,""); printf "Dsk:%02d%%", $1}'
}

get_clock() {
    date '+%a %d/%m %H:%M'
}

get_volume() {
    amixer sget Master | awk -F"[][]" '/Left:/ {print "Vol:"$2}'
}

get_media() {
    if playerctl -p spotify status 2>/dev/null | grep -q "Playing"; then
        artist=$(playerctl -p spotify metadata artist 2>/dev/null)
        title=$(playerctl -p spotify metadata title 2>/dev/null)
        raw="${title} - ${artist}"
    else
        echo "Spt:<nothing>"
        return
    fi

    max=30
    len=${#raw}
    if [ $len -lt $max ]; then
        total_pad=$(( max - len ))
        left_pad=$(( total_pad / 2 ))
        right_pad=$(( total_pad - left_pad ))
        raw="$(printf "%${left_pad}s%s%${right_pad}s" "" "$raw" "")"
        len=$max
    fi
    padded="${raw}   ${raw}"
    echo "Spt:${padded:$(( media_offset % (len + 3) )):$max}"
}

get_cpu() {
    read1=$(awk '/^cpu / {print $2,$3,$4,$5,$6,$7,$8,$9}' /proc/stat)
    sleep 0.1
    read2=$(awk '/^cpu / {print $2,$3,$4,$5,$6,$7,$8,$9}' /proc/stat)

    user=$(echo $read1 | cut -d' ' -f1)
    nice=$(echo $read1 | cut -d' ' -f2)
    system=$(echo $read1 | cut -d' ' -f3)
    idle=$(echo $read1 | cut -d' ' -f4)

    user2=$(echo $read2 | cut -d' ' -f1)
    nice2=$(echo $read2 | cut -d' ' -f2)
    system2=$(echo $read2 | cut -d' ' -f3)
    idle2=$(echo $read2 | cut -d' ' -f4)

    total=$(( user + nice + system + idle ))
    total2=$(( user2 + nice2 + system2 + idle2 ))
    dtotal=$(( total2 - total ))
    dused=$(( (user2+nice2+system2) - (user+nice+system) ))
    echo "Cpu:$(printf '%03d' $(( dused * 100 / dtotal )))%"
}

get_title() {
    raw="$(cat /tmp/dwl-title 2>/dev/null | tr -d '\n')"
    [ -z "$raw" ] && raw="dwl"
    max=12
    len=${#raw}
    if [ $len -lt $max ]; then
        total_pad=$(( max - len ))
        left_pad=$(( total_pad / 2 ))
        right_pad=$(( total_pad - left_pad ))
        raw="$(printf "%${left_pad}s%s%${right_pad}s" "" "$raw" "")"
        len=$max
    fi
    padded="${raw}   ${raw}"
    echo "${padded:$(( offset % (len + 3) )):$max}"
}

CENTER_PAD=1
offset=0
media_offset=0
toggle=0
tick=0

while true; do
    left="^fg(ffffff)$(get_clock)  $(get_memory)  $(get_temp)  $(get_cpu)  $(get_disk)"
    pad="$(printf '%*s' $CENTER_PAD '')"

    if [ $toggle -eq 0 ]; then
        title_block="^fg(ffffff)^bg(0000a8) $(get_title) "
    else
        title_block="^fg(0000a8)^bg(ffffff) $(get_title) "
    fi
    title_block="${title_block}^bg()^fg(ffffff)"

    dwlb -status HDMI-A-1 "${left}${pad}${title_block}${pad}$(get_layout)  $(get_volume)  $(get_network)  $(get_media)"

    offset=$(( offset + 1 ))
    media_offset=$(( media_offset + 1 ))

    tick=$(( tick + 1 ))
    if [ $tick -ge 2 ]; then
        toggle=$(( (toggle + 1) % 2 ))
        tick=0
    fi

    sleep 0.1
done
