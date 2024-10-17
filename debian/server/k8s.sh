#!/bin/bash

RED='\033[0;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

if /usr/sbin/swapon --show | grep -q ".*"
then
  sudo apt update
  sudo apt-get -y install iptables procps
  # Настройка автозагрузки и запуск модуля ядра br_netfilter и overlay
    cat <<EOF | tee /etc/modules-load.d/k8s.conf
  overlay
  br_netfilter
EOF

    /usr/sbin/modprobe overlay
    /usr/sbin/modprobe br_netfilter

    # Разрешение маршрутизации IP-трафика
    echo -e "net.bridge.bridge-nf-call-ip6tables = 1\nnet.bridge.bridge-nf-call-iptables = 1\nnet.ipv4.ip_forward = 1" > /etc/sysctl.d/10-k8s.conf
    /usr/sbin/sysctl -f /etc/sysctl.d/10-k8s.conf

    # Отключение файла подкачки
    /usr/sbin/swapoff -a
    sed -i '/ swap / s/^/#/' /etc/fstab

    echo -e "${GREEN}==>${WHITE} Reload computer and call second time this script${NC}"
    exit 0
fi

if ! command -v kubeadm 2>&1 >/dev/null
then
  sudo apt update
  sudo apt-get -y install systemd dbus dbus-user-session socat yq jq apt-transport-https ca-certificates curl gnupg strace

  if [ ! -d /etc/apt/keyrings ]; then
    sudo mkdir -p -m 755 /etc/apt/keyrings
  fi
  curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
  sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg # allow unprivileged APT programs to read this keyring

  # This overwrites any existing configuration in /etc/apt/sources.list.d/kubernetes.list
  echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
  sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list   # helps tools such as command-not-found to work correctly

  sudo apt update
  sudo apt install -y kubeadm kubectl kubelet
  sudo apt install -y containerd

  containerd config default > /etc/containerd/config.toml
  sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml
fi

if ! command -v helm 2>&1 >/dev/null
then
  curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
fi

if ! kubectl cluster-info | grep -q "is running at"
then
  sudo kubeadm init --pod-network-cidr=10.244.0.0/16
fi

# need add to zshrc
export KUBECONFIG=/etc/kubernetes/admin.conf

kubectl taint nodes --all node-role.kubernetes.io/control-plane-

if ! helm get all flannel -n kube-system | grep -q -i '.*STATUS: deployed.*'
then
  kubectl label --overwrite ns kube-system  pod-security.kubernetes.io/enforce=privileged

  helm repo add flannel https://flannel-io.github.io/flannel/
  helm upgrade --install flannel --set podCidr="10.244.0.0/16" --create-namespace --namespace kube-system  flannel/flannel
fi

echo -e "${GREEN}==>${WHITE} k8s and helm installed${NC}"
echo -e "${YELLOW}==>${WHITE} Add 'export KUBECONFIG=/etc/kubernetes/admin.conf' to .zshrc or /etc/environment${NC}"