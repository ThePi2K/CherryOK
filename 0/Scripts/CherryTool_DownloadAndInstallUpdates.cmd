@echo off
@title Updates

:: CHECK ADMIN
set isAdminDir=C:\Windows\CherryTestAdmin
mkdir %isAdminDir% >nul
cls
if not exist %isAdminDir% (
	set "params=%*"
	cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit )
	exit
)
rmdir %isAdminDir%

:: SET EXECUTION POLICY
powershell.exe -Command "Set-ExecutionPolicy Unrestricted"

:: UPGRADING ALL PROGRAMS ::
echo UPGRADING ALL PROGRAMS
winget upgrade --all --accept-source-agreements --force
timeout 2 > nul
cls

:: STARTING STORE UPDATES ::
echo STARTING STORE UPDATES...
powershell -command "Get-CimInstance -Namespace "Root\cimv2\mdm\dmmap" -ClassName "MDM_EnterpriseModernAppManagement_AppManagement01" | Invoke-CimMethod -MethodName UpdateScanMethod"
cls
echo Forcing Updates was successfully!
timeout 1 >nul
cls

:: START WINDOWS UPDATES ::
echo IMPORTING PACKAGES...
powershell -command "if (-not (Get-PackageProvider -ListAvailable -Name nuget)) { Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force}" > nul
powershell -command "if (-not (Get-Module -ListAvailable -Name PSWindowsUpdate)) { Install-Module PSWindowsUpdate -Force }"
cls
echo SCANNING AND INSTALLING WINDOWS UPDATES...
powershell -command "Install-WindowsUpdate -ForceDownload -ForceInstall -AcceptAll"

exit