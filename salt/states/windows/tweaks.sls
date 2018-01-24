{% from "windows/map.jinja" import windows with context %}

# disable uac
EnableLUA:
  reg.present:
    - name: HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System
    - vname: EnableLUA
    - vtype: REG_DWORD
    - vdata: 0
ConsentPromptBehaviorAdmin:
  reg.present:
    - name: HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System
    - vname: ConsentPromptBehaviorAdmin
    - vtype: REG_DWORD
    - vdata: 0
PromptOnSecureDesktop:
  reg.present:
    - name: HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System
    - vname: PromptOnSecureDesktop
    - vtype: REG_DWORD
    - vdata: 0

# launch explorer to 'This PC'
LaunchTo:
  reg.present:
    - name: HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced
    - vname: LaunchTo
    - vtype: REG_DWORD
    - vdata: 1

# disable hibernation
HibernateEnabled:
  reg.present:
    - name: HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Power
    - vname: HibernateEnabled
    - vtype: REG_DWORD
    - vdata: 0

# set power plan
power_plan:
  cmd.script:
    - source: salt://windows/files/set-power-plan.ps1
    - name: set-power-plan.ps1 -Plan "{{ windows.tweaks.power_plan }}"
    - shell: powershell
    - stateful:
      - test_name: set-power-plan.ps1 -Plan "{{ windows.tweaks.power_plan }}" -Test
