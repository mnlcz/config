# Shell behaviour
Set-PSReadLineOption -PredictionViewStyle ListView

# Install-Module -Name Terminal-Icons -Repository PSGallery
Import-Module -Name Terminal-Icons

if ($IsWindows) 
{
    # Appearance
    oh-my-posh --init --shell pwsh --config F:\Dev\Repos\Config\ps1\custom-themes\star.omp.json | Invoke-Expression

    # Alias related
    Set-Alias -Name nvconf -Value NvimConfPath
    Set-Alias -Name psconf -Value PSUserPath
    Set-Alias -Name dotfiles -Value ConfigPath
    Set-Alias -Name univault -Value UniVaultPath
    Set-Alias -Name persvault -Value PersVaultPath
    Set-Alias -Name cstools -Value CyberSecurityScripts

    # Util funcs
    function NvimConfPath { Set-Location -Path ~/AppData/Local/nvim/lua/custom/ }
    function PSUserPath { Set-Location -Path ~/Documents/PowerShell/ }
    function ConfigPath { Set-Location -Path F:/Dev/Repos/Config/ }
    function UniVaultPath { Set-Location -Path ~/OneDrive/MnLCz/Universidad/ }
    function PersVaultPath { Set-Location -Path ~/OneDrive/MnLCz/Personal/ }
    function CyberSecurityScripts { $env:PATH += ";F:/Dev/Repos/Cybersecurity/Tools" }
}
elseif ($IsLinux)
{
    # Add composer global packages bin to PATH
    # $env:PATH += ":/home/mnlcz/.composer/vendor/bin"

    # Neovim
    $env:PATH += ":/opt/nvim-linux64/bin"
    $env:PATH += ":/opt/nvim-linux64/bin"
    $env:PATH += ":/opt/nvim-linux64/bin"

    # Posh
    $env:PATH += ":$env:HOME/.local/bin"
    oh-my-posh init pwsh --config "$env:HOME/repos/Config/ps1/custom-themes/star.omp.json" | Invoke-Expression

    # Manually installed software
    $env:PATH += ":/opt/zig/" # zig compiler

    # SDKMAN (works in bash only, but PS1 can use the installed sdks)
    $env:SDKMAN_DIR = "$env:HOME/.sdkman"
    $env:PATH += ":$env:SDKMAN_DIR/candidates/gradle/current/bin" # gradle
    $env:PATH += ":$env:SDKMAN_DIR/candidates/kotlin/current/bin" # kotlin compiler
}

