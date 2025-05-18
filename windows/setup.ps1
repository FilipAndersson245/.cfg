function Add-PathToMachineEnvironment {
    param (
        [Parameter(Mandatory = $true)]
        [string]$PathToAdd
    )

    # Ensure the path ends with a backslash
    if (-not $PathToAdd.EndsWith("\")) {
        $PathToAdd += "\"
    }

    # Get the current PATH environment variable for the machine
    $currentPath = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine)

    # Check if the new path is already in the PATH variable
    if ($currentPath -notlike "*$PathToAdd*") {
        $newPathValue = "$currentPath;$PathToAdd"

        try {
            # Set the new PATH environment variable
            [System.Environment]::SetEnvironmentVariable("Path", $newPathValue, [System.EnvironmentVariableTarget]::Machine)
            Write-Output "The path '$PathToAdd' has been added successfully."
        } catch {
            Write-Error "Failed to set the environment variable: $_"
        }
    } else {
        Write-Output "The path '$PathToAdd' is already in the PATH variable."
    }
}

$devfolder = "C:\dev-setup\"
$env:GIT_CONFIG  = $devfolder".gitconfig"
$env:GIT_CONFIG_SYSTEM  = $devfolder".gitconfig"
$env:GIT_CONFIG_GLOBAL  = $devfolder".gitconfig"
$env:CARGO_HOME = $devfolder".cargo"
$env:UV_PYTHON_INSTALL_DIR = $devfolder"\uv\python"
$env:UV_CACHE_DIR = $devfolder"uv\.cache"
$env:UV_INSTALL_DIR = $devfolder"uv"

$env:UV_COMPILE_BYTECODE = "true"

powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"

[System.Environment]::SetEnvironmentVariable('UV_PYTHON_INSTALL_DIR',"C:\dev-setup\uv\python", 'Machine')
$env:UV_PYTHON_INSTALL_DIR = "C:\dev-setup\uv\python"

uv python install 3.13
uv python install 3.12
uv python install 3.10

[System.Environment]::SetEnvironmentVariable('UV_CACHE_DIR',"C:\dev-setup\uv\.cache", 'Machine')
$env:UV_CACHE_DIR = "C:\dev-setup\uv\.cache"

[System.Environment]::SetEnvironmentVariable('UV_COMPILE_BYTECODE',"true", 'Machine')
$env:UV_COMPILE_BYTECODE = "true"

Add-PathToMachineEnvironment -PathToAdd "C:\dev-setup\cli\bin\"

cargo-binstall --root C:\dev-setup\cli -y zoxide starship ripgrep bat sd hyperfine hexyl yazi-fm yazi-cli git-delta eza fd-find bottom du-dust just qsv xh samply miniserve gifski difftastic

# Install gitui, fzf, ffmpeg, manually and place them in  C:\dev-setup\cli
