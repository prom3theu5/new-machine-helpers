#!/bin/bash -e

rm -rf ~/.ansible ~/.config ~/.warp ~/.zsh

sudo dnf -y groups mark install "Development Tools"
sudo dnf -y groupinstall "Development Tools"
sudo dnf -y install procps-ng curl file git zsh util-linux-user

# Change Shell to ZSH
sudo chsh -s "$(which zsh)" "$(whoami)"
touch ~/.zshrc

# Starship
curl -sS https://starship.rs/install.sh | sh -s -- -y

# Homebrew
CI=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Restore custom dotfiles
pushd /tmp || exit
git clone https://github.com/prom3theu5/dotfiles dotfiles
cd dotfiles || exit
rm LICENSE
rm README.md
rm -rf .git
zsh -c 'mv -f /tmp/dotfiles/*(D) "$HOME"/'
cd .. || exit
rm -rf dotfiles
popd || exit

# Install Homebrew Packages
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
brew update
brew doctor
brew install python || true
brew bundle --file ~/Brewfile
rm ~/Brewfile*

echo "Done - Restart Shell Session!"
