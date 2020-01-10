###########
# .bashrc #
###########

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# User specific directories
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

alias ls="ls --color=auto"
alias grep="grep --color=auto"
alias diff="diff --color=auto"

export PS1="\u@\h [\w] \$ "