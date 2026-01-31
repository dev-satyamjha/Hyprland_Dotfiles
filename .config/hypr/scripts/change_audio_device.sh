#!/usr/bin/env bash

target_sink=$(pactl list sinks short | awk '{print $2}' | rofi -dmenu -theme audio_device)

if ! [ -z "$target_sink" ]; then
	pactl set-default-sink "$target_sink"
	echo "Sink set to $target_sink"
	notify-send -a "Audio Switcher" -i "audio" "Output Device Changed" "Output Device changed to $target_sink"
else
	echo "Nothing was selected!"
fi

