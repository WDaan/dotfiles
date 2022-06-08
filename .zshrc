export ZSH="/home/YOUR_USERNAME/.oh-my-zsh"

ZSH_THEME="agnoster"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=5'

plugins=(
  git
  zsh-syntax-highlighting
  zsh-autosuggestions
  z
  npm
)

source ~/.oh-my-zsh/oh-my-zsh.sh

#################### ALIASES ###############################
alias plz='sudo $(fc -ln -1)'
alias usage='du -h -d1'
alias kc='kubectl'
alias pa='php artisan'
alias pantr='php artisan tinker'
alias dc='docker-compose'
alias dci='docker-compose -f docker-compose.yml  -f docker-compose.ci.yml'
alias dct='docker-compose -f docker-compose.tracing.yml'
alias e='docker-compose exec'
alias art='docker-compose exec php php artisan'
alias gc='git remote update origin --prune ; git --no-pager  branch -vv | awk '\''/: gone]/{print $1}'\'' |  xargs git branch -D'

##################### VARIABLES ############################
export KUBE_EDITOR='nano'
export LC_ALL=en_US.UTF-8
export HELM_EXPERIMENTAL_OCI=1
###################### PATH ################################
export PATH="/opt/local/bin:$PATH"
export PATH="/Users/gvv/flutter/bin:$PATH"
export PATH="/usr/local/opt/mysql-client/bin:$PATH"
export PATH="/Users/gvv/.composer/vendor/bin:$PATH"

###################### FUNCTIONS ###########################
function ip() {
    docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$1"
}

function shell(){
    docker exec -u root -it $(docker ps -q | head -n 1) sh
}


eval $(thefuck --alias)

eval "$(starship init zsh)"

