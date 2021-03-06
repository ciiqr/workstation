Param (
    [Alias("SaltDir")]
    [string]$salt = $( Join-Path $env:SystemDrive 'salt' ),
    [Alias("WorkstationDir")]
    [string]$workstation = $( Join-Path $env:SystemDrive 'workstation' )
)

# functions
. "$PSScriptRoot\include\common.ps1"

# create config directory
mkdir -Force "$salt\conf\minion.d"

# link configs
CreateSymlink "$workstation\salt\etc\grains-windows.yaml" "$salt\conf\grains"
CreateSymlink "$workstation\salt\etc\minion.conf" "$salt\conf\minion"
CreateSymlink "$workstation\salt\etc\masterlike.conf" "$salt\conf\masterlike.conf"
CreateSymlink "$workstation\salt\etc\masterless.conf" "$salt\conf\minion.d\masterless.conf"

# apply bootstrap state (for installing package managers and such)
salt-call state.apply bootstrap
