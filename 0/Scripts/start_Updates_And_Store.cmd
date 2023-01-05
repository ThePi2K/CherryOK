@echo off
@title Starting Updates

:: EXIT IF NO INTERNET
echo CHECKING INTERNET...
ping -n 1 8.8.8.8 | find "TTL=" >nul
cls
if errorlevel 1 (
	echo NO INTERNET... CONNECT TO INTERNET!
	timeout 5 > nul
	exit
)
echo INTERNET OK!

:: START UPDATES BEFORE LAUNCHING SETTINGS ::
wuauclt /detectnow /updatenow
timeout 2 > nul
cls

:: OPEN MICROSOFT STORE ::
echo MICROSOFT STORE UPDATES
start ms-windows-store:

:: WINDOWS UPDATES ::
echo WINDOWS UPDATES
start ms-settings:windowsupdate

exit