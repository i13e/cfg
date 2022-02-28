alias jctl='sudo journalctl'
alias sctl='sudo systemctl'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias -- -='cd -'
alias cdg='cd `git rev-parse --show-toplevel`'
alias ydl='youtube-dl -o "./%(title)s.%(ext)s"'
alias yhd='youtube-dl -f "[height<=720]" -o "~/Videos/%(uploader)s/%(title)s.%(ext)s" --no-playlist '
alias ymp3='youtube-dl -f "bestaudio" -o "~/Music/%(uploader)s/%(title)s.%(ext)s" --no-playlist -x --audio-format mp3 --embed-thumbnail '
alias ypl3='youtube-dl -f "bestaudio" -o "~/Music/%(uploader)s/%(playlist)s/%(title)s.%(ext)s" -x --audio-format mp3 --embed-thumbnail'
alias q=exit
alias clr=clear
alias sudo='sudo '
alias rm='rm -Iv'
alias cp='cp -iv'
alias mv='mv -iv'
alias mkdir='mkdir -pv'
alias path='echo -e ${PATH//:/\\n}'
alias ports='sudo ss -tulanp'
alias mk="make"
alias gurl='curl --compressed'
alias unlock='sudo rm /var/lib/pacman/db.lck' # remove pacman lock
alias cleanup='paru -Rns $(paru -Qtdq) & paccache -ruk0'
alias sha='shasum -a 256'
alias sync='syncthing -browser-only'
# rsync for website
alias build='rm -f ~/docs/code/sites/ianb/dst/.files && ssg6 ~/docs/code/sites/ianb/src ~/docs/code/sites/ianb/dst "Ian B." "https://ianb.io"'
alias deploy='rsync -avzhP --delete-after --chmod=755 ~/docs/code/sites/ianb/dst/ munchlax:/var/www/ianb'
# bare repo alias
alias cfg='/usr/bin/git --git-dir=$HOME/.config/cfg/ --work-tree=$HOME'
alias mount='mount |column -t'
alias pacfind='pacman -Slq | fzf --multi --preview 'pacman -Si {1}' | xargs -ro sudo pacman -S'
alias btm='btm --battery'
alias yahaha='echo "you found me"'
# Editor
#alias vim='nvim'
alias em='/usr/bin/emacs -nw'
alias e="emacsclient -c -a 'emacs'"
#alias em='devour emacsclient -c -a emacs'
#alias et='emacsclient -t -a emacs'
alias wget='wget -c --hsts-file="$XDG_CACHE_HOME/wget-hsts"'
alias doom='~/.config/emacs/bin/doom'
alias moshlax='mosh munchlax -- tmux a'
alias ipp='curl ipinfo.io/ip'
alias yt='youtube-dl --add-metadate -i'
alias lofi='mpv --volume=50 --no-video --no-audio-display --pause=no --force-window=no "https://www.youtube.com/watch?v=5qap5aO4i9A"'
alias yta='yt -x -f bestaudio/best'
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
rcp() {
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

if command -v devour >/dev/null; then
  alias z='devour zathura';
  alias m='devour umpv';
  alias sxiv='devour nsxiv -a';
fi


if command -v exa >/dev/null; then
  alias ls='exa -al --color=always --color-scale --git --group-directories-first';
  alias la='exa -a --color=always --group-directories-first'  # all files and dirs
  alias ll='exa -l --color=always --group-directories-first'  # long format
  alias tree='exa -aTI .git';
fi

if command -v paru >/dev/null; then
	alias upd='checkupd && autosnap-wrapper && hostupd && z4h update';
fi

autoload -U zmv

take() {
  mkdir "$1" && cd "$1";
}; compdef take=mkdir

zman() {
  PAGER="less -g -I -s '+/^       "$1"'" man zshall;
}

# Create a reminder with human-readable durations, e.g. 15m, 1h, 40s, etc
r() {
  local time=$1; shift
  sched "$time" "notify-send --urgency=critical 'Reminder' '$@'; ding";
}; compdef r=sched
