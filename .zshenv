###########
# .zshenv #
###########

typeset -U PATH path
path=("$HOME/.local/bin" "$HOME/bin" "$path[@]")
export PATH