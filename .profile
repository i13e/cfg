#!/bin/bash
# profile file, runs on login. Environment variables are set here.

# adds "~/.local/bin" to $PATH
export PATH="$HOME/.local/bin:$PATH"

# see https://unix.stackexchange.com/a/295652/332452
. /etc/X11/xinit/xinitrc.d/50-systemd-user.sh

# see https://wiki.archlinux.org/title/GNOME/Keyring#xinitrc
eval "$(/usr/bin/gnome-keyring-daemon --start)"
export SSH_AUTH_SOCK

# see https://github.com/NixOS/nixpkgs/issues/14966#issuecomment-520083836
mkdir -p "$HOME/.local/share/keyrings"

# Default programs:
export VISUAL="/usr/bin/nvim"
export EDITOR="$VISUAL"
export TERMINAL="/usr/bin/alacritty"
export BROWSER="/usr/bin/brave"

# ~/ Clean-up:
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
#export BRAVE_FLAGS=$(cat $XDG_CONFIG_HOME/brave-flags.conf | sed 's/#.*//')
#export XINITRC="${XDG_CONFIG_HOME:-$HOME/.config}/x11/xinitrc"
#export XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority" # This line will break some DMs.
#export ERRFILE="$XDG_DATA_HOME/x11/xsession-errors"
export ICEAUTHORITY="$XDG_CACHE_HOME/ICEauthority"
#export NOTMUCH_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/notmuch-config"
#export GTK2_RC_FILES="${XDG_CONFIG_HOME:-$HOME/.config}/gtk-2.0/gtkrc-2.0"
export LESSHISTFILE="-"
export WGETRC="${XDG_CONFIG_HOME:-$HOME/.config}/wget/wgetrc"
export INPUTRC="${XDG_CONFIG_HOME:-$HOME/.config}/shell/inputrc"
export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
#export ALSA_CONFIG_PATH="$XDG_CONFIG_HOME/alsa/asoundrc"
#export GNUPGHOME="${XDG_DATA_HOME:-$HOME/.local/share}/gnupg"
export WINEPREFIX="${XDG_DATA_HOME:-$HOME/.local/share}/wineprefixes/default"
export KODI_DATA="${XDG_DATA_HOME:-$HOME/.local/share}/kodi"
#export TMUX_TMPDIR="$XDG_RUNTIME_DIR"
export ANDROID_SDK_HOME="${XDG_CONFIG_HOME:-$HOME/.config}/android"
export CARGO_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/cargo"
export RUSTUP_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/rustup"
export GOPATH="${XDG_DATA_HOME:-$HOME/.local/share}/go"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonrc"
#export ANSIBLE_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/ansible/ansible.cfg"
#export UNISON="${XDG_DATA_HOME:-$HOME/.local/share}/unison"
export HISTFILE="${XDG_DATA_HOME:-$HOME/.local/share}/history"
#export WEECHAT_HOME="${XDG_CONFIG_HOME:-$HOME/.config}/weechat"
#export MBSYNCRC="${XDG_CONFIG_HOME:-$HOME/.config}/mbsync/config"
#export ELECTRUMDIR="${XDG_DATA_HOME:-$HOME/.local/share}/electrum"

# Other program settings:
#export DICS="/usr/share/stardict/dic/"
export GPG_TTY=$(tty)
export SUDO_ASKPASS="$HOME/.local/bin/dmenupass"
#export FZF_DEFAULT_OPTS="--layout=reverse --height 40%"
export LESS='-rsiFMx4 --mouse --wheel-lines=5'
export PAGER="less"
export LESS_TERMCAP_mb="$(printf '%b' '[1;34m')"
export LESS_TERMCAP_md="$(printf '%b' '[1;34m')"
export LESS_TERMCAP_me="$(printf '%b' '[0m')"
export LESS_TERMCAP_so="$(printf '%b' '[01;35m')"
export LESS_TERMCAP_se="$(printf '%b' '[0m')"
export LESS_TERMCAP_us="$(printf '%b' '[1;32m')"
export LESS_TERMCAP_ue="$(printf '%b' '[0m')"
#export LESSOPEN="| /usr/bin/highlight -O ansi %s 2>/dev/null"
#export QT_QPA_PLATFORMTHEME="gtk2"	# Have QT use gtk2 theme.
export PF_INFO="ascii title os host kernel wm pkgs shell editor palette"
# Autostart
xrdb "$XDG_CONFIG_HOME/x11/xresources"
layout
picom --experimental-backends &
lxpolkit &
sxhkd & remaps
unclutter &
#pidof -s "beet" || setsid -f beet bpd
pidof -s "syncthing" || setsid -f syncthing -no-browser
pidof -s "redshift" || setsid -f redshift
