:: DANKE AN u/JcobMajkowsky
:: https://www.reddit.com/r/WindowsTerminal/comments/k037oe/windows_terminal_cyberpunk_2077_theme/

@echo off
set "Zielordner=%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"

REM Kopieren der Dateien
copy "cp2077L.gif" "%Zielordner%"

REM Inhalte der settings.json sichern und zusammenführen
set "Quellsettings=settings.json"
set "Zielsettings=%Zielordner%\settings.json"
set "ZielsettingsOld=%Zielordner%\settings.old"

REM Überprüfen, ob die Quell- und Zieldateien vorhanden sind, bevor sie bearbeitet werden
if exist "%Quellsettings%" (
    if exist "%Zielsettings%" (
        copy "%Zielsettings%" "%ZielsettingsOld%" > nul
        type "%Quellsettings%" >> "%Zielsettings%"
    ) else (
        copy "%Quellsettings%" "%Zielsettings%"
    )
) else (
    echo Die Quelldatei settings.json wurde nicht im aktuellen Ordner gefunden.
)

echo Prozess abgeschlossen.
pause
