#!/usr/bin/env bash

# cycle_android_ringer.sh
# Manage adb connected Android device's ringer mode from linux!

show_help() {
  cat << EOF
Usage: $0 [OPTIONS]
Toggle phone ringer mode via ADB.

OPTIONS:
  -h, --help      Show this help
  -v, --verbose   Verbose output
  -s, --select    Select a mode via rofi
  -m, --mode      Supply a mode (NORMAL = 0, VIBRATE = 1, SILENT = 2)
  -g, --get-mode  Get the current mode (NORMAL = 0, VIBRATE = 1, SILENT = 2)

Invoke the script directly to cycle NORMAL -> VIBRATE -> SILENT

EXAMPLES:
  $0
  $0 -s
  $0 -m 1
EOF
}

VERBOSE=0
MODE=""
GET=false
SELECT=false

while getopts "hvsgm:-:" opt; do
  case $opt in
    h) show_help; exit 0 ;;
    v) VERBOSE=1 ;;
    s) SELECT=true ;;
    m) MODE="$OPTARG" ;;
    g) GET=true ;;
    -) LONG_OPT="${OPTARG%%=*}"
       case $LONG_OPT in
         help) show_help; exit 0 ;;
         verbose) VERBOSE=1 ;;
         select) SELECT=true ;;
         mode) MODE="${OPTARG#*=}" ;;
         get-mode) GET=true ;;
         *) echo "Error: Unknown option --$LONG_OPT" >&2; exit 1 ;;
       esac ;;
    ?) echo "Error: Invalid option -$OPTARG" >&2; show_help >&2; exit 1 ;;
  esac
done
shift $((OPTIND-1))

# Exit if no ADB devices
[[ -z "$(adb devices | grep 'device$')" ]] && {
  #hyprctl notify 3 5000 0 "Error: No ADB device connected"
  echo "Error: No ADB device connected" >&2; exit 1
}

# this is NORMAL=2, VIBRATE=1, SILENT=0, weird android devs
CURRENT=$(adb shell settings get global mode_ringer 2>/dev/null || echo 0)

if [[ "$GET" == true ]]; then
  RET_MODE=""
  case "$CURRENT" in
    2) RET_MODE=0 ;;  # NORMAL
    1) RET_MODE=1 ;;  # VIBRATE
    0|*) RET_MODE=2 ;; # SILENT
  esac

  echo $RET_MODE
  exit 0
fi

# Handle modes
if [[ "$SELECT" == true ]]; then
  MODE=$(echo -e "0 Normal\n1 Vibrate\n2 Silent" | rofi -dmenu -p "Ringer: $CURRENT_NAME -> " -lines 3 -width 20 | cut -d' ' -f1 || echo "$CURRENT")
elif [[ -n "$MODE" ]]; then
  # Explicit mode provided
  :
elif [[ -z "$1" ]]; then
  # No args = cycle
  case "$CURRENT" in
    2) MODE=1 ;;  # NORMAL -> VIBRATE
    1) MODE=2 ;;  # VIBRATE -> SILENT
    0|*) MODE=0 ;; # SILENT -> NORMAL
  esac
else
  echo "Error: Unknown argument '$1'" >&2
  show_help >&2
  exit 1
fi

# Map numeric to string
case "$MODE" in
  0) MODE_STR="NORMAL" ;;
  1) MODE_STR="VIBRATE" ;;
  2) MODE_STR="SILENT" ;;
  *) echo "Error: Mode must be 0,1,2" >&2; exit 1 ;;
esac

# Execute (exit if fails)
[[ $VERBOSE == 1 ]] && echo "Current: $CURRENT -> $MODE_STR"
adb shell cmd audio set-ringer-mode "$MODE_STR" || {
  hyprctl notify 3 5000 0 "Failed to set ringer mode"
  echo "Failed to set ringer mode" >&2; exit 1 
}

hyprctl notify 5 5000 0 "Set ringer to $MODE_STR"
echo "Set ringer to $MODE_STR"
