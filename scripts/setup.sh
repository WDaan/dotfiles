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
    
    #add general packages
    sudo apt-get install git curl tree trash-cli ufw neofetch
}

update_deb(){
	sudo apt update
	sudo apt upgrade -y

	#update distro
	sudo apt-get dist-upgrade -y

	#clean
	sudo apt autoclean
	sudo apt autoremove -y
	
	#add general packages
    	sudo apt-get install git curl tree trash-cli ufw neofetch
}

update_arch(){
	sudo pacman -Syu

	#clean
	sudo pacman -Sc
}

install_zsh(){
    sudo apt install zsh 
}

change_hostname(){
    sudo rm /etc/hostname
    sudo touch /etc/hostname
    echo $hostname | sudo tee -a /etc/hostname
}

install_node(){
    curl -sL https://deb.nodesource.com/setup_12.x | sudo bash -
    sudo apt install -y nodejs
    sudo apt install npm
}

install_rmate(){
    sudo wget -O /usr/local/bin/rsub \https://raw.github.com/aurora/rmate/master/rmate
    sudo chmod a+x /usr/local/bin/rsub
}

install_python(){
    sudo apt-get install python3-pip -y
    sudo apt-get install python3 -y
    sudo apt-get install python3-pygments
}

configure_zsh(){
	#install oh-my-zsh
    sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    #zsh plugins
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions

    rm .zshrc
    cd ~

cat <<EOT >> .zshrc
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


source $ZSH/oh-my-zsh.sh


alias start_docker='sudo systemctl start docker'
alias stop_docker='docker kill $(docker ps -q) && sleep 1  &&  sudo systemctl stop docker'
alias dc='sudo docker-compose -f /home/${username}/Documents/docker-compose.yml up -d --remove-orphans'
alias plz='sudo $(fc -ln -1)'
alias cat='pygmentize -g'
alias usage='du -h -d1'


ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=5'
EOT


    source .zshrc
}

adding_alias(){
    echo "alias supdate='sudo apt-get update && sudo apt-get upgrade -y'" >> .zshrc
    source .zshrYc
}

read -p 'using a rpi? y/n:  ' rpi

if [ $rpi = 'y' ]
then
	echo update_pi
else
	read -p 'using a debian base? y/n (arch):  ' distro
	if [ $distro = 'y' ]
	then
		update_deb
	else
		update_arch
	fi
fi

read -p 'which hostname?:  ' hostname
read -p 'which username?:  ' username

change_hostname hostname

if [ $rpi = 'y' ] || [ $distro = 'y' ]
then
install_zsh
install_node
install_rmate
install_python
else
    sudo pacman -S git base-devel
	sudo pacman -S zsh
    sudo pacman -S nodejs npm python-pygments tree
    sudo pacman -S docker docker-compose
    cd ~
    #install yay
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
fi

configure_zsh


if [ $rpi = 'y' ] || [ $distro = 'y' ]
then
    adding_alias
fi

echo 'DONE.'
