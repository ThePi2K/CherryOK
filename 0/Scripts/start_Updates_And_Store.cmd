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

:: OPEN MICROSOFT STORE ::
start ms-windows-store:

:: WINDOWS UPDATES ::
start ms-settings:windowsupdate