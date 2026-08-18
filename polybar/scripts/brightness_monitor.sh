#!/bin/bash
# 实时轮询亮度变化并输出百分比
last=""
while true; do
    current=$(brightnessctl -m | cut -d',' -f4)
    if [ "$current" != "$last" ]; then
        echo "$current"
        last="$current"
    fi
    sleep 0.2
done
