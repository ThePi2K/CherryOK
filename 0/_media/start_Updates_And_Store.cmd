@echo off
@title Cherry OK - Updates

color 0e

:: STARTING STORE UPDATES ::
echo STARTING STORE UPDATES...
powershell -command "Get-CimInstance -Namespace "Root\cimv2\mdm\dmmap" -ClassName "MDM_EnterpriseModernAppManagement_AppManagement01" | Invoke-CimMethod -MethodName UpdateScanMethod"
cls
echo Forcing Updates was successfully!
timeout 1 >nul
cls

:: CHECKING UPDATES ::
echo CHECKING WINDOWS UPDATES
powershell -command "Get-WindowsUpdate" > tmp
find /c "ComputerName" tmp >nul
IF %ERRORLEVEL% EQU 0 (
	del tmp
	echo INSTALLING WINDOWS UPDATES...
	powershell -command "Get-WindowsUpdate"
	powershell -command "Install-WindowsUpdate -ForceDownload -ForceInstall -AcceptAll -AutoReboot"
	shutdown /r /t 30
	echo shutdown -a > "%USERPROFILE%\Desktop\Abort Shutdown.cmd"
	exit
)
del tmp
ECHO UPDATES OK
timeout 2 > nul
cls

:: STARTING CHERRY OK
:checkUSB
wmic LOGICALDISK where driveType=2 get deviceID > C:\tmp 2>&1
for /f "skip=1" %%b IN ('type C:\tmp') DO (echo %%b & %%b & IF EXIST "Cherry OK.cmd" goto openCmd)

:openCmd
del C:\tmp >nul 2>&1
IF EXIST "Cherry OK.cmd" (
	cd 0
	cls
	call "Cherry OK.bat"
) else (
	echo USB is missing...
	pause
	cls
	goto checkUSB
)
