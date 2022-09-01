export ZSH="/Users/daanwijns/.oh-my-zsh"

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
alias e='docker-compose exec'
alias gc='git remote update origin --prune ; git --no-pager  branch -vv | awk '\''/: gone]/{print $1}'\'' |  xargs git branch -D'

##################### VARIABLES ############################
export LC_ALL=en_US.UTF-8

###################### PATH ################################
export PATH="/opt/local/bin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/usr/local/go/bin:$PATH"

###################### FUNCTIONS ###########################
function ip() {
    docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$1"
}

function shell(){
    docker exec -u root -it $(docker ps -q | head -n 1) sh
}


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


eval $(thefuck --alias)
eval "$(starship init zsh)"

