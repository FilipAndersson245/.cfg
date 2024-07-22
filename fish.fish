#!/bin/fish

function echo_divider
    set_color -o yellow
    echo -----------------------------------------------------------------
    set_color normal
end

echo_divider
echo 'Installing packages'
sudo add-apt-repository -y ppa:maveonair/helix-editor

sudo apt -qq -y install build-essential libssl-dev zlib1g-dev zstd libasound2-dev \
    libbz2-dev libreadline-dev libsqlite3-dev curl fzf ffmpeg expat pkg-config nodejs gh fastfetch cmake python3-pylsp \
    libxcb-composite0-dev libharfbuzz-dev libexpat1-dev libfreetype6-dev libblas-dev liblapack-dev \
    libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev fish fzf helix
echo 'apt install done'

echo_divider

echo_divider
echo 'Setting fish as login shell.'
echo /usr/local/bin/fish | sudo tee -a /etc/shells
chsh -s $(which fish)

set -U fish_greeting ''
mkdir -p ~/.config
mkdir -p ~/.config/fish/completions
echo_divider

echo 'Installing fisher and its respective plugins.'
curl -sL 'https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish' | source && fisher install jorgebucaran/fisher
fisher install nickeb96/puffer-fish kidonng/zoxide.fish gazorby/fish-abbreviation-tips PatrickF1/fzf.fish joseluisq/gitnow@2.11.0 edc/bass

set -x ABBR_TIPS_PROMPT 'ᓚᘏᗢ \e[1m{{ .abbr }}\e[0m => \e[1m{{ .cmd }}\e[0m'

echo_divider


echo 'Installing pyenv'
curl https://pyenv.run | bash

echo 'Setup pyenv for bash'
echo 'export PYENV_ROOT="$HOME/.pyenv"' >>~/.bashrc
echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >>~/.bashrc
echo 'eval "$(pyenv init -)"' >>~/.bashrc
echo 'eval "$(pyenv virtualenv-init -)"' >>~/.bashrc
echo 'export PYENV_ROOT="$HOME/.pyenv"' >>~/.bash_profile
echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >>~/.bash_profile
echo 'eval "$(pyenv init -)"' >>~/.bash_profile
echo 'eval "$(pyenv virtualenv-init -)"' >>~/.bash_profile

echo "Setup 'pyenv' for fish"
set -Ux PYENV_ROOT $HOME/.pyenv
fish_add_path $PYENV_ROOT/bin

echo 'pyenv init - | source' >>~/.config/fish/config.fish
echo 'status --is-interactive; and pyenv virtualenv-init - | source' >>~/.config/fish/config.fish

pyenv install 3.12 3.11 3.10 3.9
pyenv global 3.12


echo_divider
echo 'Installing cargo.'
echo_divider
curl https://sh.rustup.rs -sSf | sh -s -- --default-toolchain nightly -y
curl https://sh.rustup.rs -sSf | sh -s -- --default-toolchain stable -y
fish_add_path $HOME/.cargo/bin

echo 'rustflags = ["-C", "target-cpu=native"]' >>~/.cargo/config.toml

echo_divider
source ~/.config/fish/config.fish

echo 'adds rustup components'
rustup -q component add rust-analyzer

# Install all programs using cargo using the most optimal performance
echo_divider
echo 'Installing cargo packages...'
echo_divider

set -x -g RUSTFLAGS '-C opt-level=3 -C target-cpu=native -C codegen-units=1 -C strip=symbols

cargo install -q --locked starship                                       ; and echo "starship installed"
cargo install -q --locked zoxide                                         ; and echo "zoxide installed"
cargo install -q --locked sd                                             ; and echo "sd installed"
cargo install -q --locked git-delta                                      ; and echo "git-delta installed"
cargo install -q --locked gitui                                          ; and echo "gitui installed"
cargo install -q --locked grex                                           ; and echo "grex installed"
cargo install -q --locked xh                                             ; and echo "xh installed"
cargo install -q --locked du-dust                                        ; and echo "du-dust installed"
cargo install -q --locked cargo-nextest                                  ; and echo "cargo-nextest installed"
cargo install -q --locked tealdeer                                       ; and echo "tealdeer installed"
cargo install -q --locked procs                                          ; and echo "procs installed"
cargo install -q --locked gping                                          ; and echo "gping installed"
cargo install -q --locked cargo-watch                                    ; and echo "cargo-watch installed"
cargo install -q --locked cargo-update                                   ; and echo "cargo-update installed"
cargo install -q --locked difftastic                                     ; and echo "difftastic installed"
cargo install -q --locked just                                           ; and echo "just installed"

cargo install -q --locked bat --target-dir=/tmp/bat                      ; and echo "bat installed"
cargo install -q --locked ripgrep --target-dir=/tmp/ripgrep              ; and echo "ripgrep installed"
cargo install -q --locked hyperfine --target-dir=/tmp/hyperfine          ; and echo "hyperfine installed"

set --erase RUSTFLAGS

tldr --update
hx --grammar fetch
hx --grammar build

echo_divider
echo 'Adding fish completions.'
echo_divider
rustup completions fish >>~/.config/fish/completions/rustup.fish
starship completions fish >>~/.config/fish/completions/starship.fish
mv /tmp/bat/release/build/bat-*/out/assets/completions/bat.fish ~/.config/fish/completions/
mv /tmp/hyperfine/release/build/hyperfine-*/out/hyperfine.fish ~/.config/fish/completions/
mv /tmp/ripgrep/release/build/ripgrep-*/out/rg.fish ~/.config/fish/completions/
mv /tmp/sd/release/build/sd-*/out/sd.fish ~/.config/fish/completions/
curl 'https://raw.githubusercontent.com/ducaale/xh/master/completions/xh.fish' >>~/.config/fish/completions/xh.fish
curl 'https://raw.githubusercontent.com/bootandy/dust/master/completions/dust.fish' >>~/.config/fish/completions/dust.fish

echo_divider
echo 'Init starship prompt'
echo 'starship init fish | source' >>~/.config/fish/config.fish
# curl https://raw.githubusercontent.com/FilipAndersson245/.cfg/master/starship.toml >>~/.config/starship.toml

echo_divider
echo 'Setting git username and email'
echo_divider
curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/FilipAndersson245/.cfg/master/.gitconfig >~/.gitconfig
git config --global user.name FilipAndersson245
git config --global user.email "17986183+FilipAndersson245@users.noreply.github.com"

echo_divider
echo 'creating and saving functions.'
# helper functions and abbr.
function mkcd
        mkdir -p $argv[1]; cd $argv[1]
end
funcsave mkcd

echo_divider
echo 'Setting abbr.'
echo_divider
abbr -a -- pipu 'pip install --upgrade'
abbr -a -- pipi 'pip install'
abbr -a -- cls clear
abbr -a -- vi vim
abbr -a -- mkdir 'mkdir -p'
abbr -a -- g git
abbr -a -- ga 'git add'
abbr -a -- gb 'git branch'
abbr -a -- gbl 'git blame'
abbr -a -- gc 'git commit -m'
abbr -a -- gca 'git commit --amend -m'
abbr -a -- gco 'git checkout'
abbr -a -- gcp 'git cherry-pick'
abbr -a -- gd 'git diff'
abbr -a -- gf 'git fetch'
abbr -a -- gl 'git log'
abbr -a -- gm 'git merge'
abbr -a -- gp 'git push'
abbr -a -- gpf 'git push --force-with-lease'
abbr -a -- gpl 'git pull'
abbr -a -- gr 'git remote'
abbr -a -- grb 'git rebase'
abbr -a -- gs 'git status'
abbr -a -- gst 'git stash'
abbr >> ~/.config/fish/config.fish

# Github login.
gh auth login
