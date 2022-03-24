# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/usr/share/fzf/completion.zsh" 2> /dev/null

# Key bindings
# ------------
FILE="/usr/share/fzf/key-bindings.zsh"
if [[ -a $FILE ]]; then
    source $FILE
fi
