Import-Module PSReadLine

Invoke-Expression (&starship init powershell)
Invoke-Expression (& { (zoxide init powershell | Out-String) })

$env:FZF_DEFAULT_COMMAND="fd --type file --color=always"
$env:FZF_DEFAULT_OPTS="--ansi --preview-window 'right:60%' --preview 'bat --color=always -n --nonprintable-notation=caret --style=header,grid --line-range :300 {}'"

function grep {
    $count = @($input).Count
    $input.Reset()

    if ($count) {
        $input | rg.exe --hidden $args
    }
    else {
        rg.exe --hidden $args
    }
}

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
