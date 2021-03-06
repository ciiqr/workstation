# workstation

see [ciiqr/machines](https://github.com/ciiqr/machines) for my linux setup

## compatibility
* uses several PowerShell 5 features
* this installs the most recent release of salt (nitrogen/2017.7.2), however the reg module is broken in this version, so you must compile the next release (oxygen/2018.2.0) of salt yourself: [building-and-developing-on-windows](https://docs.saltstack.com/en/latest/topics/installation/windows.html#building-and-developing-on-windows)

## install (via powershell)

* from repo
```
Start-Process powershell -ArgumentList '-NoProfile -NoExit -InputFormat None -Command "iex ((New-Object System.Net.WebClient).DownloadString(\"https://raw.githubusercontent.com/ciiqr/workstation/master/scripts/install.ps1\"))"' -verb RunAs; exit
```

* from local (change path to wherever you've clone to)
```
# open an admin powershell window to wherever you cloned to
Start-Process powershell -ArgumentList '-NoExit -command "cd C:\Users\william\Dropbox\workstation"' -verb RunAs; exit

# install linked to cloned path
& .\scripts\install.ps1 -Link
```

## update (via powershell)
```
Start-Process powershell -ArgumentList '-NoProfile -NoExit -InputFormat None -File C:\workstation\scripts\provision.ps1' -verb RunAs; exit
```
