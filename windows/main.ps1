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


# terminal
winget install -e --source winget --id Microsoft.Powershell
winget install -e --source winget --id sharkdp.bat
winget install -e --source winget --id BurntSushi.ripgrep.MSVC
winget install -e --source winget --id junegunn.fzf
winget install -e --source winget --id jqlang.jq
winget install -e --source winget --id sharkdp.hyperfine
winget install -e --source winget --id zyedidia.micro
winget install -e --source winget --id aria2.aria2
winget install -e --source winget --id eza-community.eza
winget install -e --source winget --id sharkdp.fd
winget install -e --source winget --id Clement.bottom


# git related
winget install -e --source winget --id Git.Git
winget install -e --source winget --id GitHub.GitLFS
winget install -e --source winget --id StephanDilly.gitui
winget install -e --source winget --id dandavison.delta
winget install -e --source winget --id Wilfred.difftastic


# programming languages
winget install -e --source winget --id Python.Python.3.11
winget install -e --id Rustlang.Rustup


# programs
winget install -e --source winget --id Microsoft.VisualStudioCode
winget install -e --source winget --id Microsoft.WindowsTerminal
winget install -e --source winget --id Microsoft.PowerToys


if (-not(test-path $profile)) { 
    New-Item -Path $profile -Type File -Force
}

Invoke-RestMethod https://astral.sh/uv/install.ps1 | Invoke-Expression

Add-Content -Path $profile -Value "Invoke-Expression (&starship init powershell)"
Add-Content -Path $profile -Value "Invoke-Expression (& { (zoxide init powershell | Out-String) })"
Add-Content -Path $profile -Value 'Set-PSReadLineOption -PredictionSource History'
Add-Content -Path $profile -Value '$env:FZF_DEFAULT_COMMAND = "fd --type f"'
