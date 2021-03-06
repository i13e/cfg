## ZSH configuration
if [[ $TERM == dumb || -n $INSIDE_EMACS ]]; then
  unsetopt zle prompt_cr prompt_subst
  whence -w precmd >/dev/null && unfunction precmd
  whence -w preexec >/dev/null && unfunction preexec
  PS1='$ '
fi

## Plugins
# directory
mkdir -p $XDG_DATA_HOME/zsh/plugins
export ZPLUGDIR=$XDG_DATA_HOME/zsh/plugins

# zsh-vi-mode
export ZVM_INIT_MODE=sourcing
export ZVM_VI_INSERT_ESCAPE_BINDKEY=jk

# fasd
export _FASD_DATA="$XDG_CACHE_HOME/fasd"
export _FASD_VIMINFO="$XDG_CACHE_HOME/viminfo"

# fzf
# --ansi, -- nobold, $FZF_DEFAULT_OPTS
if (( $+commands[fd] )); then
  export FZF_DEFAULT_OPTS='
    --exact
    --reverse
    --cycle
    --prompt=❯\
    --pointer=➜
    --color=fg:#e5e9f0,bg:#3b4252,hl:#81a1c1
    --color=fg+:#e5e9f0,bg+:#3b4252,hl+:#81a1c1
    --color=info:#eacb8a,prompt:#bf6069,pointer:#b48dac
    --color=marker:#a3be8b,spinner:#b48dac,header:#a3be8b'
  export FZF_DEFAULT_COMMAND="fd ."
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND="fd -t d . $HOME"
fi


## Zsh4Humans (OLD)
#setopt glob_dots magic_equal_subst no_multi_os no_local_loops
#setopt rm_star_silent rc_quotes glob_star_short
#setopt complete_in_word         # don't move cursor to end of line on completion
setopt always_to_end auto_cd no_auto_remove_slash c_bases no_flow_control interactive_comments
#prompt_percent prompt_cr no_prompt_bang no_prompt_subst
#    'no_prompt_bang'         'no_prompt_subst'
#    'prompt_sp'              'typeset_silent'   'no_auto_remove_slash'   'no_list_types'
#auto_param_slash

#noglobalrcs
#globdots
#nolisttypes
#promptsubst
#typesetsilent




# Treat these characters as part of a word.
WORDCHARS='_-*?[]~&.;!#$%^(){}<>'

unsetopt BRACE_CCL               # Allow brace character class list expansion.
setopt COMBINING_CHARS           # Combine zero-length punc chars (accents) with base char
setopt RC_QUOTES                 # Allow 'Henry''s Garage' instead of 'Henry'\''s Garage'
setopt HASH_LIST_ALL
unsetopt CORRECT_ALL
unsetopt NOMATCH
unsetopt MAIL_WARNING            # Don't print a warning message if a mail file has been accessed.
unsetopt BEEP                    # Hush now, quiet now.
setopt IGNOREEOF

## Jobs
setopt LONG_LIST_JOBS            # List jobs in the long format by default.
setopt AUTO_RESUME               # Attempt to resume existing job before creating a new process.
setopt NOTIFY                    # Report status of background jobs immediately.
unsetopt BG_NICE                 # Don't run all background jobs at a lower priority.
unsetopt HUP                     # Don't kill jobs on shell exit.
unsetopt CHECK_JOBS              # Don't report on jobs when shell exit.

## History
HISTSIZE=100000                  # Max events to store in internal history.
SAVEHIST=100000                  # Max events to store in history file.
HISTORY_IGNORE="(?|??|cd|cd [~-.]|cd ..|tmux|vim|declare|env|alias|exit|history *|pwd|clear|jobs|mount|m *|mpv *|em *|um|um *|vim */private/*|vim private/*|cd private|cd private/*)"

setopt BANG_HIST                 # Don't treat '!' specially during expansion.
setopt EXTENDED_HISTORY          # Include start time in history records
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
setopt HIST_BEEP                 # Beep when accessing non-existent history.

## Directories
DIRSTACKSIZE=9
#unsetopt AUTO_CD                 # Implicit CD slows down plugins
setopt AUTO_PUSHD                # Push the old directory onto the stack on cd.
setopt PUSHD_IGNORE_DUPS         # Do not store duplicates in the stack.
setopt PUSHD_SILENT              # Do not print the directory stack after pushd or popd.
setopt PUSHD_TO_HOME             # Push to home directory when no argument is given.
setopt CDABLE_VARS               # Change directory to a path stored in a variable.
setopt MULTIOS                   # Write to multiple descriptors.
setopt EXTENDED_GLOB             # Use extended globbing syntax.
unsetopt GLOB_DOTS
unsetopt AUTO_NAME_DIRS          # Don't add variable-stored paths to ~ list
