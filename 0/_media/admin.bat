@echo off
@title Cherry OK - Admin

:: ## Set UAC ##
set isAdminDir=C:\Windows\CherryTestAdmin
mkdir %isAdminDir%
if not exist %isAdminDir% (
	set "params=%*"
	cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )
	exit
)
rmdir %isAdminDir%

:: SET UAC ::
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "ConsentPromptBehaviorAdmin" /t reg_dword /d 0 /F >nul
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableLUA" /t reg_dword /d 0 /F >nul
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "PromptOnSecureDesktop" /t reg_dword /d 0 /F >nul

:: SET EXECUTION POLICY
powershell.exe -Command "Set-ExecutionPolicy Unrestricted"

:: START UPDATES ::
::powershell.exe .\Store.ps1
powershell -command "Get-CimInstance -Namespace "Root\cimv2\mdm\dmmap" -ClassName "MDM_EnterpriseModernAppManagement_AppManagement01" | Invoke-CimMethod -MethodName UpdateScanMethod"
wuauclt /detectnow /updatenow

exit