@echo off
@title Starting Updates

:: STARTING UPDATES ::
::powershell -command "Get-CimInstance -Namespace "Root\cimv2\mdm\dmmap" -ClassName "MDM_EnterpriseModernAppManagement_AppManagement01" | Invoke-CimMethod -MethodName UpdateScanMethod"
::wuauclt /detectnow /updatenow

:: OPEN MICROSOFT STORE ::
echo MICROSOFT STORE UPDATES
start ms-windows-store:

:: WINDOWS UPDATES ::
echo WINDOWS UPDATES
start ms-settings:windowsupdate