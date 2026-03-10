#!/bin/bash

# see man zscroll for documentation of the following parameters
/home/ryan1iu/miniconda3/bin/zscroll -l 20 \
        --delay 0.1 \
        --scroll-padding "  " \
        --match-command "bash /home/ryan1iu/.config/polybar/scripts/get_spotify_status.sh --status" \
        --match-text "Playing" "--scroll 1" \
        --match-text "Paused" "--scroll 0" \
        --update-check true "bash /home/ryan1iu/.config/polybar/scripts/get_spotify_status.sh" &

wait
