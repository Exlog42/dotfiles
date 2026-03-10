#!/bin/bash

# =========================================================
# 社区极简高冷风 (Minimalist Dark) + 浅绿高亮 (Mint Green)
# =========================================================

# 极简基础色 (纯透明与极简白)
BLANK='00000000'
CLEAR='ffffff22'
TEXT_COLOR='eeeeeeff'      # 纯白偏灰的极简文字

# 动态交互核心色 (浅绿色系)
GREEN_MAIN='13e014ff'      # 核心主色调：清透的浅绿色
GREEN_GLOW='89fc8aff'      # 浅绿发光色 (用于验证中环，视觉更亮)
WRONG_RED='f38ba8ff'       # 柔和的警示红 (出错时不刺眼)

i3lock \
--insidever-color=$BLANK        \
--ringver-color=$GREEN_GLOW     \
\
--insidewrong-color=$BLANK      \
--ringwrong-color=$WRONG_RED    \
\
--inside-color=$BLANK           \
--ring-color=$BLANK             \
--line-color=$BLANK             \
--separator-color=$BLANK        \
\
--verif-color=$TEXT_COLOR       \
--wrong-color=$WRONG_RED        \
--time-color=$GREEN_MAIN        \
--date-color=$TEXT_COLOR        \
--layout-color=$TEXT_COLOR      \
--keyhl-color=$GREEN_MAIN       \
--bshl-color=$WRONG_RED         \
\
--screen 1                      \
--blur 9                        \
--clock                         \
--indicator                     \
--time-str="%H:%M"              \
--date-str="%A, %m-%d"          \
--keylayout 1                   \
--ignore-empty-password         \
\
--radius=150                    \
--ring-width=5.0                \
--pass-media-keys               \
--pass-screen-keys              \
--pass-volume-keys              \
\
--time-font="sans-serif"        \
--date-font="sans-serif"        \
--layout-font="sans-serif"      \
--verif-font="sans-serif"       \
--wrong-font="sans-serif"       \
\
--time-size=96                  \
--date-size=24                  \
--layout-size=16                \
--verif-size=28                 \
--wrong-size=28                 \
\
--verif-text="Verifying..."     \
--wrong-text="Auth Failed"      \
--noinput-text=""               \
--lock-text="Locking..."        \
--lockfailed-text="Failed"
