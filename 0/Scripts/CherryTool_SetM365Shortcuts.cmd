copy "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Word.lnk" "%AppData%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar"
copy "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Excel.lnk" "%AppData%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar"
copy "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\PowerPoint.lnk" "%AppData%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar"
copy "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Outlook.lnk" "%AppData%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar"
copy "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Google Chrome.lnk" "%AppData%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar"
copy "%APPDATA%\Microsoft\Windows\Start Menu\Programs\File Explorer.lnk" "%AppData%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\Explorer.lnk"

copy "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Word.lnk" "%USERPROFILE%\..\Public\Desktop\"
copy "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Excel.lnk" "%USERPROFILE%\..\Public\Desktop\"
copy "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\PowerPoint.lnk" "%USERPROFILE%\..\Public\Desktop\"
copy "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Outlook.lnk" "%USERPROFILE%\..\Public\Desktop\"

reg import ..\_media\TaskbarM365.reg
taskkill /f /im explorer.exe
start explorer.exe