export ZSH="/home/daan/.oh-my-zsh"

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

alias subl='subl3'
alias mouse='python /home/daan/Documents/Github/dotfiles/scripts/mouse.py'

alias sound='gnome-control-center sound'
alias settings='gnome-control-center'
alias start_docker='sudo systemctl start docker'
alias stop_docker='docker kill $(docker ps -q) && sleep 1  &&  sudo systemctl stop docker'
alias dc='sudo docker-compose -f /home/daan/Documents/docker-compose.yml up -d --remove-orphans'
alias batt_info='upower -i /org/freedesktop/UPower/devices/battery_BAT0'
alias plz='sudo $(fc -ln -1)'
alias ssh='TERM=xterm ssh'
alias cat='pygmentize -g'
alias usage='du -h -d1'
alias cowsay='cowsay -f $(ls /usr/share/cows | shuf -n1)'

#################### I3 FUNCTIONS ############################

function dedic() {
	if [ $1 = 'on' ] 
	then 
		sudo tee /proc/acpi/bbswitch <<< ON
		echo Dedicated graphics turned on.
	elif [ $1 = 'off' ] 
	then 
		sudo tee /proc/acpi/bbswitch <<< OFF
		echo Dedicated graphics turned off.
	elif [ $1 = 'info' ] 
	then 
		sudo cat /proc/acpi/bbswitch 
	else 
		echo 'not a valid option'
	fi
}

function screen(){
	if [ $1 = 'laptop' ]
	then
		~/.screenlayout/laptop.sh
	elif [ $1 = 'home' ]
	then
		~/.screenlayout/home_4K.sh
	elif [ $1 = '4K' ]
	then
		~/.screenlayout/4K_only.sh
	elif [ $1 = 'blendr' ]
	then
		~/.screenlayout/blendr.sh
	else 
		echo 'not a valid option'
	fi
}

######################################################################


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
