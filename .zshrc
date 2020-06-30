export ZSH="/home/daan/.oh-my-zsh"
ZSH_THEME="spaceship"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=5'

plugins=(
    git
    zsh-syntax-highlighting
    zsh-autosuggestions
    web-search
    z
    npm
    git
)

source ~/.oh-my-zsh/oh-my-zsh.sh

eval $(thefuck --alias fuck)

alias plz='sudo $(fc -ln -1)'
alias cat='pygmentize -g'
alias usage='du -h -d1'
alias supdate='sudo apt-get update && sudo apt-get upgrade -y'
alias kc='kubectl'
alias pa='php artisan'
alias pantr='php artisan tinker'

###################### PATH ################################"

export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
export PATH="$PATH:$HOME/.config/npm/bin"
export PATH="$PATH:$HOME/.config/composer/vendor/bin"

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
