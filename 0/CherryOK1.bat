:: Cherry OK Script
:: by Felix Peer
:: Script 1
:: Version 3.5
:: Created and tested for Windows 11 22H2

@echo off
@title Cherry OK

:: STOPPING EXPLORER ::
taskkill /f /im explorer.exe
start explorer.exe

:: CONNECTING TO CHERRY-NET ::
echo CONNECTING TO CHERRY-NET
netsh wlan add profile filename=_media\WLAN-Cherry-Net.xml
timeout 4
cls

:: SET UAC SETTINGS ::
echo SET UAC SETTINGS
start _media\uac.bat
timeout 2 > nul
cls

:: WINDOWS UPDATES ::
echo WINDOWS UPDATES
start ms-settings:windowsupdate
timeout 2 > nul
cls

:: MICROSOFT STORE UPDATES ::
echo MICROSOFT STORE UPDATES
start ms-windows-store:

mkdir C:\Users\Public\Documents\CherryOK
exit