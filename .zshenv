#!/bin/sh
# profile file, runs on login. Environment variables are set here.

# adds "~/.local/bin" to $PATH
export PATH="$HOME/.local/bin:$PATH"

# see https://unix.stackexchange.com/a/295652/332452
#. /etc/X11/xinit/xinitrc.d/50-systemd-user.sh

# see https://wiki.archlinux.org/title/GNOME/Keyring#xinitrc
#eval "$(/usr/bin/gnome-keyring-daemon --start)"
#export SSH_AUTH_SOCK

# see https://github.com/NixOS/nixpkgs/issues/14966#issuecomment-520083836
#mkdir -p "$HOME/.local/share/keyrings"

## Default programs:
export VISUAL="/usr/bin/nvim"
export EDITOR="$VISUAL"
export TERMINAL="$HOME/.local/bin/alacritty.sh"
export BROWSER="/usr/bin/brave"
export PAGER="/usr/bin/less"

## ~/ Clean-up:
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
#export BRAVE_FLAGS=$(cat $XDG_CONFIG_HOME/brave-flags.conf | sed 's/#.*//')
#export XINITRC="$XDG_CONFIG_HOME/x11/xinitrc"
#export XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority" # This line will break some DMs.
#export ERRFILE="$XDG_DATA_HOME/x11/xsession-errors"
export ICEAUTHORITY="$XDG_CACHE_HOME/ICEauthority"
#export NOTMUCH_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/notmuch-config"
#export GTK2_RC_FILES="${XDG_CONFIG_HOME:-$HOME/.config}/gtk-2.0/gtkrc-2.0"
export LESSHISTFILE="-"
export WGETRC="$XDG_CONFIG_HOME/wget/wgetrc"
export INPUTRC="$XDG_CONFIG_HOME/shell/inputrc"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
#export ALSA_CONFIG_PATH="$XDG_CONFIG_HOME/alsa/asoundrc"
#export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export WINEPREFIX="$XDG_DATA_HOME/wineprefixes/default"
#export KODI_DATA="$XDG_DATA_HOME/kodi"
#export PASSWORD_STORE_DIR="XDG_DATA_HOME/password-store"
#export TMUX_TMPDIR="$XDG_RUNTIME_DIR"
export ANDROID_SDK_HOME="$XDG_CONFIG_HOME/android"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export GOPATH="$XDG_DATA_HOME/go"
#export ANSIBLE_CONFIG="$XDG_CONFIG_HOME/ansible/ansible.cfg"
#export UNISON="$XDG_DATA_HOME/unison"
export HISTFILE="$XDG_DATA_HOME/history"
#export WEECHAT_HOME="$XDG_CONFIG_HOME/weechat"
#export MBSYNCRC="$XDG_CONFIG_HOME/mbsync/config"
#export ELECTRUMDIR="$XDG_DATA_HOME/electrum"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonrc"
export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"

## Other program settings:
#export DICS="/usr/share/stardict/dic/"
export GPG_TTY="$(tty)"
export SUDO_ASKPASS="$HOME/.local/bin/dmenupass"
#export FZF_DEFAULT_OPTS="--layout=reverse --height 40%"
export LESS='-rsiFMx4 --mouse --wheel-lines=5'
#export LESSOPEN="| /usr/bin/highlight -O ansi %s 2>/dev/null"
#export MANPAGER='nvim +Man!'
export LIBVA_DRIVER_NAME=iHD
export QT_QPA_PLATFORMTHEME=gtk2
export PF_INFO="ascii title os host kernel wm pkgs shell editor palette"

## Autostart:
#xrdb "$XDG_CONFIG_HOME/x11/xresources"
#XDG_SESSION_TYPE=x11
#layout
#remaps
#pidof -s "beet" || beet bpd &

#autostart="syncthing --no-browser
#picom --experimental-backends
#lxpolkit
#unclutter
#redshift
#sxhkd
#"
#printf "%s" "$autostart" | while IFS="" read -r program; do
#    pgrep -fl "$program" || $program &
#done >/dev/null 2>&1
