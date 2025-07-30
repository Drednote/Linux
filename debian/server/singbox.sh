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

$SUDO curl -fsSL https://sing-box.app/install.sh | sh

$SUDO cat <<EOF | tee /etc/systemd/system/sing-box.service
[Unit]
Description=Sing-box Service
After=network.target

[Service]
Type=simple
ExecStart=sing-box run -c /etc/sing-box/config.json
Restart=on-failure
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_RAW
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_RAW
NoNewPrivileges=true

[Install]
WantedBy=multi-user.target
EOF

$SUDO mv sing-box.json /etc/sing-box/config.json