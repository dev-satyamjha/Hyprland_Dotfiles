#!/usr/bin/env bash

if pidof hyprlock >/dev/null; then
	exit 0
fi

# it will relock the screen
# pkill -USR1 hyprlock
playerctl -s -a pause


play_lock_sound() {
	mpv  /home/satyam/Personaization/lockscreen/splash-impact-zeroframe-audio-1-00-01.mp3 --no-resume-playback &
}

while getopts 'ph' OPTION; do
	case "$OPTION" in
		p)

			play_lock_sound
			;;
		h)
			echo "script usage: $(basename $0) [-p]" >&2
			exit 0
			;;
		\?)
			echo "Invalid option: -$OPTARG" >&2
			exit 1
			;;
	esac
done

shift "$((OPTIND - 1))"

hyprlock 2>&1 | tee /tmp/hyprlock.log &
