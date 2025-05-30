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

curl -LsSf https://astral.sh/uv/install.sh | sh

source $HOME/.local/bin/env.fish
fish_add_path $HOME/.local/bin/env.fish

uv python install 3.13
uv python install 3.12
uv python install 3.10

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

curl -L --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash
cargo-binstall -y zoxide starship ripgrep bat sd hyperfine hexyl yazi-fm yazi-cli git-delta eza fd-find bottom du-dust just qsv xh samply miniserve gifski difftastic bacon
cargo install -q --locked gitui

tldr --update

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

function y
	set tmp (mktemp -t "yazi-cwd.XXXXXX")
	yazi $argv --cwd-file="$tmp"
	if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
		builtin cd -- "$cwd"
	end
	rm -f -- "$tmp"
end
funcsave y

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
