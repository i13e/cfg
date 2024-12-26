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
# export NOTMUCH_CONFIG="$XDG_CONFIG_HOME/notmuch-config"
# export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc-2.0"

# export WGETRC="$XDG_CONFIG_HOME/wget/wgetrc"
alias wget="wget --hsts-file=$XDG_CACHE_HOME/wget-hsts"

export INPUTRC="$XDG_CONFIG_HOME/shell/inputrc"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
# export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export WINEPREFIX="$XDG_DATA_HOME/wineprefixes/default"
# export KODI_DATA="$XDG_DATA_HOME/kodi"
# export PASSWORD_STORE_DIR="XDG_DATA_HOME/password-store"
# export TMUX_TMPDIR="$XDG_RUNTIME_DIR"
# TODO: export ANDROID_SDK_HOME="$XDG_CONFIG_HOME/android"
export GHCUP_USE_XDG_DIRS=true
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export GOPATH="$XDG_DATA_HOME/go"
# export ANSIBLE_CONFIG="$XDG_CONFIG_HOME/ansible/ansible.cfg"
# export UNISON="$XDG_DATA_HOME/unison"
export HISTFILE="$XDG_DATA_HOME/history"
# export WEECHAT_HOME="$XDG_CONFIG_HOME/weechat"
# export MBSYNCRC="$XDG_CONFIG_HOME/mbsync/config"
# export ELECTRUMDIR="$XDG_DATA_HOME/electrum"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/config.py"

# https://github.com/python/cpython/pull/13208#issuecomment-1877159768
export PYTHONHISTORY="$XDG_STATE_HOME/python/history"

export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"

export KUBECONFIG="$XDG_CONFIG_HOME/kube"
export KUBECACHEDIR="$XDG_CACHE_HOME/kube"

## AWS
export AWS_SHARED_CREDENTIALS_FILE="$XDG_CONFIG_HOME/aws/credentials"
export AWS_CONFIG_FILE="$XDG_CONFIG_HOME/aws/config"


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
