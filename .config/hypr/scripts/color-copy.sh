!#/usr/bin/env bash

COPIED_COLOR=$(wl-paste)

COPIED_COLOR=$(echo "$COPIED_COLOR" | tr -d '" ' | tr -d '\n')

magick -size 128x128 xc:"rgb($COPIED_COLOR)" /tmp/color.png && notify-send -i /tmp/color.png "Copied Color" "$COPIED_COLOR"