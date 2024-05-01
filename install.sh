#!/bin/bash

RED='\033[0;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

UTILS="vim htop nvtop"

sudo pacman -Syu --noconfirm

read -p "$(echo -e ${WHITE}"Install $UTILS? (y,n) ${NC}")" UT
if [[ $UT == "Y" || $UT == "y" ]]; then
    # shellcheck disable=SC2086
    sudo pacman -S --noconfirm $UTILS
fi

read -p "$(echo -e ${WHITE}"Configure Zsh? (y,n) ${NC}")" ZSH
if [[ $ZSH == "Y" || $ZSH == "y" ]]; then
    source bin/zsh/init
fi

source bin/yay

### Script is done ###
echo -e "${GREEN}==>${WHITE} Script had completed. Now you can reboot to apply all settings${NC}"