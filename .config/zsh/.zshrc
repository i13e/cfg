#!/usr/bin/zsh
# DESC: Put basic settings for zsh here.
# DEPS: fzf, fd, eza, git, vivid, zoxide

# Be restrictive with permissions.
umask $(( EUID == 0 ? 077 : 027 ))

# TODO:
# if [ -n "$SSH_CONNECTION" ]; then
#   remote=$(echo $SSH_CONNECTION | awk '{ print $1 }')
#   export DISPLAY="$remote:0.0"
# fi
# If not in tmux, start tmux.
# [[ -z ${TMUX+X}${ZSH_SCRIPT+X}${ZSH_EXECUTION_STRING+X} ]] && exec tmux

# Export shell-specific variables.
export GPG_TTY=$TTY

# Put nvim formatters on the PATH
export PATH="$XDG_DATA_HOME/nvim/mason/bin:$PATH"

export LS_COLORS="$(vivid generate iceberg-dark)"
# BUG: https://superuser.com/a/1757888
export HISTFILE="$XDG_DATA_HOME/history"

# FIXME what do these do?
export GHCUP_USE_XDG_DIRS=true
# export TERM=${TERM:=xterm-256color}
# export COLORTERM=${COLORTERM:=truecolor}
# export LC_ALL=en_IN.UTF-8
# export LANG=en_IN.UTF-8

# Ensure required dirs exist
ZSH_CACHE="$XDG_CACHE_HOME/${SHELL##*/}"
ZPLUGDIR="$XDG_DATA_HOME/${SHELL##*/}/plugins"
mkdir -p "$ZSH_CACHE" "$ZPLUGDIR"

# FIXME
zstyle ':completion:*:default' menu cache-path '$ZSH_CACHE'

source "$ZDOTDIR/config.zsh"

# Function to autoload and bind Zsh functions.
# Usage: zload function_name [function_name2 ...]
function zload() {
    for z in "$@"; do
        autoload -Uz "$z" && zle -N "$z"
    done
}

# Function to autoload and bind Zsh functions.
# Usage: zcompare file_name [file_name2 ...]
function zcompare() {
    for z in "$@"; do
        [[ -s "$z".zwc && "$z" -ot "$z".zwc ]] && continue
        zcompile -R -- "$z".zwc "$z"
    done
}

# Function to source readable files.
# Usage: zsource FILE [FILE2 ...]
function zsource() {
  for z in "$@"; do
    [[ -r "$z" ]] && source "$z"
  done
}

# NOTE: Be careful about plugin load order or subtle breakage can emerge.
repos=(
  # "jeffreytse/zsh-vi-mode"
  "https://github.com/Aloxaf/fzf-tab.git"
  "https://github.com/zsh-users/zsh-syntax-highlighting.git"
  "https://github.com/zsh-users/zsh-completions.git"
  "https://github.com/zsh-users/zsh-autosuggestions.git"
  "https://github.com/zsh-users/zsh-history-substring-search.git"
  # "https://github.com/romkatv/powerlevel10k.git"
  "https://github.com/andydecleyre/zpy"
  "https://github.com/hlissner/zsh-autopair.git"
  "https://github.com/kazhala/dotbare.git"
)
plugins=(${repos:t:r})

# Clone missing plugins, add to submodules if in bare repo
for (( i = 1; i <= $#repos; i++ )); do
  [[ -e "$ZPLUGDIR/${plugins[i]}" ]] && continue
  if (( $+aliases[cfg] )) ; then
    cfg submodule add --shallow "${repos[i]}" "$ZPLUGDIR/${plugins[i]}"
  else
    git clone --depth=1 "${repos[i]}" "$ZPLUGDIR/${plugins[i]}"
  fi
done

# Enable the "new" completion system (compsys).
fpath=($ZDOTDIR/fn $fpath)
autoload -Uz - $ZDOTDIR/fn/*(D:t)
autoload -Uz $ZDOTDIR/fn/*(:t) zmv zargs add-zsh-hook
autoload -Uz compinit && compinit -d $ZSH_CACHE/zcompdump

# Byte-compile configs and plugin files
zcompare $ZSH_CACHE/zcompdump $ZDOTDIR/*.zsh
zcompare $(find $ZPLUGDIR -type f -regex ".*\.\(zsh\|zsh-theme\|ch\)")

# Don't use any plugins for root.
[[ "$EUID" == 0 || "$TERM" == dumb ]] && return

# Source plugins.
for f in "${plugins[@]}"; do
    zsource "$ZPLUGDIR/$f/$f".{plugin.zsh,zsh-theme}
done

# add-zsh-hook chpwd get_py_venv
# add-zsh-hook chpwd zsh-dirprofiles
# add-zsh-hook chpwd fire_ls
# pwd in terminal title and currently running command.
function precmd() { printf "\e]2;%s\a" "${(V)${(%):-%1~}}" >"$TTY"; }
function preexec() { printf "\e]0;$1\a" >"$TTY"; }

zsource "$ZDOTDIR"/{aliases,completion,keybinds}.zsh

# If commands are installed, initialize.
# (( $+commands[fzf] )) && source "$ZDOTDIR/fzf.zsh"
(( $+commands[zoxide] )) && eval "$(zoxide init zsh)"
(( $+commands[fnm] )) && eval "$(fnm env --use-on-cd)"
(( $+commands[starship] )) && eval "$(starship init zsh)"
(( $+commands[mise] )) && eval "$(mise activate zsh)"

zstyle ":zpy:*" exposed-funcs pipz zpy

unfunction zcompare zload zsource
