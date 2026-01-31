#!/bin/sh

powered="$(bluetoothctl show | grep "Powered" | awk '{print $2}')"

connected_macs="$(bluetoothctl devices Connected | awk '{print $2}')"

if [[ "$powered" != "yes" ]]; then
    printf "<span size='22pt'>󰂲</span> "    
    exit 0
fi

if [[ -z "$connected_macs" ]]; then
    printf "<span size='22pt'>󰂰</span> "
    exit 0
fi

printf "<span size='22pt'>󰂱</span> "
for mac in $connected_macs; do
    name="$(bluetoothctl info "$mac" | grep "Name:" | cut -d ' ' -f2-)"
    printf "%s " "<span foreground='orange'>$name</span>"
done
