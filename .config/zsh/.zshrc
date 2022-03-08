source $ZDOTDIR/config.zsh

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# NOTE ZGEN_DIR and ZGEN_SOURCE are forward-declared in modules/shell/zsh.nix
# NOTE Using zgenom because zgen is no longer maintained
#if [ ! -d "$ZGEN_DIR" ]; then
#  echo "Installing jandamm/zgenom"
#  git clone https://github.com/jandamm/zgenom "$ZGEN_DIR"
#fi
#source $ZGEN_DIR/zgenom.zsh
# Check for plugin and zgenom updates every 7 days
# This does not increase the startup time.
#cfg submodule update
#if ! zgenom saved; then
#  echo "Initializing zgenom"
#  rm -f $ZDOTDIR/*.zwc(N) \
#        $XDG_CACHE_HOME/zsh/*(N) \
#        $ZGEN_INIT.zwc

# NOTE Be extra careful about plugin load order, or subtle breakage
# can emerge. This is the best order I've found for these plugins.
[ -f $ZPLUGDIR/fzf.plugin.zsh ] && source "$ZPLUGDIR/fzf.plugin.zsh"
source "$ZPLUGDIR/zsh-vi-mode/zsh-vi-mode.plugin.zsh"
source "$ZPLUGDIR/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
source "$ZPLUGDIR/zsh-completions/zsh-completions.plugin.zsh"
source "$ZPLUGDIR/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh"
source "$ZPLUGDIR/zsh-history-substring-search/zsh-history-substring-search.plugin.zsh"
source "$ZPLUGDIR/powerlevel10k/powerlevel10k.zsh-theme"
source "$ZPLUGDIR/zsh-autopair/autopair.zsh"

# To customize prompt, run `p10k configure` or edit $ZDOTDIR/p10k.zsh.
source "$ZDOTDIR/p10k.zsh"

#  zgenom save
#  zgenom compile $ZDOTDIR

autoload -U colors && colors

## Bootstrap interactive sessions
if [[ $TERM != dumb ]]; then
  autoload -Uz compinit && compinit -u -d $ZSH_CACHE/zcompdump

  source "$ZDOTDIR/keybinds.zsh"
  source "$ZDOTDIR/completion.zsh"
  source "$ZDOTDIR/aliases.zsh"
  source "$XDG_CONFIG_HOME/git/aliases.zsh"
  # Auto-generated by nixos
  #_source $ZDOTDIR/extra.zshrc
  # If you have host-local configuration, put it here
  #_source $ZDOTDIR/local.zshrc

  _cache fasd --init posix-alias zsh-{hook,{c,w}comp{,-install}}
  autopair-init
fi

# Export environment variables.
export HISTFILE="$XDG_DATA_HOME/history"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export GOPATH="$XDG_DATA_HOME/go"

# Defaults
export PAGER="less"
export GPG_TTY=$TTY
export LESS='-rsiF --mouse --wheel-lines=3'
export LESSHISTFILE=-

# Color Man Pages
export LESS_TERMCAP_mb=$'\E[1;34m'     # begin bold
export LESS_TERMCAP_md=$'\E[1;34m'     # begin blink
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\E[01;35m'    # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline
