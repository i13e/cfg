#!/bin/bash
set -euo pipefail
# url="https://location.services.mozilla.com/v1/geolocate?key=geoclue"
#
# response=$(curl -s -H "Content-Type: application/json" -X POST -d '{}' "$url")
# latitude=$(echo "$response" | jq -r '.location.lat')
# longitude=$(echo "$response" | jq -r '.location.lng')
#
# gammastep -l "$latitude":"$longitude" &

IFS=$'\n\t'

if [ ! -z "$(pgrep gammastep)" ]; then
  killall gammastep
  wait
fi

gpsinfo="$(curl -s ipinfo.io | sed 's/[" ]//g')"
lat=$(echo "$gpsinfo" | awk -F '[:,]' '/loc/{print $2}')
lon=$(echo "$gpsinfo" | awk -F '[:,]' '/loc/{print $3}')

gammastep -l $lat:$lon 2>/dev/null &

echo "Latitude: $lat"
echo "Longitude: $lon"
