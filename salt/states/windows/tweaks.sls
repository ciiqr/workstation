{% from "windows/map.jinja" import windows with context %}
{% import "macros/reg.sls" as reg with context %}

# disable uac
{{ reg.dword('HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System', 'EnableLUA', 0) }}
{{ reg.dword('HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System', 'ConsentPromptBehaviorAdmin', 0) }}
{{ reg.dword('HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System', 'PromptOnSecureDesktop', 0) }}

# launch explorer to 'This PC'
{{ reg.dword('HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced', 'LaunchTo', 1) }}

# disable hibernation
{{ reg.dword('HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Power', 'HibernateEnabled', 0) }}

# set power plan
{{slspath}}.power_plan:
  cmd.script:
    - source: salt://windows/files/set-power-plan.ps1
    - name: set-power-plan.ps1 -Plan "{{ windows.tweaks.power_plan }}"
    - shell: powershell
    - stateful:
      - test_name: set-power-plan.ps1 -Plan "{{ windows.tweaks.power_plan }}" -Test
