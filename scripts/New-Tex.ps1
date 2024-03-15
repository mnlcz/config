Param
(
    [Parameter(Mandatory = $true, Position = 0)]
    [String]$Template,
    
    [Parameter(Mandatory = $true, Position = 1)]
    [String]$Title
)

New-Item -ItemType Directory -Name $Title
Copy-Item -Recurse -Force -Path $PSScriptRoot\..\templates\latex\$Template\* -Destination ".\$Title\"
