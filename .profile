#!/bin/sh

# see https://unix.stackexchange.com/a/295652/332452
. /etc/X11/xinit/xinitrc.d/50-systemd-user.sh

# see https://wiki.archlinux.org/title/GNOME/Keyring#xinitrc
eval "$(/usr/bin/gnome-keyring-daemon --start)"
export SSH_AUTH_SOCK

# see https://github.com/NixOS/nixpkgs/issues/14966#issuecomment-520083836
mkdir -p "$HOME/.local/share/keyrings"

# Export Variables
export PATH="$HOME/.local/bin:$PATH"
export VISUAL="/usr/bin/nvim"
export EDITOR="$VISUAL"
export TERMINAL="/usr/bin/alacritty"
export BROWSER="/usr/bin/brave"
export SUDO_ASKPASS="$HOME/.local/bin/dmenupass"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export ICEAUTHORITY="$XDG_CACHE_HOME/ICEauthority"
export WGETRC="$XDG_CONFIG_HOME/wgetrc"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export GPG_TTY=$(tty)
export ERRFILE="$XDG_DATA_HOME/x11/xsession-errors"

# Autostart
layout
xrdb "$XDG_CONFIG_HOME"/x11/xresources
picom --experimental-backends &
lxpolkit &
sxhkd & remaps
unclutter &
pidof -s "beet" || setsid -f beet bpd
pidof -s "syncthing" || setsid -f syncthing -no-browser
pidof -s "redshift" || setsid -f redshift
