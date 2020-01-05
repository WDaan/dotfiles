#!/bin/bash

# update package and firmware
update_pi(){
	# update package
	sudo apt-get update
	sudo apt-get -y upgrade

	# update firmware
	sudo rpi-update

    #clean useless packages
    sudo apt autoremove
}

update_deb(){
	sudo apt update
	sudo apt upgrade -y

	#update distro
	sudo apt-get dist-upgrade -y

	#clean
	sudo apt autoclean
	sudo apt autoremove -y
}

update_arch(){
	sudo pacman -Syu --noconfirm

	#clean
	sudo pacman -Scc
}

#general packages
general_packages(){
	printf '====Installing general packages ====\n'
	if [ $debian = 'true' ]
	then
    sudo apt-get install git curl tree trash-cli neofetch -y
    wget https://raw.githubusercontent.com/scopatz/nanorc/master/install.sh -O- | sh
	elif [ $arch = 'true' ]
	then
	sudo pacman -S git curl tree trash-cli neofetch nano-syntax-highlighting --noconfirm
	fi
}

install_zsh(){
	printf '====Installing zsh ====\n'
  	if [ $debian = 'true' ] || [ $rpi = 'true' ]
	then
    sudo apt install zsh 
	elif [ $arch = 'true' ]
	then
	sudo pacman -S zsh
	fi
}

install_node(){
	printf '====Installing node ====\n'
	if [ $debian = 'true' ] || [ $rpi = 'true' ]
	then
    curl -sL https://deb.nodesource.com/setup_12.x | sudo bash -
    sudo apt install -y nodejs
    # seperate because npm needs nodejs before it can install
    sudo apt install  npm -y
	elif [ $arch = 'true' ]
	then
	sudo pacman -S nodejs npm --noconfirm
	fi
    
}

install_rmate(){
	printf '====Installing rmate ====\n'
    sudo wget -O /usr/local/bin/rsub \https://raw.github.com/aurora/rmate/master/rmate
    sudo chmod a+x /usr/local/bin/rsub
}

instal_docker(){
	printf '====Installing docker ====\n'
	if [ $debian = 'true' ]
	then
    sudo apt install docker docker-compose -y 
	elif [ $arch = 'true' ]
	then
	sudo pacman -S docker docker-compose --noconfirm
	elif [ $rpi = 'true' ]
	then
	curl -fsSL get.docker.com -o get-docker.sh && sh get-docker.sh
	fi

	#adding user to docker
	sudo usermod -aG docker $username
}

install_python(){
	printf '====Installing python ====\n'
    if [ $debian = 'true' ] || [ $rpi = 'true' ]
	then
    sudo apt-get install python3 python3-pip python-pygments -y
	elif [ $arch = 'true' ]
	then
	sudo pacman -S python3 python3-pip pygmentize --noconfirm
	fi
    
}

configure_zsh(){
	#install oh-my-zsh
    sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    exit
    #zsh plugins
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

    rm .zshrc
    cd ~

cat <<EOT >> ~/.zshrc
export ZSH="/home/${username}/.oh-my-zsh"
ZSH_THEME="agnoster"
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
alias start_docker='sudo systemctl start docker'
alias stop_docker='docker kill $(docker ps -q) && sleep 1  &&  sudo systemctl stop docker'
alias dc='sudo docker-compose -f /home/${username}/Documents/docker-compose.yml up -d --remove-orphans'
alias plz='sudo $(fc -ln -1)'
alias cat='pygmentize -g'
alias usage='du -h -d1'
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=5'
EOT


    source ~/.zshrc
}

adding_alias(){
    echo "alias supdate='sudo apt-get update && sudo apt-get upgrade -y'" >> ~/.zshrc
    source ~/.zshrc
}

change_hostname(){
    sudo rm /etc/hostname
    sudo touch /etc/hostname
    echo $hostname | sudo tee -a /etc/hostname
}

setup_samba(){
	printf '====Setting up SAMBA (WIP) ====\n'
	if [ $debian = 'true' ] || [ $rpi = 'true' ]
	then
    	sudo apt-get install samba ufw -y
	read -p 'which directory?  ' directory
	read -p 'which sharename?  ' sharename
	
	cat << EOT
	
	[$sharename]
    		comment = Samba on Ubuntu
    		path = $directory
    		read only = no
   		browsable = yes
	EOT | sudo tee -a /etc/samba/smb.conf
	
	sudo service smbd restart
	
	sudo ufw allow samba
	
	sudo smbpasswd -a $USER
	
	elif [ $arch = 'true' ]
	then
	printf '==== SAMBA setup on Arch not implemented ====\n'
	fi
	
}

start_install(){
	printf '==== Starting installation ====\n'
	if [ "${result[0]}" = true ]; then install_zsh && configure_zsh; fi;
	if [ "${result[1]}" = true ]; then install_node; fi;
	if [ "${result[2]}" = true ]; then install_rmate; fi;
	if [ "${result[3]}" = true ]; then install_python; fi;
	if [ "${result[4]}" = true ]; then instal_docker; fi;
	if [ "${result[5]}" = true ]; then setup_samba; fi;
	if [ "${result[6]}" = true ]
	then
		read -p 'which hostname?  ' hostname
		read -p 'which username?  ' username
		change_hostname
	else
		username=$USER
	fi
	
}

function multiselect {

    # little helpers for terminal print control and key input
    ESC=$( printf "\033")
    cursor_blink_on()   { printf "$ESC[?25h"; }
    cursor_blink_off()  { printf "$ESC[?25l"; }
    cursor_to()         { printf "$ESC[$1;${2:-1}H"; }
    print_inactive()    { printf "$2   $1 "; }
    print_active()      { printf "$2  $ESC[7m $1 $ESC[27m"; }
    get_cursor_row()    { IFS=';' read -sdR -p $'\E[6n' ROW COL; echo ${ROW#*[}; }
    key_input()         {
      local key
      IFS= read -rsn1 key 2>/dev/null >&2
      if [[ $key = ""      ]]; then echo enter; fi;
      if [[ $key = $'\x20' ]]; then echo space; fi;
      if [[ $key = $'\x1b' ]]; then
        read -rsn2 key
        if [[ $key = [A ]]; then echo up;    fi;
        if [[ $key = [B ]]; then echo down;  fi;
      fi 
    }
    toggle_option()    {
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

    IFS=';' read -r -a options <<< "$2"
    if [[ -z $3 ]]; then
      defaults=()
    else
      IFS=';' read -r -a defaults <<< "$3"
    fi
    local selected=()

    for ((i=0; i<${#options[@]}; i++)); do
      selected+=("${defaults[i]}")
      printf "\n"
    done

    # determine current screen position for overwriting the options
    local lastrow=`get_cursor_row`
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
        case `key_input` in
            space)  toggle_option selected $active;;
            enter)  break;;
            up)     ((active--));
                    if [ $active -lt 0 ]; then active=$((${#options[@]} - 1)); fi;;
            down)   ((active++));
                    if [ $active -ge ${#options[@]} ]; then active=0; fi;;
        esac
    done

    # cursor position back to normal
    cursor_to $lastrow
    printf "\n"
    cursor_blink_on

    eval $retval='("${selected[@]}")'
}

#asking which packages
multiselect result "oh-my-zsh;node;rmate;python;docker;samba;change hostname/username" "true;true;;true;;;;"

#asking which kind of system
PS3='Please enter your choice: '
options=("rpi" "debian" "arch" "Quit")
select opt in "${options[@]}"
do
	case $opt in
        "rpi")
		  printf '==== RPI ====\n'
		  rpi='true'
		  update_pi
		  general_packages
		  start_install
		  adding_alias
          break
          ;;
        "debian")
		  printf '==== DEBIAN ====\n'
		  debian='true'
		  update_deb
		  general_packages
		  start_install
		  adding_alias
          break
          ;;
        "arch")
		  printf '==== arch ====\n'
		  arch='true'
		  update_arch
		  general_packages
		  start_install
          break
          ;;
        *) echo "invalid option";;
	esac
done

echo 'DONE!!!'
