echo "setup.fish"
echo "---------------------------------------------------------------------------------------------"

echo "Installing packages"
sudo add-apt-repository ppa:maveonair/helix-editor

sudo apt -qq install build-essential clang-15 lldb-15 lld-15 libssl-dev zlib1g-dev libasound2-dev  \
libbz2-dev libreadline-dev libsqlite3-dev curl fzf ffmpeg expat pkg-config nodejs gh cmake python3-pylsp \
libxcb-composite0-dev libharfbuzz-dev libexpat1-dev libfreetype6-dev libblas-dev liblapack-dev \
libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev fish fzf helix -y
echo "apt install done."

echo "Set greeting to None"
fish -c 'set -U fish_greeting ""'

mkdir -p ~/.config
mkdir -p ~/.config/fish/completions

echo "Setting fish as login shell."
echo /usr/local/bin/fish | sudo tee -a /etc/shells
fish -c 'chsh -s (command -s fish)'

echo "Installing fisher and its respective plugins."
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
fisher install nickeb96/puffer-fish kidonng/zoxide.fish gazorby/fish-abbreviation-tips PatrickF1/fzf.fish joseluisq/gitnow@2.11.0 edc/bass

# install


if test -f "/proc/sys/fs/binfmt_misc/WSLInterop"
   curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/FilipAndersson245/.cfg/master/setup_wsl | bash
end