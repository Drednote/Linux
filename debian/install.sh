#!/bin/bash

RED='\033[0;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

UTILS="vim htop"

sudo apt-get -y update && sudo apt-get -y upgrade && sudo apt-get -y install curl

CUR_PWD=$(pwd)
mkdir "$HOME"/bin
cp -r "$CUR_PWD"/bin "$HOME"
mkdir "$HOME"/IdeaProjects
ln -s "$HOME"/bin/docker-compose "$HOME"/IdeaProjects/docker-compose

read -p "$(echo -e ${YELLOW}"==>${WHITE}Install $UTILS? (y,n) ${NC}")" UT
if [[ $UT == "Y" || $UT == "y" ]]; then
    # shellcheck disable=SC2086
    sudo apt-get -y install $UTILS
fi

read -p "$(echo -e ${YELLOW}"==>${WHITE}Configure Zsh? (y,n) ${NC}")" ZSH
if [[ $ZSH == "Y" || $ZSH == "y" ]]; then
    source zsh/init
fi

read -p "$(echo -e ${YELLOW}"==>${WHITE}Configure Sdkman? (y,n) ${NC}")" SDK
if [[ $SDK == "Y" || $SDK == "y" ]]; then
    sudo apt-get -y install unzip zip
    curl -s "https://get.sdkman.io" | bash
fi

### Script is done ###
echo -e "${GREEN}==>${WHITE} Script had completed. Now you can reboot to apply all settings${NC}"