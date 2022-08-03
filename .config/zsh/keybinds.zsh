# References:
# http://zshwiki.org/home/#reading_terminfo
# https://stackoverflow.com/questions/31641910/why-is-terminfokcuu1-eoa
# https://www.reddit.com/r/zsh/comments/eblqvq/del_pgup_and_pgdown_input_in_terminal/fb7337q/

# vi mode (the equivalent of `set -o vi`)
bindkey -v

# set 1ms timeout for Esc press so we can switch
# between vi "normal" and "command" modes faster
export KEYTIMEOUT=1

# Change cursor shape for different vi modes.
# block cursor for cmd mode, line (beam) otherwise
#  1 -> blinking block
#  2 -> solid block
#  3 -> blinking underscore
#  4 -> solid underscore
#  5 -> blinking vertical bar
#  6 -> solid vertical bar
function zle-keymap-select() {
    if [[ ${KEYMAP} == vicmd || $1 = 'block' ]] {
        printf '\e[2 q' >"$TTY"
    } elif [[ ${KEYMAP} == (main|viins|'') || $1 = 'beam' ]] {
        printf '\e[5 q' >"$TTY"
    }
}
zle -N zle-keymap-select

# make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )) {
    function zle-line-init() {
        printf '\e[5 q' >"$TTY" # reset to beam cursor on new prompt
        echoti smkx
    }
    function zle-line-finish() {
        echoti rmkx
    }
    zle -N zle-line-init
    zle -N zle-line-finish
}

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search

zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

# TODO Guidelines for adding key bindings:
#   - Do not add hardcoded escape sequences, they are not easily portable.
#   - Adding Ctrl characters, such as '^b' is okay; '^b' and '^B' are the same.
#   - Sequences like '\ex' are allowed in here as well.
#   - All keys from the $key[] mapping are obviously okay.
#   - tab, '\ec', '^I', '^R', and '^T' are bound by FZF

local -A keybindings=(
    'Home'   beginning-of-line
    'End'    end-of-line
    'Delete' delete-char
    'Up'     history-substring-search-up
    'Down'   history-substring-search-down

    "C-A" beginning-of-line
    "C-E" end-of-line
    'C-Right'     forward-word
    'C-Left'      backward-word
    'C-Backspace' backward-kill-word
    'Space' magic-space  # Expand history by space
    'C-D'   delete-char  # Delete chararcter under cursor
    'C-W'   kill-region

    'M-.'   insert-last-word
    # Single line mode puts the current content on the stack and opens a temporary prompt
    # Allows editing of previous lines in multi-line mode
    'M-Q' push-line-or-edit

    'C-J' self-insert-unmeta
)

zbindkey -M vicmd "Backspace" backward-delete-char


# Jump by parameter boundary
# Reference: https://blog.lilydjwg.me/2013/11/14/zsh-move-by-shell-arguments.41712.html
() {
    local -a to_bind=(forward-word backward-word backward-kill-word)
    local widget
    for widget ($to_bind) {
        autoload -Uz $widget-match
        zle -N $widget-match
    }
    zstyle ':zle:*-match' word-style shell
}
keybindings+=(
    'M-Right' forward-word-match
    'M-Left'  backward-word-match
    'C-Backspace' backward-kill-word-match
)

## fuzzy related bindings
# Fast directory jumping
# function fz-zjump-widget() {
#     local selected=$(z -l | fzf -n "2.." --tiebreak=end,index --tac --prompt="jump> ")
#     if [[ "$selected" != "" ]] {
#         builtin cd "${selected[(w)2]}"
#     }
#     zle push-line
#     zle accept-line
# }
# zle -N fz-zjump-widget
# zbindkey 'M-c' fz-zjump-widget

# Search History
function fz-history-widget() {
    local query="
SELECT commands.argv
FROM   history
    LEFT JOIN commands
        ON history.command_id = commands.rowid
    LEFT JOIN places
        ON history.place_id = places.rowid
GROUP BY commands.argv
ORDER BY places.dir != '${PWD//'/''}',
    commands.argv LIKE '${BUFFER//'/''}%' DESC,
    Count(*) DESC
"
    # Ensure that the entire history is searched
    # NOTE: This relies on fzf-tab
    local selected=$(fc -rl 1 | ftb-tmux-popup -n "2.." --tiebreak=index --prompt="cmd> " ${BUFFER:+-q$BUFFER})
    if [[ "$selected" != "" ]] {
        zle vi-fetch-history -n $selected
    }
}
zle -N fz-history-widget
keybindings[C-r]=fz-history-widget

# Search for files
# will replace * or ** with search results
# The former means search for a single level, the latter means search for a subdirectory
function fz-find() {
    local selected dir cut
    cut=$(grep -oP '[^* ]+(?=\*{1,2}$)' <<< $BUFFER)
    eval "dir=${cut:-.}"
    if [[ $BUFFER == *"**"* ]] {
        selected=$(fd -H . $dir | ftb-tmux-popup --tiebreak=end,length --prompt="cd> ")
    } elif [[ $BUFFER == *"*"* ]] {
        selected=$(fd -d 1 . $dir | ftb-tmux-popup --tiebreak=end --prompt="cd> ")
    }
    BUFFER=${BUFFER/%'*'*/}
    BUFFER=${BUFFER/%$cut/$selected}
    zle end-of-line
}
zle -N fz-find
keybindings[M-s]=fz-find

# ZLE related

# zce
# Quick jump to the specified character
function zce-jump-char() {
    [[ -z $BUFFER ]] && zle up-history
    zstyle ':zce:*' prompt-char '%B%F{green}Jump to character:%F%b '
    zstyle ':zce:*' prompt-key '%B%F{green}Target key:%F%b '
    with-zce zce-raw zce-searchin-read
    CURSOR+=1
}
zle -N zce-jump-char
keybindings[M-j]=zce-jump-char

# Delete to the specified character
# function zce-delete-to-char() {
#     [[ -z $BUFFER ]] && zle up-history
#     local pbuffer=$BUFFER pcursor=$CURSOR
#     local keys=${(j..)$(print {a..z} {A..Z})}
#     zstyle ':zce:*' prompt-char '%B%F{yellow}Delete to character:%F%b '
#     zstyle ':zce:*' prompt-key '%B%F{yellow}Target key:%F%b '
#     zce-raw zce-searchin-read $keys
#
#     if (( $CURSOR < $pcursor ))  {
#         pbuffer[$CURSOR,$pcursor]=$pbuffer[$CURSOR]
#     } else {
#         pbuffer[$pcursor,$CURSOR]=$pbuffer[$pcursor]
#         CURSOR=$pcursor
#     }
#     BUFFER=$pbuffer
# }
# zle -N zce-delete-to-char
# zbindkey "C-j d" zce-delete-to-char

# Quickly add pairs of parentheses
# function add-bracket() {
#     local -A keys=('(' ')' '{' '}' '[' ']')
#     BUFFER[$CURSOR+1]=${KEYS[-1]}${BUFFER[$CURSOR+1]}
#     BUFFER+=$keys[$KEYS[-1]]
# }
# zle -N add-bracket
# keybindings[M-\(]=add-bracket
# keybindings[M-\{]=add-bracket

# Quick jump to parent directory: ... => ../..
# https://grml.org/zsh/zsh-lovers.html
function rationalise-dot() {
    if [[ $LBUFFER = *.. ]] {
        LBUFFER+=/..
    } else {
        LBUFFER+=.
    }
}
zle -N rationalise-dot
keybindings[.]=rationalise-dot

# Remember the cursor position of the previous command
# function cached-accept-line() {
#     _last_cursor=$CURSOR
#     zle .accept-line
# }
# zle -N accept-line cached-accept-line
# zbindkey "C-m" accept-line

# function prev-buffer-or-beginning-search() {
#     local pbuffer=$BUFFER
#     zle up-line-or-beginning-search
#     if [[ -n $_last_cursor && -z $pbuffer ]] {
#         CURSOR=$_last_cursor
#         _last_cursor=
#     }
# }
# zle -N prev-buffer-or-beginning-search
# Continuous upturn is problematic
# zbindkey "C-p" prev-buffer-or-beginning-search
# zbindkey "Up"  prev-buffer-or-beginning-search

# Edit the current line with the editor
autoload -U edit-command-line
function edit-command-line-as-zsh() {
    TMPSUFFIX=.zsh
    edit-command-line
    unset TMPSUFFIX
}
zle -N edit-command-line-as-zsh
keybindings+=('C-X C-E' edit-command-line-as-zsh)

# https://wiki.archlinux.org/title/Zsh#Shortcut_to_exit_shell_on_partial_command_line
function exit_zsh() { exit; }
zle -N exit_zsh
keybindings+=('C-X C-X' exit_zsh)

# Omni-Completion
if (( $+commands[fasd] )); then
    keybindings+=('C-x C-f' fasd-complete-f)  # C-x C-f to do fasd-complete-f (only files)
    keybindings+=('C-x C-d' fasd-complete-d)  # C-x C-d to do fasd-complete-d (only directories)
fi

# https://wiki.archlinux.org/title/Zsh#Clear_the_backbuffer_using_a_key_binding
function clear-screen-and-scrollback() {
    echoti civis >"$TTY"
    printf '%b' '\e[H\e[2J' >"$TTY"
    zle .reset-prompt
    zle -R
    printf '%b' '\e[3J' >"$TTY"
    echoti cnorm >"$TTY"
}
zle -N clear-screen-and-scrollback
keybindings+=('C-l' clear-screen-and-scrollback)

# Execute M-x
function execute-command() {
    local selected=$(printf "%s\n" ${(k)widgets} | ftb-tmux-popup --reverse --prompt="cmd> " --height=10 )
    zle redisplay
    [[ $selected ]] && zle $selected
}
zle -N execute-command
keybindings[M-x]=execute-command

zbindkey -A keybindings
