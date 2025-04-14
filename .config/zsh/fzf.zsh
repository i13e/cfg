#!/bin/zsh
local color00='#2E3440'
local color01='#3B4252'
local color02='#434C5E'
local color03='#4C566A'
local color04='#D8DEE9'
local color05='#E5E9F0'
local color06='#ECEFF4'
local color07='#8FBCBB'
local color08='#BF616A'
local color09='#D08770'
local color0A='#EBCB8B'
local color0B='#A3BE8C'
local color0C='#88C0D0'
local color0D='#81A1C1'
local color0E='#B48EAD'
local color0F='#5E81AC'

export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS
--color=bg+:$color00,bg:$color00,spinner:$color0C,hl:$color0D
--color=fg:$color04,header:$color0D,info:$color0A,pointer:$color0C
--color=marker:$color0C,fg+:$color06,prompt:$color0A,hl+:$color0D
--height 100% --layout=reverse --border --cycle --info=inline -m
--bind=ctrl-space:toggle,pgup:preview-up,pgdn:preview-down,tab:down
--prompt='❯ ' --pointer=❯"

# Use fd to generate auto completion
if (( $+commands[fd] )); then
    _fzf_compgen_path() {
        fd --hidden --follow . "$1"
    }
    _fzf_compgen_dir() {
        fd --type d --hidden --follow . "$1"
    }
    export FZF_DEFAULT_COMMAND="fd --type f"
    export FZF_ALT_C_COMMAND="fd --type d"
    export FZF_ALT_C_OPTS="--preview 'exa -T -L 1 --group-directories-first {} | head -200'"
fi

source "/usr/share/fzf/completion.zsh"
source "/usr/share/fzf/key-bindings.zsh"

#FZF_PREVIEW_COMMAND='cat {}'
#FZF_COMPLETION_TRIGGER=''
#FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

_fzf_comprun() {
    local command=$1
    shift

    case "$command" in
        cd)           fzf "$@" --preview 'exa -T {} | head -200' ;;
        z)            fzf "$@" --preview 'exa -1 --color=always {}' ;;
        export|unset) fzf "$@" --preview "eval 'echo \$'{}" ;;
        ssh)          fzf "$@" --preview 'drill {}' ;;
        *)            fzf "$@" ;;
    esac
}


# FZF_DEFAULT_COMMAND='--hidden --follow --exclude .git --exclude .DS_Store' \
#     FZF_DEFAULT_OPTS='--preview "bat --color=always --style=numbers --line-range :500 {}"' \
#     fzf --preview "bat --color=always --style=numbers --line-range :500 {}" "$@"
#
# FZF_DEFAULT_OPTS="--height 40% --preview '(bat --color=always --style=numbers --line-range :500 {} | head -n 500) 2> /dev/null'" \
#   local fzf_path="$(which fzf)"
#   if [[ -n $fzf_path ]]; then
#       $fzf_path --color=256 --bind "ctrl-r:toggle-preview" --preview "bat --color=always --style=numbers --line-range :500 {}" "$@"
#   fi

## fzf-tab

# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false

# disable sort when completing options of any command
#zstyle ':completion:complete:*:options' sort false
zstyle ':completion:*' file-sort modification
zstyle ':completion:*:exa' sort false
zstyle ':completion:files' sort false

# preview directory's content with exa when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'
zstyle ':fzf-tab:complete:cd:*' popup-pad 30 0

# Add extra padding due to border (default: 2)
zstyle ':fzf-tab:complete:*:*' fzf-pad 4

# switch group using `,` and `.`
zstyle ':fzf-tab:*' switch-group ',' '.'

# use tmux-popup to show results
#zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
zstyle ':fzf-tab:*:*argument-rest*' popup-pad 100 0

# kill command
# give a preview of commandline arguments when completing `kill`
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview \
  '[[ $group == "[process ID]" ]] && ps --pid=$word -o cmd --no-headers -w -w'
#zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview 'ps --pid=$word -o cmd --no-headers -w -w'
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-flags --preview-window=down:3:wrap
zstyle ':fzf-tab:complete:kill:*' popup-pad 0 3



#zstyle ':fzf-tab:*:*argument-rest*' popup-pad 100 0
# zstyle ':fzf-tab:*:*argument-rest*' fzf-preview '
# echo desc: $desc
# echo word: $word
# echo group: $group
# echo realpath: $realpath
# if [[ -z $realpath ]]; then
#   return
# fi
# # 用 exa 展示目录内容
# if [[ -d $realpath ]]; then
#   exa -1 --color=always $realpath
#   return
# fi
# local type=${$(file --mime-type $realpath)[(w)2]}
# case $type in;
#   text*) bat -p --color=always $realpath;;
# esac
# '




# show systemd unit status
zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word'

#zstyle ':fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' \
#    fzf-preview 'echo ${(P)word}'
# tldr previews
zstyle ':fzf-tab:complete:tldr:argument-1' fzf-preview 'tldr --color always $word'
#zstyle ':fzf-tab:*' show-group brief



## fzf functions

# # Search with fzf and open selected file with Vim
# # bindkey -s '^v' 'vim $(fzf);^M'
#
# # +-----+
# # | Git |
# # +-----+
#
# # git log browser with FZF
# fglog() {
#   git log --graph --color=always \
#       --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
#   fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
#       --bind "ctrl-m:execute:
#                 (grep -o '[a-f0-9]\{7\}' | head -1 |
#                 xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
#                 {}
# FZF-EOF"
# }
#
# # +--------+
# # | Pacman |
# # +--------+
#
# # TODO can improve that with a bind to switch to what was installed
# fpac() {
#     pacman -Slq | fzf --multi --reverse --preview 'pacman -Si {1}' | xargs -ro sudo pacman -S
# }
#
# fyay() {
#     yay -Slq | fzf --multi --reverse --preview 'yay -Si {1}' | xargs -ro yay -S
# }
#
# # +------+
# # | tmux |
# # +------+
#
# fmux() {
#     prj=$(find $XDG_CONFIG_HOME/tmuxp/ -execdir bash -c 'basename "${0%.*}"' {} ';' | sort | uniq | nl | fzf | cut -f 2)
#     echo $prj
#     [ -n "$prj" ] && tmuxp load $prj
# }
#
# # ftmuxp - propose every possible tmuxp session
# ftmuxp() {
#     if [[ -n $TMUX ]]; then
#         return
#     fi
#
#     # get the IDs
#     ID="$(ls $XDG_CONFIG_HOME/tmuxp | sed -e 's/\.yml$//')"
#     if [[ -z "$ID" ]]; then
#         tmux new-session
#     fi
#
#     create_new_session="Create New Session"
#
#     ID="${create_new_session}\n$ID"
#     ID="$(echo $ID | fzf | cut -d: -f1)"
#
#     if [[ "$ID" = "${create_new_session}" ]]; then
#         tmux new-session
#     elif [[ -n "$ID" ]]; then
#         # Change name of urxvt tab to session name
#         printf '\033]777;tabbedx;set_tab_name;%s\007' "$ID"
#         tmuxp load "$ID"
#     fi
# }
#
# # ftmux - help you choose tmux sessions
# ftmux() {
#     if [[ ! -n $TMUX ]]; then
#         # get the IDs
#         ID="`tmux list-sessions`"
#         if [[ -z "$ID" ]]; then
#             tmux new-session
#         fi
#         create_new_session="Create New Session"
#         ID="$ID\n${create_new_session}:"
#         ID="`echo $ID | fzf | cut -d: -f1`"
#         if [[ "$ID" = "${create_new_session}" ]]; then
#             tmux new-session
#         elif [[ -n "$ID" ]]; then
#             printf '\033]777;tabbedx;set_tab_name;%s\007' "$ID"
#             tmux attach-session -t "$ID"
#         else
#             :  # Start terminal normally
#         fi
#     fi
# }
#
# # +-------+
# # | Other |
# # +-------+
#
# # List install files for dotfiles
# fdot() {
#     file=$(find "$DOTFILES/install" -exec basename {} ';' | sort | uniq | nl | fzf | cut -f 2)
#     [ -n "$file" ] && "$EDITOR" "$DOTFILES/install/$file"
# }
#
# # List projects
# fwork() {
#     result=$(find ~/workspace/* -type d -prune -exec basename {} ';' | sort | uniq | nl | fzf | cut -f 2)
#     [ -n "$result" ] && cd ~/workspace/$result
# }
#
# fpdf() {
#     result=$(find -type f -name '*.pdf' | fzf --bind "ctrl-r:reload(find -type f -name '*.pdf')" --preview "pdftotext {} - | less")
#     [ -n "$result" ] && zathura "$result" &
# }
#
# fepub() {
#     result=$(find -type f -name '*.epub' | fzf --bind "ctrl-r:reload(find -type f -name '*.epub')")
#     [ -n "$result" ] && zathura "$result" &
# }
#
# # List mindmaps
# fmind() {
#     local folders=("$CLOUD/knowledge_base" "$WORKSPACE/alexandria")
#
#     files=""
#     for root in ${folders[@]}; do
#         files="$files $(find $root -name '*.mm')"
#     done
#     result=$(echo "$files" | fzf -m --height 60% --border sharp | tr -s "\n" " ")
#     [ -n "$result" ] && freemind $(echo $result) &> /dev/null &
# }
#
# # List tracking spreadsheets (productivity, money ...)
# ftrack() {
#     file=$(ls $CLOUD/tracking/**/*.{ods,csv} | fzf) || return
#     [ -n "$file" ] && libreoffice "$file" &> /dev/null &
# }
#
# fpop() {
#     # Only work with alias d defined as:
#
#     # alias d='dirs -v'
#     # for index ({1..9}) alias "$index"="cd +${index}"; unset index
#
#     d | fzf --height="20%" | cut -f 1 | source /dev/stdin
# }

# function cd() {
#     if [[ "$#" != 0 ]]; then
#         builtin cd "$@";
#         return
#     fi
#     while true; do
#         local lsd=$(echo ".." && exa -Fa | grep '/$' | sed 's;/$;;')
#         local dir="$(printf '%s\n' "${lsd[@]}" |
#             fzf --reverse --preview '
#                     __cd_nxt="$(echo {})";
#                     __cd_path="$(echo $(pwd)/${__cd_nxt} | sed "s;//;/;")";
#                     echo $__cd_path;
#                     echo;
#                     exa -Fal --icons --color=always "${__cd_path}";
#                     ')"
#                     [[ ${#dir} != 0 ]] || return 0
#                     builtin cd "$dir" &> /dev/null
#                 done
#             }
# Install packages using yay (change to pacman/AUR helper of your choice)
# function in { paru -Slq | fzf -q "$1" -m --preview 'paru -Si {1}'| xargs -ro paru -S }
# # Remove installed packages (change to pacman/AUR helper of your choice)
# function re { paru -Qq | fzf -q "$1" -m --preview 'paru -Qi {1}' | xargs -ro paru -Rns }
# # Helper function to integrate yay and fzf
# yzf() {
#     pos=$1
#     shift
#     sed "s/ /\t/g" |
#         fzf --nth=$pos --multi --history="${FZF_HISTDIR:-$XDG_STATE_HOME/fzf}/history-yzf$pos" \
#         --preview-window=60%,border-left \
#         --bind="double-click:execute(xdg-open 'https://archlinux.org/packages/{$pos}'),alt-enter:execute(xdg-open 'https://aur.archlinux.org/packages?K={$pos}&SB=p&SO=d&PP=100')" \
#         "$@" | cut -f$pos | xargs
#     }
#
#     # Dev note: print -s adds a shell history entry
#
#     # List installable packages into fzf and install selection
#     yas() {
#         cache_dir="/tmp/yas-$USER"
#         test "$1" = "-y" && rm -rf "$cache_dir" && shift
#         mkdir -p "$cache_dir"
#         preview_cache="$cache_dir/preview_{2}"
#         list_cache="$cache_dir/list"
#         { test "$(cat "$list_cache$@" | wc -l)" -lt 50000 && rm "$list_cache$@"; } 2>/dev/null
#             pkg=$( (cat "$list_cache$@" 2>/dev/null || { pacman --color=always -Sl "$@"; yay --color=always -Sl aur "$@" } | sed 's/ [^ ]*unknown-version[^ ]*//' | tee "$list_cache$@") |
#                 yzf 2 --tiebreak=index --preview="cat $preview_cache 2>/dev/null | grep -v 'Querying' | grep . || yay --color always -Si {2} | tee $preview_cache")
#                             if test -n "$pkg"
#                             then echo "Installing $pkg..."
#                                 cmd="yay -S $pkg"
#                                 print -s "$cmd"
#                                 eval "$cmd"
#                                 rehash
#                             fi
#                         }
#                         # List installed packages into fzf and remove selection
#                         # Tip: use -e to list only explicitly installed packages
#                         yar() {
#                             pkg=$(yay --color=always -Q "$@" | yzf 1 --tiebreak=length --preview="yay --color always -Qli {1}")
#                             if test -n "$pkg"
#                             then echo "Removing $pkg..."
#                                 cmd="yay -R --cascade --recursive $pkg"
#                                 print -s "$cmd"
#                                 eval "$cmd"
#                             fi
#                         }













## Zsh4Humans (OLD)
#setopt glob_dots magic_equal_subst no_multi_os no_local_loops
#setopt rm_star_silent rc_quotes glob_star_short
#setopt complete_in_word         # don't move cursor to end of line on completion
#setopt always_to_end no_auto_remove_slash c_bases no_flow_control interactive_comments
#prompt_percent prompt_cr no_prompt_bang no_prompt_subst
#    'no_prompt_bang'         'no_prompt_subst'
#    'prompt_sp'              'typeset_silent'   'no_auto_remove_slash'   'no_list_types'
#auto_param_slash

#nolisttypes
#promptsubst
#typesetsilent
