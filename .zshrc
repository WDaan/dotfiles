export ZSH="/home/YOUR_USERNAME/.oh-my-zsh"

ZSH_THEME="spaceship"
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
alias supdate='sudo apt-get update && sudo apt-get upgrade -y'
alias kc='kubectl'
alias pa='php artisan'
alias pantr='php artisan tinker'
alias dc='docker-compose'
alias e='docker-compose exec'
alias art='docker-compose exec php php artisan'

##################### VARIABLES ############################
export KUBE_EDITOR='nano'
export LC_ALL=en_US.UTF-8

###################### PATH ################################
export PATH="$PATH:/home/linuxbrew/.linuxbrew/bin"
export PATH="$PATH:$HOME/.npm/bin"
export PATH="$PATH:$HOME/.composer/vendor/bin"
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:$HOME/go/bin"
