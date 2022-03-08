alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias q=exit
alias clr=clear
alias sudo='sudo '
alias rm='rm -Iv'
alias cp='cp -iv'
alias mv='mv -iv'
alias mkdir='mkdir -pv'
alias wget='wget -c --hsts-file="$XDG_CACHE_HOME/wget-hsts"'
alias path='echo -e ${PATH//:/\\n}'
alias btm='btm --battery'
alias ports='sudo ss -tulanp'

# youtube-dlp
alias ydl='youtube-dlp -o "./%(title)s.%(ext)s"'
alias yhd='youtube-dlp -f "[height<=720]" -o "~/Videos/%(uploader)s/%(title)s.%(ext)s" --no-playlist '
alias ymp3='youtube-dlp -f "bestaudio" -o "~/Music/%(uploader)s/%(title)s.%(ext)s" --no-playlist -x --audio-format mp3 --embed-thumbnail '
alias ypl3='youtube-dlp -f "bestaudio" -o "~/Music/%(uploader)s/%(playlist)s/%(title)s.%(ext)s" -x --audio-format mp3 --embed-thumbnail'
alias yt='youtube-dl --add-metadate -i'
alias yta='yt -x -f bestaudio/best'

# arch
alias unlock='sudo rm /var/lib/pacman/db.lck' # remove pacman lock
alias cleanup='paru -Rns $(paru -Qtdq) ; paccache -ruk0'
alias pacfind='pacman -Slq | fzf --multi --preview 'pacman -Si {1}' | xargs -ro sudo pacman -S'

alias mk="make"
alias gurl='curl --compressed'
alias sha='shasum -a 256'
alias sync='syncthing -browser-only'

alias mount='mount |column -t'
# Editor
#alias vim='nvim'
#alias em='/usr/bin/emacs -nw'
#alias e="emacsclient -c -a 'emacs'"
#alias em='devour emacsclient -c -a emacs'
#alias et='emacsclient -t -a emacs'
#alias doom='~/.config/emacs/bin/doom'

# NOTE: personal aliases
alias cfg='/usr/bin/git --git-dir=$HOME/.config/cfg/ --work-tree=$HOME'
alias moshlax='mosh munchlax -- tmux a'
alias build='rm -f ~/docs/code/sites/ianb/dst/.files && ssg6 ~/docs/code/sites/ianb/src ~/docs/code/sites/ianb/dst "Ian B." "https://ianb.io"'
alias deploy='rsync -avzhP --delete-after --chmod=755 ~/docs/code/sites/ianb/dst/ munchlax:/var/www/ianb'

alias ipp='curl ipinfo.io/ip'
alias lofi='mpv --volume=50 --no-video --no-audio-display --pause=no --force-window=no "https://www.youtube.com/watch?v=5qap5aO4i9A"'
#alias sudo='sudo -v; sudo '
#alias miccheck='arecord -vvv -f dat /dev/null'
# Add flags to existing aliases.
#alias ls="${aliases[ls]:-ls} -A"
# dfc & ncdu aliases
alias df='dfc -s'
alias du='ncdu --color dark'
# broot
alias br='br -dhp'
alias bs='br --sizes'
# gpg encryption
# verify signature for isos
alias gpg-check="gpg2 --keyserver-options auto-key-retrieve --verify"
# receive the key of a developer
alias gpg-retrieve="gpg2 --keyserver-options auto-key-retrieve --receive-keys"
## get top process eating memory
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'
## get top process eating cpu ##
alias pscpu='ps auxf | sort -nr -k 3'
alias pscpu10='ps auxf | sort -nr -k 3 | head -10'
alias shutdown='sudo shutdown'
alias reboot='sudo reboot'

# An rsync that respects gitignore
function rcp {
  # -a = -rlptgoD
  #   -r = recursive
  #   -l = copy symlinks as symlinks
  #   -p = preserve permissions
  #   -t = preserve mtimes
  #   -g = preserve owning group
  #   -o = preserve owner
  # -z = use compression
  # -P = show progress on transferred file
  # -J = don't touch mtimes on symlinks (always errors)
  rsync -azPJ \
    --include=.git/ \
    --filter=':- .gitignore' \
    --filter=":- $XDG_CONFIG_HOME/git/ignore" \
    "$@"
}; compdef rcp=rsync
alias rcpd='rcp --delete --delete-after'
alias rcpu='rcp --chmod=go='
alias rcpdu='rcpd --chmod=go='






alias y='xclip -selection clipboard -in'
alias p='xclip -selection clipboard -out'

alias jc='journalctl -xe'
alias sc=systemctl
alias ssc='sudo systemctl'
alias jctl='sudo journalctl'
alias sctl='sudo systemctl'

# save search engines in chrome/brave/etc
#sqlite3 -csv ~/.config/BraveSoftware/Brave-Browser/Default/Web\ Data 'select short_name,keyword,url from keywords' > ~/search-engines.csv
# check if installed

if (( $+commands[devour] )); then
    alias z='devour zathura';
    alias m='devour umpv';
    alias sxiv='devour nsxiv -a';

    # open a twitch stream in mpv
    function twitch { streamlink --twitch-disable-hosting --twitch-disable-reruns\
        --twitch-disable-ads -p "devour mpv -" "http://twitch.tv/$@" 720p60 }
fi
if (( $+commands[exa] )); then
    alias ls='exa -al --color=always --color-scale --git --group-directories-first';
    alias la='exa -a --color=always --group-directories-first'  # all files and dirs
    alias ll='exa -l --color=always --group-directories-first'  # long format
    alias tree='exa -aTI .git';
fi

if (( $+commands[paru] )); then
    alias upd='checkupd && autosnap-wrapper && hostupd'
fi

if (( $+commands[fasd] )); then
  # fuzzy completion with 'z' when called without args
  unalias z 2>/dev/null
  function z {
    [ $# -gt 0 ] && _z "$*" && return
    cd "$(_z -l 2>&1 | fzf --height 40% --nth 2.. --reverse --inline-info +s --tac --query "${*##-* }" | sed 's/^[0-9,.]* *//')"
  }
fi

autoload -U zmv

# make directory and enter it
function take {
  mkdir "$1" && cd "$1";
}; compdef take=mkdir

function zman {
  PAGER="less -g -I -s '+/^       "$1"'" man zshall;
}

# Create a reminder with human-readable durations, e.g. 15m, 1h, 40s, etc
function r {
  local time=$1; shift
  sched "$time" "notify-send --urgency=critical 'Reminder' '$@'; ding";
}; compdef r=sched

function cheat { curl cht.sh/$1 }

function lie {
    if [[ "$1" == "not" ]]
    then
        unset GIT_AUTHOR_DATE
        unset GIT_COMMITTER_DATE
        return 0
    fi
    export GIT_AUTHOR_DATE="$1"
    export export GIT_COMMITTER_DATE="$1"
}

# https://news.ycombinator.com/item?id=18898898
function pycd { pushd `python -c "import os.path, $1; print(os.path.dirname($1.__file__))"`; }

# set terminal window title
function precmd { print -Pn "\e]0;%~\a"; }
function preexec { print -Pn "\e]0;${1//\%/%%}\a"; }
