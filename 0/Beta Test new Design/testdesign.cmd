:: DANKE AN u/JcobMajkowsky
:: https://www.reddit.com/r/WindowsTerminal/comments/k037oe/windows_terminal_cyberpunk_2077_theme/

@echo off
set "Zielordner=%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"

REM Schriftart kopieren
copy "PxPlus_IBM_VGA8.ttf" "%WINDIR%\Fonts"
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" /v "PxPlus IBM VGA8 (OpenType)" /t REG_SZ /d PxPlus_IBM_VGA8.ttf /f

REM Kopieren der Dateien
copy "cp2077L.gif" "%Zielordner%"
copy %Zielordner%\settings.json %Zielordner%\settings.old
copy settings.json %Zielordner%
