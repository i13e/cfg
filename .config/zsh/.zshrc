# Ian's config for the Zoomer Shell
# https://github.com/romkatv/zsh4humans
# Personal Zsh configuration file. It is strongly recommended to keep all
# shell customization and configuration (including exported environment
# variables such as PATH) in this file or in files source by it.
# Documentation: https://github.com/romkatv/zsh4humans/blob/v4/README.md.
#
# Periodic auto-update on Zsh startup: 'ask' or 'no'.
zstyle ':z4h:'                auto-update      'ask'
# Ask whether to auto-update this often; has no effect if auto-update is 'no'.
zstyle ':z4h:'                auto-update-days '28'
HISTORY_IGNORE="(?|??|cd|cd [~-.]|cd ..|tmux|vim|declare|env|alias|exit|history *|pwd|clear|jobs|mount|m *|mpv *|em *|um|um *|vim */private/*|vim private/*|cd private|cd private/*)"
# Keyboard type: 'mac' or 'pc'.
zstyle ':z4h:bindkey'         keyboard         'pc'
# When fzf menu opens on TAB, another TAB moves the cursor down ('tab:down')
# or accepts the selection and triggers another TAB-completion ('tab:repeat')?
zstyle ':z4h:fzf-complete'    fzf-bindings     'tab:down'
# When fzf menu opens on Alt+Down, TAB moves the cursor down ('tab:down')
# or accepts the selection and triggers another Alt+Down ('tab:repeat')?
zstyle ':z4h:cd-down'         fzf-bindings     'tab:down'
# Right-arrow key accepts one character ('partial-accept') from
# command autosuggestions or the whole thing ('accept')?
zstyle ':z4h:autosuggestions' forward-char     'accept'

# Send these files over to the remote host when connecting over ssh.
# Multiple files can be listed here.
zstyle ':z4h:ssh:*'           send-extra-files '~/.iterm2_shell_integration.zsh'
# Disable automatic teleportation of z4h over ssh when connecting to some-host.
# This makes `ssh some-host` equivalent to `command ssh some-host`.
zstyle ':z4h:ssh:some-host'   passthrough      'yes'

# Move the cursor to the end when Up/Down fetches a command from history?
zstyle ':zle:up-line-or-beginning-search'   leave-cursor 'yes'
zstyle ':zle:down-line-or-beginning-search' leave-cursor 'yes'

# Clone additional Git repositories from GitHub.
#
# Install or update core components (fzf, zsh-autosuggestions, etc.) and
# initialize Zsh. After this point console I/O is unavailable until Zsh
# is fully initialized. Everything that requires user interaction or can
# perform network I/O must be done above. Everything else is best done below.
z4h init || return

# Export environmental variables.

# Default Apps
export EDITOR="nvim"
export READER="zathura"
export VISUAL="emacsclient -n -a emacs"
export TERMINAL="alacritty"
export BROWSER="brave"
export COLORTERM="truecolor"
export OPENER="xdg-open"
export PAGER="less"
export GPG_TTY=$TTY
export LESS='-RiF --mouse --wheel-lines=3'
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export LESSHISTFILE=-
export WGET="$XDG_CONFIG_HOME/wgetrc"
export HISTFILE="$XDG_DATA_HOME/bash/history"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export GOPATH="$XDG_DATA_HOME/go"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"

# Extend PATH.
path=(~/.local/bin $path)

# Use additional Git repositories pulled in with `z4h install`.
#
# This is just an example that you should delete. It does nothing useful.
#z4h source $Z4H/ohmyzsh/ohmyzsh/lib/diagnostics.zsh
#z4h source $Z4H/ohmyzsh/ohmyzsh/plugins/emoji-clock/emoji-clock.plugin.zsh
#fpath+=($Z4H/ohmyzsh/ohmyzsh/plugins/supervisor)

# Source additional local files if they exist.
z4h source ~/.iterm2_shell_integration.zsh

# Define key bindings.
z4h bindkey z4h-backward-kill-word  Ctrl+Backspace Ctrl+H
z4h bindkey z4h-backward-kill-zword Ctrl+Alt+Backspace

z4h bindkey undo Ctrl+/  # undo the last command line change
z4h bindkey redo Alt+/   # redo the last undone command line change

z4h bindkey z4h-cd-back    Alt+Left   # cd into the previous directory
z4h bindkey z4h-cd-forward Alt+Right  # cd into the next directory
z4h bindkey z4h-cd-up      Alt+Up     # cd into the parent directory
z4h bindkey z4h-cd-down    Alt+Down   # cd into a child directory

# Autoload functions.
autoload -Uz zmv

# Define functions and completions.
function md() { [[ $# == 1 ]] && mkdir -p -- "$1" && cd -- "$1" }
compdef _directories md


ipif() {
    if grep -P "(([1-9]\d{0,2})\.){3}(?2)" <<< "$1"; then
	 curl ipinfo.io/"$1"
    else
	ipawk=($(host "$1" | awk '/address/ { print $NF }'))
	curl ipinfo.io/${ipawk[1]}
    fi
    echo }

# Curl gitignore templates
# Usage: gi <template>
gi() {curl -Ls https://gitignore.io/api/$@;}

# Backup
bak() { cp $1 $1.bak }

# Replace `ssh` with `z4h ssh` to automatically teleport z4h to remote hosts.
function ssh() { z4h ssh "$@" }

# Define named directories: ~w <=> Windows home directory on WSL.
[[ -n $z4h_win_home ]] && hash -d w=$z4h_win_home


# Define aliases.
alias sync='syncthing -browser-only'
alias build='rm -f ~/docs/code/sites/ianb/dst/.files && ssg6 ~/docs/code/sites/ianb/src ~/docs/code/sites/ianb/dst "Ian B." "https://ianb.io"'
alias sctl='sudo systemctl'
alias jctl='sudo journalctl -p3 -xe'
# Nav
alias ...='../..'
alias .3='../../..'
alias .4='../../../..'
alias .5='../../../../..'
# LS
alias mount='mount |column -t'
alias tree='exa -aTI .git'
alias ls='exa -al --color=always --color-scale --git --group-directories-first'
alias la='exa -a --color=always --group-directories-first'
alias ports='sudo ss -tunlp'
# Editor 
#alias vim='nvim'
alias em='/usr/bin/emacs -nw'
alias e="emacsclient -c -a 'emacs'"
#alias em='devour emacsclient -c -a emacs'
#alias et='emacsclient -t -a emacs'
alias deploy='chmod -R 755 ~/docs/code/sites/ianb && rsync -vruP --delete-after ~/docs/code/sites/ianb/dst/ munchlax:/var/www/ianb'
alias wget='wget --hsts-file="$XDG_CACHE_HOME/wget-hsts"'
alias doom='~/.config/emacs/bin/doom'
alias upd='checkupd && paru -Syu && hostupd && z4h update'
alias cp='cp -riv'
alias mv='mv -iv'
alias rm='rm -Iv'
alias moshlax='mosh munchlax -- tmux a'
alias mkdir='mkdir -pv'
alias ipp='curl ipinfo.io/ip'
alias sha='shasum -a 256'
alias yt='youtube-dl --add-metadate -i'
alias lofi='mpv --volume=50 --no-video --no-audio-display --pause=no --force-window=no "https://www.youtube.com/watch?v=5qap5aO4i9A"'
alias yta='yt -x -f bestaudio/best'
alias g='git'
alias cfg='/usr/bin/git --git-dir=$HOME/.config/cfg/ --work-tree=$HOME'
alias z='devour zathura'
alias m='devour umpv'
alias sxiv='devour sxiv'
#alias sudo='sudo -v; sudo '
alias unlock='sudo rm /var/lib/pacman/db.lck' # remove pacman lock
alias miccheck='arecord -vvv -f dat /dev/null'
# Add flags to existing aliases.
#alias ls="${aliases[ls]:-ls} -A"
# Set shell options: http://zsh.sourceforge.net/Doc/Release/Options.html.
setopt glob_dots     # no special treatment for file names with a leading dot
setopt no_auto_menu  # require an extra TAB press to open the completion menu

# Use Nord dircolors theme
#test -r "~/.config/dircolors" && eval $(dircolors ~/.config/dircolors)

# Integrate FZF with terminal color scheme
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPTS='
    --exact
    --reverse
    --no-bold
    --prompt=❯\ 
    --color=16
    --color=bg:-1,bg+:8
    --color=fg:-1,fg+:-1
    --color=hl:2,hl+:2
    --color=prompt:5
    --color=pointer:6
    --color=marker:11
    --color=spinner:6
    --color=info:6'

# Color Man Pages
export LESS_TERMCAP_mb=$'\E[1;34m'     # begin bold
export LESS_TERMCAP_md=$'\E[1;34m'     # begin blink
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\E[01;35m'    # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

# Syntax Highlighting 
typeset -A ZSH_HIGHLIGHT_STYLES

ZSH_HIGHLIGHT_STYLES[alias]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[function]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[command]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=white,bold'
ZSH_HIGHLIGHT_STYLES[redirection]='fg=white,bold'
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=white,bold'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=white,bold'
