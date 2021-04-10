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
alias bcat='batcat'
alias usage='du -h -d1'
alias supdate='sudo apt-get update && sudo apt-get upgrade -y'
alias kc='kubectl'
alias pa='php artisan'
alias pantr='php artisan tinker'
alias dc='docker-compose'

##################### VARIABLES ############################
export KUBE_EDITOR='nano'

###################### PATH ################################
export PATH="$PATH:/home/linuxbrew/.linuxbrew/bin"
export PATH="$PATH:$HOME/.config/npm/bin"
export PATH="$PATH:$HOME/.config/composer/vendor/bin"
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:$HOME/go/bin"
export PATH="$HOME/.symfony/bin:$PATH"
