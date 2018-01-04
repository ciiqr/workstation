
# declarations
$saltUrl = 'https://repo.saltstack.com/windows/Salt-Minion-2017.7.2-Py3-AMD64-Setup.exe'
$saltFilename = 'salt-installer.exe'
$repoUrl = 'https://github.com/ciiqr/workstation/archive/master.zip'
$repoFilename = 'repo.zip'

$repoZipSubDir = 'workstation-master'
$workstation = Join-Path $env:SystemDrive 'workstation'
$install = Join-Path $workstation 'install.ps1'

$saltDir = Join-Path $env:SystemDrive 'salt'
$saltCall = Join-Path $saltDir 'salt-call'














# TODO: run salt highstate
& $saltCall --local state.apply

echo 'done'
