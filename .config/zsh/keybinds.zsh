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
zle-keymap-select () {
    case $KEYMAP in
        vicmd) printf "\e[2 q" >"$TTY" ;;
        viins|main|*|"") printf "\e[5 q" >"$TTY" ;;
    esac
}
zle -N zle-keymap-select

# make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )) {
    function zle-line-init() {
        printf '\e[5 q' >"$TTY"     # reset cursor on new prompt
        echoti smkx
    }
    function zle-line-finish() {
        echoti rmkx
    }
    zle -N zle-line-init
    zle -N zle-line-finish
}

zle -N beginning-of-somewhere beginning-or-end-of-somewhere
zle -N end-of-somewhere beginning-or-end-of-somewhere


# TODO Guidelines for adding key bindings:
#   - Do not add hardcoded escape sequences, they are not easily portable.
#   - Adding Ctrl characters, such as '^b' is okay; '^b' and '^B' are the same.
#   - Sequences like '\ex' are allowed in here as well.
#   - All keys from the $key[] mapping are obviously okay.
#   - tab, '\ec', '^I', '^R', and '^T' are bound by FZF

# Bind all of these to EMACS/VIINS mode.
# #k# Perform abbreviation expansion
# '^x.' zleiab
# #k# Display list of abbreviations that would expand
# '^xb' help-show-abk
# #k# mkdir -p <dir> from string under cursor or marked area
# '^xM' inplaceMkDirs
# #k# display help for keybindings and ZLE
# '^xz' help-zle
# #k# Insert files and test globbing
# "^xf" insert-files
# #k# Edit the current line in \kbd{\$EDITOR}
# '\ee' edit-command-line
# #k# search history backward for entry beginning with typed text
# '^xp' history-beginning-search-backward-end
# #k# search history forward for entry beginning with typed text
# '^xP' history-beginning-search-forward-end
# #k# search history backward for entry beginning with typed text
# PageUp history-beginning-search-backward-end
# #k# search history forward for entry beginning with typed text
# PageDown history-beginning-search-forward-end
# "^x^h" commit-to-history
# #k# Kill left-side word or everything up to next slash
# '\ev' slash-backward-kill-word
# #k# Kill left-side word or everything up to next slash
# '\e^h' slash-backward-kill-word
# #k# Kill left-side word or everything up to next slash
# '\e^?' slash-backward-kill-word
# #k# Trigger menu-complete
# '\ei' menu-complete  # menu completion via esc-i
# #k# Insert a timestamp on the command line (yyyy-mm-dd)
# '^xd' insert-datestamp
# #k# Insert last typed word
# "\em" insert-last-typed-word
# #k# A smart shortcut for \kbd{fg<enter>}
# '^z' grml-zsh-fg
# #k# prepend the current command with "sudo"
# "^os" sudo-command-line
# #k# jump to after first word (for adding options)
# '^x1' jump_after_first_word
# #k# complete word from history with menu
# "^x^x" hist-complete

local -A keybindings=(
    # Bind to function keys.
    'Home'   vi-beginning-of-line # beginning-of-line
    'End'    vi-end-of-line # end-of-line
    'Insert' overwrite-mode # vi-insert
    'Delete' vi-delete-char # delete-char
    'Up'     history-substring-search-up # up-line-or-{,beginning-}search
    'Down'   history-substring-search-down # down-line-or-{,beginning-}search
    'Left'   vi-backward-char # backward-char
    'Right'  vi-forward-char # forward-char

    # Emacs flavored control keys.
    'C-A' beginning-of-line
    'C-E' end-of-line
    'C-K' kill-line
    'C-L' clear-screen
    'C-R' history-incremental-search-backward
    'C-U' kill-whole-line
    'C-W' backward-kill-word
    'C-Y' yank

    'C-Right' forward-word
    'C-Left' backward-word
    'C-Backspace' backward-kill-word
    'Space' magic-space  # Expand history on space
    'C-D'   delete-char  # Delete character under cursor
    'C-W'   kill-region

    'M-.'   insert-last-word

    # Single line mode puts the current content on the stack and opens a temporary prompt
    # Allows editing of previous lines in multi-line mode
    'M-Q' push-line-or-edit

    'C-J' self-insert-unmeta
)

zbindkey -M vicmd "Backspace" backward-delete-char


# TODO alt+E: open $EDITOR

# Jump by parameter boundary
# Reference: https://blog.lilydjwg.me/2013/11/14/zsh-move-by-shell-arguments.41712.html
zload {forward,backward{,-kill}}-word-match
zstyle ':zle:*-match' word-style shell
keybindings+=(
    'C-Left'  backward-word-match
    'C-Right' forward-word-match
    #'C-Up'
    #'C-Down'
    'C-Backspace' backward-kill-word-match
)

function _run_ls() {
    ls
    return
}
zle -N _run_ls ; keybindings+=('C-x l' _run_ls)

function _run_with_sudo() {
    if [[ -n "$BUFFER" ]]; then
        [[ "$BUFFER" =~ "^sudo.*" ]] && return
        BUFFER="sudo $BUFFER"
    else
        [[ "$(fc -ln -1)" =~ '^sudo.*' ]] && return
        BUFFER="sudo $(fc -ln -1)"
    fi
    zle end-of-line ; return
}
zle -N _run_with_sudo ; keybindings+=('C-x v' _run_with_sudo)


function cd-back() { cd-rotate +1 } ; zle -N cd-back
function cd-forward() { cd-rotate -0 } ; zle -N cd-forward
function cd-up() { pushd ..; redraw-prompt; } ; zle -N cd-up

keybindings+=(
    'M-Left'  cd-back       # alt+left   cd into the prev directory
    'M-Right' cd-forward    # alt+right  cd into the next directory
    'M-Up'    cd-up         # alt+up     cd into the parent directory
    # 'M-Down'  cd-down       # alt+down   cd into the child directory
)

zle -N lfcd; keybindings+=('C-O' lfcd)
zle -N fancy-ctrl-z; keybindings+=('C-Z' fancy-ctrl-z)

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
    [[ "$selected" != "" ]] && zle vi-fetch-history -n $selected
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
    if [[ $BUFFER == *"**"* ]] ; then
        selected=$(fd -H . $dir | ftb-tmux-popup --tiebreak=end,length --prompt="cd> ")
    elif [[ $BUFFER == *"*"* ]] ; then
        selected=$(fd -d 1 . $dir | ftb-tmux-popup --tiebreak=end --prompt="cd> ")
    fi
    BUFFER=${BUFFER/%'*'*/}
    BUFFER=${BUFFER/%$cut/$selected}
    zle end-of-line
}
zle -N fz-find
keybindings[M-s]=fz-find

# alt+L: run "ls"




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
zle -N rationalise-dot; keybindings[.]=rationalise-dot

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
zload edit-command-line
keybindings+=('C-x e' edit-command-line)

# https://wiki.archlinux.org/title/Zsh#Shortcut_to_exit_shell_on_partial_command_line
function exit_zsh() { exit; }
zle -N exit_zsh
keybindings+=('C-x c' exit_zsh)

# https://github.com/denisidoro/navi
# _call_navi() {
#    local -r buff="$BUFFER"
#    local -r r="$(printf "$(navi --print </dev/tty)")"
#    zle kill-whole-line
#    BUFFER=${buff}${r}
#    CURSOR=$#BUFFER
# }
# zle -N _call_navi
# keybindings+=('C-X C-N' _call_navi)
#
# # Jump to the next (*) position
# _navi_next_pos() {
#     local -i pos=$BUFFER[(ri)\(*\)]-1
#     BUFFER=${BUFFER/${BUFFER[(wr)\(*\)]}/}
#     CURSOR=$pos
# }
# zle -N _navi_next_pos
# keybindings+=('C-X C-V' _call_navi)


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
keybindings+=('C-L' clear-screen-and-scrollback)

# Execute M-x
function execute-command() {
    local selected=$(printf "%s\n" ${(k)widgets} | ftb-tmux-popup --reverse --prompt="cmd> " --height=10 )
    zle redisplay
    [[ $selected ]] && zle $selected
}
zle -N execute-command
keybindings[M-x]=execute-command

zbindkey -A keybindings
