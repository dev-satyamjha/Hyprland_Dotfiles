#!/usr/bin/env bash

WEATHER_CACHE=/tmp/weather_cache

if ! [ -f "$WEATHER_CACHE" ]; then
	echo "Weather cache file does not exist. Please create it." >&2
	exit 1;
fi

if [ -z "$WEATHER_CACHE" ]; then
	echo "Weather cache file exists but does not contain any data. Please populate it with weather data." >&2
fi

weather="$(cat $WEATHER_CACHE)"
text="$(echo $weather | jq .text | tr -d \")"

echo "$text"
