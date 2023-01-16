@echo off
@title Starting Updates

:: STARTING STORE UPDATES ::
echo STARTING STORE UPDATES...
powershell -command "Get-CimInstance -Namespace "Root\cimv2\mdm\dmmap" -ClassName "MDM_EnterpriseModernAppManagement_AppManagement01" | Invoke-CimMethod -MethodName UpdateScanMethod"
timeout 1 >nul
cls

:: START WINDOWS UPDATES ::
echo SCANNING AND INSTALLING WINDOWS UPDATES...
powershell -command "Get-WindowsUpdate"
powershell -command "Install-WindowsUpdate -ForceDownload -ForceInstall -AcceptAll -AutoReboot"

:: CHECKING UPDATES ::
echo CHECKING UPDATES
powershell -command "Get-WindowsUpdate" > tmp
find /c "ComputerName" tmp >nul
IF %ERRORLEVEL% EQU 0 (
	del tmp
	shutdown /r /t 30
	echo shutdown -a > "%USERPROFILE%\Desktop\Abort Shutdown.cmd"
	exit
)
del tmp
ECHO UPDATES OK
timeout 2 > nul
cls

:: STARTING CHERRY OK
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
	exit
)
