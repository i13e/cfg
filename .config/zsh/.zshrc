#!/usr/bin/zsh
# DESC: TODO
# Requires: fzf, fd, eza, git, vivid, and zoxide

# FIXME
zstyle ':completion:*:default' menu cache-path '$ZSH_CACHE'

source "$ZDOTDIR/config.zsh"

# Be restrictive with permissions.
case (( EUID )) in
  0) umask 077 ;;
  *) umask 027 ;;
esac

# if [ -n "$SSH_CONNECTION" ]; then
#   remote=$(echo $SSH_CONNECTION | awk '{ print $1 }')
#   export DISPLAY="$remote:0.0"
# fi

# BUG: https://superuser.com/a/1757888
export HISTFILE="$XDG_DATA_HOME/history"

export GHCUP_USE_XDG_DIRS=true

# If not in tmux, start tmux.
# [[ -z ${TMUX+X}${ZSH_SCRIPT+X}${ZSH_EXECUTION_STRING+X} ]] && exec tmux

# Export shell-specific variables.
export GPG_TTY=$TTY
export PATH="$XDG_DATA_HOME/nvim/mason/bin:$PATH"
export LS_COLORS="$(vivid generate iceberg-dark)"
ZSH_CACHE="$XDG_CACHE_HOME/${SHELL##*/}"
ZPLUGDIR="$XDG_DATA_HOME/${SHELL##*/}/plugins"
#export TERM=${TERM:=xterm-256color}
#export COLORTERM=${COLORTERM:=truecolor}
#export LC_ALL=en_IN.UTF-8
#export LANG=en_IN.UTF-8
#export BRAVE_FLAGS=$(cat $XDG_CONFIG_HOME/brave-flags.conf | sed 's/#.*//')

# Make zsh directories if needed.
mkdir -p "$ZSH_CACHE" "$ZPLUGDIR"

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
  "https://github.com/zdharma-continuum/fast-syntax-highlighting.git"
  "https://github.com/zsh-users/zsh-completions.git"
  "https://github.com/zsh-users/zsh-autosuggestions.git"
  "https://github.com/zsh-users/zsh-history-substring-search.git"
  "https://github.com/romkatv/powerlevel10k.git"
  "https://github.com/hlissner/zsh-autopair.git"
  "https://github.com/kazhala/dotbare.git"
)
plugins=(${repos:t:r})

# Clone missing plugins. Be sure to commit any new plugins to Remote
for (( i = 1; i <= $#repos; i++ )); do
  [[ -e "$ZPLUGDIR/${plugins[i]}" ]] && continue
  if (( $+aliases[cfg] )) ; then
    cfg submodule add --shallow "${repos[i]}" "$ZPLUGDIR/${plugins[i]}"
  else
    git clone --depth=1 "${repos[i]}" "$ZPLUGDIR/${plugins[i]}"
  fi
done

# Activate Powerlevel10k Instant Prompt.
zsource "$XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh"

# Enable the "new" completion system (compsys).
fpath=("$ZDOTDIR"/fn "$ZPLUGDIR"/zsh-completions/src $fpath)
autoload -Uz "$ZDOTDIR"/fn/*(:t) zmv zargs
autoload -Uz compinit && compinit -d "$ZSH_CACHE"/zcompdump
zcompare "$ZSH_CACHE"/zcompdump "$ZDOTDIR"/*.zsh
mv -- "$ZPLUGDIR"/fast-syntax-highlighting/{"→chroma","tmp"}
zcompare $(find "$ZPLUGDIR" -type f -regex ".*\.\(zsh\|zsh-theme\|ch\)")
mv -- "$ZPLUGDIR"/fast-syntax-highlighting/{"tmp","→chroma"}

# Don't use any plugins for root.
[[ "$EUID" == 0 || "$TERM" == dumb ]] && return

# Source plugins.
for f in "${plugins[@]}"; do
    zsource "$ZPLUGDIR/$f/$f".{plugin.zsh,zsh-theme}
done

# pwd in terminal title and currently running command.
function precmd() { printf "\e]2;%s\a" "${(V)${(%):-%1~}}" >"$TTY"; }
function preexec() { printf "\e]0;$1\a" >"$TTY"; }

# To customize prompt, run `p10k configure` or edit $ZDOTDIR/p10k.zsh.
zsource "$ZDOTDIR"/{p10k,aliases,completion,keybinds}.zsh

# If commands are installed, initialize.
(( $+commands[fzf] )) && source "$ZDOTDIR/fzf.zsh"
(( $+commands[zoxide] )) && eval "$(zoxide init zsh)"
(( $+commands[fnm] )) && eval "$(fnm env --use-on-cd)"

unfunction zcompare zload zsource
