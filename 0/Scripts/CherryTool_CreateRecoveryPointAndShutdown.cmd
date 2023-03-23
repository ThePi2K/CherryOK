@echo off
powershell.exe -Command "Set-ExecutionPolicy Unrestricted"

:: CONFIGURE SYSTEM RESTORE ::
echo CONFIGURING SYSTEM RESTORE
powershell.exe .\..\_media\restore.ps1
find /c "Cherry OK" tmp >nul
IF %ERRORLEVEL% EQU 1 (
	del tmp
	ECHO NO RESTORE POINT FOUND!!!
	timeout 2 > nul
	sysdm.cpl
	powershell.exe -Command "Set-ExecutionPolicy Restricted"
	exit
)
echo RESTORE POINT OK
timeout 2 > nul
del tmp
cls
shutdown -t 30 -s