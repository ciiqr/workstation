Param (
    [Alias("SaltDir")] 
    [string]$salt = $( Join-Path $env:SystemDrive 'salt' ),
    [Alias("WorkstationDir")] 
    [string]$workstation = $( Join-Path $env:SystemDrive 'workstation' )
)

# declarations
$saltCall = Join-Path $salt 'salt-call'

# functions
function CreateSymlink($target, $link) {
    New-Item -Path $link -ItemType SymbolicLink -Value $target -Force > $null
}

# link configs
CreateSymlink "$workstation\salt\etc\grains-windows" "$salt\conf\grains"
CreateSymlink "$workstation\salt\etc\minion.conf" "$salt\conf\minion"
CreateSymlink "$workstation\salt\etc\masterlike.conf" "$salt\conf\masterlike.conf"
CreateSymlink "$workstation\salt\etc\masterless.conf" "$salt\conf\minion.d\masterless.conf"

# install chocolatey (TODO: could be a state)
& $saltCall chocolatey.bootstrap