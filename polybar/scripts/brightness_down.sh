#!/bin/bash
# 降低亮度，但不低于 5%
max=$(brightnessctl max)
min=$((max * 5 / 100))
step=$((max / 100))
current=$(brightnessctl get)
new=$((current - step))
if [ "$new" -lt "$min" ]; then
    brightnessctl set "$min"
else
    brightnessctl set "$new"
fi
