# Stop TRAMP (in Emacs) from hanging or term/shell from echoing back commands
if [[ $TERM == dumb || -n $INSIDE_EMACS ]]; then
    unsetopt zle prompt_cr prompt_subst
    whence -w precmd >/dev/null && unfunction precmd
    whence -w preexec >/dev/null && unfunction preexec
    PS1='$ '
#elif (( EUID == 0 )); then
fi

# Personal aliases & functions.
if (( USER == ianb )) ; then
    alias cfg='/usr/bin/git --git-dir=$HOME/.config/cfg/ --work-tree=$HOME'
    alias moshlax='mosh munchlax -- tmux a'
    function build() {
        rm -f ~/docs/code/sites/ianb/dst/.files
        ssg6 ~/docs/code/sites/ianb/src ~/docs/code/sites/ianb/dst \
        "Ian B." "https://ianb.io/"
    }
    function deploy() {
        rsync -avzhP --delete-after --chmod=755 \
        ~/docs/code/sites/ianb/dst/ munchlax:/var/www/ianb
    }
fi

# https://superuser.com/q/480928
autoload -Uz colors && colors

() {
    local white_b=$fg_bold[white] blue=$fg[blue] rst=$reset_color
    REPORTTIME=120
    TIMEFMT=("$white_b%J$rst"$'\n'
        "User: $blue%U$rst"$'\t'"System: $blue%S$rst  Total: $blue%*Es$rst"$'\n'
        "CPU:  $blue%P$rst"$'\t'"Mem:    $blue%M MB$rst")
}

## ZSH Configuration
# Treat these characters as part of a word.
WORDCHARS='_-*?[]~&.;!#$%^(){}<>'
#WORDCHARS=''
SPROMPT="%F{yellow}:: Correct '%R' to '%r'? [nyae]:%f "

setopt COMBINING_CHARS           # Combine zero-length punc chars (accents) with base char
setopt CORRECT                   # Try to correct the spelling of commands.
setopt HASH_LIST_ALL             # Hash path on command completion or spelling correction.
setopt IGNOREEOF                 # Require the use of exit or logout instead of EOF.
setopt INTERACTIVE_COMMENTS      # Use comments in interactive mode.
setopt KSH_OPTION_PRINT          # Print all options in a single list.
setopt LIST_PACKED               # Allow different column widths for completion lists.
setopt MULTIOS                   # Allow multiple redirects.
setopt RC_QUOTES                 # Allow 'Henry''s Garage' instead of 'Henry'\''s Garage'.
unsetopt BEEP                    # Beep on error in ZLE.
unsetopt BRACE_CCL               # Allow brace character class list expansion.
unsetopt CORRECT_ALL             # Try to correct the spelling of all arguments in a line.
unsetopt MAIL_WARNING            # Print a warning message if a mail file has been accessed.
unsetopt NOMATCH                 # Report an error if there is no match for a glob.

## Jobs
setopt AUTO_RESUME               # Attempt to resume job before creating a new process.
setopt LONG_LIST_JOBS            # List jobs in the long format by default.
setopt NOTIFY                    # Report status of background jobs immediately.
unsetopt BG_NICE                 # Run all background jobs at a lower priority.
unsetopt CHECK_JOBS              # Report on jobs when shell exits.
unsetopt HUP                     # Kill jobs on shell exit.

## History
# Limit the length of a single history record
# return 2: will not be saved
# return 0: saved on the internal history list
autoload -Uz add-zsh-hook
add-zsh-hook zshaddhistory max_history_len
function max_history_len() { if (($#1 > 240)) { return 2; } ; return 0 ; }

# Use fc -IR to read history and fc -IA to save history
#alias history="history 0"
HISTSIZE=50000                   # Max events to store in internal history.
SAVEHIST=100000                  # Max events to store in history file.

setopt APPEND_HISTORY            # Appends history to history file on exit
# setopt BANG_HIST                 # Treat '!' specially during expansion.
# setopt EXTENDED_HISTORY          # Include start time in history records
# setopt HIST_BEEP                 # Beep when accessing non-existent history.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history.
setopt HIST_FCNTL_LOCK           # Use modern file-locking for increased performance.
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event.
setopt HIST_IGNORE_ALL_DUPS      # Remove old events if new event is a duplicate
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again.
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space.
setopt HIST_REDUCE_BLANKS        # Minimize unnecessary whitespace
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file.
setopt HIST_VERIFY               # Do not execute immediately upon history expansion.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not at exit.
setopt SHARE_HISTORY             # Share history between all sessions.

## Directories
DIRSTACKSIZE=9                   # Max number of directories to remember.
#DIRSTACKSIZE=100
setopt AUTO_CD                   # Enter the path directly to jump
setopt AUTO_PUSHD                # Push the old directory onto the stack on cd.
setopt CDABLE_VARS               # Change directory to a path stored in a variable.
setopt EXTENDED_GLOB             # Use extended globbing syntax.
setopt MULTIOS                   # Write to multiple descriptors.
setopt PUSHD_IGNORE_DUPS         # Do not store duplicates in the stack.
setopt PUSHD_SILENT              # Do not print the directory stack after pushd or popd.
setopt PUSHD_TO_HOME             # Push to home directory when no argument is given.
unsetopt AUTO_NAME_DIRS          # Add variable-stored paths to ~ list
unsetopt GLOB_DOTS               # Require leading ‘.’ in a filename to be matched.

# rustup mirror
#export RUSTUP_DIST_SERVER=https://mirrors.tuna.tsinghua.edu.cn/rustup
# export RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static
# export RUSTUP_UPDATE_ROOT=https://mirrors.ustc.edu.cn/rust-static/rustup

# speed up rustc compile
# removed because all cache has be placed in ~/.cache/cargo-build
# export RUSTC_WRAPPER=sccache

# https://archive.zhimingwang.org/blog/2015-09-21-zsh-51-and-bracketed-paste.html
autoload -Uz bracketed-paste-url-magic
zle -N bracketed-paste bracketed-paste-url-magic
