# workstation

see [ciiqr/machines](https://github.com/ciiqr/machines) for my linux setup

## compatibility
* uses several PowerShell 5 features

## install with powershell

* from repo
```
Start-Process powershell -ArgumentList '-NoProfile -NoExit -InputFormat None -Command "iex ((New-Object System.Net.WebClient).DownloadString(\"https://raw.githubusercontent.com/ciiqr/workstation/master/scripts/install.ps1\"))"' -verb RunAs; exit
```

* from local (change path to wherever you've clone to)
```
Start-Process powershell -ArgumentList '-NoProfile -NoExit -InputFormat None -File C:\Users\william\Dropbox\workstation\scripts\install.ps1' -verb RunAs; exit
```

