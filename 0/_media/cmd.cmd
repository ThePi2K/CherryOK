:: DANKE AN CHAT GPT

@echo off
setlocal enabledelayedexpansion

set "inputFile=atera.csv"
set "outputFile=atera_modified.csv"

if not exist %inputFile% (
    echo Die Datei %inputFile% existiert nicht.
    exit /b 1
)

del %outputFile%

for /f "usebackq tokens=1-4 delims=;" %%a in ("%inputFile%") do (
    set "col1=%%a"
    set "col2=%%b"
    set "col3=%%c"
    set "col4=%%d"

    if not defined header (
        echo !col1!,!col2!,!col3!,!col4! > %outputFile%
        set "header=true"
    ) else (
        set "col4=!col4:~1,-1!"
        echo !col1!,!col2!,!col3!,!col4! >> %outputFile%
    )
)

echo Die Datei %outputFile% wurde erfolgreich erstellt.
timeout /t 3