#!/usr/bin/sh
## Originally from: https://github.com/Barbaross93/Nebula/blob/main/.local/bin/lockscreen.sh
## rewritten to support multi-monitors, additional lockers,
## security features, Wayland, and be POSIX-compliant.
## Requires: i3lock-color, imagemagick, picom, xss-lock

# trap 'kill -9 -$$ %1 %2' EXIT INT

### Generate User Pic for lockscreen.
USER_PIC="$HOME/images/icons/avatar_highres.png" # where your user pic resides
CROP_USER="/tmp/$USER-pic-crop.png"              # where the formatted pic will be generated

if [ -f "$USER_PIC" ] && [ -f "$CROP_USER" ]; then
	true
elif [ ! -f "$USER_PIC" ]; then
	echo "No user picture has been selected."
	exit
elif [ ! -f "$CROP_USER" ]; then
	convert "$USER_PIC" -resize 150x150 -gravity Center \( \
		-size 150x150 xc:Black \
		-fill White \
		-draw "circle 75 75 75 1" \
		-alpha Copy \) -compose CopyOpacity -composite -trim "$CROP_USER"
fi

# see xss-lock(1) and /usr/share/doc/xss-lock/transfer-sleep-lock-i3lock.sh
# if i3lock causes trouble with suspend on your computer. It could also be a
# kernel issue, so installing LTS may fix your bug if all else fails.

## CONFIGURATION ##############################################################

STATUS=$(playerctl status >/dev/null 2>&1 || true)

## Run before starting the locker
pre_lock() {

	# Pause all players
	playerctl -a pause

	# Pause notifications
	pgrep -x dunst && dunstctl set-paused true

	# Ensure picom is running, otherwise blur won't work
	if [ "$XDG_SESSION_TYPE" = x11 ]; then
		pgrep -x picom >/dev/null || picom --experimental-backends &
	fi

	# Kill these just in case
	pkill -x rofi
	pkill -x xcolor

	# Clear gpg-cache and ssh keys prior to lock. pam-gnupg starts it up again after unlock
	gpg-connect-agent --no-autostart reloadagent /bye >/dev/null

	# Clear all clipboard & selections
	[ "$XDG_SESSION_TYPE" = x11 ] && xsel -dbps --logfile /dev/null
	[ "$XDG_SESSION_TYPE" = wayland ] && wl-copy -c

	# TODO is this needed?
	# echo pause >/tmp/signal_bar

	## If using locker w/o screen coverage (e.g. xtrlock, slock with unlockscreen patch)
	# nsxiv -bf ~/.cache/i3lock/$currentWall &
	# unclutter -idle 0 -jitter 99999 & # hide cursor
}

## Variables for lockers
FONT="monospace"
DIM="#0000001A"  # dim screen 10%: https://stackoverflow.com/a/25170174/15593672
BG="#2E3440"     # background color
ACCENT="#81A1C1" # accent color
TEXT="#EFE9F0"   # text color
RIGHT="#88C0D0"  # blue color
WRONG="#BF616A"  # red color

## Options to pass to xsecurelock
# XSECURELOCK_SAVER="/home/barbaross/.local/bin/background.sh"
xlock() {
	XSECURELOCK_AUTH_BACKGROUND_COLOR="$BG" \
		XSECURELOCK_BACKGROUND_COLOR="$BG" \
		XSECURELOCK_AUTH_FOREGROUND_COLOR="$TEXT" \
		XSECURELOCK_DIM_COLOR="$DIM" \
		XSECURELOCK_AUTH_WARNING_COLOR="$WRONG" \
		XSECURELOCK_SHOW_HOSTNAME=0 \
		XSECURELOCK_COMPOSITE_OBSCURER=1 \
		XSECURELOCK_BURNIN_MITIGATION=0 \
		XSECURELOCK_SHOW_USERNAME=0 \
		XSECURELOCK_PASSWORD_PROMPT=time \
		XSECURELOCK_SHOW_DATETIME=0 \
		XSECURELOCK_FONT="$FONT" \
		XSECURELOCK_NO_COMPOSITE=0 \
		XSECURELOCK_BLANK_TIMEOUT=-1 \
		XSECURELOCK_DISCARD_FIRST_KEYPRESS=0 \
		XSECURELOCK_BLANK_DPMS_STATE=off \
		xsecurelock
}

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
		--layout-color="$TEXT" \
		--time-color="$TEXT" \
		--date-color="$TEXT" \
		--modif-color="$TEXT" \
		--insidewrong-color="$BG"D9 \
		--insidever-color="$BG"D9 \
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
} # --no-verify --blur 5 --screen 1 --ind-pos="w/2:h/2-42"

# slock -m "$(lock_msg.sh)" || lock
# i3lock -i ~/Pictures/noise_lock_452f2f.png -e -t -u -n || lock

## Run after the locker exits
post_lock() {

	# Resume most recent players (if active)
	[ "$STATUS" = "Playing" ] && playerctl play

	# Unpause notifications
	pgrep -x dunst && dunstctl set-paused false

	#echo resume >/tmp/signal_bar
	#task sync
	#vdirsyncer sync
}

pre_lock

if [ "$XDG_SESSION_TYPE" = wayland ]; then
	swaylock
elif [ "$XDG_SESSION_TYPE" = x11 ]; then
	case $1 in
	--simple) slock || lock ;;
	--secure) xlock || lock ;;
	*) lock ;;
	esac
else
	echo "Unsupported session type: $XDG_SESSION_TYPE"
fi

post_lock
