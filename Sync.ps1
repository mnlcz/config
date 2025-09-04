if ($IsWindows) {
    [String]$uname = (whoami).Split('\')[1]

    # PowerShell
    if ($args.Count -eq 0 -or $args[0] -ne 'NotPS1') {
        Copy-Item -Force -Path C:\Users\$uname\Documents\PowerShell\profile.ps1 -Destination ./shells/ps1
    }
    # nvim
    Remove-Item -Recurse -Force -Path ./nvim/*
    Copy-Item -Path "C:\Users\MnLCz\AppData\Local\nvim\*" -Destination "./nvim/" -Recurse -Force
    # mpv
    Remove-Item -Recurse -Force -Path ./mpv/*
    Copy-Item -Path "C:\Users\MnLCz\AppData\Roaming\mpv\*" -Destination "./mpv/" -Recurse -Force
} elseif ($IsLinux) {
    # i3
    Copy-Item -Force -Path ~/.config/i3/config -Destination ./i3/
    # i3blocks
    Copy-Item -Force -Path ~/.config/i3blocks/config -Destination ./i3/i3blocks/
}
