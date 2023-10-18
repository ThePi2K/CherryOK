:: COPIED AND MODIFIED FROM CHERRY OK SCRIPT 7.2

@echo off

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
if "%OSLanguage%"=="de-DE" powershell -command "curl https://customdesignservice.teamviewer.com/download/windows/v15/6bgwa4q/TeamViewerQS.exe -OutFile '%userprofile%\Desktop\Cherry Hilfe.exe'"
if "%OSLanguage%"=="it-IT" powershell -command "curl https://customdesignservice.teamviewer.com/download/windows/v15/6bgwa4q/TeamViewerQS.exe -OutFile '%userprofile%\Desktop\Cherry Aiuto.exe'"
if not exist "%userprofile%\Desktop\Cherry *.exe" powershell -command "curl https://customdesignservice.teamviewer.com/download/windows/v15/6bgwa4q/TeamViewerQS.exe -OutFile '%userprofile%\Desktop\Cherry Help.exe'"

if not exist "%userprofile%\Desktop\Cherry *.exe" (
	cls
	echo RETRY...
	if "%OSLanguage%"=="de-DE" copy "_media\TeamViewerQS.exe" "%userprofile%\Desktop\Cherry Hilfe.exe"
	if "%OSLanguage%"=="it-IT" copy "_media\TeamViewerQS.exe" "%userprofile%\Desktop\Cherry Aiuto.exe"
	if not exist "%userprofile%\Desktop\Cherry *.exe" copy "_media\TeamViewerQS.exe" "%userprofile%\Desktop\Cherry Help.exe"
)