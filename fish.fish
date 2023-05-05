#!/bin/fish

function echo_divider
    set_color -o green; 
    echo "------------------------------------------------------------";
    set_color normal;
end

echo_divider
echo "Installing packages"
sudo add-apt-repository -qq ppa:maveonair/helix-editor

sudo apt -qq install build-essential clang-15 lldb-15 lld-15 libssl-dev zlib1g-dev libasound2-dev \
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
chsh -s (command -s fish)

echo "Installing fisher and its respective plugins."
curl -sL 'https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish' | source && fisher install jorgebucaran/fisher
fisher install nickeb96/puffer-fish kidonng/zoxide.fish gazorby/fish-abbreviation-tips PatrickF1/fzf.fish joseluisq/gitnow@2.11.0 edc/bass





echo_divider
echo "Installing cargo."
curl https://sh.rustup.rs -sSf | sh -s -- --default-toolchain nightly -y
fish -c 'fish_add_path $HOME/.cargo/bin'
export PATH=$HOME/.cargo/bin:$PATH
source "$HOME/.cargo/env"


mkdir ~/.linker
mkdir ~/.linker/mold
curl -L -k $(curl -s https://api.github.com/repos/rui314/mold/releases/latest | grep 'x86_64-linux' | grep http | cut -d\" -f4) | tar zx
mv $(ls | grep mold) mold && mv mold ~/.linker/

echo "Installing mold"
curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/FilipAndersson245/.cfg/master/download_mold.bash | bash
set -gx MOLD_BIN (path resolve ~/.linker/mold/bin/mold)
echo '[target.x86_64-unknown-linux-gnu]' >> ~/.cargo/config.toml 
echo 'linker = "clang-15"' >> ~/.cargo/config.toml 
echo 'rustflags = ["-C", "target-cpu=native", "-C", "link-arg=-fuse-ld='$MOLD_BIN'"]' >> ~/.cargo/config.toml 

echo "adds rustup components"
rustup -q component add rust-analyzer

# Install all programs using cargo using the most optimal performance

RUSTFLAGS='-C opt-level=3 -C target-cpu=native -C codegen-units=1 -C strip=symbols -C panic=abort -C link-arg=-fuse-ld='${MOLD_BIN} && \
  cargo install -q starship --locked && \
  cargo install -q bat --target-dir=/tmp/bat --locked && \
  cargo install -q zoxide --locked && \
  cargo install -q sd --locked && \
  cargo install -q git-delta --locked && \
  cargo install -q ripgrep --target-dir=/tmp/ripgrep --locked && \
  cargo install -q hyperfine --target-dir=/tmp/hyperfine --locked  && \
  cargo install -q silicon --locked && \
  cargo install -q gitui --locked && \
  cargo install -q grex --locked && \
  cargo install -q xh --locked && \
  cargo install -q du-dust --locked && 
  cargo install -q codevis --locked && \
  cargo install -q cargo-nextest --locked && \
  cargo install -q tealdeer --locked && \
  cargo install -q lsd --locked && \
  cargo install -q procs --locked && \
  cargo install -q gping --locked && \
  cargo install -q cargo-watch --locked && \
  cargo install -q cargo-update --locked && \
  cargo install -q just --locked && \
  cargo install -q difftastic --locked && \
  cargo install -q nu --locked && \
  cargo install -q macchina --locked

tldr --update
hx --grammar fetch
hx --grammar build

echo "Adding fish completions."
fish -c 'rustup completions fish >> ~/.config/fish/completions/rustup.fish'
fish -c 'starship completions fish >> ~/.config/fish/completions/starship.fish'
mv /tmp/bat/release/build/bat-*/out/assets/completions/bat.fish ~/.config/fish/completions/
mv /tmp/hyperfine/release/build/hyperfine-*/out/hyperfine.fish ~/.config/fish/completions/
mv /tmp/ripgrep/release/build/ripgrep-*/out/rg.fish ~/.config/fish/completions/
mv /tmp/sd/release/build/sd-*/out/sd.fish ~/.config/fish/completions/
curl https://raw.githubusercontent.com/ducaale/xh/master/completions/xh.fish >> ~/.config/fish/completions/xh.fish
curl https://raw.githubusercontent.com/bootandy/dust/master/completions/dust.fish >> ~/.config/fish/completions/dust.fish

echo "Init starship prompt"
echo 'starship init fish | source' >> ~/.config/fish/config.fish
curl https://raw.githubusercontent.com/FilipAndersson245/.cfg/master/starship.toml >> ~/.config/starship.toml


if test -f "/proc/sys/fs/binfmt_misc/WSLInterop"
   curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/FilipAndersson245/.cfg/master/setup_wsl | bash
end