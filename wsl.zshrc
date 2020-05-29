export ZSH="/home/daan/.oh-my-zsh"
ZSH_THEME="spaceship"
ZSH_DISABLE_COMPFIX=true 
SPACESHIP_KUBECTL_SHOW=true

plugins=(
    git
    zsh-syntax-highlighting
    zsh-autosuggestions
    web-search
    z
    npm
    git
    kubectl
)
source ~/.oh-my-zsh/oh-my-zsh.sh

eval $(thefuck --alias fuck)

alias plz='sudo $(fc -ln -1)'
alias cat='pygmentize -g'
alias usage='du -h -d1'
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=5'
alias supdate='sudo apt-get update && sudo apt-get upgrade -y'
alias kc='kubectl'
alias subl='"/mnt/c/Program Files/Sublime Text 3/subl.exe"'
alias exp='Explorer.exe .'
alias pa='php artisan'
alias pantr='php artisan tinker'

###################### PATH ################################"

export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
export PATH="$PATH:$HOME/.npm/bin"
export PATH="$PATH:$HOME/.symfony/bin"
export PATH="$PATH:$HOME/.composer/vendor/bin"
export GOPATH="$HOME/go"
export PATH="$PATH:/usr/local/go/bin:$GOPATH/bin"
export DENO_INSTALL="/home/daan/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"

################### C/C++ compile functions ###########################
gcc_comp() {
gcc -o "${1%.*}" "$1";
}

g++_comp() {
g++ -o "${1%.*}" "$1";
}

#usage bv: gcc_run test.c
gcc_run(){
gcc -o "${1%.*}" "$1";
./"${1%.*}";
}

g++_run(){
g++ -o "${1%.*}" "$1";
./"${1%.*}".exe;
}

#usage bv : gcc_mtp util.h util.c main.c -o test
gcc_mtp(){
array=( "$@" )
files=();
for var in "${@:1:$(($#-1))}"
do
        files+=("$var") ;
done
gcc "${files[@]}" -o "${array[-1]}";
./"${array[-1]}";
}


g++_mtp(){
array=( "$@" )
files=();
for var in "${@:1:$(($#-1))}"
do
        files+=("$var") ;
done
g++ "${files[@]}" -o "${array[-1]}";
./"${array[-1]}".exe;
}

