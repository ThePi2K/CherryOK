vssadmin delete shadows /all /quiet
Enable-ComputerRestore -Drive "C:\"
cls
vssadmin resize shadowstorage /for=C: /on=C: /maxsize=20%
cls
Checkpoint-Computer -Description "Cherry OK" -RestorePointType "MODIFY_SETTINGS"