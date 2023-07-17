@echo off
@title Cherry OK

color 09

:: ## Set UAC ##
set isAdminDir=C:\Windows\CherryTestAdmin
mkdir %isAdminDir% > nul
cls
if not exist %isAdminDir% (
	set "params=%*"
	cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit )
	exit
)
rmdir %isAdminDir%

:: SET UAC ::
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "ConsentPromptBehaviorAdmin" /t reg_dword /d 0 /F >nul
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableLUA" /t reg_dword /d 0 /F >nul
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "PromptOnSecureDesktop" /t reg_dword /d 0 /F >nul

:: SET EXECUTION POLICY
powershell.exe -Command "Set-ExecutionPolicy Unrestricted"

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
::powershell -command "Get-WindowsUpdate"
powershell -command "Install-WindowsUpdate -ForceDownload -ForceInstall -AcceptAll -AutoReboot"
timeout 5 > nul

:: COMPUTER RESTART ::
cls
echo RESTARTING COMPUTER...
timeout 3 >nul
echo shutdown -a > "%USERPROFILE%\Desktop\Abort Shutdown.cmd"
shutdown /t 0 /r

exit