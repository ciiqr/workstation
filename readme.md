# workstation

see [ciiqr/machines](https://github.com/ciiqr/machines) for my linux setup

## compatibility
* uses several PowerShell 5 features

## install

* from powershell
```
Start-Process powershell -ArgumentList '-NoProfile -NoExit -InputFormat None -Command "iex ((New-Object System.Net.WebClient).DownloadString(\"https://raw.githubusercontent.com/ciiqr/workstation/master/install.ps1\"))"' -verb RunAs; exit
```
