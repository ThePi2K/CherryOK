copy "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Word.lnk" "%AppData%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar" >nul 2>&1
copy "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Excel.lnk" "%AppData%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar" >nul 2>&1
copy "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\PowerPoint.lnk" "%AppData%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar" >nul 2>&1
copy "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Outlook.lnk" "%AppData%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar" >nul 2>&1
if exist "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Google Chrome.lnk" copy "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Google Chrome.lnk" "%AppData%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar" >nul 2>&1
if exist "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Google Chrome.lnk" copy "C:\Users\User\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Google Chrome.lnk" "%AppData%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar" >nul 2>&1
copy "%APPDATA%\Microsoft\Windows\Start Menu\Programs\File Explorer.lnk" "%AppData%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\Explorer.lnk" >nul 2>&1

reg import ..\_media\TaskbarM365.reg
taskkill /f /im explorer.exe
start explorer.exe