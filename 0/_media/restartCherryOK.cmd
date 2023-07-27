@echo off
@title Cherry OK

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
wmic LOGICALDISK where driveType=2 get deviceID > C:\tmp 2>&1
for /f "skip=1" %%b IN ('type C:\tmp') DO (echo %%b & %%b)

:openCmd
del C:\tmp >nul 2>&1
cd \
IF EXIST "Cherry OK.cmd" (
	cd 0
	cls
	call "Cherry OK.bat"
) else (
	echo USB is missing...
	DIR
	pause
	cls
	goto checkUSB
)