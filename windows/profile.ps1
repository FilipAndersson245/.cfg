Import-Module PSReadLine

Invoke-Expression (&starship init powershell)
Invoke-Expression (& { (zoxide init powershell | Out-String) })

$env:FZF_DEFAULT_COMMAND="fd --type file --color=always"
$env:FZF_DEFAULT_OPTS="--ansi --preview-window 'right:60%' --preview 'bat --color=always -n --nonprintable-notation=caret --style=header,grid --line-range :300 {}'"

Set-PSReadLineOption -Colors @{ InlinePrediction = "`e[38;5;238m" }

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


function grep {
    $count = @($input).Count
    $input.Reset()

    if ($count) {
        $input | rgxe --hidden $args
    }
    else {
        rg --hidden $args
    }
}

function rmrf { if (Test-Path @args) { rm -r -force ./your_path} }

function y {
    $tmp = [System.IO.Path]::GetTempFileName()
    yazi $args --cwd-file="$tmp"
    $cwd = Get-Content -Path $tmp -Encoding UTF8
    if (-not [String]::IsNullOrEmpty($cwd) -and $cwd -ne $PWD.Path) {
        Set-Location -LiteralPath ([System.IO.Path]::GetFullPath($cwd))
    }
    Remove-Item -Path $tmp
}

function imgcat { wezterm imgcat @args }

Set-Alias find fd

Set-Alias ls eza
function ll { eza -l @args }
function la { eza -la @args }
function lt { eza --tree @args }
