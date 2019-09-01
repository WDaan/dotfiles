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

install_zsh(){
    sudo apt install git zsh
    sudo apt install curl
    #install oh-my-zsh
    sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    #zsh plugins
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions

    source .zshrc

    echo '#mijn edits' >> .zshrc
    echo "ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=5'" >> .zshrc
}

change_hostname(){
    sudo rm /etc/hostname
    sudo touch /etc/hostname
    echo 'pi4' >> /etc/hostname
}

install_node(){
    curl -sL https://deb.nodesource.com/setup_10.x | sudo bash -
    sudo apt install -y nodejs
    sudo apt install npm

}

install_rmate(){
    mkdir bin
    curl -Lo ~/bin/rmate https://raw.githubusercontent.com/textmate/rmate/master/bin/rmate
    chmod a+x ~/bin/rmate
}

install_python(){
    sudo apt-get install python3-pip -y
    sudo apt-get install python3 -y
    sudo apt-get install python3-pygments
}

adding_alias(){
    echo "alias supdate='sudo apt-get update && sudo apt-get upgrade -y'" >> .zshrc
    echo "alias cat='pygmentize -g'" >> .zshrc
    echo "alias usage='du -h -d1'" >> .zshrc
    echo "alias temp='vcgemdcmd measure_temp'" >> .zshrc
    echo "alias home='cd /home/pi'" >> .zshrc

    source .zshrc
}

update_pi
install_zsh
change_hostname
install_node
install_rmate
install_python
adding_alias

echo 'DONE.'