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
    Set-Alias -Name repos -Value ReposPath
    Set-Alias -Name v -Value nvim
    Set-Alias -Name vps1 -Value PS1Config
    Set-Alias -Name vnv -Value NvimConfig

    # Util funcs
    function ReposPath { Set-Location -Path F:/Dev/Repos/ }
    function ConfigPath { Set-Location -Path F:/Dev/Repos/config/ }
    function PS1Config { nvim F:/Dev/Repos/config/shells/profile.ps1 }
    function NvimConfig { nvim F:/Dev/Repos/config/nvim/ }
}
elseif ($IsLinux)
{
    # TODO
}
