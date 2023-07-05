@echo off
if not DEFINED IS_MINIMIZED set IS_MINIMIZED=1 && start "" /min "%~dpnx0" %* && exit
powershell -c (New-Object Media.SoundPlayer "'C:\Windows\Media\Windows Unlock.wav'").PlaySync();
powershell -command "New-BurntToastNotification -AppLogo C:\Windows\Cherry\CherryOK.png -Text 'CHERRY OK', 'Tested & Approved!'"
powershell.exe -Command "Set-ExecutionPolicy Restricted"
del "%~nx0"
exit