# References:
# http://zsh.sourceforge.net/Doc/Release/Completion-Widgets.html#Completion-Matching-Control
# http://zsh.sourceforge.net/Doc/Release/Completion-System.html#Completion-System

# TODO: complete-with-dot
# https://github.com/romkatv/dotfiles-public/commit/50647477461db9ed767d134884527217943a5587
# https://www.zsh.org/mla/users/2007/msg00465.html

# You can hook zstyle to see exactly what stuff is being requested
# A better way is to C-x h

# Disable the old completion system
zstyle ':completion:*' use-compctl false
function compctl() {
    print -P "\n%F{red}Don't use compctl anymore%f"
}

# Cache the completion results
zstyle ':completion:*:complete:*' use-cache true
zstyle ':completion:*' cache-path "$ZSH_CACHE"
zstyle ':completion:*:complete:*' cache-policy _caching_policy
_caching_policy() {
    # if it doesn't exist or is 14 days old, it is considered invalid
    [[ ! -f $1 && -n "$1"(Nm+14) ]]
}

# Completeness order:
# _complete - normal completion function _extensions - select extensions by *. \t select extensions
# _match - similar to _complete but allows wildcards
# _expand_alias - expands aliases _ignored - ignored by ignored-patterns
# zstyle ':completion:*' completer _expand_alias _complete _extensions _match _files
# Some completer calls are not considered the first time they are called because they are more expensive
zstyle -e ':completion:*' completer '
   if [[ $_last_try != "$HISTNO$BUFFER$CURSOR" ]]; then
     _last_try="$HISTNO$BUFFER$CURSOR"
     reply=(_expand_alias _complete _extensions _match _files)
   else
     reply=(_complete _ignored _correct _approximate)
   fi'
#zstyle ':completion:*' completer _complete _match _approximate #_list

# Enhanced filename completion
# 0 - exact match ( Abc -> Abc ) 1 - capitalization correction ( abc -> Abc )
# 2 - single word completion ( f-b -> foo-bar ) 3 - suffix completion ( .cxx -> foo.cxx )
zstyle ':completion:*:(argument-rest|files):*' matcher-list '' \
    'm:{[:lower:]-}={[:upper:]_}' \
    'r:|[.,_-]=* r:|=*' \
    'r:|.=* r:|=*'
# zstyle ':completion:*' matcher-list 'b:=*'

# Do not expand common aliases
zstyle ':completion:*' regular false

# Result style
# zstyle ':completion:*:*:*:*:*' menu select
# zstyle ':completion:*:options' description 'yes'
# zstyle ':completion:*:options' auto-description '%d'
# zstyle ':completion:*:corrections' format ' %F{green}-- %d (errors: %e) --%f'
# zstyle ':completion:*:descriptions' format ' %F{yellow}-- %d --%f'
# zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
# zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
# zstyle ':completion:*:default' list-prompt '%S%M matches%s'
# zstyle ':completion:*' format ' %F{yellow}-- %d --%f'

zstyle ':completion:*' menu yes select
zstyle ':completion:*' list-grouped false
zstyle ':completion:*' list-separator ''
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:warnings' format '%F{red}%B-- No match for: %d --%b%f'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
zstyle ':completion:*:descriptions' format '[%d]'
# Group matches and describe.
#zstyle ':completion:*:corrections' format '%B%F{green}%d (errors: %e)%f%b'
#zstyle ':completion:*:messages' format '%B%F{yellow}%d%f%b'
#zstyle ':completion:*:warnings' format '%B%F{red}No such %d%f%b'
#zstyle ':completion:*:errors' format '%B%F{red}No such %d%f%b'
#zstyle ':completion:*:descriptions' format $'\e[35;1m%d\e[0m'
#zstyle ':completion:*:default' list-prompt '%S%M matches%s'

# Completes the list of all processes for the current user
# PID completion for kill
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm,cmd -w -w"
zstyle ':completion:*:kill:*' ignored-patterns '0'
#zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;36=0=01'
#zstyle ':completion:*:*:kill:*' menu yes select
#zstyle ':completion:*:*:kill:*' force-list always
#zstyle ':completion:*:*:kill:*' insert-ids single

# complete manual by their section, from grml
zstyle ':completion:*:manuals'    separate-sections true
zstyle ':completion:*:manuals.*'  insert-sections   true
#zstyle ':completion:*:manuals' separate-sections true
#zstyle ':completion:*:manuals.(^1*)' insert-sections true

# Completes third-party Git subcommands
# It's better to use git-extras directly
# zstyle ':completion:*:*:git:*' user-commands ${${(M)${(k)commands}:#git-*}/git-/}

# ignore the zwc or whatever
# FIXME: causes zmodload's completions to result in other files
# zstyle ':completion:*:*:*:*'   file-patterns '^*.(zwc|pyc):compiled-files' '*:all-files'
# zstyle ':completion:*:*:rm:*'  file-patterns '*:all-files'
# zstyle ':completion:*:*:gio:*' file-patterns '*:all-files'

# Allow docker to recognize combinations of commands like -it when completing
zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes

# color
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# fg/bg completions use jobs id
zstyle ':completion:*:jobs' verbose true
zstyle ':completion:*:jobs' numbers true






# Don't offer history completion; we have fzf, C-r, and
# zsh-history-substring-search for that.
ZSH_AUTOSUGGEST_STRATEGY=(completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=30
ZSH_AUTOSUGGEST_MANUAL_REBIND=1
#ZSH_AUTOSUGGEST_USE_ASYNC=1

# Expand partial paths, e.g. cd f/b/z == cd foo/bar/baz (assuming no ambiguity)
zstyle ':completion:*:paths' path-completion yes

# Fix slow one-by-one character pasting when bracketed-paste-magic is on. See
# zsh-users/zsh-syntax-highlighting#295
zstyle ':bracketed-paste-magic' active-widgets '.self-*'

# Options
setopt COMPLETE_IN_WORD    # Complete from both ends of a word.
setopt PATH_DIRS           # Perform path search even on command names with slashes.
setopt AUTO_MENU           # Show completion menu on a successive tab press.
setopt AUTO_LIST           # Automatically list choices on ambiguous completion.
# setopt AUTO_PARAM_SLASH    # If completed parameter is a directory, add a trailing slash.
# setopt AUTO_PARAM_KEYS
# setopt FLOW_CONTROL        # Disable start/stop characters in shell editor.
unsetopt MENU_COMPLETE     # Do not autoselect the first completion entry.
unsetopt COMPLETE_ALIASES  # Completion for aliases
# unsetopt ALWAYS_TO_END     # Move cursor to the end of a completed word.
unsetopt CASE_GLOB

# Fuzzy match mistyped completions.
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric
# Increase the number of errors based on the length of the typed word.
zstyle -e ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3))numeric)'
# Don't complete unavailable commands.
zstyle ':completion:*:functions' ignored-patterns '(_*|.*|pre(cmd|exec))'
# Merge multiple, consecutive slashes in paths
zstyle ':completion:*' squeeze-slashes true
# cd will never select the parent directory (e.g.: cd ../<TAB>).
zstyle ':completion:*:cd:*' ignore-parents parent pwd
# Prevent CVS files/directories from being completed:
zstyle ':completion:*:(all-|)files' ignored-patterns '(|*/)CVS'
zstyle ':completion:*:cd:*' ignored-patterns '(*/)#CVS'






# Don't wrap around when navigating to either end of history
zstyle ':completion:*:history-words' stop yes
zstyle ':completion:*:history-words' remove-all-dups yes
zstyle ':completion:*:history-words' list false
zstyle ':completion:*:history-words' menu yes
# Exclude internal/fake envvars
zstyle ':completion::*:(-command-|export):*' fake-parameters ${${${_comps[(I)-value-*]#*,}%%,*}:#-*-}
# Sory array completion candidates
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters
# Complete hostnames from ssh files too
zstyle -e ':completion:*:hosts' hosts 'reply=(
  ${=${=${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) 2>/dev/null)"}%%[#| ]*}//\]:[0-9]*/ }//,/ }//\[/ }
  ${=${${${${(@M)${(f)"$(cat ~/.ssh/config 2>/dev/null)"}:#Host *}#Host }:#*\**}:#*\?*}}
)'
# Don't complete uninteresting users
zstyle ':completion:*:users' ignored-patterns \
  adm amanda apache avahi beaglidx bin cacti canna clamav daemon \
  dbus distcache dovecot fax ftp games gdm gkrellmd gopher \
  hacluster haldaemon halt hsqldb ident junkbust ldap lp mail \
  mailman mailnull mldonkey mysql nagios \
  named netdump news nfsnobody nobody 'nixbld*' nscd ntp nut nx openvpn \
  operator pcap postfix postgres privoxy pulse pvm quagga radvd \
  rpc rpcuser rpm shutdown squid sshd sync 'systemd-*' uucp vcsa xfs '_*'
# ... unless we really want to.
zstyle '*' single-ignored show
# Ignore multiple entries.
zstyle ':completion:*:(rm|kill|diff):*' ignore-line other
zstyle ':completion:*:rm:*' file-patterns '*:all-files'
# Media Players
zstyle ':completion:*:*:mpg123:*' file-patterns '*.(mp3|MP3):mp3\ files *(-/):directories'
zstyle ':completion:*:*:mpg321:*' file-patterns '*.(mp3|MP3):mp3\ files *(-/):directories'
zstyle ':completion:*:*:ogg123:*' file-patterns '*.(ogg|OGG|flac):ogg\ files *(-/):directories'
zstyle ':completion:*:*:mocp:*' file-patterns '*.(wav|WAV|mp3|MP3|ogg|OGG|flac):ogg\ files *(-/):directories'
# SSH/SCP/RSYNC
zstyle ':completion:*:(scp|rsync):*' tag-order 'hosts:-host:host hosts:-domain:domain hosts:-ipaddr:ip\ address *'
zstyle ':completion:*:(scp|rsync):*' group-order users files all-files hosts-domain hosts-host hosts-ipaddr
zstyle ':completion:*:ssh:*' tag-order 'hosts:-host:host hosts:-domain:domain hosts:-ipaddr:ip\ address *'
zstyle ':completion:*:ssh:*' group-order users hosts-domain hosts-host users hosts-ipaddr
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-host' ignored-patterns '*(.|:)*' loopback ip6-loopback localhost ip6-localhost broadcasthost
#zstyle ':completion:*:(ssh|scp|rsync):*:hosts-domain' ignored-patterns '<->.<->.<->.<->' '^[-[:alnum:]]##(.[-[:alnum:]]##)##' '*@*'
#zstyle ':completion:*:(ssh|scp|rsync):*:hosts-ipaddr' ignored-patterns '^(<->.<->.<->.<->|(|::)([[:xdigit:].]##:(#c,2))##(|%*))' '127.0.0.<->' '255.255.255.255' '::1' 'fe80::*'
