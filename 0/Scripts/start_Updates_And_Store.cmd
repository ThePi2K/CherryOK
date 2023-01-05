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

:: START WIN STORE UPDATES
WMIC OS Get Name | findstr Microsoft > result.txt
set /p QUERY=<result.txt
del result.txt
for /f "tokens=1 delims=|" %%a in ("%QUERY%") do (
	set winver=%%a
)
if NOT "%winver%"=="%winver:11=%" (
	timeout 8 > nul
	_media\nircmd cmdwait 1500 sendkeypress tab tab tab
	_media\nircmd cmdwait 1500 sendkeypress down down down down
	_media\nircmd cmdwait 1500 sendkeypress enter
	_media\nircmd cmdwait 2500 sendkeypress enter
)

:: WINDOWS UPDATES ::
echo WINDOWS UPDATES
start ms-settings:windowsupdate

exit