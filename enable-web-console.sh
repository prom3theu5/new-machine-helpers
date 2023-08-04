#!/bin/bash

sudo dnf -y install cockpit
sudo systemctl enable --now cockpit.socket
sudo systemctl status cockpit.socket