#!/usr/bin/env bash

cd $HOME/tweet

install() {
		sudo apt-get update
		sudo apt-get upgrade
sudo apt-get install lua5.1 luarocks lua-socket lua-sec redis-server curl 
sudo luarocks install oauth 
sudo luarocks install redis-lua 
sudo luarocks install lua-cjson 
sudo luarocks install ansicolors 
sudo luarocks install serpent 
}

function print_logo() {
	green "         |"
	green "         |"
	green "         |"
	green "         |"
	echo -e "\n\e[0m"
}

function logo_play() {
    declare -A txtlogo
    seconds="0.010"
    txtlogo[1]="|"
    txtlogo[2]="|"
    txtlogo[3]="|"
    txtlogo[4]="|"
    printf "\e[31m\t"
    for i in ${!txtlogo[@]}; do
        for x in `seq 0 ${#txtlogo[$i]}`; do
            printf "${txtlogo[$i]:$x:1}"
            sleep $seconds
        done
        printf "\n\t"
    done
    printf "\n"
	echo -e "\e[0m"
}

function hamid() {
	echo -e "\e[0m"
	green "     >>>>                       H                            "
	green "     >>>>                       A                            "
	white "     >>>>                       M                            "
	white "     >>>>                       I                            "
	red   "     >>>>                       D                            "
	red   "     >>>>                       :)                           "
	echo -e "\e[0m"
}

red() {
  printf '\e[1;31m%s\n\e[0;39;49m' "$@"
}
green() {
  printf '\e[1;32m%s\n\e[0;39;49m' "$@"
}
white() {
  printf '\e[1;37m%s\n\e[0;39;49m' "$@"
}
update() {
	git pull
}

if [ "$1" = "install" ]; then
	print_logo
	hamid
	logo_play
	install
elif [ "$1" = "update" ]; then
	logo_play
	beyondteam
	update
	exit 1
else
	print_logo
	hamid
	logo_play
	green "Bot running..."
	#sudo service redis-server restart
	lua ./bot/bot.lua
fi
