# Description: Put zsh config settings here

# Stop TRAMP (in Emacs) from hanging or term/shell from echoing back commands
# if [[ $TERM == dumb || -n $INSIDE_EMACS ]]; then
if [[ $TERM == dumb ]]; then
    unsetopt zle prompt_cr prompt_subst
    whence -w precmd >/dev/null && unfunction precmd
    whence -w preexec >/dev/null && unfunction preexec
    case $EUID in
        0) prompt="#" ;;
        *) prompt="$" ;;
    esac
    return
fi

# Dotfiles management
export DOTBARE_DIR="$XDG_CONFIG_HOME/cfg"
export DOTBARE_TREE="$HOME"
function cfg {
  if (( $+commands[dotbare] )); then
    dotbare "$@"
  else
    git --git-dir="$DOTBARE_DIR" --work-tree="$DOTBARE_TREE" "$@"
  fi
}

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
SPROMPT="%F{yellow}:: Correct '%R' to '%r'? [nyae]:%f "

unsetopt BRACE_CCL        # Allow brace character class list expansion.
setopt COMBINING_CHARS    # Combine zero-length punc chars (accents) with base char
setopt RC_QUOTES          # Allow 'Henry''s Garage' instead of 'Henry'\''s Garage'
setopt HASH_LIST_ALL      # Hash path on command completion or spelling correction.
unsetopt CORRECT_ALL      # Try to correct the spelling of all arguments in a line.
unsetopt NOMATCH          # Report an error if there is no match for a glob.
unsetopt MAIL_WARNING     # Don't print a warning message if a mail file has been accessed.
unsetopt BEEP             # Hush now, quiet now.
setopt IGNOREEOF          # Require the use of exit or logout instead of EOF.

## Jobs

setopt LONG_LIST_JOBS     # List jobs in the long format by default.
setopt AUTO_RESUME        # Attempt to resume existing job before creating a new process.
setopt NOTIFY             # Report status of background jobs immediately.
unsetopt BG_NICE          # Don't run all background jobs at a lower priority.
unsetopt HUP              # Don't kill jobs on shell exit.
unsetopt CHECK_JOBS       # Don't report on jobs when shell exit.

## History
# Use fc -IR to read history and fc -IA to save history
# alias history="history 0"
# Limit the length of a single history record
# return 2: will not be saved
# return 0: saved on the internal history list
autoload -Uz add-zsh-hook
add-zsh-hook zshaddhistory max_history_len
function max_history_len() { if (($#1 > 240)) { return 2; } ; return 0 ; }


HISTORY_SUBSTRING_SEARCH_PREFIXED=1
HISTORY_SUBSTRING_SEARCH_FUZZY=1

HISTSIZE=100000   # Max events to store in internal history.
SAVEHIST=100000   # Max events to store in history file.

# setopt BANG_HIST                 # History expansions on '!'
# setopt EXTENDED_HISTORY          # Include start time in history records
setopt APPEND_HISTORY            # Appends history to history file on exit
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history.
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Remove old events if new event is a duplicate
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event.
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file.
setopt HIST_REDUCE_BLANKS        # Minimize unnecessary whitespace
setopt HIST_VERIFY               # Do not execute immediately upon history expansion.
# setopt HIST_BEEP                 # Beep when accessing non-existent history.

setopt HIST_FCNTL_LOCK           # Use modern file-locking for increased performance.

## Directories

DIRSTACKSIZE=9

setopt AUTO_CD            # Implicit CD slows down plugins
setopt AUTO_PUSHD           # Push the old directory onto the stack on cd.
setopt PUSHD_IGNORE_DUPS    # Do not store duplicates in the stack.
setopt PUSHD_SILENT         # Do not print the directory stack after pushd or popd.
setopt PUSHD_TO_HOME      # Push to $HOME when no argument is given.
setopt CDABLE_VARS          # Change directory to a path stored in a variable.
setopt MULTIOS              # Write to multiple descriptors.
unsetopt GLOB_DOTS          # Require leading ‘.’ in a filename to be matched.
unsetopt AUTO_NAME_DIRS     # Don't add variable-stored paths to ~ list

setopt EXTENDED_GLOB        # Use extended globbing syntax.

# https://archive.zhimingwang.org/blog/2015-09-21-zsh-51-and-bracketed-paste.html
autoload -Uz bracketed-paste-url-magic
zle -N bracketed-paste bracketed-paste-url-magic

# TODO: belak/zsh-utils history module
# Requirements

if zstyle -T ':zsh-utils:plugins:history' use-xdg-basedirs; then
  # Ensure the data directory exists
  _data_dir=${XDG_DATA_HOME:-$HOME/.local/share}/zsh
  [[ -d "$_data_dir"  ]] || mkdir -p "$_data_dir"

  _zhistfile=$_data_dir/${ZHISTFILE:-history}
else
  _zhistfile=${ZDOTDIR:-$HOME}/${ZHISTFILE:-.zsh_history}
fi

#
# Options
#

#
# Variables
#

HISTFILE="$_zhistfile"

#
# Aliases
#

# Lists the ten most used commands.
alias history-stat="history 0 | awk '{print \$2}' | sort | uniq -c | sort -n -r | head"

#
# Cleanup
#

unset _data_dir _zhistfile
