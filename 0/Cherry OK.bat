:: Cherry OK Script
:: by Felix Peer
:: Designed for Windows 11 23H2
:: Semi Automated v7

@echo off
set version=7.5b
title Cherry OK
chcp 65001 > nul
setlocal enabledelayedexpansion


:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::                                CHECKING UPDATES, ACTIVATION USW.                                ::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


color 09

:: CHECK IF ADMIN OK ::
set isAdminDir=C:\Windows\CherryTestAdmin
mkdir %isAdminDir% >nul 2>&1
if not exist %isAdminDir% (
	goto ADMIN
	exit
)
rmdir %isAdminDir% >nul 2>&1

: ADMIN

del "%USERPROFILE%\Desktop\Abort Shutdown.cmd" >nul 2>&1

:: CONNECT TO WIFI
netsh wlan add profile filename=_media\WLAN-Cherry-Net.xml >nul 2>&1s

:: RESTARTING EXPLORER FOR BETTER EXPERIENCE ::
timeout 2 > nul
taskkill /f /im explorer.exe >nul 2>&1
timeout 1 > nul
start explorer.exe >nul 2>&1
timeout 2 > nul
cls

:: GO TO CMD WINDOW ::
_media\nircmd cmdwait 1500 sendkeypress alt+tab

:: INTERNET CHECK ::
: INTERNET_CHECK
cls
echo Checking Internet...
timeout 1 > nul
ping -n 1 8.8.8.8 | find "TTL=" >nul 2>&1
if errorlevel 1 (
	echo No Connection possible!
	timeout 1 > nul
	goto INTERNET_CHECK
)
echo Connection ok!
cls

:: CHECK WINDOWS VERSION ::
WMIC OS Get Name | findstr Microsoft > result.txt
set /p QUERY=<result.txt
del result.txt
for /f "tokens=1 delims=|" %%a in ("%QUERY%") do (
	set winver=%%a
)
if NOT "%winver%"=="%winver:10=%" set winversion=10
if NOT "%winver%"=="%winver:11=%" set winversion=11

:: CHECK IF ADMIN OK ::
set isAdminDir=C:\Windows\CherryTestAdmin
mkdir %isAdminDir% >nul 2>&1
if not exist %isAdminDir% (
	goto FIRSTRUN
	exit
)
rmdir %isAdminDir% >nul 2>&1

:: SET EXECUTION POLICY ::
powershell.exe -Command "Set-ExecutionPolicy Unrestricted"

:: CHECK FIRST RUN ::
if not exist "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\start_Updates_And_Store.cmd" (
	goto FIRSTRUN
	exit
)

:: SKIP UPDATES ::
if exist C:\Windows\Cherry\SkipUpdates.txt (
	echo SKIPPING UPDATES
	goto skipwinupd
)

:: CHECKING UPDATES ::
echo CHECKING UPDATES
powershell -command "Get-WindowsUpdate" > tmp
find /c "ComputerName" tmp >nul
IF %ERRORLEVEL% EQU 0 (
	del tmp
	ECHO ATTENTION: UPDATES AVAILABLE!
	timeout 2 > nul
	cls
	"%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\start_Updates_And_Store.cmd"
	exit
)
del tmp
ECHO UPDATES OK
:skipwinupd
timeout 2 > nul
cls

:: CHECKING UNKNOWN DRIVERS ::
: DRIVER_CHECK
cls
echo CHECKING UNKNOWN DRIVERS...
wmic path win32_pnpentity where ConfigManagerErrorcode!=0 get * /format:list >tmp 2>&1
timeout 1 > nul
find /c "Status" tmp >nul
IF %ERRORLEVEL% EQU 0 (
	del tmp
	ECHO ERROR IN DEVICE MANAGER
	timeout 2 > nul
	devmgmt.msc
	cls
	goto DRIVER_CHECK
)
del tmp
ECHO DEVICE MANAGER OK
timeout 2 > nul
cls

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::                                         CHERRY OK START                                         ::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


color 0f

_media\setvol.exe unmute
_media\setvol.exe 80

:: CHERRY OK ASCII ::
title 🍒 Cherry OK
powershell.exe .\_media\echoTitle.ps1
echo.
echo    Cherry OK - Version %version%
echo    Designed for Windows 11 23H2
if "%winversion%" == "10" echo    Legacy Mode for Windows 10 enabled
timeout 5 > nul

:: CHECK WINDOWS ACTIVATION ::
powershell.exe .\_media\checkWindowsActivation.ps1
cls
echo CHECKING WINDOWS ACTIVATION...
set /p status=<tmp
del tmp
if "%status%"=="Licensed" (
	echo Windows is activated!
	timeout 1 > nul
	cls
) else (
	echo Windows is not activated!
	echo %status%
	echo.
	echo Press Enter to start the Windows Activation
	pause>nul
	start ms-settings:activation
	copy _media\restartCherryOK.cmd "%userprofile%\Desktop\"
	exit
)

:: CHECK LANGUAGE ::
FOR /F "tokens=2 delims==" %%a IN ('wmic os get OSLanguage /Value') DO set OSLangCode=%%a
set OSLanguage=undefined
if %OSLangCode% == 1031 set OSLanguage=de-DE
if %OSLangCode% == 1033 set OSLanguage=en-US
if %OSLangCode% == 1040 set OSLanguage=it-IT
cls

:: CHECK WINGET ::
WHERE winget >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
	echo CHECKING FOR WINGET...
	timeout 1 > nul
	echo Winget is not installed! Starting Store Updates...
	powershell -command "Get-CimInstance -Namespace "Root\cimv2\mdm\dmmap" -ClassName "MDM_EnterpriseModernAppManagement_AppManagement01" | Invoke-CimMethod -MethodName 	UpdateScanMethod | Out-Null"
	cls

	echo Restarting...
	timeout 2 > nul
	shutdown /r /t 0
	exit
)

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::                                   PERSONAL OR BUSINESS CHOICE                                   ::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

color CF
powershell -c echo `a

:: PERSONAL OR BUSINESS ::
:choice
cls
echo Choose an option:
echo 1. Personal or no specific customer
echo 2. Business
echo.

set /p c=Your choice: 

if "%c%"=="1" (
    set "customertype=Personal"
) else if "%c%"=="2" (
    set "customertype=Business"
) else (
    echo Invalid choice. Please enter 1 or 2.
    goto choice
)

:end
color 0f
echo You have selected "%customertype%".
timeout 2 > nul

if "%customertype%"=="Personal" goto skip
cls

color CF
powershell -c echo `a
echo Loading Customer file...
for %%A in (_media\clienti.csv) do set "lastdate=%%~tA"
echo The file was last modified on %lastdate%
echo.
:restartcustomer
set /p customerNumber=Enter the customer number (5 digits): 

:: CHECKING CUSTOMER NUMBER ::
cls
for /f "tokens=2,3 delims=," %%a in (_media\clienti.csv) do (
    if "%%a" equ "%customerNumber%" (
        set customerName=%%b
    )
)
echo Customer: %customerName%

choice /C YN /N /M "Is this correct? [Y or N]"
if errorlevel 2 (
    timeout 1 > nul
    cls
    goto restartcustomer
)
timeout 2 > nul
cls

:: CHECKING CUSTOMER IN ATERA ::
set customerFound=0
for /f "tokens=2,3,4 delims=," %%a in (_media\atera_modified.csv) do (
    if "%%a" equ "%customerNumber%" (
        set "curl=%%c"
        set customerFound=1
    )
)

:: INSTALLING ATERA ::
if not exist "C:\Program Files\ATERA Networks\AteraAgent\AteraAgent.exe" (
    if not "%customerFound%" equ "1" (
        echo No Monitoring for %customerName%
        timeout /t 2 > nul
    ) else (
        echo Installing Atera Agent for %customerName%...
        timeout /t 1 > nul
        cmd /c "!curl!" && del setup.msi
        )
	)
) else echo Atera is already installed!
timeout 2 > nul
cls

color CF
powershell -c echo `a

:: RENAMING COMPUTER ::
echo Current name: %computername%

choice /C YN /N /M "Do you want to rename the computer? [Y or N]"
if errorlevel 2 (
    echo Rename operation canceled.
    timeout 1 > nul
    goto skip
)
timeout 2 > nul
cls

:restart
set /p deviceType=Enter device type: 
set /p deviceNumber=Enter device number (2 digits): 

for /f "usebackq delims=" %%I in (`powershell "\"%deviceType%\".toUpper()"`) do set "deviceType_upper=%%~I"

set newname=%customerNumber%-%deviceType_upper%-%deviceNumber%

choice /C YN /N /M "Is this correct? %computername% -> %newname% [Y or N]"
if errorlevel 2 (
    timeout 1 > nul
    cls
    goto restart
)
timeout 2 > nul
cls

wmic computersystem where name="%computername%" call rename "%newname%"
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Splashtop Inc.\Splashtop Remote Server" /v CloudComputerName /t REG_SZ /d "%newname%" /f >nul
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\ATERA Networks\AlphaAgent" /v ServerName /t REG_SZ /d "%newname%" /f >nul
cls
echo The %deviceType_upper% will be renamed to %newname% on the next reboot
timeout 2 > nul

:: END RENAMING COMPUTER ::

:skip
color 0f
echo Continuing...
timeout 2 > nul
cls

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::                                            CONTINUING                                           ::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:: SYNC TIME ::
echo TIME SYNCING STARTING...
net stop w32time >nul 2>&1
w32tm /unregister >nul 2>&1
w32tm /register >nul 2>&1
net start w32time >nul 2>&1
w32tm /resync >nul 2>&1
timeout 1 > nul
cls

:: EMPTY RECYCLE BIN ::
rd /s /q C:\$Recycle.Bin >nul 2>&1

:: INSTALL MICROSOFT 365 APPS ::
if not exist "C:\Program Files\Microsoft Office\root\Office16\WINWORD.EXE" (
	echo INSTALL MICROSOFT 365 APPS
	start _media\installing_m365.bat
)	else (
	echo Microsoft 365 is installed!
)
timeout 1 > nul
cls

:: GO TO CMD WINDOW ::
_media\nircmd cmdwait 1500 sendkeypress alt+tab

:: INSTALL CHERRY HILFE ::
del /f "%userprofile%\Desktop\Cherry Hilfe.exe" >nul 2>&1
del /f "%userprofile%\Desktop\Cherry Aiuto.exe" >nul 2>&1
del /f "%userprofile%\Desktop\Cherry Help.exe" >nul 2>&1
if "%customerFound%" equ "1" goto skipcherryhelp

echo SETTING UP CHERRY HELP...
timeout 1 > nul
curl https://customdesignservice.teamviewer.com/download/windows/v15/6bgwa4q/TeamViewerQS.exe -o C:\TeamViewerQS.exe
if "%OSLanguage%"=="de-DE" move C:\TeamViewerQS.exe "%userprofile%\Desktop\Cherry Hilfe.exe" >nul 2>&1
if "%OSLanguage%"=="it-IT" move C:\TeamViewerQS.exe "%userprofile%\Desktop\Cherry Aiuto.exe" >nul 2>&1
if not exist "%userprofile%\Desktop\Cherry *.exe" move C:\TeamViewerQS.exe "%userprofile%\Desktop\Cherry Help.exe" >nul 2>&1

if not exist "%userprofile%\Desktop\Cherry *.exe" (
	cls
	echo RETRY...
	if "%OSLanguage%"=="de-DE" copy "_media\TeamViewerQS.exe" "%userprofile%\Desktop\Cherry Hilfe.exe"
	if "%OSLanguage%"=="it-IT" copy "_media\TeamViewerQS.exe" "%userprofile%\Desktop\Cherry Aiuto.exe"
	if not exist "%userprofile%\Desktop\Cherry *.exe" copy "_media\TeamViewerQS.exe" "%userprofile%\Desktop\Cherry Help.exe"
) else (
    for %%F in ("%userprofile%\Desktop\Cherry *.exe") do (
        if %%~zF LSS 1024 (
	    cls
	    echo RETRY...
	    if "%OSLanguage%"=="de-DE" copy "_media\TeamViewerQS.exe" "%userprofile%\Desktop\Cherry Hilfe.exe"
	    if "%OSLanguage%"=="it-IT" copy "_media\TeamViewerQS.exe" "%userprofile%\Desktop\Cherry Aiuto.exe"
	    if not exist "%userprofile%\Desktop\Cherry *.exe" copy "_media\TeamViewerQS.exe" "%userprofile%\Desktop\Cherry Help.exe"
        )
    )
)

timeout 1 > nul
cls

:skipcherryhelp

:: INSTALL NEARBY SHARE ::
echo INSTALLING GOOGLE NEARBY SHARE (new!)
winget install --id Google.NearbyShare --accept-package-agreements --accept-source-agreements --force
timeout 1 > nul
cls

:: INSTALL GOOGLE CHROME ::
if not exist "C:\Program Files\Google\Chrome\Application\chrome.exe" (
	echo INSTALL GOOGLE CHROME
	winget install --id Google.Chrome --accept-source-agreements --force --scope machine
)	else (
	echo Google Chrome is installed!
)
if not exist "C:\Program Files\Google\Chrome\Application\chrome.exe" (
	if "%OSLanguage%"=="de-DE" (
		\Programme\ChromeSetup_DE.exe
	) else if "%OSLanguage%"=="it-IT" (
		\Programme\ChromeSetup_IT.exe
	) else (
		\Programme\ChromeSetup_EN.exe
	)
taskkill /F /IM chrome.exe >nul 2>&1
)
timeout 1 > nul
cls

:: INSTALL ACROBAT DC ::
if not exist "C:\Program Files\Adobe\Acrobat DC\Acrobat\Acrobat.exe" (
	echo INSTALL ACROBAT DC
	winget install --id Adobe.Acrobat.Reader.64-bit --accept-package-agreements --accept-source-agreements --force --scope machine
)	else (
	echo Adobe Reader is installed!
)
timeout 1 > nul
cls

:: DISABLE BITLOCKER ENCRYPTION ::
echo DISABLING BITLOCKER ENCRYPTION...
manage-bde -status C: > nul
manage-bde -off C: > nul
cls

:: SET DEFAULT APPS ::
_media\SetUserFTA .pdf Acrobat.Document.DC
_media\SetUserFTA http ChromeHTML
_media\SetUserFTA https ChromeHTML
_media\SetUserFTA .htm ChromeHTML
_media\SetUserFTA .html ChromeHTML
_media\SetUserFTA mailto Outlook.URL.mailto.15
_media\SetUserFTA webcal Outlook.URL.mailto.15
_media\SetUserFTA webcals Outlook.URL.mailto.15

:: SET ENERGY SETTINGS ::
powercfg -change -standby-timeout-ac 0

:: DISABLE PASSWORD EXPIRATION ::
wmic useraccount where "name='%username%'" set passwordexpires=False >nul

:: ADD OEM INFORMATIONS ::
REG ADD HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation /v SupportPhone /t REG_SZ /d "0471 813087" /f >nul
REG ADD HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation /v SupportURL /t REG_SZ /d "https://www.cherrycomputer.com" /f >nul
REG ADD HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation /v Manufacturer /t REG_SZ /d "Cherry Computer Gmbh" /f >nul

:: DISABLING "Automatically save my restartable apps and restart them when I sign back in" ::
if "%winversion%"=="11" REG ADD "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v RestartApps /t REG_DWORD /d 0 /f >nul

:: DISABLING EDGE BAR ::
if "%winversion%"=="10" reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v WebWidgetAllowed /t REG_DWORD /d 0 /f >nul 2>&1

:: SET TASKBAR ::
if "%winversion%"=="10" (
	REG ADD HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v ShowCortanaButton /t REG_DWORD /d 0 /f >nul
	REG ADD HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Search /v SearchboxTaskbarMode /t REG_DWORD /d 1 /f >nul
	REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds" /v EnableFeeds /t REG_DWORD /d 0 /f >nul
)
if "%winversion%"=="11" (
	REG ADD "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarDA /t REG_DWORD /d 0 /f >nul
	reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Search" /v "SearchboxTaskbarMode" /t REG_DWORD /d 1 /f >nul
)

:: TURN OFF WINDOWS WELCOME EXPERIENCE ::
REG ADD "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-310093Enabled /t REG_DWORD /d 0 /f >nul
REG ADD "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement" /v ScoobeSystemSettingEnabled /t REG_DWORD /d 0 /f >nul

:: SET DESIGN ::
echo SET DESIGN
copy "_media\Win%winversion%Desktop.jpg" "C:\Windows\"
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v Wallpaper /t REG_SZ /d "C:\Windows\Win%winversion%Desktop.jpg" /f
REG ADD HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize /v SystemUsesLightTheme /t REG_DWORD /d 0 /f >nul
if "%winversion%"=="10" REG ADD HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize /v AppsUseLightTheme /t REG_DWORD /d 1 /f >nul
if "%winversion%"=="11" REG ADD HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize /v AppsUseLightTheme /t REG_DWORD /d 0 /f >nul
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
timeout 5 > nul
cls

:: CLEAR NOTIFICATIONS ::
echo CLEAR NOTIFICATIONS
:: BurntToast Module was installed in admin.cmd
powershell -command "New-BurntToastNotification -AppLogo _media\cherry.jpg -Text 'CHERRY OK', 'in progress...'"
timeout 8 > nul
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
cls

:: INSTALL ADOBE READER IF FAILED ::
if not exist "C:\Program Files\Adobe\Acrobat DC\Acrobat\Acrobat.exe" (
	if "%OSLanguage%"=="de-DE" copy \Programme\Reader_Install_Setup_DE.exe reader.exe
	if "%OSLanguage%"=="it-IT" copy \Programme\Reader_Install_Setup_IT.exe reader.exe
	reader.exe
)

:: STARTING STORE UPDATES ::
echo STARTING STORE UPDATES...
powershell -command "Get-CimInstance -Namespace "Root\cimv2\mdm\dmmap" -ClassName "MDM_EnterpriseModernAppManagement_AppManagement01" | Invoke-CimMethod -MethodName UpdateScanMethod | Out-Null"
cls

:: UPGRADING ALL PROGRAMS ::
echo UPGRADING ALL PROGRAMS
winget upgrade --all --accept-source-agreements --force
timeout 2 > nul
cls

:: DISABLING TEAMS AUTOSTART
REG ADD HKEY_CURRENT_USER\SOFTWARE\Policies\Microsoft\Office\16.0\Teams /v PreventFirstLaunchAfterInstall /t REG_DWORD /d 1 /f >nul

:: REMOVE EDGE LINKS AND BLOCK EDGE FROM CREATING SHORTCUTS ::
echo BLOCK EDGE FROM CREATING SHORTCUTS
REG ADD HKLM\SOFTWARE\Policies\Microsoft\EdgeUpdate /v CreateDesktopShortcutDefault /t REG_DWORD /d 0 /f >nul
del /f "%PUBLIC%\Desktop\Microsoft Edge.lnk" >nul 2>&1
del /f "%USERPROFILE%\Desktop\Microsoft Edge.lnk" >nul 2>&1
timeout 1 > nul
cls

:: REMOVING EDGE AND CHROME DATA ::
:: just moving the folders to User Data.old, to restore: move it back
:: echo REMOVING EDGE AND CHROME DATA
:: timeout 1 > nul
:: rd /s /q "%LOCALAPPDATA%\Microsoft\Edge\User Data" >nul 2>&1
:: rd /s /q "%LOCALAPPDATA%\Google\Chrome\User Data" >nul 2>&1
:: robocopy "%LOCALAPPDATA%\Microsoft\Edge\User Data" "%LOCALAPPDATA%\Microsoft\Edge\User Data.old" /MOVE
:: robocopy "%LOCALAPPDATA%\Google\Chrome\User Data" "%LOCALAPPDATA%\Google\Chrome\User Data.old" /MOVE
:: timeout 1 > nul
:: cls

:: CHECKING IF M365 SETUP IS RUNNING ::
:CheckOffice
tasklist /fi "ImageName eq setup.exe" /fo csv 2>NUL | find /I "setup.exe">NUL
if "%ERRORLEVEL%"=="0" (
	echo Microsoft 365 Setup is running...
	timeout 5 > nul
	cls
	goto CheckOffice
)
cls

:: SETTING MICROSOFT 365 SHORTCUTS ::
if "%customertype%"=="Business" (
	copy "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Word.lnk" "%AppData%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar" >nul 2>&1
	copy "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Excel.lnk" "%AppData%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar" >nul 2>&1
	copy "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\PowerPoint.lnk" "%AppData%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar" >nul 2>&1
	copy "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Outlook.lnk" "%AppData%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar" >nul 2>&1
)

:: SET TASKBAR AND RESTARTING EXPLORER ::
echo SET TASKBAR
if exist "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Google Chrome.lnk" copy "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Google Chrome.lnk" "%AppData%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar" >nul 2>&1
if exist "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Google Chrome.lnk" copy "C:\Users\User\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Google Chrome.lnk" "%AppData%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar" >nul 2>&1
copy "%APPDATA%\Microsoft\Windows\Start Menu\Programs\File Explorer.lnk" "%AppData%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\Explorer.lnk" >nul 2>&1
if "%customertype%"=="Personal" reg import _media\Taskbar.reg >nul 2>&1
if "%customertype%"=="Business" reg import _media\TaskbarM365.reg >nul 2>&1
timeout 2 > nul
taskkill /f /im explorer.exe >nul 2>&1
timeout 1 > nul
start explorer.exe >nul 2>&1
timeout 5 > nul
cls

:: REMOVING CMD AND COUNTER FILE ::
del "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\start_Updates_And_Store.cmd" >nul 2>&1
del "%userprofile%\Desktop\restartCherryOK.cmd" >nul 2>&1
del "%userprofile%\Desktop\skipWinUpdates.cmd" >nul 2>&1
del "%USERPROFILE%\Desktop\Stop Cherry OK.cmd" >nul 2>&1
del "C:\Windows\Cherry\counter.txt" >nul 2>&1
del "C:\Windows\Cherry\SkipUpdates.txt" >nul 2>&1

:: CONFIGURE SYSTEM RESTORE ::
echo CONFIGURING SYSTEM RESTORE
powershell.exe .\_media\restore.ps1
find /c "Cherry OK" tmp >nul
IF %ERRORLEVEL% EQU 1 (
	del tmp
	ECHO NO RESTORE POINT FOUND!!!
	timeout 2 > nul
	sysdm.cpl
	powershell.exe -Command "Set-ExecutionPolicy Restricted"
	exit
)
echo RESTORE POINT OK
timeout 2 > nul
del tmp
cls

:: GO TO CMD WINDOW ::
_media\nircmd cmdwait 1500 sendkeypress alt+tab

color CF
powershell -c echo `a

:: CHERRY OK SIEGEL? ::
cls
echo Did you put the Cherry Quality seal on it?? [Y or N]
set /p seal=Your choice: 
color 0F
if /I "%seal%"=="N" powershell.exe .\_media\echoMiddlefingerASCII.ps1
timeout 3 > nul
cls

copy _media\CherryOK.png C:\Windows\Cherry >nul 2>&1
powershell.exe .\_media\echoTitle.ps1
echo.
echo    CHERRY OK SUCCEEDED SUCCESSFULLY
echo    TESTED AND APPROVED
powershell -command "New-BurntToastNotification -AppLogo C:\Windows\Cherry\CherryOK.png -Text 'CHERRY OK', 'Tested & Approved!'"
timeout 5 > nul
cls

:: REFRESH DESKTOP ::
_media\nircmd cmdwait 1500 sendkeypress rwin+D
_media\nircmd cmdwait 1500 sendkeypress F5

:: DELETE POWERSHELL FOLDER IF EXISTS ::
rd /s /q "%USERPROFILE%\Documents\WindowsPowerShell" >nul 2>&1
powershell.exe -Command "Set-ExecutionPolicy Restricted"

shutdown -r -t 10

exit


:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::                                            FIRST RUN                                            ::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


:FIRSTRUN

color CF
powershell -c echo `a

:: ASK FOR START ::
echo WELCOME TO CHERRY OK :)
echo.
choice /C YN /N /M "Shall we begin? [Y or N]"
if errorlevel 2 (
    echo See you later alligator
    exit /B
)
echo Touch the system!
timeout 2 > nul
cls

color 09

cd ..\0\

:: SET UAC SETTINGS AND STARTING UPDATES ::
echo SET UAC SETTINGS AND STARTING UPDATES
start _media\admin.bat

:: CREATE UPDATE SCRIPT FOR CHERRY OK ::
copy _media\start_Updates_And_Store.cmd "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup" >nul 2>&1
copy _media\restartCherryOK.cmd "%userprofile%\Desktop\" >nul 2>&1
copy _media\skipWinUpdates.cmd "%userprofile%\Desktop\" >nul 2>&1

:: MAKE CMD FILE "STOP CHERRY OK" ::
echo shutdown -a > "%USERPROFILE%\Desktop\Stop Cherry OK.cmd"
echo del "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\start_Updates_And_Store.cmd" >> "%USERPROFILE%\Desktop\Stop Cherry OK.cmd"
echo del "%userprofile%\Desktop\restartCherryOK.cmd" >> "%USERPROFILE%\Desktop\Stop Cherry OK.cmd"
echo del "%userprofile%\Desktop\skipWinUpdates.cmd" >> "%USERPROFILE%\Desktop\Stop Cherry OK.cmd"
echo del "%USERPROFILE%\Desktop\Abort Shutdown.cmd" >> "%USERPROFILE%\Desktop\Stop Cherry OK.cmd" 
echo del "%USERPROFILE%\Desktop\Stop Cherry OK.cmd" >> "%USERPROFILE%\Desktop\Stop Cherry OK.cmd"
echo del "C:\Windows\Cherry\counter.txt" >> "%USERPROFILE%\Desktop\Stop Cherry OK.cmd"
echo del "C:\Windows\Cherry\SkipUpdates.txt" >> "%USERPROFILE%\Desktop\Stop Cherry OK.cmd"
cls

exit