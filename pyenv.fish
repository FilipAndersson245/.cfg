#!/bin/fish
echo "setup.fish"
echo "----------------------------------------------------------------------------------------------"

echo "Installing 'pyenv'"
curl https://pyenv.run | bash

echo "Setup 'pyenv' for bash"
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(pyenv init -)"' >> ~/.bashrc
echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bashrc

echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bash_profile
echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(pyenv init -)"' >> ~/.bash_profile
echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bash_profile

echo "Setup 'pyenv' for fish"
set -Ux PYENV_ROOT $HOME/.pyenv
fish_add_path $PYENV_ROOT/bin'

echo 'pyenv init - | source' >> ~/.config/fish/config.fish
echo 'status --is-interactive; and pyenv virtualenv-init - | source' >> ~/.config/fish/config.fish

pyenv install 3.11 3.10
pyenv global 3.11