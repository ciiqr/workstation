
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

$saltDir = Join-Path $env:SystemDrive 'salt'
$saltCall = Join-Path $saltDir 'salt-call'

# functions
function CustomTempDirectory {
    # NOTE: I would rather generate a unique directory name and then delete it when done,
    # but windows is stupid with the permissions of the newly downloaded file

    $parent = [System.IO.Path]::GetTempPath()
    $tmp = Join-Path $parent 'workstation'
    if (![System.IO.Directory]::Exists($tmp)) {
        [System.IO.Directory]::CreateDirectory($tmp) > $null
    }
    return $tmp
}

function TryRemoveDirectory($dir) {
    if ([System.IO.Directory]::Exists($dir)) {
        Remove-Item $dir -Force -Recurse
    }
}

function WaitForFile($file) {
    while (!(Test-Path $file)) {
        echo "Waiting for $file to appear"
        Start-Sleep 5
    }
    Start-Sleep 5
}

function WaitForSalt {
    # source: https://gist.github.com/deuscapturus/8f18d28d1a1ccef6327c
    $saltCallExe = "$saltCall.exe"
    $saltCallBat = "$saltCall.bat"
    while (!(Test-Path $saltCallExe) -and !(Test-Path $saltCallBat)) {
        echo 'Waiting for salt-call to appear'
        Start-Sleep 5
    }
    Start-Sleep -s 15
}

function EnsureAdmin {
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    if (!$currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        echo 'must be run as an admin'
        exit 0
    }
}

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


# download workstation
echo 'Downloading workstation...'
Invoke-WebRequest $repoUrl -OutFile $repoTempFile -UseBasicParsing

# unzip workstation
TryRemoveDirectory $repoTempDir
Expand-Archive $repoTempFile -DestinationPath $repoTempDir

# move to system drive
TryRemoveDirectory $workstation
Move-Item $repoSubDir $workstation


# download salt
echo 'Downloading salt...'
Invoke-WebRequest $saltUrl -OutFile $saltFile -UseBasicParsing

# install salt
# TODO: probably don't need the minion name, or I could create minion_id myself
& $saltFile /S /minion-name=workstation /start-minion=0

# set salt perms
WaitForFile($saltDir)
icacls $saltDir /grant "Everyone:(OI)(CI)F"

# wait for salt to be ready
WaitForSalt


# setup salt
& "$setup_salt" -SaltDir $saltDir -WorkstationDir $workstation

# run salt highstate
& "$provision" -SaltDir $saltDir

echo 'done'
