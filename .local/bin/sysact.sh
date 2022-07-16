#!/bin/sh
# A dmenu wrapper script for system functions. loginctl lock-session is
# reliant on running xss-lock in the background.

# read init system
case "$(readlink -f /sbin/init)" in
	*systemd*) ctl='systemctl' ;;
	*) ctl='loginctl' ;;
esac

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
	*Lock*) loginctl lock-session || lock.sh ;;
	*Logout*) kill -15 -1 ;;
	*Suspend*) loginctl lock-session & $ctl suspend-then-hibernate ;;
	*Hibernate*) loginctl lock-session & $ctl hibernate ;;
	*Reboot*) $ctl reboot -i ;;
	*Shutdown*) $ctl poweroff -i ;;
	*Display*off*) xset dpms force off ;; # TODO write a wayland alternative
	*) exit 1 ;;
esac
