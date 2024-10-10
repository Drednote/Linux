#!/bin/bash

RED='\033[0;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

UTILS="curl vim htop git"

# shellcheck disable=SC2086
sudo apt-get -y update && sudo apt-get -y upgrade && sudo apt-get -y install $UTILS

read -p "$(echo -e ${YELLOW}"==>${WHITE}Configure Zsh? (y,n) ${NC}")" ZSH
if [[ $ZSH == "Y" || $ZSH == "y" ]]; then
    source zsh/init
fi

read -p "$(echo -e ${YELLOW}"==>${WHITE}Configure Sdkman? (y,n) ${NC}")" SDK
if [[ $SDK == "Y" || $SDK == "y" ]]; then
    sudo apt-get -y install unzip zip
    curl -s "https://get.sdkman.io" | bash
fi

read -p "$(echo -e ${YELLOW}"==>${WHITE}Configure k3s? (y,n) ${NC}")" k3c
if [[ $k3c == "Y" || $k3c == "y" ]]; then
    sudo apt-get -y install systemd dbus dbus-user-session
    curl -sfL https://get.k3s.io | sh -
fi

### Script is done ###
echo -e "${GREEN}==>${WHITE} Script had completed. Now you can reboot to apply all settings${NC}"
