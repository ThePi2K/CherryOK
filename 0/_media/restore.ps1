vssadmin delete shadows /all /quiet
Enable-ComputerRestore -Drive "C:\"
vssadmin resize shadowstorage /for=C: /on=C: /maxsize=20%
Checkpoint-Computer -Description "Cherry OK" -RestorePointType "MODIFY_SETTINGS"