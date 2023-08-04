#!/bin/bash

brew install derailed/k9s/k9s
brew install helm

mkdir -p ~/.kube
sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config