@echo off
title Cherry OK %version%
powershell.exe -Command "$host.ui.RawUI.WindowTitle = 'Cherry OK %version%'"

color 09

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

:: Create Cherry Folder in Windows ::
mkdir C:\Windows\Cherry >nul 2>&1

:: SET UAC ::
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "ConsentPromptBehaviorAdmin" /t reg_dword /d 0 /F >nul
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableLUA" /t reg_dword /d 0 /F >nul
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "PromptOnSecureDesktop" /t reg_dword /d 0 /F >nul

:: SET EXECUTION POLICY
powershell.exe -Command "Set-ExecutionPolicy Unrestricted"

:: SET TERMINAL AS DEFAULT COMMAND PROMPT ::
reg add "HKEY_CURRENT_USER\Console\%%Startup" /v "DelegationConsole" /t REG_SZ /d "{2EACA947-7F5F-4CFA-BA87-8F7FBEEFBE69}" >nul
reg add "HKEY_CURRENT_USER\Console\%%Startup" /v "DelegationTerminal" /t REG_SZ /d "{E12CFF52-A866-4C77-9A90-F570A7AA2C6B}" /F >nul

:: IMPORTING PACKAGES ::
echo IMPORTING PACKAGES...
powershell -command "if (-not (Get-PackageProvider -ListAvailable -Name nuget)) { Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force}" > nul
powershell -command "if (-not (Get-Module -ListAvailable -Name PSWindowsUpdate)) { Install-Module PSWindowsUpdate -Force }"
powershell -command "if (-not (Get-Module -ListAvailable -Name BurntToast)) { Install-Module BurntToast -Force }"
cls

color 0e

:: STARTING STORE UPDATES ::
echo STARTING STORE UPDATES...
powershell -command "Get-CimInstance -Namespace "Root\cimv2\mdm\dmmap" -ClassName "MDM_EnterpriseModernAppManagement_AppManagement01" | Invoke-CimMethod -MethodName UpdateScanMethod"
cls

:: SCANNING AND INSTALLING WINDOWS UPDATES ::
echo SCANNING AND INSTALLING WINDOWS UPDATES...
powershell -command "Install-WindowsUpdate -ForceDownload -ForceInstall -AcceptAll -AutoReboot"

:: COMPUTER RESTART ::
cls
echo RESTARTING COMPUTER...
timeout 3 >nul
echo shutdown -a > "%USERPROFILE%\Desktop\Abort Shutdown.cmd"
shutdown /t 30 /r

exit