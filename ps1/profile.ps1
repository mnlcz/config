# Shell behaviour
Set-PSReadLineOption -PredictionViewStyle ListView

if ($IsWindows) 
{
    # Appearance
    oh-my-posh --init --shell pwsh --config F:\Dev\Repos\Config\ps1\custom-themes\star.omp.json | Invoke-Expression
    Import-Module -Name Terminal-Icons

    # Alias related
    Set-Alias -Name nvconf -Value NvimConfPath
    Set-Alias -Name psconf -Value PSUserPath
    Set-Alias -Name dotfiles -Value ConfigPath
    Set-Alias -Name univault -Value UniVaultPath
    Set-Alias -Name persvault -Value PersVaultPath

    # Util funcs
    function NvimConfPath { Set-Location -Path ~/AppData/Local/nvim/lua/custom/ }
    function PSUserPath { Set-Location -Path ~/Documents/PowerShell/ }
    function ConfigPath { Set-Location -Path F:/Dev/Repos/Config/ }
    function UniVaultPath { Set-Location -Path ~/OneDrive/MnLCz/Universidad/ }
    function PersVaultPath { Set-Location -Path ~/OneDrive/MnLCz/Personal/ }
}
elseif ($IsLinux)
{
    # Add composer global packages bin to PATH
    $env:PATH += ":/home/mnlcz/.composer/vendor/bin"
}

