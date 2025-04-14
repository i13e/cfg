# Define an associative array for aliases
# TODO https://stackoverflow.com/questions/22097130/delete-all-broken-symbolic-links-with-a-line
# TODO https://stackoverflow.com/questions/19331497/set-environment-variables-from-file-of-key-value-pairs?rq=1
# FIXME https://stackoverflow.com/a/11512211/15593672
#find /path/to/dir -type f -exec chmod 640 {} \;
#find /path/to/dir -type d -exec chmod 750 {} \;
#zsh delete broken symlinks from directory stackoverflow
typeset -A real_aliases=(
# Verbosity and settings that you almost always will want.
    chgrp 'chgrp --preserve-root -vc'
    chmod 'chmod --preserve-root -vc'
    chown 'chown --preserve-root -vc'
    cp 'cp -iv'
    df 'df -h'
    du 'ncdu -ch'
    ffmpeg 'ffmpeg -hide_banner'
    mkdir 'mkdir -pv'
    mv 'mv -iv'
    path 'echo -e ${PATH//:/\\n}'
    ports 'ss -tulpn'
    rm 'rm -Iv'
    yt 'yt-dlp --embed-metadata -i'
    yta 'yt -x -f bestaudio/best'
# Colorize commands when possible.
    grep 'grep --color=auto'
    egrep 'egrep --color=auto'
    fgrep 'fgrep --color=auto'
    diff 'diff --color=auto'
    ip 'ip -color=auto'
# These common commands are too long! Abbreviate them.
    cleanup 'pacman -Rns $(pacman -Qtdq) ; paccache -ruk0'
    clr ' clear'
    mpv 'umpv'
    doom '$XDG_CONFIG_HOME/emacs/bin/doom'
    ipp 'curl -s https://ipinfo.io/ | jq .ip'
    jctl 'journalctl'
    mk 'make'
    open ' xdg-open'
    pfetch 'wget -qO- https://raw.github.com/dylanaraps/pfetch/master/pfetch | sh'
    q ' exit'
    sctl 'systemctl'
    sha 'shasum -a 256'
    ta 'tmux attach -t'
    tl 'tmux list-sessions'
    ts 'tmux new-session -s'
    unlock 'sudo rm /var/lib/pacman/db.lck'
    wttr 'curl https://wttr.in/'
    xx 'atool -x'
    del 'gio trash'
)
for key val in "${(@kv)real_aliases}"; do
    alias "$key=$val"
done

global_aliases=(
  :: ':>!'

  B '`git rev-parse --abbrev-ref HEAD`'

  V "|& less"
  G "|& egrep --color"
  S "|& sort"
  R "|& sort -rn"
  L "|& wc -l | sed 's/^\ *//'"

  H  "|& head"
  T  "|& tail"
  H1 "H -n 1"
  T1 "T -n 1"

  ZF '*(.L0)'     # zero-length regular files
  ZD '*(/L0)'     # zero-length directories

  AE '{,.}*'      # all files, including dot files
  AF '**/*(.)'    # all regular files
  AD '**/*(/)'    # all directories
  AS '**/*(@)'    # all symlinks

  OF '*(.om[-1])' # oldest regular file
  OD '*(/om[-1])' # oldest directory
  OS '*(@om[-1])' # oldest symlink

  NF '*(.om[1])'  # newest regular file
  ND '*(/om[1])'  # newest directory
  NS '*(@om[1])'  # newest symlink
)
for key val in "${(@kv)global_aliases}"; do
    alias -g "$key=$val"
done


alias -s {ape,avi,flv,m4a,mkv,mov,mp3,mp4,mpeg,mpg,ogg,ogm,wav,webm}=mpv
alias -s {pdf}=zathura
zsource /usr/share/doc/pkgfile/command-not-found.zsh
# alias -s git="git clone"

# https://wiki.archlinux.org/index.php/Sudo#Passing_aliases
alias sudo='sudo '

# https://wiki.archlinux.org/title/sudo#Reduce_the_number_of_times_you_have_to_type_a_password
# alias sudo='sudo -v; sudo '

#${${commands[nvim]:t}:-vi}
# Use $XINITRC variable if file exists.
[ -f "$XINITRC" ] && alias startx="startx $XINITRC"

(( $+commands[nvim] )) && alias {vim,vi}='nvim' vi{diff,mdiff}='nvim -d'
(( $+commands[eza] )) && alias eza='eza --icons --git --group-directories-first --color-scale=all'
(( $+commands[prettyping] )) && alias ping='prettyping -nolegend'

# Define an array of system commands
cmds=(
    "journalctl"
    "mount"
    "pacman"
    "poweroff"
    "reboot"
    "shutdown"
    "ss"
    "su"
    "sv"
    "systemctl"
    "ufw"
    "umount"
    "updatedb"
)

# Create aliases for each command with sudo
for cmd in "${cmds[@]}"; do
    alias "$cmd"="sudo $cmd"
done; unset cmd

# python virtual env alias
alias activate="source env/bin/activate"


alias xpropc='xprop | grep WM_CLASS' # display xprop class
alias spotify="/usr/bin/spotify --force-device-scale-factor=1.3"
#if os = arch
alias pacfind='pacman -Slq | fzf --multi --preview 'pacman -Si {1}' | xargs -ro sudo pacman -S'
alias gurl='curl --compressed'
alias sync='syncthing -browser-only'
# alias mount='mount |column -t'
#alias em='/usr/bin/emacs -nw'
#alias e="emacsclient -c -a 'emacs'"
#alias em='devour emacsclient -c -a emacs'
#alias et='emacsclient -t -a emacs'


#alias lofi='mpv --volume=50 --no-video --no-audio-display --pause=no --force-window=no "https://www.youtube.com/watch?v=5qap5aO4i9A"'

# TODO Add aliases for new tools
# TODO will I still use these tools?
#alias df='dfc -s'
#alias du='ncdu --color dark'

# gpg encryption
# verify signature for isos
alias gpg-check="gpg --keyserver-options auto-key-retrieve --verify"
# receive the key of a developer
alias gpg-retrieve="gpg --keyserver-options auto-key-retrieve --receive-keys"
## get top process eating memory
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'
## get top process eating cpu ##
alias pscpu='ps auxf | sort -nr -k 3'
alias pscpu10='ps auxf | sort -nr -k 3 | head -10'


# Bat
# From: https://github.com/sharkdp/bat
alias -g -- -h='-h 2>&1 | bat --language=help --style=plain'
alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'

# DESC: Colorize man pages.
function man() {
	env \
        LESS_TERMCAP_mb="$(printf "\e[1;34m")" \
        LESS_TERMCAP_md="$(printf "\e[1;34m")" \
        LESS_TERMCAP_me="$(printf "\e[0m")" \
        LESS_TERMCAP_se="$(printf "\e[0m")" \
        LESS_TERMCAP_so="$(printf "\e[01;35m")" \
        LESS_TERMCAP_ue="$(printf "\e[0m")" \
        LESS_TERMCAP_us="$(printf "\e[1;32m")" \
		man "$@"
}

# function lf() {
#     local tempfile="$(mktemp)"
#     command lf -command "map Q \$echo \$PWD >$tempfile; lf -remote \"send \$id quit\"" "$@"
#
#     if [[ -f "$tempfile" ]] && [[ "$(cat -- "$tempfile")" != "$(echo -n $(pwd))" ]]; then
#           cd -- "$(cat "$tempfile")" || return
#     fi
#     command rm -f -- "$tempfile" 2>/dev/null
# }

# DESC: An rsync that respects gitignore.
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

# DESC: save search engines in chrome/brave/etc
#sqlite3 -csv ~/.config/BraveSoftware/Brave-Browser/Default/Web\ Data 'select short_name,keyword,url from keywords' > ~/search-engines.csv

# TODO rework this.
if (( $+commands[devour] )); then
    alias zath='devour zathura';
    # alias umpv='devour umpv';
    alias sxiv='devour nsxiv -a';

    # open a twitch stream in mpv
    function twitch {
        streamlink --twitch-disable-hosting --twitch-disable-reruns \
        --twitch-disable-ads -p "devour umpv -" "http://twitch.tv/$@" 480p
    }
fi

# When present, use eza instead of ls
if [ -x /usr/bin/eza ]; then
  alias ls='eza -la'
  alias ll='eza -l'
  alias la='eza -a'
  alias lx='ll -sextension'
  alias lk='ll -ssize'
  alias lt='ll -smodified'
  alias lc='ll -schanged'
  alias tree='eza -Tl --git-ignore'
fi

if [ -x /usr/bin/paru ]; then
    # Alias for update scripts
    alias upd='checkupd && autosnap-wrapper && hostupd'
fi


function chmod_calc() {
    local -a permission=(${(s::)${_PMS:-"rwxrwxrwx"}})
    local -a binary=()

    for i in ${(s::)1}; do
        binary+=(${(s::)${(l:3::0:)${"$(( [#2]i ))":2}}})
    done

    for i j in ${permission:^binary}; do
        if (( $j )); then
            echo -n $i
        else
            echo -n _
        fi
    done

    echo
}

# DESC: Create a reminder with human-readable durations, e.g. 15m, 1h, 40s, etc
function remind {
    local time=$1; shift
    sched "$time" "notify-send --urgency=critical 'Reminder' '$@'; ding"
}; compdef r=sched

function cheat {
    curl -s "cheat.sh/$(echo -n "$*" | jq -sRr @uri)"
}

# Mind the Gap
# Clean up filenames by replacing spaces and non-ascii characters with underscores
function mtg { 
  for f in "$@"; do
    mv "$f" "${f//[^a-zA-Z0-9\.\-]/_}"
  done
}

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

# DESC:
# https://news.ycombinator.com/item?id=18898898
function pycd() {
    pushd `python -c "import os.path, $1; print(os.path.dirname($1.__file__))"`
}

# Fix NTFS drive that can't be recognized due to unknown error
function fix_drive() {
  sudo ntfsfix /dev/$1
}


# systemd stuff
alias jc='journalctl -xe'
alias jcu='journalctl -xe -u'
alias sc=systemctl
alias scu='systemctl --user'
alias scur='systemctl --user restart'
alias scus='systemctl --user status'
alias ssc='sudo systemctl'
alias sscr='sudo systemctl restart'
alias sscs='sudo systemctl status'
alias rctl='sudo resolvectl'
alias nctl='sudo networkctl'

if (( $+commands[udisksctl] )); then
  alias ud='udisksctl'
  alias udm='udisksctl mount -b'
  alias udu='udisksctl unmount -b'
fi

# if (( $+commands[swayimg] )); then
#   alias -s {jpg,jpeg,gif,png,svg}=swayimg
# elif (( $+commands[feh] )); then
#   alias -s {jpg,jpeg,gif,png,svg}=feh
# fi

if (( $+commands[mpv] )); then
  alias -s {mp4,avi,mkv,mov}=mpv
fi

if (( $+commands[xdg-open] )); then
  alias open=xdg-open
fi

if (( $+commands[img2sixel] )); then
  alias six=img2sixel
fi


autoload -U zmv

# DESC: make directory and enter it
function take() {
  mkdir -p $@ && cd ${@:$#}
} ; compdef take=mkdir

function zman { PAGER="less -g -I -s '+/^       "$1"'" man zshall; }

if (( $+commands[nix] )); then
  alias n=nix
  alias ne=nix-env
  alias nf='nix flake'
  alias nfm='nix flake metadata'
  alias nfs='nix flake show'
  alias nr='nix repl'
  alias nrp='nix repl "<nixpkgs>"'
  alias ns='nix search'
  alias nsp='nix search nixpkgs'
fi

# https://unix.stackexchange.com/a/314975
alias delb="find . -xtype l -print -delete"

function toggle_dns {
  dns_config="$XDG_CONFIG_HOME/etc/resolv.conf"

  if [[ -f $dns_config ]]; then
    mv $dns_config new_dns
  else
    mv $dns_config
  fi
}
