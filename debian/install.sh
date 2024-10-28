#!/bin/bash

RED='\033[0;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

UTILS="curl vim htop git"

# shellcheck disable=SC2086
apt-get -y update && apt-get -y upgrade && apt-get -y install $UTILS

read -p "$(echo -e ${YELLOW}"==>${WHITE}Configure Zsh? (y,n) ${NC}")" ZSH
if [[ $ZSH == "Y" || $ZSH == "y" ]]; then
    source zsh/init
fi

read -p "$(echo -e ${YELLOW}"==>${WHITE}Configure Sdkman? (y,n) ${NC}")" SDK
if [[ $SDK == "Y" || $SDK == "y" ]]; then
    apt-get -y install unzip zip
    curl -s "https://get.sdkman.io" | bash
fi

read -p "$(echo -e ${YELLOW}"==>${WHITE}Configure k3s? (y,n) ${NC}")" SERVER
if [[ $SERVER == "Y" || $SERVER == "y" ]]; then
    bash server/k3s.sh
fi

read -p "$(echo -e ${YELLOW}"==>${WHITE}Configure k8s? (y,n) ${NC}")" k8s
if [[ $k8s == "Y" || $k8s == "y" ]]; then
    bash server/k8s.sh
fi

### Script is done ###
echo -e "${GREEN}==>${WHITE} Script had completed. Now you can reboot to apply all settings${NC}"
