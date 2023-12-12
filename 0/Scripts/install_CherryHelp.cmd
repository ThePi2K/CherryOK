:: COPIED AND MODIFIED FROM CHERRY OK SCRIPT 7.2

@echo off

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

:: CHECK LANGUAGE ::
FOR /F "tokens=2 delims==" %%a IN ('wmic os get OSLanguage /Value') DO set OSLangCode=%%a
set OSLanguage=undefined
if %OSLangCode% == 1031 set OSLanguage=de-DE
if %OSLangCode% == 1033 set OSLanguage=en-US
if %OSLangCode% == 1040 set OSLanguage=it-IT
cls

del /f "%userprofile%\Desktop\Cherry Hilfe.exe" >nul 2>&1
del /f "%userprofile%\Desktop\Cherry Aiuto.exe" >nul 2>&1
del /f "%userprofile%\Desktop\Cherry Help.exe" >nul 2>&1

echo SETTING UP CHERRY HELP...
timeout 1 > nul
curl https://customdesignservice.teamviewer.com/download/windows/v15/6bgwa4q/TeamViewerQS.exe -o C:\TeamViewerQS.exe
if "%OSLanguage%"=="de-DE" move C:\TeamViewerQS.exe "%userprofile%\Desktop\Cherry Hilfe.exe" >nul 2>&1
if "%OSLanguage%"=="it-IT" move C:\TeamViewerQS.exe "%userprofile%\Desktop\Cherry Aiuto.exe" >nul 2>&1
if not exist "%userprofile%\Desktop\Cherry *.exe" move C:\TeamViewerQS.exe "%userprofile%\Desktop\Cherry Help.exe" >nul 2>&1

if not exist "%userprofile%\Desktop\Cherry *.exe" (
	cls
	echo RETRY...
	if "%OSLanguage%"=="de-DE" copy "..\_media\TeamViewerQS.exe" "%userprofile%\Desktop\Cherry Hilfe.exe"
	if "%OSLanguage%"=="it-IT" copy "..\_media\TeamViewerQS.exe" "%userprofile%\Desktop\Cherry Aiuto.exe"
	if not exist "%userprofile%\Desktop\Cherry *.exe" copy "..\_media\TeamViewerQS.exe" "%userprofile%\Desktop\Cherry Help.exe"
) else (
    for %%F in ("%userprofile%\Desktop\Cherry *.exe") do (
        if %%~zF LSS 1024 (
	    cls
	    echo RETRY...
	    if "%OSLanguage%"=="de-DE" copy "..\_media\TeamViewerQS.exe" "%userprofile%\Desktop\Cherry Hilfe.exe"
	    if "%OSLanguage%"=="it-IT" copy "..\_media\TeamViewerQS.exe" "%userprofile%\Desktop\Cherry Aiuto.exe"
	    if not exist "%userprofile%\Desktop\Cherry *.exe" copy "..\_media\TeamViewerQS.exe" "%userprofile%\Desktop\Cherry Help.exe"
        )
    )
)

exit