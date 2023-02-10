@echo off
rem Install.cmd
rem HP auto install file for SFU Service

@setlocal enableextensions
set currentpath=%cd%
cd %~dp0
echo %cd%

if not exist C:\system.sav\logs mkdir C:\system.sav\logs

echo =============================================
echo Installing HP SFU Service
echo =============================================

set SFUlog=C:\system.sav\logs\SFU.log
echo [%date% %time%] Installing HP SFU Service >> %SFUlog%

pnputil /add-driver HpSfuService.inf /install >> %SFUlog% 2>&1
set DriverReturn=%ERRORLEVEL%

echo [Driver Return] = %DriverReturn%

@echo [%date% %time%]  SFU - ErrorLevel "%DriverReturn%"  	   >> %SFUlog%

cd %currentpath%
echo [%date% %time%] HP SFU Service Installation completed...

::Uninstallation Instructions
REM For driver uninstallation do the following steps
REM 1. Uninstall HP SFU Device from device manager, be sure to check "Delete the driver software for this device." box.

