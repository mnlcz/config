# Shell behaviour
# Set-PSReadLineOption -PredictionViewStyle ListView

# Install-Module -Name Terminal-Icons -Repository PSGallery
# Import-Module -Name Terminal-Icons

if ($IsWindows) 
{
    # Appearance
    # oh-my-posh --init --shell pwsh --config F:\Dev\Repos\Config\ps1\custom-themes\star.omp.json | Invoke-Expression

    # Alias related
    Set-Alias -Name config -Value ConfigPath
    Set-Alias -Name v -Value nvim
    Set-Alias -Name vps1 -Value PS1Config
    Set-Alias -Name vnv -Value NvimConfig

    # Util funcs
    function ConfigPath { Set-Location -Path F:/Dev/Repos/Config/ }
    function PS1Config { nvim ~/Documents/PowerShell/profile.ps1 }
    function NvimConfig { nvim ~/AppData/Local/nvim/ }
}
elseif ($IsLinux)
{
    # TODO
}
