powershell.exe -Command "Set-ExecutionPolicy Unrestricted"
powershell.exe .\_media\restore.ps1
powershell.exe -Command "Set-ExecutionPolicy Restricted"
timeout 2 > nul
cls

echo CHERRY OK SUCCEEDED SUCCESSFULLY
timeout 2 > nul
cls