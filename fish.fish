#!/bin/fish

function echo_divider
    set_color -o yellow
    echo -----------------------------------------------------------------
    set_color normal
end

echo_divider
echo 'Installing packages'
sudo add-apt-repository -y ppa:maveonair/helix-editor

sudo apt -qq -y install build-essential clang-15 lldb-15 lld-15 libssl-dev zlib1g-dev zstd libasound2-dev \
    libbz2-dev libreadline-dev libsqlite3-dev curl fzf ffmpeg expat pkg-config nodejs gh cmake python3-pylsp \
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

pyenv install 3.11 3.10
pyenv global 3.10


echo_divider
echo 'Installing cargo.'
curl https://sh.rustup.rs -sSf | sh -s -- --default-toolchain nightly -y
fish_add_path $HOME/.cargo/bin

echo_divider
echo 'Installing MOLD.'
mkdir ~/.linker
mkdir ~/.linker/mold
curl -L -k (curl -s https://api.github.com/repos/rui314/mold/releases/latest | grep 'x86_64-linux' | grep http | cut -d\" -f4) | tar zx
mv (ls | grep mold) mold && mv mold ~/.linker/
set -gx MOLD_BIN (path resolve ~/.linker/mold/bin/mold)
echo '[target.x86_64-unknown-linux-gnu]' >>~/.cargo/config.toml
echo 'linker = "clang-15"' >>~/.cargo/config.toml
echo 'rustflags = ["-C", "target-cpu=native", "-C", "link-arg=-fuse-ld='$MOLD_BIN'"]' >>~/.cargo/config.toml

echo_divider
echo 'adds rustup components'
rustup -q component add rust-analyzer

# Install all programs using cargo using the most optimal performance
echo_divider
echo 'Installing cargo packages...'
set -x -g RUSTFLAGS '-C opt-level=3 -C target-cpu=native -C codegen-units=1 -C strip=symbols -C panic=abort -C link-arg=-fuse-ld='$MOLD_BIN

# This function is faster but may run out of memory.
function cargo_build_on_sub
    for command in $argv
        echo 'executing: cargo install --locked '$command
        nohup fish -c 'cargo install -q --locked --force '$command &
        sleep 5
    end
    echo (jobs -p)
    echo 'waiting to join jobs'
    wait (jobs -p)
end

cargo_build_on_sub starship 'bat --target-dir=/tmp/bat' zoxide sd git-delta 'ripgrep --target-dir=/tmp/ripgrep' 'hyperfine --target-dir=/tmp/hyperfine' gitui grex xh du-dust codevis cargo-nextest tealdeer procs gping cargo-watch cargo-update difftastic macchina

rm nohup.out -f
set -u --erase RUSTFLAGS

tldr --update
hx --grammar fetch
hx --grammar build

echo_divider
echo 'Adding fish completions.'
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
curl https://raw.githubusercontent.com/FilipAndersson245/.cfg/master/starship.toml >>~/.config/starship.toml

echo_divider
echo 'Setting git username and email'
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
abbr -a -- hist history
abbr -a -- histg 'history | rg'
abbr -a -- neofetch 'macchina'
abbr >> ~/.config/fish/config.fish

# Github login.
gh auth login
