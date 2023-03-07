:: Cherry OK Script
:: by Felix Peer
:: Created and tested for Windows 11 22H2
:: Full Automated

@echo off
@title Cherry OK
@set version=6.3


:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::                                CHECKING UPDATES, ACTIVATION USW.                                ::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


del "%USERPROFILE%\Desktop\Abort Shutdown.cmd" >nul 2>&1

:: CONNECT TO WIFI
netsh wlan add profile filename=_media\WLAN-Cherry-Net.xml >nul

:: EXIT IF NO INTERNET ::
: INTERNET_CHECK
cls
echo CHECKING INTERNET...
timeout 3 > nul
ping -n 1 8.8.8.8 | find "TTL=" >nul
if errorlevel 1 (
	cls
	echo NO INTERNET... CONNECT TO INTERNET!
	pause
	goto INTERNET_CHECK
)
cls
echo INTERNET OK!
timeout 2 > nul
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

:: SET EXECUTION POLICY
powershell.exe -Command "Set-ExecutionPolicy Unrestricted"

:: TEST FIRST RUN ::
if not exist "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\start_Updates_And_Store.cmd" (
	goto FIRSTRUN
	exit
)

:: CHERRY OK ASCII
powershell.exe .\_media\echoTitle.ps1
echo.
echo    Cherry OK - Version %version%

:: CHECK WINDOWS ACTIVATION ::
powershell.exe .\_media\checkWindowsActivation.ps1
cls
echo CHECKING WINDOWS ACTIVATION...
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

:: CHECKING UPDATES ::
echo CHECKING UPDATES
powershell -command "Get-WindowsUpdate" > tmp
find /c "ComputerName" tmp >nul
IF %ERRORLEVEL% EQU 0 (
	del tmp
	ECHO ATTENTION: UPDATES AVAILABLE!
	powershell -command "Get-WindowsUpdate"
	timeout 2 > nul
	cls
	echo Restarting...
	timeout 2 > nul
	shutdown /r /t 0
	exit
)
del tmp
ECHO UPDATES OK
timeout 2 > nul
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

:: CHECK WINGET ::
WHERE winget >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
	echo CHECKING FOR WINGET...
	timeout 1 > nul
	ECHO Winget is not installed! Install all Updates from the Microsoft Store to start the Script!
	timeout 2 > nul
	cls
	echo Restarting...
	timeout 2 > nul
	shutdown /r /t 0
	exit
)


:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::                                         CHERRY OK START                                         ::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:: TURN ON NOTIFICATIONS ::
REG ADD HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\PushNotifications /v ToastEnabled /t REG_DWORD /d 1 /f >nul

:: EMPTY RECYCLE BIN ::
rd /s /q C:\$Recycle.Bin

:: BLOCK EDGE FROM CREATING SHORTCUTS ::
echo BLOCK EDGE FROM CREATING SHORTCUTS
REG ADD HKLM\SOFTWARE\Policies\Microsoft\EdgeUpdate /v CreateDesktopShortcutDefault /t REG_DWORD /d 0 /f >nul
start _media\delEdge.bat
timeout 1 > nul
cls

:: INSTALL MICROSOFT 365 APPS ::
if not exist "C:\Program Files\Microsoft Office\root\Office16\WINWORD.EXE" (
	echo INSTALL MICROSOFT 365 APPS
	start _media\installing_m365.bat
	REG ADD HKEY_CURRENT_USER\SOFTWARE\Policies\Microsoft\Office\16.0\Teams /v PreventFirstLaunchAfterInstall /t REG_DWORD /d 1 /f >nul
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
	if "%OSLanguage%"=="de-DE" powershell -command "curl https://customdesignservice.teamviewer.com/download/windows/v15/6bgwa4q/TeamViewerQS.exe -OutFile '%userprofile%\Desktop\Cherry Hilfe.exe'"
	if "%OSLanguage%"=="it-IT" powershell -command "curl https://customdesignservice.teamviewer.com/download/windows/v15/6bgwa4q/TeamViewerQS.exe -OutFile '%userprofile%\Desktop\Cherry Aiuto.exe'"
	if not exist "%userprofile%\Desktop\Cherry *.exe" powershell -command "curl https://customdesignservice.teamviewer.com/download/windows/v15/6bgwa4q/TeamViewerQS.exe -OutFile '%userprofile%\Desktop\Cherry Help.exe'"
)
timeout 1 > nul
cls

:: INSTALL GOOGLE CHROME ::
if not exist "C:\Program Files\Google\Chrome\Application\chrome.exe" (
	echo INSTALL GOOGLE CHROME
	winget install --id Google.Chrome --accept-source-agreements --force --scope machine

	:: RESTART CHROME FOR ICON IN TASKBAR ::
	start _media\openChrome.bat
	_media\nircmd cmdwait 2500 sendkeypress alt+f4
	taskkill /f /im explorer.exe
	timeout 1 > nul
	start explorer.exe
	timeout 2 > nul
	cls

)	else (
	echo Google Chrome is installed!
)
if not exist "C:\Program Files\Google\Chrome\Application\chrome.exe" ..\1\ChromeSetup.exe
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
echo DISABLE BITLOCKER ENCRYPTION
manage-bde -status C:

manage-bde -off C:
timeout 1 > nul
cls

:: SET DEFAULT APPS ::
_media\SetUserFTA .pdf Acrobat.Document.DC
_media\SetUserFTA http ChromeHTML
_media\SetUserFTA https ChromeHTML
_media\SetUserFTA .htm ChromeHTML
_media\SetUserFTA .html ChromeHTML

:: SET ENERGY SETTINGS ::
powercfg -change -standby-timeout-ac 0

:: DISABLE PASSWORD EXPIRATION ::
wmic useraccount where "name='user'" set passwordexpires=False >nul

:: ADD OEM INFORMATIONS ::
REG ADD HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation /v SupportPhone /t REG_SZ /d "0471 813087" /f >nul
REG ADD HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation /v SupportURL /t REG_SZ /d "https://www.cherrycomputer.com" /f >nul
REG ADD HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation /v Manufacturer /t REG_SZ /d "Cherry Computer Gmbh" /f >nul

:: HIDE CHAT AND WIDGETS ::
if "%winversion%"=="11" (
	REG ADD HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v TaskbarMn /t REG_DWORD /d 0 /f >nul
	REG ADD HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v TaskbarDA /t REG_DWORD /d 0 /f >nul
)

:: HIDE CORTANA, SET TASKBAR AND HIDE WEATHER ::
if "%winversion%"=="10" (
	REG ADD HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v ShowCortanaButton /t REG_DWORD /d 0 /f >nul
	REG ADD HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Search /v SearchboxTaskbarMode /t REG_DWORD /d 1 /f >nul
	REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds" /v EnableFeeds /t REG_DWORD /d 0 /f >nul
)

:: TURN OFF WINDOWS WELCOME EXPERIENCE ::
REG ADD HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager /v SubscribedContent-310093Enabled /t REG_DWORD /d 0 /f >nul
REG ADD HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement /v ScoobeSystemSettingEnabled /t REG_DWORD /d 0 /f >nul

:: SET DESIGN ::
echo SET DESIGN
copy "_media\WinDesktop.jpg" "C:\Windows\WinDesktop.jpg"
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v Wallpaper /t REG_SZ /d "C:\Windows\WinDesktop.jpg" /f
REG ADD HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize /v SystemUsesLightTheme /t REG_DWORD /d 0 /f >nul
REG ADD HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize /v AppsUseLightTheme /t REG_DWORD /d 1 /f >nul
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
timeout 2 > nul
cls

:: SET DESIGN [OLD, NOT IMPLEMETED] ::
::echo SET DESIGN
::if "%winversion%"=="10" _media\Windows10.deskthemepack
::if "%winversion%"=="11" _media\Windows11.deskthemepack
::taskkill /im SystemSettings.exe /f > nul
::timeout 2 > nul
::cls

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
:: Module was installed in admin.cmd
mkdir C:\Windows\Cherry >nul 2>&1
copy _media\CherryOK.png C:\Windows\Cherry >nul 2>&1
powershell -command "New-BurntToastNotification -AppLogo C:\Windows\Cherry\CherryOK.png -Text 'Clearing Notifications', '...'"
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
timeout 1 > nul
cls

:: INSTALL ADOBE READER IF FAILED ::
if not exist "C:\Program Files\Adobe\Acrobat DC\Acrobat\Acrobat.exe" (
      copy ..\1\readerdc64_de_hi_crd_mdr_install.exe ..\1\reader.exe
      ..\1\reader.exe
)

:: REMOVING UPDATE CMD ::
del "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\start_Updates_And_Store.cmd" >nul 2>&1

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

powershell.exe .\_media\echoTitle.ps1
echo.
echo    CHERRY OK SUCCEEDED SUCCESSFULLY
echo    TESTED AND APPROVED
timeout 5 > nul

:: REFRESH DESKTOP ::
_media\nircmd cmdwait 1000 sendkeypress rwin+D
_media\nircmd cmdwait 1000 sendkeypress F5

:: DELETE MICROSOFT EDGE ::
echo DELETE MICROSOFT EDGE FROM DESKTOP
start _media\delEdge.bat
timeout 1 > nul
cls

powershell -command "New-BurntToastNotification -AppLogo C:\Windows\Cherry\CherryOK.png -Text 'CHERRY OK', 'Tested & Approved!'"
powershell.exe -Command "Set-ExecutionPolicy Restricted"

shutdown -r -t 10

exit


:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::                                            FIRST RUN                                            ::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


:FIRSTRUN

cls
echo WELCOME TO CHERRY OK
timeout 2 > nul
cls

:: ASKING FOR START ::
set /p cherry_ok_start="Ready to perform Cherry OK? [y|n] "
if not "%cherry_ok_start%" == "y" (
	timeout 1 > nul
	exit
)
timeout 2 > nul
cls

:: SET UAC SETTINGS AND STARTING UPDATES ::
echo SET UAC SETTINGS AND STARTING UPDATES
start _media\admin.bat

:: CREATE UPDATE SCRIPT AND FOLDER FOR CHERRY OK ::
copy _media\start_Updates_And_Store.cmd "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup" >nul 2>&1
cls

exit