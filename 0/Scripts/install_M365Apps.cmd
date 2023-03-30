if not exist "C:\Program Files\Microsoft Office\root\Office16\WINWORD.EXE" winget install --id Microsoft.Office --accept-source-agreements --force
REG ADD HKEY_CURRENT_USER\SOFTWARE\Policies\Microsoft\Office\16.0\Teams /v PreventFirstLaunchAfterInstall /t REG_DWORD /d 1 /f

set /p links="Taskleiste anpassen? Chrome, Explorer und Office? [y|n] "
if "%links%" == "y" CherryTool_SetM365Links.cmd