# before starting download and install build tools for microsoft windows
# https://visualstudio.microsoft.com/visual-cpp-build-tools/


# get latest download url
$URL = "https://api.github.com/repos/microsoft/winget-cli/releases/latest"
$URL = (Invoke-WebRequest -Uri $URL).Content | ConvertFrom-Json |
Select-Object -ExpandProperty "assets" |
Where-Object "browser_download_url" -Match '.msixbundle' |
Select-Object -ExpandProperty "browser_download_url"

# download
Invoke-WebRequest -Uri $URL -OutFile "Setup.msix" -UseBasicParsing

# install
Add-AppxPackage -Path "Setup.msix"

# delete file
Remove-Item "Setup.msix"

Install-Module -Name PSReadLine -AllowClobber -Force


# Step 1: Install Chocolatey if not present
if (!(Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Output "Chocolatey not found. Installing Chocolatey..."
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}
else {
    Write-Output "Chocolatey is already installed."
}

winget install -e --source winget --id Git.Git
winget install -e --source winget --id GitHub.GitLFS
winget install -e --source winget --id=junegunn.fzf  -e
winget install -e --source winget --id Microsoft.Powershell
winget install -e --source winget --id Microsoft.PowerToys
winget install -e --source winget --id Microsoft.VisualStudio.2022.BuildTools
winget install -e --source winget --id Rustlang.Rustup

rustup toolchain install nightly

# Step 2: List of programs to install
$packages = @(
    "vscode",
    "powertoys",
    "wezterm",

    # cli
    "fzf",
    "zoxide",
    "starship"
    "ripgrep",
    "bat",
    "sd-cli",
    "hyperfine",
    "jq",
    "hexyl",
    "grex",
    "ffmpeg-full",
    "yazi",
    "rclone",
    "nushell",
    "bitwarden-cli",
    

    # languages
    "bun",    # js
    "nodejs", # js
    "uv", # python
    "ninja",
    

    # git
    "git",
    "git-lfs",
    "gitui",
    "gh",
    "delta",
    "difftastic",



    # general
    "brave",
    "bitwarden",
    "obsidian",
    "7zip",

    # private
    "mpvio",
    "tutanota"
    "signal",
    "discord",
    "spotify",
    "steam",
    "qbittorrent"
)


Write-Output "Installing packages with Chocolatey..."
foreach ($package in $packages) {
    choco install $package -y
}

[System.Environment]::SetEnvironmentVariable('UV_PYTHON_INSTALL_DIR','C:\Program Files\Python', 'Machine')
$env:UV_PYTHON_INSTALL_DIR = "C:\Program Files\Python"


uv python install 3.13
uv python install 3.12
uv python install 3.10


if (-not(test-path $profile)) { 
    New-Item -Path $profile -Type File -Force
}

Invoke-RestMethod https://astral.sh/uv/install.ps1 | Invoke-Expression

Add-Content -Path $profile -Value "Invoke-Expression (&starship init powershell)"
Add-Content -Path $profile -Value "Invoke-Expression (& { (zoxide init powershell | Out-String) })"
Add-Content -Path $profile -Value 'Set-PSReadLineOption -PredictionSource History'
Add-Content -Path $profile -Value '$env:FZF_DEFAULT_COMMAND = "fd --type f"'
