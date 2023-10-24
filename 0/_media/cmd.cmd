@echo off
setlocal enabledelayedexpansion

set "inputFile=atera.csv"
set "outputFile=atera_fixed.csv"

(
    for /f "usebackq delims=" %%a in ("%inputFile%") do (
        set "line=%%a"
        set "line=!line:;=,!"
        set "line=!line:""="!"
        echo !line!
    )
) > "%outputFile%"

endlocal
