#!/bin/bash

last="unknown"

upower -m |
while read -r _time _2 _3 device; do
  [ "$device" = "/org/freedesktop/UPower/devices/line_power_AC" ] || continue
  state=$(acpi -a | awk '{print $3}')
  
  if [ $state == 'on-line' ]; then
  	if [ "$last" != 'on-line' ]; then
    	notify-send -a "Power" -i "battery" "Charger Connected" "Charging" #-h string:x-canonical-private-synchronous:anything -h int:value:$(acpi -b | grep -o '\w+%' | cut -d'%' -f1)
  
        last="on-line"
        pkill -SIGRTMIN+4 waybar
    fi
  elif [ $state == 'off-line' ]; then
  	if [ "$last" != 'off-line' ]; then
  		notify-send -a "Power" -i "battery-full" "Charger Disconnected" "Discharging" #-h string:x-canonical-private-synchronous:anything -h int:value:$(acpi -b | grep -o '\w+%' | cut -d'%' -f1)
  		
  	    last="off-line"
  	    pkill -SIGRTMIN+4 waybar
	fi
  fi
done
