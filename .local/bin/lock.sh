#!/usr/bin/bash
## Initially from: https://github.com/Barbaross93/Nebula/blob/main/.local/bin/lockscreen.sh
## fixed to work with multi-monitor
## Requires: i3lock-color, imagemagick, picom

set -euo pipefail

USER_PIC="$HOME/images/icons/avatar_highres.png"
CROP_USER="$XDG_CACHE_HOME/$USER-pic-crop.png"

if [[ ! -d "$CROP_USER" ]]; then
    mkdir -p "$XDG_CACHE_HOME"
    convert "$USER_PIC" -resize 140x140 -gravity Center \( \
	-size 140x140 xc:Black \
	-fill White \
	-draw "circle 70 70 70 1" \
	-alpha Copy\
	\) -compose CopyOpacity -composite -trim "$CROP_USER"
fi

# see xss-lock(1) and /usr/share/doc/xss-lock/transfer-sleep-lock-i3lock.sh
# if i3lock causes trouble with suspend on your computer. It could also be a
# kernel issue, so installing LTS may fix your bug if all else fails.

## CONFIGURATION ##############################################################

STATUS=$(media-control status || true)

## Run before starting the locker
pre_lock() {
    if [ "$STATUS" == "Playing" ]; then
        media-control pause
    fi
    dunstctl set-paused true

    # Ensure picom is running otherwise blur won't work
    if pgrep -x "picom" >/dev/null; then
        true
    else
        setsid -f picom --experimental-backends &
    fi

    # If rofi is opened, it grabs the keyboard and borks i3lock. Not sure how to
    # take a general approach to see if the keyboard is actively grabbed
    if pgrep -x rofi; then
        killall rofi
    fi
    return
}

## Variables for i3lock
FONT="monospace"
WRONG="bf616a"

## Options to pass to i3lock
lock() {
    i3lock \
        --color 0000001A \
        --ignore-empty-password \
        --pass-media-keys \
        --pass-volume-keys \
        --pass-screen-keys \
        --pass-power-keys \
        --indicator \
        --nofork \
        --force-clock \
        --image "$CROP_USER" --center \
        --radius 50 \
        --ring-width 3 \
        --time-size 14 \
        --time-str="%R" \
        --date-size 16 \
        --date-str="@$(uname -n)" \
        --time-font="$FONT" \
        --date-font="$FONT" \
        --time-pos="ix:iy+75" \
        --date-pos="ix:iy+130" \
        --time-color=e5e9f0 \
        --date-color=e5e9f0 \
        --line-uses-inside                    \
        --insidever-color=2e3440A8 \
        --insidewrong-color=2e3440A8 \
        --inside-color=2e344000 \
        --ringver-color=88c0d0 \
        --ringwrong-color="$WRONG" \
        --ring-color=81a1c1 \
        --separator-color=81a1c1 \
        --keyhl-color=b48ead \
        --bshl-color="$WRONG" \
        --verif-color=88c0d0                  \
        --wrong-color="$WRONG" \
        --verif-font="$FONT" \
        --wrong-font="$FONT" \
        --greeter-font="$FONT:style=Bold" \
        --greeter-text="$USER"                \
        --greeter-color=8fbcbb                \
        --greeter-pos="ix:iy+110" \
        --greeter-size=18                     \
        --verif-size=10                       \
        --wrong-size=10                       \
        --modif-size=9                        \
        --modif-pos="ix:iy+10"
    } #--no-verify --blur 5 --screen 1 --ind-pos="w/2:h/2-42"

## Run after the locker exits
post_lock() {
    if [ "$STATUS" == "Playing" ]; then
	    media-control play
    fi
    dunstctl set-paused false
    return
}

pre_lock

lock

post_lock
