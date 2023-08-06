#!/bin/bash

CUSTOM_RESOLV_CONF="/etc/k3s-resolv.conf"

/usr/local/bin/k3s-uninstall.sh
sudo dnf remove postgresql-server -y
sudo rm -rf /var/lib/pgsql
sudo rm $CUSTOM_RESOLV_CONF