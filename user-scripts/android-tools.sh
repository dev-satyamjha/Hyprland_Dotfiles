#!/usr/bin/env bash

# Function to log messages with a timestamp
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

log_message "--- Script Started ---"

MODE="$1"
VIDEO="$2"
AUDIO="$3"
if [ -z "$MODE" ]; then
    log_message "ERROR: No mode provided. Must provide to run the scrcpy."
    exit 1
fi

if [ -z "$VIDEO" ]; then
    log_message "INFO: No video mode provided. Using Default Display."
fi

if [ -z "$AUDIO" ]; then
    log_message "INFO: No audio mode provided. Using Default Output."
fi

APP_NAME="Android Tools"

FPS=60
VCODEC="h265" # h264, h265, av1 (not all devices have this)
ACODEC="opus" # opus, aac, raw, flac

RECORD_FILE="Videos/Android/$(date +%Y%m%d%H%M%S).mp4"

FLAGS=""

case $MODE in
	"Mirror" | "") ;;
	"Mirror - No Control") FLAGS+=" --no-control --video-buffer=200 --audio-buffer=200";;
	"Record") FLAGS+=" --record=$RECORD_FILE";;
	"Record - No Window") FLAGS+=" --record=$RECORD_FILE --no-window --video-buffer=200 --audio-buffer=200" ;;
	"New Display") 
		APP=$(adb shell pm list packages | rofi -dmenu | cut -d ':' -f 2)
		FLAGS+=" --new-display --start-app=$APP"
		;;
	*)
		log_message "Unknown Mode Passed $MODE"
		notify-send $APP_NAME "Unknown Mode Passed $MODE"
		exit 1
		;;
esac

case $VIDEO in
	"Display" | "") ;;
	"Camera - Back") FLAGS+=" --video-source=camera --orientation=90";;
	"Camera - Front") FLAGS+=" --video-source=camera --orientation=90 --camera-facing=front";;
	"Webcam")
		notify-send $APP_NAME "Webcam Not Implemented yet"
		log_mesaage "Webcam Not Implemented Yet"
		exit 1
		;;
	"No Video") FLAGS+=" --no-video --audio-buffer=200";;
	*)
		log_message "Unknown Video Mode Passed $VIDEO"
		notify-send $APP_NAME "Unknown Video Mode Passed $VIDEO"
		exit 1
		;;
esac

case $AUDIO in
	"Output" | "") ;;
	"Playback") FLAGS+=" --audio-source=playback" ;;
	"Mic") FLAGS+=" --audio-source=mic" ;;
	"Voice Call") FLAGS+=" --audio-source=voice-call" ;;
	"Voice Call Uplink") FLAGS+=" --audio-source=voice-call-uplink" ;;
	"Voice Call Downlink") FLAGS+=" --audio-source=voice-call-downlink" ;;
	"Mic Communication") FLAGS+=" --audio-source=mic-voice-communication" ;;
	"Mic Camcorder") FLAGS+=" --audio-source=mic-camcorder" ;;
	*)
		log_message "Unknown Audio Mode Passed $AUDIO"
		notify-send $APP_NAME "Unknown Audio Mode Passed $AUDIO"
		exit 1
		;;
esac

CMD="scrcpy -e \
--max-size=1024 \
--video-bit-rate=2M \
--max-fps=$FPS \
--video-codec=$VCODEC \
--video-encoder=c2.qti.hevc.encoder \
--audio-codec=$ACODEC \
--keyboard=uhid \
--mouse=uhid \
$FLAGS"

log_message "Executing $CMD"

konsole --noclose -e $CMD


