#!/usr/bin/zsh
# DESC: TODO
# Requires: ERROR MESSAGE IF NOT INSTALLED?

source "$ZDOTDIR/config.zsh"

# Be restrictive with permissions.
{ (( EUID != 0 )) && umask 027; } || umask 077

# If not in tmux, start tmux.
# [[ -z ${TMUX+X}${ZSH_SCRIPT+X}${ZSH_EXECUTION_STRING+X} ]] && exec tmux

# Export shell-specific variables.
export GPG_TTY=$TTY
export LS_COLORS="$(vivid generate iceberg-dark)"
ZSH_CACHE="$XDG_CACHE_HOME/${SHELL##*/}"
ZPLUGDIR="$XDG_DATA_HOME/zsh/plugins"
#export BRAVE_FLAGS=$(cat $XDG_CONFIG_HOME/brave-flags.conf | sed 's/#.*//')

# Make zsh directories if needed.
[ -e "$ZSH_CACHE" ] || mkdir -p "$ZSH_CACHE"
[ -e "$ZPLUGDIR" ] || mkdir -p "$ZPLUGDIR"

# Determines the need for zcompile on many files.
function zcompare() {
    for z in "$@"; do
        [[ -s "$z".zwc && "$z" -ot "$z".zwc ]] && continue
        zcompile -R -- "$z".zwc "$z"
    done
}

# Check if we can read given files and source those we can.
function zsource() {
    (( ${#argv} < 1 )) && {
        printf 'usage: zsource FILE(s)...\n' >&2 ; return 1 ;
    }
    while (( ${#argv} > 0 )) ; do
        [[ -r "$1" ]] && source "$1" ; shift
    done ; return 0
}

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
    [[ -e "$ZPLUGDIR/${plugins[$i]}" ]] && continue
    git clone --depth=1 "${repos[$i]}" "$ZPLUGDIR/${plugins[$i]}"
    # cfg submodule add --shallow "${repos[$i]}" "$ZPLUGDIR/${plugins[$i]}"
    # ln -s $ZPLUGDIR/$file/$file.(plugin.zsh|zsh-theme) $ZPLUGDIR/
done

# Update plugins every 7 days.
zmodload zsh/datetime
zsource "$ZSH_CACHE/autoupdate"
if (( EPOCHSECONDS - LAST_EPOCH >= 7 * 86400 )); then
    echo "Updating plugins..." && cfg submodule update --remote
    echo "LAST_EPOCH=$EPOCHSECONDS" >| "$ZSH_CACHE/autoupdate"
fi

# Activate Powerlevel10k Instant Prompt.
zsource "$XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh"

# Enable the "new" completion system (compsys).
fpath=("$ZDOTDIR/fn" "$ZPLUGDIR/zsh-completions/src" $fpath)
autoload -Uz compinit && compinit -d "$ZSH_CACHE/zcompdump"
zcompare "$ZSH_CACHE/zcompdump" "$ZDOTDIR"/*.zsh
mv -- "$ZPLUGDIR/fast-syntax-highlighting/"{'→chroma','tmp'}
zcompare $(fd -e zsh -e zsh-theme -e ch . "$ZPLUGDIR")
mv -- "$ZPLUGDIR/fast-syntax-highlighting/"{'tmp','→chroma'}

# Don't use any plugins for root.
[[ "$EUID" == 0 || "$TERM" == dumb ]] && return

# Source plugins.
for f in "${plugins[@]}"; do
    zsource "$ZPLUGDIR/$f/$f".{plugin.zsh,zsh-theme}
done

autoload -Uz $ZDOTDIR/fn/*(:t)
autoload -Uz zcalc zmv zargs

## Bootstrap interactive sessions
# pwd in terminal title and currently running command.
precmd() { printf "\e]2;%s\a" "${(V)${(%):-%1~}}" >"$TTY"; }
preexec() { printf "\e]0;${1//\%/%%}\a" >"$TTY"; }

# To customize prompt, run `p10k configure` or edit $ZDOTDIR/p10k.zsh.
zsource "$ZDOTDIR"/{p10k,keybinds,completion,aliases}.zsh

# Source fzf config if installed
(( $+commands[fzf] )) && source "$ZDOTDIR/fzf.zsh"

eval "$(zoxide init zsh)"

unfunction zcompare zsource
