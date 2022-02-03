#!/usr/bin/sh

# progress-notify - Send audio and brightness notifications for dunst

# dependencies: dunstify, pulsemixer

### How to use: ###
# Pass the values via stdin and provide the notification type
# as an argument. Options are audio, brightness and muted

### Audio notifications ###
#   ponymix increase 5 | notify audio
#   ponymix decrease 5 | notify audio
#   pulsemixer --toggle-mute --get-mute | notify muted
### Brightness notifications ###
#   xbacklight -inc 5  && xbacklight -get | notify brightness
#   xbacklight -dec 5  && xbacklight -get | notify brightness

notifyMuted() {
        volume="$1"
        dunstify -h string:x-canonical-private-synchronous:audio "󰖁 Muted" -h int:value:"$volume" -t 1500
}

notifyAudio() {
        volume="$1"
        pulsemixer --get-muted && notifyMuted "$volume" && return

        if [ "$volume" -le 25 ]; then
                dunstify -h string:x-canonical-private-synchronous:audio "󰕿 Volume: " -h int:value:"$volume" -t 1500
        elif [ "$volume" -le 75 ]; then
                dunstify -h string:x-canonical-private-synchronous:audio "󰖀 Volume: " -h int:value:"$volume" -t 1500
        else
                dunstify -h string:x-canonical-private-synchronous:audio "󰕾 Volume: " -h int:value:"$volume" -t 1500
        fi
}

notifyBrightness() {
        brightness="$1"
        if [ "$brightness" -le 25 ]; then
                dunstify -h string:x-canonical-private-synchronous:brightness "󰃞 Brightness: " -h int:value:"$brightness" -t 1500
        elif [ "$brightness" -le 75 ]; then
                dunstify -h string:x-canonical-private-synchronous:brightness "󰃟 Brightness: " -h int:value:"$brightness" -t 1500
        else
                dunstify -h string:x-canonical-private-synchronous:brightness "󰃠 Brightness: " -h int:value:"$brightness" -t 1500
        fi
}

input=$(cat /dev/stdin)

case "$1" in
        muted)
		volume=$(pulsemixer --get-volume)
                if [ "$input" -eq 0 ]
                then
                        notifyAudio "$volume"
                else
                        notifyMuted "$volume"
                fi
                ;;
        audio)
                notifyAudio "$input"
                ;;
        brightness)
                notifyBrightness "$input"
                ;;

        *)
                echo "Not the right arguments"
                echo "$1"
                exit 2
esac
