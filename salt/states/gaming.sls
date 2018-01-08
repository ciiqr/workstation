
steam: chocolatey.installed
discord: chocolatey.installed
twitch: chocolatey.installed
battle.net: chocolatey.installed

# leagueoflegends: chocolatey.installed

geforce-experience:
  chocolatey.installed:
    - onlyif: wmic path win32_VideoController get AdapterCompatibility | findstr -I nvidia
