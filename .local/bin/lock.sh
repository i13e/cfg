#!/usr/bin/sh
## Originally from: https://github.com/Barbaross93/Nebula/blob/main/.local/bin/lockscreen.sh
## rewritten to work with multi-monitor setups and be POSIX-compliant
## Requires: i3lock-color, imagemagick, picom

USER_PIC="$HOME/images/icons/avatar_highres.png" # where your user pic resides
CROP_USER="/tmp/$USER-pic-crop.png" # where the formatted pic will be generated


if [ -f "$USER_PIC" ] && [ -f "$CROP_USER" ]; then
    true
elif [ ! -f "$USER_PIC" ]; then
    echo "No user picture has been selected."; exit
elif [ ! -f "$CROP_USER" ]; then
    convert "$USER_PIC" -resize 150x150 -gravity Center \( \
	-size 150x150 xc:Black \
	-fill White \
	-draw "circle 75 75 75 1" \
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

    # Pause music
    if [ "$STATUS" = "Playing" ]; then
        media-control pause
    fi

    # Pause notifications
    if pgrep -x "dunst"; then
        dunstctl set-paused true
    fi

    # Ensure picom is running otherwise blur won't work
    if pgrep -x "picom"; then
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
DIM="0000001A" # dim screen 10%: https://stackoverflow.com/a/25170174/15593672
ACCENT="81A1C1"
WHITE="EFE9F0"
DARK="2E3440D9"
RIGHT="88C0D0"
WRONG="BF616A"

## Options to pass to i3lock
lock() {
    i3lock \
        --color="$DIM" \
        --inside-color="$DIM" \
        --ignore-empty-password \
        --show-failed-attempts \
        --pass-media-keys \
        --pass-screen-keys \
        --pass-power-keys \
        --pass-volume-keys \
        --force-clock \
        --nofork \
        --image "$CROP_USER" --center \
        --indicator \
        --line-uses-inside \
        --radius=55 \
        --ring-width=3 \
        --time-str="%a %d, %R" \
        --date-str="@$(uname -n)" \
        --verif-text="Verifying…" \
        --wrong-text="Access Denied" \
        --greeter-text="$USER" \
        --keyhl-color=b48ead \
        --greeter-color=8fbcbb \
        --ring-color="$ACCENT" \
        --separator-color="$ACCENT" \
        --layout-color="$WHITE" \
        --time-color="$WHITE" \
        --date-color="$WHITE" \
        --modif-color="$WHITE" \
        --insidewrong-color="$DARK" \
        --insidever-color="$DARK" \
        --keylayout 0 \
        --verif-color="$RIGHT" \
        --ringver-color="$RIGHT" \
        --bshl-color="$WRONG" \
        --wrong-color="$WRONG" \
        --ringwrong-color="$WRONG" \
        --layout-font="$FONT" \
        --time-font="$FONT" \
        --date-font="$FONT" \
        --verif-font="$FONT" \
        --wrong-font="$FONT" \
        --greeter-font="$FONT:style=Bold" \
        --time-pos="ix:iy+80" \
        --date-pos="ix:iy+135" \
        --greeter-pos="ix:iy+115" \
        --verif-size=12 \
        --wrong-size=12 \
        --modif-size=12 \
        --time-size=14 \
        --date-size=16 \
        --greeter-size=18
    } #--no-verify --blur 5 --screen 1 --ind-pos="w/2:h/2-42"
    #--layout



## Run after the locker exits
post_lock() {
    if [ "$STATUS" = "Playing" ]; then
	    media-control play
    fi

    if pgrep -x dunst; then
        dunstctl set-paused false
    fi

    return
}

pre_lock

lock

post_lock
