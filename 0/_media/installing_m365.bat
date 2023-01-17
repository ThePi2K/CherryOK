@echo off
@title Microsoft 365

powershell -window minimized -command ""
winget install --id Microsoft.Office --accept-source-agreements --force
if not exist "C:\Program Files\Microsoft Office\root\Office16\WINWORD.EXE" (
  if not exist "C:\Program Files (x86)\Microsoft Office\root\Office16\WINWORD.EXE" ..\..\1\OfficeSetup.exe
)
exit