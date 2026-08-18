#!/bin/sh
# 为每个屏幕设置独立壁纸
# eDP-1: 内置屏（横屏）, DP-2: 外接屏（竖屏）
set -u

WALL_DIR="$HOME/Pictures"

# 内置屏（始终存在）
xwallpaper --output eDP-1 --zoom "$WALL_DIR/bingimg_20250909_UHD.jpg"

# 外接屏（可能未连接，检测后再设置，避免报错）
if xrandr --query | grep -q '^DP-2 connected'; then
    xwallpaper --output DP-2 --zoom "$WALL_DIR/wallhaven-5yd6d5_1920x1200.png"
fi
