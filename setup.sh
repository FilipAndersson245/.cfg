#!/bin/bash
sudo apt update -y
sudo apt upgrade -y

sudo apt install zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Python and pyenv install

# Dependencies
sudo apt install python3-pip build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev curl \
libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev -y

# Download and install pyenv
curl https://pyenv.run | zsh
exec $SHELL

# 
pyenv virtualenv 3.11.2
pyenv global 3.11.2


sudo curl -sS https://starship.rs/install.sh | sh -s -- -y
