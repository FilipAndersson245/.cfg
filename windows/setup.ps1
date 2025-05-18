$devfolder = "D:\.setup"

$env:GIT_CONFIG = "$devfolder\.gitconfig"
$env:GIT_CONFIG_SYSTEM = "$devfolder\.gitconfig"
$env:GIT_CONFIG_GLOBAL = "$devfolder\.gitconfig"

$env:CARGO_HOME = "$devfolder\.cargo"
$env:RUSTUP_HOME = "$devfolder\.rustup"

$env:UV_PYTHON_INSTALL_DIR = "$devfolder\uv\python"
$env:UV_CACHE_DIR = "$devfolder\uv\.cache"
$env:UV_INSTALL_DIR = "$devfolder\uv"
$env:UV_COMPILE_BYTECODE = "true"

$env:path = "$env:path;$devfolder\cli\bin\;$devfolder\.cargo\bin\"

powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"

uv python install 3.13
uv python install 3.12
uv python install 3.10

$url = "https://static.rust-lang.org/rustup/dist/x86_64-pc-windows-msvc/rustup-init.exe"
$path = "$env:TEMP\rustup-init.exe"
Invoke-WebRequest $url -OutFile $path

Start-Process $path -ArgumentList "-y --default-toolchain stable --no-modify-path"
rustup toolchain install stable nightly

cargo-binstall --root C:\dev-setup\cli -y zoxide starship ripgrep bat sd hyperfine hexyl yazi-fm yazi-cli git-delta eza fd-find bottom du-dust just qsv xh samply miniserve gifski difftastic

# Install gitui, fzf, ffmpeg, manually and place them in  C:\dev-setup\cli
