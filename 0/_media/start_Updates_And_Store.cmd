@echo off
setlocal enabledelayedexpansion
del "%USERPROFILE%\Desktop\Abort Shutdown.cmd" >nul 2>&1

color 0e

:: SKIP UPDATES ::
if exist C:\Windows\Cherry\SkipUpdates.txt (
	echo SKIPPING UPDATES
	goto skipwinupd
)

:: COUNTER ::
set "counterFile=C:\Windows\Cherry\counter.txt"
if not exist %counterFile% (
    echo 0 > %counterFile%
)
for /f %%A in (%counterFile%) do set "counter=%%A"
set /a "counter+=1"
echo !counter! > %counterFile%
set maxLoop=7

:: SET TITLE ::
powershell.exe -Command "$host.ui.RawUI.WindowTitle = 'Updates !counter!'"

:: IF COUNTER OVER maxLoop ::
if !counter! gtr %maxLoop% (
    del "%counterFile%" >nul 2>&1
    echo The Computer was restarted over %maxLoop% times!
    echo Starting Windows Updates...
    timeout 10 > nul
    start ms-settings:windowsupdate
    exit /b
)

:: STARTING STORE UPDATES ::
echo STARTING STORE UPDATES...
powershell -command "Get-CimInstance -Namespace "Root\cimv2\mdm\dmmap" -ClassName "MDM_EnterpriseModernAppManagement_AppManagement01" | Invoke-CimMethod -MethodName UpdateScanMethod | Out-Null"
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

:skipwinupd

:: STARTING CHERRY OK
:checkUSB
set "cherryDrive="
for /f "skip=1" %%b IN ('wmic LOGICALDISK where driveType^=2 get deviceID') DO (
    set "usbDrive=%%b"
    if exist "%%b\Cherry OK.cmd" (
        set "cherryDrive=%%b"
        goto :foundCherry
    )
)
:foundCherry
if defined cherryDrive (
    %cherryDrive%
    cd 0
    cls
    call "Cherry OK.bat"
) else (
    cls
    echo Cherry OK was not found...
    pause
    cls
    goto checkUSB
)