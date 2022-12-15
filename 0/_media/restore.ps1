vssadmin delete shadows /all /quiet
Enable-ComputerRestore -Drive "C:\"
cls
echo "CONFIGURING SYSTEM RESTORE"
vssadmin resize shadowstorage /for=C: /on=C: /maxsize=20%
cls
echo "CONFIGURING SYSTEM RESTORE"
Checkpoint-Computer -Description "Cherry OK" -RestorePointType "MODIFY_SETTINGS"