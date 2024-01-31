# Shell behaviour
Set-PSReadLineOption -PredictionViewStyle ListView

if ($IsWindows) {
    # Appearance
    oh-my-posh --init --shell pwsh --config C:\Users\manuc\Documents\PowerShell\Modules\oh-my-posh\themes\star.omp.json | Invoke-Expression
    Import-Module -Name Terminal-Icons

    # Alias related
    Set-Alias -Name nvconf -Value NvimConfPath
    Set-Alias -Name psconf -Value PSUserPath
    Set-Alias -Name dotfiles -Value ConfigPath

    # Util funcs
    function NvimConfPath { Set-Location -Path ~/AppData/Local/nvim/lua/custom/ }
    function PSUserPath { Set-Location -Path ~/Documents/PowerShell/ }
    function ConfigPath { Set-Location -Path F:/Dev/Repos/Config/ }
}

