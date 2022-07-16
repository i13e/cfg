#!/bin/sh
# A dmenu wrapper script for system functions.
# Requires: dmenu, xss-lock, and my locking script.

# read init system
case "$(readlink -f /sbin/init)" in
	*systemd*) ctl='systemctl' ;;
	*) ctl='loginctl' ;;
esac

# Background xss-lock if not already running
if [ pgrep -x "xss-lock" >/dev/null ] ; then
    true
else
    xset s 300 5
    xss-lock -n /usr/lib/xsecurelock/dimmer -l -- lock.sh &
fi

options=" Lock
↵ Logout
 Suspend
⏼ Hibernate
 Reboot
 Shutdown
ﴹ Display off"

choice=$(printf "$options" | dmenu -i -p "Action:")
# TODO is lock-session needed on suspend with xss-lock?
case "$choice" in
	*Lock*) loginctl lock-session ;;
	*Logout*) kill -15 -1 ;;
	*Suspend*) loginctl lock-session & $ctl suspend-then-hibernate ;;
	*Hibernate*) loginctl lock-session & $ctl hibernate ;;
	*Reboot*) $ctl reboot -i ;;
	*Shutdown*) $ctl poweroff -i ;;
	*Display*off*) xset dpms force off ;; # TODO write a wayland alternative
	*) exit 1 ;;
esac
