$devfolder = "C:\dev-setup"

$env:GIT_CONFIG = "$devfolder\.gitconfig"
$env:GIT_CONFIG_SYSTEM = "$devfolder\.gitconfig"
$env:GIT_CONFIG_GLOBAL = "$devfolder\.gitconfig"

$env:CARGO_HOME = "$devfolder\.cargo"

$env:UV_PYTHON_INSTALL_DIR = "$devfolder\uv\python"
$env:UV_CACHE_DIR = "$devfolder\uv\.cache"
$env:UV_INSTALL_DIR = "$devfolder\uv"
$env:UV_COMPILE_BYTECODE = "true"

$env:path = "$env:path;$devfolder\cli\bin\"

powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"

uv python install 3.13
uv python install 3.12
uv python install 3.10

cargo-binstall --root C:\dev-setup\cli -y zoxide starship ripgrep bat sd hyperfine hexyl yazi-fm yazi-cli git-delta eza fd-find bottom du-dust just qsv xh samply miniserve gifski difftastic

# Install gitui, fzf, ffmpeg, manually and place them in  C:\dev-setup\cli
