g() { [[ $# = 0 ]] && git status --short . || git $*; }

alias cdg='cd `git rev-parse --show-toplevel`'
alias git='noglob git'
#alias ga='git add'
alias gap='git add --patch'
alias gb='git branch -av'
alias gop='git open'
alias gbl='git blame'
#alias gc='git commit'
alias gcm='git commit -m'
alias gca='git commit --amend'
alias gcf='git commit --fixup'
alias gcl='git clone'
alias gco='git checkout'
alias gcoo='git checkout --'
alias gf='git fetch'
alias gi='git init'
alias gl='git log --graph --pretty="format:%C(yellow)%h%Creset %C(red)%G?%Creset%C(green)%d%Creset %s %Cblue(%cr) %C(bold blue)<%aN>%Creset"'
alias gll='git log --pretty="format:%C(yellow)%h%Creset %C(red)%G?%Creset%C(green)%d%Creset %s %Cblue(%cr) %C(bold blue)<%aN>%Creset"'
alias gL='gl --stat'
alias gpl='git pull --rebase --autostash'
alias gst='git stash'
alias gr='git reset HEAD'
alias gv='git rev-parse'

alias gs='git status'
alias gss='git status --short .'
alias gd='git diff'
alias gds='git diff --staged'
alias ga='git add --patch'
alias gc='git commit --verbose'
alias gp='git push'
alias gpf='git push --force-with-lease'
alias gpu='git push --set-upstream-origin \`git rev-parse --abbrev-ref HEAD\`'
# fzf
if (( $+commands[fzf] )); then
    __git_log () {
        # format str implies:
        #  --abbrev-commit
        #  --decorate
        git log \
            --color=always \
            --graph \
            --all \
            --date=short \
            --format="%C(bold blue)%h%C(reset) %C(green)%ad%C(reset) | %C(white)%s %C(red)[%an] %C(bold yellow)%d"
        }

    _fzf_complete_git() {
        ARGS="$@"

    # these are commands I commonly call on commit hashes.
    # cp->cherry-pick, co->checkout

    if [[ $ARGS == 'git cp'* || \
        $ARGS == 'git cherry-pick'* || \
        $ARGS == 'git co'* || \
        $ARGS == 'git checkout'* || \
        $ARGS == 'git reset'* || \
        $ARGS == 'git show'* || \
        $ARGS == 'git log'* ]]; then
            _fzf_complete "--reverse --multi" "$@" < <(__git_log)
        else
            eval "zle ${fzf_default_completion:-expand-or-complete}"
    fi
}

_fzf_complete_git_post() { sed -e 's/^[^a-z0-9]*//' | awk '{print $1}' }
fi
