ECHO change boot to ubuntu
bcdedit /set {fwbootmgr} displayorder {7d213386-6f8c-11ea-a799-ea0e19d24cb4} /addfirst
PAUSE
shutdown /r /t 0