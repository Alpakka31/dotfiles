###########
# .bashrc #
###########

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# User specific directories
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

ex() {
    if [ -f $1 ]; then
        case $1 in
            *.tar.bz2)  tar xjf $1      ;;
            *.tar.gz)   tar xzf $1      ;;
            *.bz2)      bunzip2 $1      ;;
            *.rar)      unrar x $1      ;;
            *.gz)       gunzip $1       ;;
            *.tar)      tar xf $1       ;;
            *.tbz2)     tar xjf $1      ;;
            *.tgz)      tar xzf $1      ;;
            *.zip)      unzip $1        ;;
            *.Z)        uncompress $1   ;;
            *.7z)       7z x $1         ;;
            *.deb)      ar x $1         ;;
            *.tar.xz)   tar xf $1       ;;
            *.tar.zst)  unzstd $1       ;;
            *)          echo "'$1' cannot be extracted via ex()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

alias doas="doas --"

alias ..="cd .."
alias ...="cd ../.."
alias .3="cd ../../.."
alias .4="cd ../../../.."
alias .5="cd ../../../../.."

alias uppkgs="sudo pacman -Syyu"
alias upaur="yay -Sua"
alias unlockdb="sudo rm /var/lib/pacman/db.lck"
alias cleanup="sudo pacman -Rns $(pacman -Qtdq)"

alias upmirror="sudo reflector -f 30 -l 30 -n 10 --verbose --save /etc/pacman.d/mirrorlist"

alias ls="ls --color=always"
alias grep="grep --color=auto"
alias egrep="egrep --color=auto"
alias fgrep="fgrep --color=auto"

alias cp="cp -i"
alias rm="rm -i"