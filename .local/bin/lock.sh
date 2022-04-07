#!/usr/bin/bash
# Mostly from https://github.com/Barbaross93/Genome
# With some cleanup at the end

set -euo pipefail

cachepath=$XDG_CACHE_HOME/lockscreen
cropuser=$cachepath/$USER-pic-crop.png

width=$(xrandr --query | grep ' connected' | grep -o '[0-9][0-9]*x[0-9][0-9]*[^ ]*' | sed -r 's/^[^0-9]*([0-9]+x[0-9]+).*$/\1/' |cut -d "x" -f 1 |head -n1)
height=$(xrandr --query | grep ' connected' | grep -o '[0-9][0-9]*x[0-9][0-9]*[^ ]*' | sed -r 's/^[^0-9]*([0-9]+x[0-9]+).*$/\1/' |cut -d "x" -f 2 |head -n1)
half_width=$((width/2))
half_height=$((height/2))

cropuser() {
  userpic=$HOME/pics/link-coffee.png

	convert $userpic -resize 170x170 -gravity Center \( \
		-size 170x170 xc:Black \
		-fill White \
		-draw "circle 85 85 85 1" \
		-alpha Copy\
		\) -compose CopyOpacity -composite -trim $cropuser
}

blurbg() {
    maim -u "$cachepath/screenshot.png"
	convert "$cachepath/screenshot.png" \
		-filter Gaussian \
		-blur 0x27 \
		"$cachepath/screenshot-blur.png"
}

genbg() {
	if [[ ! -d $cachepath ]]; then
		mkdir -p $cachepath
    cropuser
	fi
	blurbg
	composite -geometry "+$((half_width-85))+$((half_height-137))" $cropuser $cachepath/screenshot-blur.png $cachepath/screenshot-pic-blur.png
}

#genbg

# see xss-lock(1) and /usr/share/doc/xss-lock/transfer-sleep-lock-i3lock.sh
# if i3lock causes trouble with suspend on your computer. It could also be a
# kernel issue, so installing LTS may fix your bug if all else fails.

## CONFIGURATION ##############################################################

status=$(playerctl status || true)

# Run before starting the locker
pre_lock() {
    if [ "$status" == "Playing" ]; then
        playerctl pause
    fi
    dunstctl set-paused true

    #if pgrep -x "picom" >/dev/null; then
        #true
    #else
        #setsid -f picom --experimental-backends &
    #fi

    # If rofi is opened, it grabs the keyboard and borks i3lock. Not sure how to
    # take a general approach to see if the keyboard is actively grabbed
    if pgrep -x rofi; then
        killall rofi
    fi
    return
}

# Options to pass to i3lock
lock() {
    i3lock --nofork                           \
        --color 00000000                      \
        --tiling                              \
        --ignore-empty-password               \
        --screen=1                            \
        --date-str="@$(uname -n)"             \
        --date-pos="w/2:h/2+90"               \
        --indicator                           \
        --force-clock                         \
        --pass-media-keys                     \
        --pass-power-keys                     \
        --pass-volume-keys                    \
        --date-size=16                        \
        --insidever-color=2e3440A8            \
        --insidewrong-color=2e3440A8          \
        --inside-color=2e344000               \
        --ringwrong-color=bf616a              \
        --ring-color=81a1c1                   \
        --ringver-color=88c0d0                \
        --line-uses-inside                    \
        --keyhl-color=b48ead                  \
        --bshl-color=bf616a                   \
        --separator-color=81a1c1              \
        --verif-color=88c0d0                  \
        --wrong-color=bf616a                  \
        --ind-pos="w/2:h/2-42"                \
        --time-color=e5e9f0                   \
        --time-pos="w/2:h/2+35"               \
        --time-str="%R"                       \
        --date-color=e5e9f0                   \
        --time-font="Monospace"               \
        --date-font="Monospace"               \
        --verif-font="Monospace"              \
        --wrong-font="Monospace"              \
        --greeter-font="Monospace:style=Bold" \
        --greeter-text="$USER"                \
        --greeter-color=8fbcbb                \
        --greeter-pos="w/2:h/2+70"            \
        --radius 50                           \
        --ring-width 3                        \
        --greeter-size=18                     \
        --time-size=14                        \
        --verif-size=10                       \
        --wrong-size=10                       \
        --modif-size=9                        \
        --modif-pos="w/2:h/2-15"
    } #--no-verify -i

# Run after the locker exits
post_lock() {
    if [ "$status" == "Playing" ]; then
	    playerctl play
    fi
    dunstctl set-paused false
    return
}

pre_lock

lock

post_lock
