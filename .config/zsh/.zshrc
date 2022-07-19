#!/usr/bin/zsh
# Description

# If .zprofile wasn't sourced, source it.
[ -z "$XDG_CONFIG_HOME" ] && . "$HOME/.zprofile"

source "$ZDOTDIR/config.zsh"

# Be restrictive with permissions.
(( EUID != 0 )) && umask 027 || umask 077

# Make zsh directories if needed.
ZSH_CACHE="$XDG_CACHE_HOME/${SHELL##*/}"
ZPLUGDIR="$XDG_DATA_HOME/zsh/plugins"
[ -e "$ZSH_CACHE" ] || mkdir -p "$ZSH_CACHE"
[ -e "$ZPLUGDIR" ] || mkdir -p "$ZPLUGDIR"

# If not in tmux, start tmux.
#[[ -z ${TMUX+X}${ZSH_SCRIPT+X}${ZSH_EXECUTION_STRING+X} ]] && exec tmux

# Cache output of commands.
zcache() {
    (( $+commands[$1] )) || return 1
    local z="$ZSH_CACHE/$1"
    [ -s $z -a "$(command -v $1)" -nt $z ] || "$@" >| $z
    source $z
}

# Determines the need for zcompile on many files.
zcompare() {
    for z in "$@"; do
        [[ -s $z.zwc && $z -ot $z.zwc ]] && continue
        zcompile -R -- $z.zwc $z
    done
}

# Source many files, safely.
zsource() {
    for z in "$@"; do
        [[ -s $z ]] && source $z
    done
}

alias cfg='/usr/bin/git --git-dir=$HOME/.config/cfg/ --work-tree=$HOME'

# NOTE: Be careful about plugin load order or subtle breakage can emerge.
repos=(
    #"jeffreytse/zsh-vi-mode"
    "https://github.com/Aloxaf/fzf-tab.git"
    "https://github.com/zdharma-continuum/fast-syntax-highlighting.git"
    "https://github.com/zsh-users/zsh-completions.git"
    "https://github.com/zsh-users/zsh-autosuggestions.git"
    "https://github.com/zsh-users/zsh-history-substring-search.git"
    "https://github.com/romkatv/powerlevel10k.git"
    "https://github.com/hlissner/zsh-autopair.git"
    "https://github.com/kazhala/dotbare.git"
)
plugins=(${repos:t:r})

## Clone missing plugins.
for (( i = 1; i <= $#repos; i++ )); do
    [[ -e "$ZPLUGDIR/$plugins[$i]" ]] && continue
    git clone --depth=1 "$repos[$i]" "$ZPLUGDIR/$plugins[$i]"
    # cfg submodule add --shallow "$repos[$i]" "$ZPLUGDIR/$plugins[$i]"
    # ln -s $ZPLUGDIR/$file/$file.(plugin.zsh|zsh-theme) $ZPLUGDIR/
done

# Update plugins every 7 days.
zmodload zsh/datetime
[ -e "$ZSH_CACHE/autoupdate" ] && . "$ZSH_CACHE/autoupdate"
if (( EPOCHSECONDS - LAST_EPOCH >= 7 * 86400 )); then
    echo "Updating plugins..." && cfg submodule update --remote
    echo "LAST_EPOCH=$EPOCHSECONDS" >| "$ZSH_CACHE/autoupdate"
fi

# Activate Powerlevel10k Instant Prompt.
zsource "$XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh"

# Enable the "new" completion system (compsys).
fpath=($ZPLUGDIR/zsh-completions/src $fpath)
autoload -Uz compinit && compinit -d $ZSH_CACHE/zcompdump
zcompare $ZSH_CACHE/zcompdump
zcompare $ZDOTDIR/*.zsh
zcompare $(find "$ZPLUGDIR" -name "*.zsh" -or -name "*.zsh-theme")

ZSH_AUTOSUGGEST_MANUAL_REBIND=1

# Don't use any plugins for root.
[[ "$EUID" == 0 || "$TERM" == dumb ]] && return

# Source plugins.
for f in $plugins; do
    zsource $ZPLUGDIR/$f/$f.(plugin.zsh|zsh-theme)
done

## Bootstrap interactive sessions

# Set incorrectly in zprofile.
export GPG_TTY=$TTY

# Change cursor shape to beam and pwd in terminal title
precmd() { printf "\e]0;%s\a" ${(V)${(%):-%1~}} >$TTY; printf "\e[5 q" >$TTY }
preexec() { printf "\e]0;%s\a" ${(V)${(%):-%1~}} >$TTY; printf "\e[5 q" >$TTY }

# To customize prompt, run `p10k configure` or edit $ZDOTDIR/p10k.zsh.
zsource $ZDOTDIR/{p10k,keybinds,completion,aliases}.zsh

#[ -x /usr/bin/fzf ] && source "$ZPLUGDIR/fzf.zsh"

zcache fasd --init posix-alias zsh-{hook,{c,w}comp{,-install}}

unfunction zcompare zsource zcache
