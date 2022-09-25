ECHO change boot to windows
bcdedit /set {fwbootmgr} displayorder {bootmgr} /addfirst
PAUSE
shutdown /r /t 0