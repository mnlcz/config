#!/bin/sh
# get-lyrics.sh
# Fetches synced lyrics from lrclib.net and caches them per track.
# Writes to:
#   /tmp/dwl-lyrics-track  — "artist|title" of currently cached track
#   /tmp/dwl-lyrics        — parsed LRC: "SECONDS\tLINE" one per line

TRACK_FILE='/tmp/dwl-lyrics-track'
LYRICS_FILE='/tmp/dwl-lyrics'

artist=$(playerctl -p ncspot metadata artist 2>/dev/null)
title=$(playerctl -p ncspot metadata title 2>/dev/null)

# If nothing is playing, clear cache and exit
if [ -z "$artist" ] && [ -z "$title" ]; then
    rm -f "$TRACK_FILE" "$LYRICS_FILE"
    exit 0
fi

current="${artist}|${title}"

# If cache is valid for this track, nothing to do
if [ -f "$TRACK_FILE" ] && [ "$(cat "$TRACK_FILE")" = "$current" ]; then
    exit 0
fi

# Fetch duration
dur=$(playerctl -p ncspot metadata mpris:length 2>/dev/null | \
    awk '{printf "%d", $1/1000000}')

# Fetch synced lyrics from lrclib
synced=$(curl -sG 'https://lrclib.net/api/get' \
    --data-urlencode "artist_name=$artist" \
    --data-urlencode "track_name=$title" \
    --data-urlencode "duration=$dur" | \
    jq -r '.syncedLyrics // empty')

if [ -z "$synced" ]; then
    # No synced lyrics available — write empty marker
    printf '%s' "$current" > "$TRACK_FILE"
    : > "$LYRICS_FILE"
    exit 0
fi

# Parse LRC format: [MM:SS.xx] Line
# Convert timestamps to seconds, write "SECONDS\tLINE"
printf '%s' "$current" > "$TRACK_FILE"
printf '%s\n' "$synced" | sed 's/\\n/\n/g' | \
    awk '/^\[[0-9]+:[0-9]+\.[0-9]+\]/ {
        line = $0
        # Extract mins and secs using split on [ : . ]
        gsub(/[\[\]]/, " ", line)
        split(line, parts, /[: ]/)
        mins = parts[2] + 0
        secs = parts[3] + 0
        total = mins * 60 + secs
        # Extract lyric text (after the timestamp)
        text = $0
        sub(/^\[[0-9]+:[0-9]+\.[0-9]+\] ?/, "", text)
        if (text != "")
            printf "%.2f\t%s\n", total, text
    }' > "$LYRICS_FILE"