#!/bin/bash

RED='\033[0;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

SUDO=""

if [ $(whoami) != "root" ]; then
    SUDO=sudo
fi

if /usr/sbin/swapon --show | grep -q ".*"
then
    # Отключение файла подкачки
    /usr/sbin/swapoff -a
    sed -i '/ swap / s/^/#/' /etc/fstab

    echo -e "${GREEN}==>${WHITE} Reload computer and call second time this script${NC}"
    exit 0
fi

$SUDO apt update
$SUDO apt-get -y install systemd dbus dbus-user-session socat yq jq containerd \
  apt-transport-https ca-certificates curl gnupg strace rsync

containerd config default > /etc/containerd/config.toml
sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml

if ! command -v helm 2>&1 >/dev/null
then
  curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
fi

if ! command -v k3s 2>&1 >/dev/null
then
  echo -e "${YELLOW}==>${WHITE} Installing k3s${NC}"

  mkdir -p /etc/rancher/k3s && cp config.yaml /etc/rancher/k3s
  curl -sfL https://get.k3s.io | sh -s - --disable traefik --disable servicelb --cluster-init --servicelb-namespace metallb-system
  echo 'export KUBECONFIG=/etc/rancher/k3s/k3s.yaml' > /etc/environment

  echo -e "${GREEN}==>${WHITE} k3s and helm installed${NC}"
fi
