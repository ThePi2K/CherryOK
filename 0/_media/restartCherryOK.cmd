@echo off
@title Cherry OK

shutdown -a

:: START AS ADMIN ::
set isAdminDir=C:\Windows\CherryTestAdmin
mkdir %isAdminDir% > nul
cls
if not exist %isAdminDir% (
	set "params=%*"
	cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit )
	exit
)
rmdir %isAdminDir%

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