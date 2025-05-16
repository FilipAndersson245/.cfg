Import-Module PSReadLine

Invoke-Expression (&starship init powershell)
Invoke-Expression (& { (zoxide init powershell | Out-String) })

$env:FZF_DEFAULT_COMMAND = "fd --type f"
$env:FZF_DEFAULT_OPTS = "--height 40% --layout=reverse --border"

# --- eza Aliases ---
Set-Alias ls eza
Set-Alias ll "eza -l"
Set-Alias la "eza -la"
Set-Alias lt "eza --tree"

# --- fd as find replacement ---
Set-Alias find fd