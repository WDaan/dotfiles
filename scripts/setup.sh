#!/bin/bash

# update package and firmware
update() {
  sudo apt update && sudo apt upgrade -y
  sudo apt-get dist-upgrade -y

  #clean
  sudo apt autoclean
  sudo apt autoremove -y
}

general_packages() {
  echo -e "\033[36mInstalling general packages...\e[0m"
  sudo apt-get install git curl tree trash-cli neofetch unzip -y
  wget https://raw.githubusercontent.com/scopatz/nanorc/master/install.sh -O- | sh
}

install_node() {
  echo -e "\033[36Installing Node..\e[0m"
  curl -sL https://deb.nodesource.com/setup_14.x | sudo bash -
  sudo apt install -y nodejs
  # seperate because npm needs nodejs before it can install
  sudo apt install npm -y

  mkdir "${HOME}/.config/npm" || (mkdir "${HOME}/.config" && mkdir "${HOME}/.config/npm") || true
  npm config set prefix "${HOME}/.config/npm"
}

install_rmate() {
  echo -e "\033[36Installing rmate..\e[0m"
  sudo wget -O /usr/local/bin/rsub \https://raw.github.com/aurora/rmate/master/rmate
  sudo chmod a+x /usr/local/bin/rsub
}

instal_docker() {
  echo -e "\033[36mSetting up Docker...\e[0m"
  sudo apt install docker docker-compose -y

  #adding user to docker
  sudo usermod -aG docker $username
}

install_python() {
  echo -e "\033[36mSetting up Python...\e[0m"
  sudo apt-get install python3 python3-pip -y
}

configure_zsh() {
  echo -e "\033[36mSetting up ZSH...\e[0m"
  sudo apt install zsh
  #install oh-my-zsh
  wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh
  sed -i "s,${ZSH:-~/.oh-my-zsh},${ZSH:-/home/$username/.oh-my-zsh}," install.sh
  chmod a+x install.sh
  ./install.sh
  rm install.sh
  #zsh plugins
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-/home/$username/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-/home/$username/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

  rm /home/$username/.zshrc
  cd ~
  #download .zshrc from github
  wget https://raw.githubusercontent.com/WDaan/dotfiles/master/.zshrc -O /home/$username/.zshrc
  sed -i "s/YOUR_USERNAME/$username/g" /home/$username/.zshrc
  chown $username /home/$username/.zshrc
}

install_kubectl() {
  echo -e "\033[36mSetting Kubectl..\e[0m"
  kubectl version || curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
  kubectl version || sudo chmod +x ./kubectl
  kubectl version || sudo mv ./kubectl /usr/local/bin/kubectl

  #install brew
  brew --version || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

  kubectx -h || brew install kubectx
}

setup_composer() {
  echo -e "\033[36mSetting up PHP & Composer..\e[0m"
  sudo apt-get install php php-mysql php-xml php-mbstring php-zip mariadb-client -y
  sudo curl -s https://getcomposer.org/installer | php
  sudo mv composer.phar /usr/local/bin/composer
  composer global require laravel/installer
}

start_install() {
  echo -e "\033[36m==== Starting installation ====\e[0m"
  if [ "${result[0]}" = true ]; then update; fi
  if [ "${result[1]}" = true ]; then general_packages; fi
  if [ "${result[2]}" = true ]; then configure_zsh; fi
  if [ "${result[3]}" = true ]; then install_node; fi
  if [ "${result[4]}" = true ]; then install_rmate; fi
  if [ "${result[5]}" = true ]; then install_python; fi
  if [ "${result[6]}" = true ]; then instal_docker; fi
  if [ "${result[7]}" = true ]; then setup_composer; fi
  if [ "${result[8]}" = true ]; then install_kubectl; fi

}

function multiselect() {
  # little helpers for terminal print control and key input
  ESC=$(printf "\033")
  cursor_blink_on() { printf "$ESC[?25h"; }
  cursor_blink_off() { printf "$ESC[?25l"; }
  cursor_to() { printf "$ESC[$1;${2:-1}H"; }
  print_inactive() { printf "$2   $1 "; }
  print_active() { printf "$2  $ESC[7m $1 $ESC[27m"; }
  get_cursor_row() {
    IFS=';' read -sdR -p $'\E[6n' ROW COL
    echo ${ROW#*[}
  }
  key_input() {
    local key
    IFS= read -rsn1 key 2>/dev/null >&2
    if [[ $key = "" ]]; then echo enter; fi
    if [[ $key = $'\x20' ]]; then echo space; fi
    if [[ $key = $'\x1b' ]]; then
      read -rsn2 key
      if [[ $key = [A ]]; then echo up; fi
      if [[ $key = [B ]]; then echo down; fi
    fi
  }
  toggle_option() {
    local arr_name=$1
    eval "local arr=(\"\${${arr_name}[@]}\")"
    local option=$2
    if [[ ${arr[option]} == true ]]; then
      arr[option]=
    else
      arr[option]=true
    fi
    eval $arr_name='("${arr[@]}")'
  }

  local retval=$1
  local options
  local defaults

  IFS=';' read -r -a options <<<"$2"
  if [[ -z $3 ]]; then
    defaults=()
  else
    IFS=';' read -r -a defaults <<<"$3"
  fi
  local selected=()

  for ((i = 0; i < ${#options[@]}; i++)); do
    selected+=("${defaults[i]}")
    printf "\n"
  done

  # determine current screen position for overwriting the options
  local lastrow=$(get_cursor_row)
  local startrow=$(($lastrow - ${#options[@]}))

  # ensure cursor and input echoing back on upon a ctrl+c during read -s
  trap "cursor_blink_on; stty echo; printf '\n'; exit" 2
  cursor_blink_off

  local active=0
  while true; do
    # print options by overwriting the last lines
    local idx=0
    for option in "${options[@]}"; do
      local prefix="[ ]"
      if [[ ${selected[idx]} == true ]]; then
        prefix="[x]"
      fi

      cursor_to $(($startrow + $idx))
      if [ $idx -eq $active ]; then
        print_active "$option" "$prefix"
      else
        print_inactive "$option" "$prefix"
      fi
      ((idx++))
    done

    # user key control
    case $(key_input) in
    space) toggle_option selected $active ;;
    enter) break ;;
    up)
      ((active--))
      if [ $active -lt 0 ]; then active=$((${#options[@]} - 1)); fi
      ;;
    down)
      ((active++))
      if [ $active -ge ${#options[@]} ]; then active=0; fi
      ;;
    esac
  done

  # cursor position back to normal
  cursor_to $lastrow
  printf "\n"
  cursor_blink_on

  eval $retval='("${selected[@]}")'
}

#asking which packages
multiselect result "update;general_packages;oh-my-zsh;node;rmate;python;docker;composer;kubectl" ";;true;true;;true;;;;;"

start_install

echo -e "\033[32mDONE!!!🙂\e[0m"
