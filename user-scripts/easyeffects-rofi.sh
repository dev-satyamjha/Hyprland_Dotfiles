#!/usr/bin/env bash

THEME="$HOME/.config/rofi/easyeffects.rasi"

PRESET=$(easyeffects -p | \
sed -E 's/^[0-9]+[\.:[:space:]]*//;s/^[[:space:]]*//' | \
rofi -dmenu -theme "$THEME" -i -p "Easy Effects")

if [ -n "$PRESET" ]; then
    easyeffects -l "$PRESET"
    notify-send -i "easyeffects" -a "Easy Effects" "Preset Loaded" "$PRESET"
fi
