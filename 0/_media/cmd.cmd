:: DANKE AN BING AI

@echo off
setlocal enabledelayedexpansion

set "inputFile=atera.csv"
set "outputFile=atera_fixed.csv"

REM Create a new file
type nul > %outputFile%

REM Read the file line by line
for /f "delims=" %%a in (%inputFile%) do (
    set "line=%%a"
    
    REM Replace semicolons with commas
    set "line=!line:;=,!"
    
    REM Remove the first and last quote in the last column
    for /f "tokens=1-4 delims=," %%i in ("!line!") do (
        set "part1=%%i"
        set "part2=%%j"
        set "part3=%%k"
        set "part4=%%l"
        
        REM Remove the first quote
        set "part4=!part4:\"=!"
        
        REM Remove the last quote
        set "part4=!part4:~0,-1!"
        
        REM Combine the parts and write to the new file
        echo !part1!,!part2!,!part3!,!part4! >> %outputFile%
    )
)

endlocal
