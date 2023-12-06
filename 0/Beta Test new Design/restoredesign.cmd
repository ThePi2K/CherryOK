@echo off
set "Zielordner=%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"

del "%Zielordner%\cp2077L.gif"

REM Zurückkopieren der alten settings.json aus der Sicherung settings.old, falls vorhanden
if exist "%Zielordner%\settings.old" (
    copy "%Zielordner%\settings.old" "%Zielordner%\settings.json"
    echo Die alte settings.json wurde erfolgreich wiederhergestellt.
) else (
    echo Die Sicherung settings.old existiert nicht. Es gibt keine vorherige Version zum Wiederherstellen.
)

echo Prozess abgeschlossen.
pause
