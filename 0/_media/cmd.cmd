:: DANKE AN BING AI

@echo off
setlocal enabledelayedexpansion

set "inputFile=atera.csv"
set "outputFile=atera_fixed.csv"

REM Remove old file if existing
del %outputFile% /f > nul

REM Create a new file
type nul > %outputFile%

REM Initialize a line counter
set /a "counter=0"

REM Read the file line by line
for /f "delims=" %%a in (%inputFile%) do (
    set "line=%%a"

    REM Increase the counter
    set /a "counter+=1"
    
    REM Replace semicolons with commas
    set "line=!line:;=,!"

    REM If it's the first line, just write it to the new file
    if !counter! equ 1 (
        echo !line! >> %outputFile%
        goto nextline
    )

    REM Remove the first and last quote in the last column
    for /f "tokens=1-4 delims=," %%i in ("!line!") do (
        set "part1=%%i"
        set "part2=%%j"
        set "part3=%%k"
        set "part4=%%l"
        
        REM Remove the first quote
        set "part4=!part4:~1!"
        
        REM Remove the last quote
        set "part4=!part4:~0,-1!"
        
        REM Combine the parts and write to the new file
        echo !part1!,!part2!,!part3!,!part4! >> %outputFile%
    )

    :nextline
)

endlocal
