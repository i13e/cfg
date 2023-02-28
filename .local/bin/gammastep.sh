#!/bin/bash

url="https://location.services.mozilla.com/v1/geolocate?key=geoclue"

response=$(curl -s -H "Content-Type: application/json" -X POST -d '{}' "$url")
latitude=$(echo "$response" | jq -r '.location.lat')
longitude=$(echo "$response" | jq -r '.location.lng')

gammastep -l "$latitude":"$longitude" &
