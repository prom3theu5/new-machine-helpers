#!/bin/bash

sudo yum groupinstall 'Development Tools'
sudo yum install procps-ng curl file git
sudo dnf install -y zsh
sudo dnf -y install util-linux-user

# OhMyZsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Starship
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

mkdir -p ~/.config

# STARSHIP CONFIG
tee ~/.config/starship.toml <<EOF
# Inserts a blank line between shell prompts
add_newline = true

# Change command timeout from 500 to 1000 ms
command_timeout = 1000

# Change the default prompt format
format = """\$env_var \$all"""

# Change the default prompt characters
[character]
success_symbol = ""
error_symbol = ""

# Shows the username
[username]
style_user = "green"
style_root = "red"
format = "[\$user](\$style) "
disabled = false
show_always = true

[hostname]
ssh_only = false
format = "on [\$hostname](blue) "
disabled = false

[directory]
truncation_length = 1
truncation_symbol = "../"
home_symbol = " ~"
read_only_style = "197"
read_only = "  "
format = "at [\$path](\$style)[\$read_only](\$read_only_style) "

[git_branch]
symbol = " "
format = "[\$symbol\$branch](\$style) "
# truncation_length = 4
truncation_symbol = "…/"
style = "bold green"

[git_status]
format = '[\(\$all_status\$ahead_behind\)](\$style) '
style = "bold green"
conflicted = "🏳"
up_to_date = " "
untracked = " "
ahead = "⇡\${count}"
diverged = "⇕⇡\${ahead_count}⇣\${behind_count}"
behind = "⇣\${count}"
stashed = " "
modified = " "
staged = '[++\(\$count\)](green)'
renamed = "襁 "
deleted = " "

[kubernetes]
format = 'via [ﴱ \$context\(\$namespace\)](bold purple) '
disabled = false

# (deactivated because of no space left)
[terraform]
format = "via [ terraform \$version](\$style) 壟 [\$workspace](\$style) "
disabled = true

[vagrant]
format = "via [ vagrant \$version](\$style) "
disabled = true

[docker_context]
format = "via [ \$context](bold blue) "
disabled = true

[helm]
format = "via [ \$version](bold purple) "
disabled = true

[python]
symbol = " "
python_binary = "python3"
disabled = true

[nodejs]
format = "via [ \$version](bold green) "
disabled = true

[ruby]
format = "via [ \$version](\$style) "
disabled = true
EOF

# ZSH CONFIG
tee ~/.zshrc <<EOF
export ZSH="\$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

plugins=(
git
zsh-autosuggestions
zsh-syntax-highlighting
)

source \$ZSH/oh-my-zsh.sh

# HOMEBREW
eval "\$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# STARSHIP
eval "\$(starship init zsh)"
EOF

source ~/.zshrc

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions

source ~/.zshrc