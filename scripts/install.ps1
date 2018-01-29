Param (
    [Alias("SaltDir")]
    [string]$salt = $( Join-Path $env:SystemDrive 'salt' ),
    [switch]$link
)

# declarations
$saltUrl = 'https://repo.saltstack.com/windows/Salt-Minion-2017.7.2-Py3-AMD64-Setup.exe'
$saltFilename = 'salt-installer.exe'
$repoUrl = 'https://github.com/ciiqr/workstation/archive/master.zip'
$repoFilename = 'repo.zip'

$repoZipSubDir = 'workstation-master'
$workstation = Join-Path $env:SystemDrive 'workstation'
$scripts = Join-Path $workstation 'scripts'
$setup_salt = Join-Path $scripts 'setup-salt.ps1'
$provision = Join-Path $scripts 'provision.ps1'

# functions
. "$PSScriptRoot\include\common.ps1"

# ensure we're running as an admin
EnsureAdmin

# set execution polity
Set-ExecutionPolicy Bypass -Scope CurrentUser


# create temp directory
echo 'Creating temp directory...'
$tmp = CustomTempDirectory

# temp files
$saltFile = Join-Path $tmp $saltFilename
$repoTempFile = Join-Path $tmp $repoFilename
$repoTempDir = Join-Path $tmp 'workstation'
$repoSubDir = Join-Path $repoTempDir $repoZipSubDir


if ($link) {
    # link
    TryRemoveDirectory $workstation
    CreateSymlink "$PSScriptRoot\.." $workstation
}
else {
    # download workstation
    echo 'Downloading workstation...'
    Invoke-WebRequest $repoUrl -OutFile $repoTempFile -UseBasicParsing

    # unzip workstation
    TryRemoveDirectory $repoTempDir
    Expand-Archive $repoTempFile -DestinationPath $repoTempDir

    # move to system drive
    TryRemoveDirectory $workstation
    Move-Item $repoSubDir $workstation
}


# TODO: support building ourself (since I'm already doing this manually) https://docs.saltstack.com/en/latest/topics/installation/windows.html#building-and-developing-on-windows and https://docs.saltstack.com/en/latest/topics/development/tests/index.html#running-test-subsections
# download salt
echo 'Downloading salt...'
Invoke-WebRequest $saltUrl -OutFile $saltFile -UseBasicParsing

# install salt
# TODO: probably don't need the minion name, or I could create minion_id myself
& $saltFile /S /minion-name=workstation /start-minion=0

# set salt perms
WaitForFile($salt)
icacls $salt /grant "Everyone:(OI)(CI)F"

# wait for salt to be ready
WaitForSalt($salt)


# setup salt
echo 'Setting up salt...'
& "$setup_salt" -SaltDir $salt -WorkstationDir $workstation

# run salt highstate
echo 'Provisioning...'
& "$provision" -SaltDir $salt

echo 'done'
