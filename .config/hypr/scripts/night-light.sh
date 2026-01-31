#!/usr/bin/env bash

DEFAULT_TEMPERATURE=6000
WARM_TEMPERATURE=4500

current="$(hyprctl hyprsunset temperature)"

[ $# -eq 1 ] && {
	if [ "$current" -eq "$DEFAULT_TEMPERATURE" ]; then
		echo '{"text":"<big>󱣗</big>  ", "tooltip":"Normal Temperature", "class": "inactive"}'
	else
		echo '{"text":"<big>󱣗</big>  ", "tooltip": "Temperature Changed", "class": "active"}'
	fi
} || {
	if [ "$current" -eq "$DEFAULT_TEMPERATURE" ]; then
		notify-send -a "Night Light" "Temperature Changed" "Temperature set to ${WARM_TEMPERATURE}K" -e -r "9875"
		hyprctl hyprsunset temperature "$WARM_TEMPERATURE"
	else
		notify-send -a "Night Light" "Temperature Changed" "Temperature set to ${DEFAULT_TEMPERATURE}K" -e -r "9875"
		hyprctl hyprsunset temperature "$DEFAULT_TEMPERATURE"
	fi

	pkill -SIGRTMIN+3 waybar
}

