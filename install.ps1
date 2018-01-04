
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

# functions
function CustomTempDirectory {
    # NOTE: I would rather generate a unique directory name and then delete it when done,
    # but windows is stupid with the permissions of the newly downloaded file

    $parent = [System.IO.Path]::GetTempPath()
    $tmp = Join-Path $parent 'workstation'
    if (![System.IO.Directory]::Exists($tmp)) {
        [System.IO.Directory]::CreateDirectory($tmp)
    }
    return $tmp
}

function TryRemoveDirectory($dir) {
    if ([System.IO.Directory]::Exists($dir)) {
        Remove-Item $dir -Force -Recurse
    }
}

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
$down = New-Object System.Net.WebClient
$down.DownloadFile($repoUrl, $repoTempFile)

# unzip workstation
TryRemoveDirectory $repoTempDir
Expand-Archive $repoTempFile -DestinationPath $repoTempDir

# move to system drive
TryRemoveDirectory $workstation
Move-Item $repoSubDir $workstation


# download salt
echo 'Downloading salt...'
$down = New-Object System.Net.WebClient
$down.DownloadFile($saltUrl, $saltFile)

# install salt
Set-ExecutionPolicy Bypass -Scope Process -Force
& $saltFile /S /minion-name=workstation /start-minion=0


# TODO: run salt highstate
& $saltCall --local state.apply

echo 'done'
