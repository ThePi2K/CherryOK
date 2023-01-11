:: Cherry OK Script
:: by Felix Peer
:: Created and tested for Windows 11 22H2

@echo off
@title Cherry OK

set version=5.5.2b

title Cherry OK - Preparing...

:: CONNECT TO WIFI
netsh wlan add profile filename=_media\WLAN-Cherry-Net.xml >nul

:: CHECK IF ADMIN OK
set isAdminDir=C:\Windows\CherryTestAdmin
mkdir %isAdminDir%
if not exist %isAdminDir% (
	echo NO ADMIN OR NOT RESTARTED YET
	goto FIRSTRUN
	exit
)
rmdir %isAdminDir%

:: TEST FIRST RUN ::
if not exist C:\Users\Public\Documents\CherryOK (
	echo NO CHERRY OK 1
	goto FIRSTRUN
	exit
)

:: CHERRY OK ASCII
powershell.exe .\_media\echoTitle.ps1
echo.
echo    Cherry OK - Version %version%

:: CHECK WINDOWS VERSION ::
WMIC OS Get Name | findstr Microsoft > result.txt
set /p QUERY=<result.txt
del result.txt
for /f "tokens=1 delims=|" %%a in ("%QUERY%") do (
	set winver=%%a
)
if NOT "%winver%"=="%winver:10=%" set winversion=10
if NOT "%winver%"=="%winver:11=%" set winversion=11

:: CHECK WINDOWS ACTIVATION ::
powershell.exe .\_media\checkWindowsActivation.ps1
cls
echo CHECKING WINDOWS ACTIVATION...
::timeout 2 > nul
set /p status=<tmp
del tmp
if "%status%"=="Licensed" (
	echo Windows is activated!
	timeout 2 > nul
	cls
) else (
	echo Windows is not activated!
	echo Error: %status%
	echo.
	echo Press Enter to start the Windows Activation
	pause>nul
	start ms-settings:activation
	exit
)

:: CHECK LANGUAGE ::
FOR /F "tokens=2 delims==" %%a IN ('wmic os get OSLanguage /Value') DO set OSLangCode=%%a
set OSLanguage=undefined
if %OSLangCode% == 1031 set OSLanguage=de-DE
if %OSLangCode% == 1033 set OSLanguage=en-US
if %OSLangCode% == 1040 set OSLanguage=it-IT
cls

:: CHECKING OPTIONAL UPDATES ::
echo CHECKING OPTIONAL UPDATES
start ms-settings:windowsupdate-optionalupdates
timeout 6 > nul
taskkill /f /im SystemSettings.exe
cls

:: CHECKING UNKNOWN DRIVERS ::
echo CHECKING UNKNOWN DRIVERS...
wmic path win32_pnpentity where ConfigManagerErrorcode!=0 get * /format:list >tmp 2>&1
timeout 1 > nul
find /c "Status" tmp >nul
IF %ERRORLEVEL% EQU 0 (
	del tmp
	ECHO ERROR IN DEVICE MANAGER
	timeout 2 > nul
	devmgmt.msc
	exit
)
del tmp
ECHO DEVICE MANAGER OK
timeout 2 > nul
cls

:::::::::::::::::::::::::::::::::::::::  TEMPORÄR NO DO  ::::::::::::::::::::::::::::::::::::::::::::::
:: OPEN DEVICE MANAGER ::
echo CHECKING DEVICE MANAGER
timeout 1 > nul
devmgmt.msc
cls
:::::::::::::::::::::::::::::::::::::::  TEMPORÄR NO DO  ::::::::::::::::::::::::::::::::::::::::::::::

:: CHECK WINGET ::
echo CHECKING FOR WINGET...
WHERE winget >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
echo CHECKING FOR WINGET...
timeout 1 > nul
ECHO Winget is not installed! Install all Updates from the Microsoft Store to start the Script!
pause >nul
start ms-windows-store:
exit
)

:: CHECKED? ::
set /p drivers="Everything ok? [y|n] "
if not "%drivers%" == "y" (
	timeout 1 > nul
	exit
)
:: powershell -window minimized -command ""
cls


:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::                                         CHERRY OK START                                         ::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


:: REMOVING UPDATE CMD FILE ON DESKTOP AND IN STARTUP
del "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\start_Updates_And_Store.cmd"
cls

:: EMPTY RECYCLE BIN ::
rd /s /q C:\$Recycle.Bin

:: DELETE MICROSOFT EDGE ::
echo DELETE MICROSOFT EDGE FROM DESKTOP
start _media\delEdge.bat
timeout 1 > nul
cls

title Cherry OK - Installing Programs

:: INSTALL MICROSOFT 365 APPS ::
if not exist "C:\Program Files\Microsoft Office\root\Office16\WINWORD.EXE" (
	echo INSTALL MICROSOFT 365 APPS
	start _media\installing_m365.bat
	REG ADD HKEY_CURRENT_USER\SOFTWARE\Policies\Microsoft\Office\16.0\Teams /v PreventFirstLaunchAfterInstall /t REG_DWORD /d 1 /f
)	else (
	echo Microsoft 365 is installed!
)
timeout 1 > nul
cls

:: INSTALL CHERRY HILFE ::
if exist "%userprofile%\Desktop\Cherry *.exe" (
	echo Cherry Hilfe exists
) else (
	echo SETTING UP CHERRY HELP...
	timeout 1 > nul
	if "%OSLanguage%"=="de-DE" copy "_media\TeamViewerQS.exe" "%userprofile%\Desktop\Cherry Hilfe.exe"
	if "%OSLanguage%"=="it-IT" copy "_media\TeamViewerQS.exe" "%userprofile%\Desktop\Cherry Aiuto.exe"
	if not exist "%userprofile%\Desktop\Cherry *.exe" copy "_media\TeamViewerQS.exe" "%userprofile%\Desktop\Cherry Help.exe"
)
timeout 1 > nul
cls

:: INSTALL GOOGLE CHROME ::
if not exist "C:\Program Files\Google\Chrome\Application\chrome.exe" (
	echo INSTALL GOOGLE CHROME
	winget install --id Google.Chrome --accept-source-agreements --force --scope machine
)	else (
	echo Google Chrome is installed!
)
if not exist "C:\Program Files\Google\Chrome\Application\chrome.exe" ..\1\ChromeSetup.exe
timeout 1 > nul
cls

:: INSTALL ACROBAT DC ::
if not exist "C:\Program Files\Adobe\Acrobat DC\Acrobat\Acrobat.exe" (
	echo INSTALL ACROBAT DC
	winget install --id Adobe.Acrobat.Reader.64-bit --accept-source-agreements --force --scope machine
)	else (
	echo Adobe Reader is installed!
)
timeout 1 > nul
cls

title Cherry OK - Settings are being configured...

:: DISABLE BITLOCKER ENCRYPTION ::
echo DISABLE BITLOCKER ENCRYPTION
manage-bde -status C:

manage-bde -off C:
timeout 1 > nul
cls

:: SET DEFAULT APPS ::
::echo SET DEFAULT APPS
_media\SetUserFTA .pdf Acrobat.Document.DC
_media\SetUserFTA http ChromeHTML
_media\SetUserFTA https ChromeHTML
_media\SetUserFTA .htm ChromeHTML
_media\SetUserFTA .html ChromeHTML
::timeout 2 > nul
::cls

:: SET ENERGY SETTINGS ::
::echo SET ENERGY SETTINGS
powercfg -change -standby-timeout-ac 0
::timeout 2 > nul
::cls

:: DISABLE PASSWORD EXPIRATION ::
::echo DISABLE PASSWORD EXPIRATION
wmic useraccount where "name='user'" set passwordexpires=False >nul
::timeout 1 > nul
::cls

:: ADD OEM INFORMATIONS ::
::echo ADD OEM INFORMATIONS
REG ADD HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation /v SupportPhone /t REG_SZ /d "0471 813087" /f >nul
REG ADD HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation /v SupportURL /t REG_SZ /d "https://www.cherrycomputer.com" /f >nul
REG ADD HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation /v Manufacturer /t REG_SZ /d "Cherry Computer Gmbh" /f >nul
::timeout 1 > nul
::cls

:: SET DESIGN ::
echo SET DESIGN
if "%winversion%"=="10" _media\Windows10.deskthemepack
if "%winversion%"=="11" _media\Windows11.deskthemepack
taskkill /im SystemSettings.exe /f > nul
timeout 1 > nul
cls

:: HIDE CHAT AND WIDGETS ::
if "%winversion%"=="11" (
	echo HIDE CHAT AND WIDGETS
	REG ADD HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v TaskbarMn /t REG_DWORD /d 0 /f
	REG ADD HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v TaskbarDA /t REG_DWORD /d 0 /f
	timeout 1 > nul
	cls
)

:: HIDE CORTANA, SET TASKBAR AND HIDE WEATHER ::
if "%winversion%"=="10" (
	echo HIDE CORTANA, SET TASKBAR AND HIDE WEATHER
	REG ADD HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v ShowCortanaButton /t REG_DWORD /d 0 /f
	REG ADD HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Search /v SearchboxTaskbarMode /t REG_DWORD /d 1 /f
	REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds" /v EnableFeeds /t REG_DWORD /d 0 /f
	taskkill /f /im explorer.exe
	start explorer.exe
	timeout 1 > nul
	cls
)

:: TURN OFF WINDOWS WELCOME EXPERIENCE ::
echo TURN OFF WINDOWS WELCOME EXPERIENCE
REG ADD HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager /v SubscribedContent-310093Enabled /t REG_DWORD /d 0 /f
REG ADD HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement /v ScoobeSystemSettingEnabled /t REG_DWORD /d 0 /f
timeout 1 > nul
cls

title Cherry OK - Almost here...

:: SET TASKBAR ::
echo SET TASKBAR
if exist "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Google Chrome.lnk" copy "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Google Chrome.lnk" "%AppData%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar"
if exist "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Google Chrome.lnk" copy "C:\Users\User\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Google Chrome.lnk" "%AppData%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar"
copy "%APPDATA%\Microsoft\Windows\Start Menu\Programs\File Explorer.lnk" "%AppData%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\Explorer.lnk"
reg import _media\Taskbar.reg
taskkill /f /im explorer.exe
timeout 1 > nul
start explorer.exe
timeout 2 > nul
cls

:: CLEAR NOTIFICATIONS ::
echo CLEAR NOTIFICATIONS
timeout 2 > nul
if "%winversion%"=="10" (
	_media\nircmd sendkeypress lwin+a
	_media\nircmd cmdwait 2000 sendkeypress leftshift+tab
	_media\nircmd cmdwait 1500 sendkeypress leftshift+tab
	_media\nircmd cmdwait 1500 sendkeypress spc
	_media\nircmd cmdwait 1500 sendkeypress esc
)
if "%winversion%"=="11" (
	_media\nircmd sendkeypress lwin+n
	_media\nircmd cmdwait 2000 sendkeypress tab
	_media\nircmd cmdwait 1500 sendkeypress enter
	_media\nircmd cmdwait 1500 sendkeypress esc
)
timeout 1 > nul
cls

:: REFRESH DESKTOP ::
echo Refreshing Desktop...
timeout 1 > nul
_media\nircmd cmdwait 1000 sendkeypress rwin+D
_media\nircmd cmdwait 1000 sendkeypress F5
timeout 1 > nul
_media\nircmd cmdwait 1000 sendkeypress rwin+3
timeout 1 > nul
cls

title Cherry OK - Last Steps

:: OPENING PROGRAMS FOR ACCEPTING EULA ::
if "%winversion%"=="11" (
	echo ACCEPTING EULA
	timeout 5 > nul
	if exist "C:\Program Files\Adobe\Acrobat DC\Acrobat\Acrobat.exe" start Acrobat.exe
	if exist "%userprofile%\Desktop\Cherry Hilfe.exe" "%userprofile%\Desktop\Cherry Hilfe.exe"
	if exist "%userprofile%\Desktop\Cherry Aiuto.exe" "%userprofile%\Desktop\Cherry Aiuto.exe"
	if exist "%userprofile%\Desktop\Cherry Help.exe" "%userprofile%\Desktop\Cherry Help.exe"
	_media\nircmd cmdwait 1000 sendkeypress rwin+D
	timeout 4 > nul
	if exist "C:\Program Files\Adobe\Acrobat DC\Acrobat\Acrobat.exe" (
		:: ADOBE ::
		_media\nircmd cmdwait 1500 sendkeypress rwin+4
		_media\nircmd cmdwait 1500 sendkeypress tab
		_media\nircmd cmdwait 1500 sendkeypress enter
		_media\nircmd cmdwait 1500 sendkeypress alt+F4
	)
	:: CHERRY HELP ::
	_media\nircmd cmdwait 1500 sendkeypress rwin+4
	_media\nircmd cmdwait 1500 sendkeypress down
	_media\nircmd cmdwait 1500 sendkeypress up
	_media\nircmd cmdwait 4000 sendkeypress up
	_media\nircmd cmdwait 1500 sendkeypress spc
	_media\nircmd cmdwait 1500 sendkeypress shift+tab
	_media\nircmd cmdwait 1500 sendkeypress enter
	_media\nircmd cmdwait 5000 sendkeypress enter
	_media\nircmd cmdwait 1000 sendkeypress rwin+3
	timeout 1 > nul
	cls
)
if "%winversion%"=="10" (
	echo OPENING PROGRAMS FOR EULA
	if exist "C:\Program Files\Adobe\Acrobat DC\Acrobat\Acrobat.exe" start Acrobat.exe
	if exist "%userprofile%\Desktop\Cherry Hilfe.exe" "%userprofile%\Desktop\Cherry Hilfe.exe"
	if exist "%userprofile%\Desktop\Cherry Aiuto.exe" "%userprofile%\Desktop\Cherry Aiuto.exe"
	if exist "%userprofile%\Desktop\Cherry Help.exe" "%userprofile%\Desktop\Cherry Help.exe"
	timeout 1 > nul
	cls
)

:: INSTALL ADOBE READER IF FAILED
if not exist "C:\Program Files\Adobe\Acrobat DC\Acrobat\Acrobat.exe" (
      copy ..\1\readerdc64_de_hi_crd_mdr_install.exe ..\1\reader.exe
      ..\1\reader.exe
)

:: CONFIGURE SYSTEM RESTORE ::
rmdir C:\Users\Public\Documents\CherryOK
echo CONFIGURING SYSTEM RESTORE
powershell.exe .\_media\restore.ps1
timeout 6 > nul
cls

powershell.exe .\_media\echoTitle.ps1
echo.
echo    CHERRY OK SUCCEEDED SUCCESSFULLY
echo    TESTED AND APPROVED
timeout 5 > nul
cls

powershell.exe -Command "Set-ExecutionPolicy Restricted"

shutdown /t 0 /r
exit


:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::                                            FIRST RUN                                            ::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


:FIRSTRUN
timeout 5 > nul
cls

:: EXIT IF NO INTERNET
echo CHECKING INTERNET...
ping -n 1 8.8.8.8 | find "TTL=" >nul
cls
if errorlevel 1 (
	echo NO INTERNET... CONNECT TO INTERNET!
	timeout 5 > nul
	exit
)

:: SET UAC SETTINGS AND STARTING UPDATES ::
echo SET UAC SETTINGS
start _media\admin.bat
timeout 10 > nul
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
	timeout 9 > nul
	_media\nircmd cmdwait 500 sendkeypress tab tab tab
	_media\nircmd cmdwait 500 sendkeypress down down down down
	_media\nircmd cmdwait 500 sendkeypress enter
	::_media\nircmd cmdwait 1500 sendkeypress enter
)

:: WINDOWS UPDATES ::
echo WINDOWS UPDATES
start ms-settings:windowsupdate
timeout 2 > nul
cls

_media\nircmd sendkeypress lwin+i
if NOT "%winver%"=="%winver:11=%" (
	::timeout 9 > nul
	::_media\nircmd cmdwait 500 sendkeypress tab tab tab
	::_media\nircmd cmdwait 1500 sendkeypress enter
)

mkdir C:\Users\Public\Documents\CherryOK

:: CREATE UPDATE SCRIPT
copy Scripts\start_Updates_And_Store.cmd "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"

exit