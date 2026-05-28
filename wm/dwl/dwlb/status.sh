#!/bin/sh

get_layout() {
    LAYOUT="$(cat /tmp/dwl-layout 2>/dev/null)"
    if [ $? -eq 0 ]; then
        echo "Lyt:$LAYOUT"
    else
        echo "Lyt:LAT"
    fi
}

get_temp() {
    temp=$(sysctl -n hw.acpi.thermal.tz0.temperature | tr -d 'C')
    echo "Tmp:${temp}°C"
}

get_memory() {
    total=$(sysctl -n hw.physmem)
    inactive=$(sysctl -n vm.stats.vm.v_inactive_count)
    cache=$(sysctl -n vm.stats.vm.v_cache_count)
    free=$(sysctl -n vm.stats.vm.v_free_count)
    pagesize=$(sysctl -n hw.pagesize)

    used=$(( (total - (inactive + cache + free) * pagesize) / 1024 / 1024 ))
    total_mb=$(( total / 1024 / 1024 ))

    if [ $used -ge 1024 ]; then
        echo "Mem:$(( used / 1024 ))G"
    else
        echo "Mem:${used}M"
    fi
}

get_network() {
    state=$(ifconfig re0 | grep -c "status: active")
    if [ "$state" -gt 0 ]; then
        echo "Net:Up"
    else
        echo "Net:Down"
    fi
}

get_disk() {
    pct=$(df /home | awk 'NR==2 {gsub(/%/,""); print $5}')
    printf "Dsk:%02d%%\n" "$pct"
}

get_clock() {
    date '+%a %d/%m %H:%M'
}

get_volume() {
    val=$(mixer -f /dev/mixer7 vol.volume | awk -F= '{print $2}' | cut -d: -f1)
    pct=$(printf "%.0f" $(echo "$val * 100" | bc))
    echo "Vol:${pct}%"
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
    start=$(( media_offset % (len + 3) + 1 ))
    echo "Spt:$(echo "$padded" | awk -v s=$start -v l=$max '{print substr($0, s, l)}')"
}

get_cpu() {
    read1=$(sysctl -n kern.cp_time)
    sleep 0.1
    read2=$(sysctl -n kern.cp_time)

    user=$(echo $read1 | cut -d' ' -f1)
    nice=$(echo $read1 | cut -d' ' -f2)
    system=$(echo $read1 | cut -d' ' -f3)
    idle=$(echo $read1 | cut -d' ' -f5)

    user2=$(echo $read2 | cut -d' ' -f1)
    nice2=$(echo $read2 | cut -d' ' -f2)
    system2=$(echo $read2 | cut -d' ' -f3)
    idle2=$(echo $read2 | cut -d' ' -f5)

    total=$(( user + nice + system + idle ))
    total2=$(( user2 + nice2 + system2 + idle2 ))
    dtotal=$(( total2 - total ))
    dused=$(( (user2 + nice2 + system2) - (user + nice + system) ))

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
    start=$(( offset % (len + 3) + 1 ))
    echo "$padded" | awk -v s=$start -v l=$max '{print substr($0, s, l)}'
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
