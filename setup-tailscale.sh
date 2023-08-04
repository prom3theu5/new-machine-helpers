#!/bin/bash

USAGE_MESSAGE="Usage: $0 <login-server>"

if [ -z "$1" ]; then
    echo $USAGE_MESSAGE
    exit 1
fi

curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale up --login-server=$1
