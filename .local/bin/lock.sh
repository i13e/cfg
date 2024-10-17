#!/usr/bin/sh
## Originally from: https://github.com/Barbaross93/Nebula/blob/main/.local/bin/lockscreen.sh
# This script is designed to lock the screen with enhanced security features,
# multi-monitor support, and compatibility with both X11 and Wayland sessions.
# Dependencies: i3lock-color, ImageMagick, picom, xss-lock, playerctl, dunst, slock
# Wayland: wl-copy, swaylock

set -eu
# trap 'kill -9 -$$ %1 %2' EXIT INT

## Generate User Pic for lockscreen.
USER_PIC="$HOME/images/icons/avatar_highres.png" # where your user pic resides
CROP_USER="/tmp/$USER-pic-crop.png"              # where the formatted pic will be generated

## Generate user avatar for lock screen
if [ ! -f "$USER_PIC" ]; then
  echo "No user picture has been selected."
  exit 1
elif [ ! -f "$CROP_USER" ]; then
  magick "$USER_PIC" -resize 150x150 -gravity Center \( \
    -size 150x150 xc:Black -fill White \
    -draw "circle 75 75 75 1" -alpha Copy \) \
    -compose CopyOpacity -composite -trim "$CROP_USER"
fi

STATUS=$(playerctl status || true)

## Pre-lock procedures
pre_lock() {

  # Pause all media players
  playerctl -a pause

  # Pause notifications if dunst is running
  pidof dunst >/dev/null && dunstctl set-paused true

  # Ensure picom is running for blur effect (X11 only)
  if [ "$XDG_SESSION_TYPE" = x11 ]; then
    pgrep -x picom >/dev/null || picom --experimental-backends &
  fi

  # Terminate unnecessary processes
  pidof rofi >/dev/null && pkill -x rofi
  pidof xcolor >/dev/null && pkill -x xcolor

  # Clear GPG and SSH caches
  gpg-connect-agent --no-autostart reloadagent /bye >/dev/null

  # Clear clipboard contents

  # TODO: is this needed?
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

## Configure xsecurelock
xlock() {
  # https://blog.utveckla.re/stuff/i3-fancy-blurred-lockscreen-with-xsecurelock/

  LOCKSCREEN_DIR=~/.cache # this dir must contain a dir called 'lockscreen'
  BLURTYPE="0x8"          # http://www.imagemagick.org/Usage/blur/#blur_args

  mkdir -p ~/.cache/lockscreen

  maim ${LOCKSCREEN_DIR}/lockscreen-plain.png &&
    magick ${LOCKSCREEN_DIR}/lockscreen-plain.png -blur $BLURTYPE ${LOCKSCREEN_DIR}/lockscreen-blurred.png &&
    mv ${LOCKSCREEN_DIR}/lockscreen-blurred.png ${LOCKSCREEN_DIR}/lockscreen/lockscreen.png &

  XSECURELOCK_SAVER=saver_mpv \
    XSECURELOCK_IMAGE_DURATION_SECONDS=3600 \
    XSECURELOCK_LIST_VIDEOS_COMMAND="find ${LOCKSCREEN_DIR}/lockscreen/ -type f" \
    XSECURELOCK_AUTH_BACKGROUND_COLOR="$BG" \
    XSECURELOCK_BACKGROUND_COLOR="$BG" \
    XSECURELOCK_AUTH_FOREGROUND_COLOR="$TEXT" \
    XSECURELOCK_DIM_COLOR="$DIM" \
    XSECURELOCK_AUTH_WARNING_COLOR="$WRONG" \
    XSECURELOCK_SHOW_HOSTNAME=0 \
    XSECURELOCK_COMPOSITE_OBSCURER=1 \
    XSECURELOCK_BURNIN_MITIGATION=0 \
    XSECURELOCK_SHOW_USERNAME=0 \
    XSECURELOCK_PASSWORD_PROMPT=kaomoji \
    XSECURELOCK_FONT=Monospace \
    XSECURELOCK_SHOW_DATETIME=0 \
    XSECURELOCK_FONT="$FONT" \
    XSECURELOCK_NO_COMPOSITE=0 \
    XSECURELOCK_AUTH_TIMEOUT=30 \
    XSECURELOCK_BLANK_TIMEOUT=0 \
    XSECURELOCK_DISCARD_FIRST_KEYPRESS=0 \
    XSECURELOCK_BLANK_DPMS_STATE=off \
    xsecurelock && rm ${LOCKSCREEN_DIR}/lockscreen/lockscreen.png
}

## configure i3lock
# see xss-lock(1) and /usr/share/doc/xss-lock/transfer-sleep-lock-i3lock.sh
# if i3lock causes trouble with suspend on your computer. It could also be a
# kernel issue, so installing LTS may fix your bug if all else fails.
ilock() {
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
  # --no-verify \
  # --blur 5 \
  # --screen 1 \
  # --ind-pos="w/2:h/2-42" \
}

## Post-lock procedures
post_lock() {

  # Resume media players if they were playing before the lock
  [ "$STATUS" = "Playing" ] && playerctl play

  # Unpause notifications
  pidof dunst >/dev/null && dunstctl set-paused false

  #echo resume >/tmp/signal_bar
  #task sync
  #vdirsyncer sync
}

pre_lock

if [ "$XDG_SESSION_TYPE" = wayland ]; then
  wl-copy -c

  swaylock
elif [ "$XDG_SESSION_TYPE" = x11 ]; then
  xsel -cbps --logfile /dev/null

  case ${1:-} in
  --simple) slock ;;
  --secure) xlock ;;
  --fancy) ilock ;;
  *) ilock ;;
  esac
else
  echo "Unsupported session type: $XDG_SESSION_TYPE"
  exit 1
fi
# slock -m "$(lock_msg.sh)" || lock
# i3lock -i ~/Pictures/noise_lock_452f2f.png -e -t -u -n || lock

post_lock
