#!/bin/sh
# A dmenu wrapper script for system functions.

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
⏻ Shutdown
ﴹ Display off"

choice=$(echo "$options" | dmenu -i -p "Action:")

case "$choice" in
	*Lock*) lock.sh ;;
	*Logout*) kill -9 -1 ;;
	*Suspend*) lock.sh & systemctl suspend-then-hibernate ;;
	*Hibernate*) lock.sh & systemctl hibernate ;;
	*Reboot*) $ctl reboot -i ;;
	*Shutdown*) $ctl poweroff -i ;;
	*Display*off*) xset dpms force off ;;
	*) exit 1 ;;
esac
