#!/bin/sh
# A dmenu wrapper script for system functions.
# Requires: dmenu, xss-lock, and my locking script.

# read init system
case "$(readlink -f /sbin/init)" in
*systemd*) ctl='systemctl' ;;
*) ctl='loginctl' ;;
esac

# Background xss-lock if not already running
if ! pgrep -x "xss-lock" >/dev/null; then
  [ "$XDG_SESSION_TYPE" = x11 ] && xset s 300
  xset dpms 0 0 0
  # xss-lock -n /usr/lib/xsecurelock/dimmer -l -- lock.sh &
  xss-lock -v lock.sh &
fi

options=" Lock
↵ Logout
 Suspend
⏼ Hibernate
 Reboot
 Shutdown
ﴹ Display off"

choice=$(printf "%s" "$options" | dmenu -i -p "Action:")
case "$choice" in
*Lock*) loginctl lock-session ;;
*Logout*) killall -u $USER ;; # equivalent to kill -9 -1 scoped to $USER
*Suspend*) $ctl suspend ;;
*Hibernate*) $ctl suspend-then-hibernate ;;
*Reboot*) $ctl reboot -i ;;
*Shutdown*) $ctl poweroff -i ;;
*Display*off*) xset dpms force off ;; # TODO write a wayland alternative
*) exit 1 ;;
esac
