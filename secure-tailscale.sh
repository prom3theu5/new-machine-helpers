#!/bin/bash

sudo ufw allow in on tailscale0
sudo ufw enable
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow from 10.42.0.0/16 to any
sudo ufw allow from 10.43.0.0/16 to any
sudo ufw delete 22/tcp
sudo ufw reload
sudo systemctl restart sshd
sudo systemctl restart ssh
