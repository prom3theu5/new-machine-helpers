#!/bin/bash

USAGE_MESSAGE="Usage: $0 <username>"

if [ -z "$1" ]; then
    echo $USAGE_MESSAGE
    exit 1
fi

adduser $1
passwd $1
usermod -aG wheel $1