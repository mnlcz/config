
if ($IsWindows) {
    # PowerShell
    Copy-Item -Force -Path C:\Users\manuc\Documents\PowerShell\profile.ps1 -Destination ./ps1/
    # nvim
    Remove-Item -Recurse -Force -Path ./nvim/*
    Copy-Item -Path "C:\Users\manuc\AppData\Local\nvim\lua\custom\*" -Destination "./nvim/" -Recurse -Force
} elseif ($IsLinux) {
    # i3
    Copy-Item -Force -Path ~/.config/i3/config -Destination ./i3/
    # i3blocks
    Copy-Item -Force -Path ~/.config/i3blocks/config -Destination ./i3/i3blocks/
}
