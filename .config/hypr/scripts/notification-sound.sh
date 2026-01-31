#!/usr/bin/env bash

SILENT_FILE="/home/satyam/.cache/swaync_is_silent"

path="$1"

if [[ -z "$path" ]]; then
    echo "Usage: $0 <sound_file_path>"
    exit 1
fi

if [[ -f "$SILENT_FILE" ]]; then
	echo "Silent file exists, skipping sound..."
	exit 0
fi

is_dnd=$(swaync-client -D)

if [[ "$is_dnd" == "true" ]]; then
    echo "Notification sound disabled due to Do Not Disturb mode."
    exit 0
fi

if [[ ! -f "$path" ]]; then
    echo "File not found: $path"
    exit 1
fi

# Play the notification sound
canberra-gtk-play -f "$path"

if [[ $? -eq 0 ]]; then
    exit 0
fi

paplay "$path"

if [[ $? -eq 0 ]]; then
    exit 0
fi

echo "Failed to play notification sound."
exit 1
