@echo off
set "Zielordner=%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"

REM Löschen der Dateien
del "%Zielordner%\cp2077L.gif"
copy %Zielordner%\settings.old %Zielordner%\settings.json
del "%Zielordner%\settings.old"
