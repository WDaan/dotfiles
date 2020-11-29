export ZSH="/home/pi/.oh-my-zsh"

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


source /home/pi/.oh-my-zsh/oh-my-zsh.sh

alias start_docker='sudo systemctl start docker'
alias stop_docker='docker kill  && sleep 1  &&  sudo systemctl stop docker'
alias dc='sudo docker-compose -f /home/pi/Documents/Docker/docker-compose.yml up -d --remove-orphans'
alias plz='sudo $(fc -ln -1)'
alias cat='pygmentize -g'
alias usage='du -h -d1'
alias temp="vcgencmd measure_temp"
alias supdate='sudo apt-get update && sudo apt-get upgrade -y'

export PATH="$PATH:$HOME/.config/composer/vendor/bin"