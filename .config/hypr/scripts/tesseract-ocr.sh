#!/usr/bin/env bash

# Check if wl-copy is installed
if ! command -v wl-copy &> /dev/null; then
	notify-send -u critical "Error" "wl-copy is not installed. Please install it to copy to the clipboard."
	exit 1
fi

if ! command -v tesseract &> /dev/null; then
	notify-send -u critical "Error" "tesseract is not installed. Please install it."
	exit 1
fi

if ! command -v magick &> /dev/null; then
	notify-send -u critical "Error" "magick is not installed. Please install it."
	exit 1
fi

tmp_file=$(mktemp /tmp/ocr.XXXXXX.png)

# take and save the screenshot
grim -g "$(slurp -d -c D1E5F4BB -b 1B232866 -s 00000000)" "$tmp_file"

if ! [ -f "$tmp_file" ]; then
    # no screenshot was captured
    exit 0;
fi

# process the image first for best OCR results
# magick "$tmp_file" -colorspace Gray -auto-level -define filter:blur=0x6 -adaptive-blur 0x4 -auto-threshold otsu "$tmp_file"

# run ocr on it and copy the text
text=$(tesseract -l eng "$tmp_file" -)

if [ -z "$text" ]; then
	# probably text wasn't english
	# get all languages installed
	lang=$(tesseract --list-langs | awk 'NR > 1 {print $1}' | sed 's/ /_/g' | rofi -dmenu -i -p "Select Language for OCR:")

	if [ -z "$lang" ]; then
		# User cancelled language selection
		rm "$tmp_file"
		exit 1
	fi

	echo "Trying with $lang"

	text=$(tesseract -l "$lang" "$tmp_file" -)

	if [ -z "$text" ]; then
		# not good anymore
		rm "$tmp_file"
    	notify-send -u critical "Error" "OCR failed even with language '$lang'. Check image quality or language."
		exit 1
	fi
fi

# remove the screenshot
rm "$tmp_file"

text=$(echo "$text" | tr -d '\r')
text=$(echo "$text" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
text=$(echo "$text" | sed '/^$/d')

# copy the text
echo -n "$text" | wl-copy

# Truncate the text for the notification
if [ ${#text} -gt 100 ]; then
	truncated_text="${text:0:100}..." 
else
	truncated_text="$text"
fi

# copy the text to clipboard
echo -n "$text" | wl-copy

# notify user with the truncated OCR'd text
notify-send -i tesseract "Copied Text" "$truncated_text"
