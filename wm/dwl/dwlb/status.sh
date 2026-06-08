#!/bin/sh

LYRICS_SCRIPT="$DWLCONF/dwlb/get-lyrics.sh"
LYRICS_FILE='/tmp/dwl-lyrics'
TRACK_FILE='/tmp/dwl-lyrics-track'

get_layout() {
    layout="$(cat /tmp/dwl-layout 2>/dev/null)"
    echo "Lyt:${layout:-LAT}"
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
    pct=$(df / | awk 'NR==2 {gsub(/%/,""); print $5}')
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
    if playerctl -p ncspot status 2>/dev/null | grep -q 'Playing'; then
        artist=$(playerctl -p ncspot metadata artist 2>/dev/null)
        title=$(playerctl -p ncspot metadata title 2>/dev/null)
        echo "Spt:${title} - ${artist}"
        return
    else
        echo "Spt:<nothing>"
        return
    fi
}

get_lyrics() {
    # Trigger fetch/cache update in background
    sh "$LYRICS_SCRIPT" &

    # Nothing playing
    if ! playerctl -p ncspot status 2>/dev/null | grep -q 'Playing'; then
        echo "Lyr:<nothing>"
        return
    fi

    # No lyrics file or empty = no lyrics available
    if [ ! -s "$LYRICS_FILE" ]; then
        echo "Lyr:<no lyrics>"
        return
    fi

    # Get current playback position in seconds
    pos=$(playerctl -p ncspot position 2>/dev/null)
    if [ -z "$pos" ]; then
        echo "Lyr:..."
        return
    fi

    # Find the current lyric line: last line whose timestamp <= pos
    line=$(awk -v pos="$pos" '
        BEGIN { current = "..." }
        {
            ts = $1 + 0
            if (ts <= pos) {
                # Rebuild line without the timestamp field
                $1 = ""
                sub(/^ /, "", $0)
                current = $0
            }
        }
        END { print current }
    ' "$LYRICS_FILE")

    if [ -z "$line" ]; then
        echo "Lyr:..."
        return
    fi

    max=40
    raw_len=${#line}

    if [ $raw_len -le $max ]; then
        total_pad=$(( max - raw_len ))
        left_pad=$(( total_pad / 2 ))
        right_pad=$(( total_pad - left_pad ))
        printf "Lyr:%${left_pad}s%s%${right_pad}s" "" "$line" ""
        return
    fi

    # Scroll long lines
    sep="   "
    cycle=$(( raw_len + ${#sep} ))
    padded="${line}${sep}${line}"
    start=$(( lyrics_offset % cycle + 1 ))
    echo "Lyr:$(echo "$padded" | awk -v s=$start -v l=$max '{print substr($0, s, l)}')"
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

    dtotal=$(( (user2 + nice2 + system2 + idle2) - (user + nice + system + idle) ))
    dused=$(( (user2 + nice2 + system2) - (user + nice + system) ))

    echo "Cpu:$(printf '%03d' $(( dused * 100 / dtotal )))%"
}

get_title() {
    raw="$(cat /tmp/dwl-title 2>/dev/null | tr -d '\n')"
    [ -z "$raw" ] && raw="dwl"

    max=25
    raw_len=${#raw}

    if [ $raw_len -le $max ]; then
        total_pad=$(( max - raw_len ))
        left_pad=$(( total_pad / 2 ))
        right_pad=$(( total_pad - left_pad ))
        printf "%${left_pad}s%s%${right_pad}s" "" "$raw" ""
        return
    fi

    sep="   "
    cycle=$(( raw_len + ${#sep} ))
    padded="${raw}${sep}${raw}"
    start=$(( offset % cycle + 1 ))
    echo "$padded" | awk -v s=$start -v l=$max '{print substr($0, s, l)}'
}

CENTER_PAD=1
offset=0
media_offset=0
lyrics_offset=0
lyrics_tick=0

while true; do
    title_block="^bg(999999) $(get_title) ^bg()"
    pad="$(printf '%*s' $CENTER_PAD '')"
    right="$(get_clock)  $(get_memory)  $(get_temp)  $(get_cpu)  $(get_disk)  $(get_layout)  $(get_volume)  $(get_network)  $(get_media)  $(get_lyrics)"

    dwlb -status HDMI-A-1 "^fg(222222)${title_block}${pad}${right}"

    offset=$(( offset + 1 ))
    media_offset=$(( media_offset + 1 ))

    # Lyrics scroll at half speed (1 char per 2 ticks = 0.2s)
    lyrics_tick=$(( lyrics_tick + 1 ))
    if [ $lyrics_tick -ge 2 ]; then
        lyrics_offset=$(( lyrics_offset + 1 ))
        lyrics_tick=0
    fi

    sleep 0.1
done