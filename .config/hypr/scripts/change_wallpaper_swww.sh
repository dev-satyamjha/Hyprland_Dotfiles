#!/usr/bin/env bash

path="$1"

if ! [[ -f "$path" ]]; then
	exit 1
fi

# actually change the wallpaper
swww img --transition-type any "$path"

# trigger theme change
wallust run "$path"
