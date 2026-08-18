#!/bin/bash
output() {
    muted=$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')
    if [ "$muted" = "yes" ]; then
        echo "%{F#707880}%{F-}"
    else
        vol=$(pactl get-sink-volume @DEFAULT_SINK@ | head -1 | awk '{print $5}' | tr -d '%')
        echo "%{F#13e014}%{F-} ${vol}%"
    fi
}
output
pactl subscribe 2>/dev/null | grep --line-buffered "sink" | while read -r _; do
    output
done
