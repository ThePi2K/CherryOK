@echo off
setlocal enabledelayedexpansion

set "csv_file=clients.csv"

echo Bitte gib die Nummer ein:
set /p input_number=

for /f "tokens=1,2 delims=," %%a in (%csv_file%) do (
    set "number=%%a"
    set "name=%%b"
    if !number! equ %input_number% (
        echo Der Name des Kunden mit der Nummer %input_number% ist: !name!
        exit /b
    )
)

echo Kein Kunde mit der Nummer %input_number% gefunden.
