#!/bin/sh
# Description: Runs on login. Static environment variables are set here.

# adds "~/.local/bin" to $PATH
export PATH="$HOME/.local/bin:$PATH"

# see https://unix.stackexchange.com/a/295652/332452
#. /etc/X11/xinit/xinitrc.d/50-systemd-user.sh

# see https://wiki.archlinux.org/title/GNOME/Keyring#xinitrc
#eval "$(/usr/bin/gnome-keyring-daemon --start)"
#export SSH_AUTH_SOCK

# see https://github.com/NixOS/nixpkgs/issues/14966#issuecomment-520083836
#mkdir -p "$HOME/.local/share/keyrings"

## Default programs.
# export VISUAL="emacsclient -nw -c -a ''"
export VISUAL="nvim"
export EDITOR="$VISUAL"
export TERMINAL="/usr/bin/wezterm"
export BROWSER="brave"
export PAGER="less"

## $HOME Clean-up.
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XINITRC="$XDG_CONFIG_HOME/x11/xinitrc"
# export XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority" # This line will break some DMs.
export ERRFILE="$XDG_DATA_HOME/x11/xsession-errors"
export ICEAUTHORITY="$XDG_CACHE_HOME/ICEauthority"
# export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc-2.0"

# export WGETRC="$XDG_CONFIG_HOME/wget/wgetrc"
alias wget="wget --hsts-file=$XDG_CACHE_HOME/wget-hsts"

export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
# export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export WINEPREFIX="$XDG_DATA_HOME/wineprefixes/default"
# export TMUX_TMPDIR="$XDG_RUNTIME_DIR"
# export ANDROID_SDK_HOME="$XDG_CONFIG_HOME/android"
export GHCUP_USE_XDG_DIRS=true
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export GOPATH="$XDG_DATA_HOME/go"
export HISTFILE="$XDG_DATA_HOME/history"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"

# https://github.com/python/cpython/pull/13208#issuecomment-1877159768
export PYTHONHISTORY="$XDG_STATE_HOME/python/history"

export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"
export KUBECONFIG="$XDG_CONFIG_HOME/kube"
export KUBECACHEDIR="$XDG_CACHE_HOME/kube"

## Other program settings.
# export DICS="/usr/share/stardict/dic/"
export SUDO_ASKPASS="$HOME/.local/bin/dmenupass"
export LESS='-isRFMx4 --mouse --wheel-lines=5' # giMRSwz-4
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANROFFOPT='-c'
# export LESSOPEN="| /usr/bin/highlight -O ansi %s 2>/dev/null"
# export MANPAGER='nvim +Man!'
export LIBVA_DRIVER_NAME=iHD
export QT_QPA_PLATFORMTHEME=gtk2
export PF_INFO="ascii title os host kernel wm pkgs shell editor palette"
