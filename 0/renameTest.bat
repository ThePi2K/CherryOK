@echo off
setlocal

echo Current name: %computername%

choice /C YN /N /M "Do you want to rename the computer? [Y or N]"
if errorlevel 2 (
    echo Rename operation canceled.
    timeout 1 > nul
    exit
)
timeout 2 > nul
cls

:restart
set /p customerNumber=Enter customer number (5 digits): 
set /p deviceType=Enter device type: 
set /p deviceNumber=Enter device number (2 digits): 
    
set newname=%customerNumber%-%deviceType%-%deviceNumber%
    

choice /C YN /N /M "Is this correct? %computername% -> %newname% [Y or N]"
if errorlevel 2 (
    timeout 1 > nul
    cls
    goto restart
)
timeout 2 > nul
cls


wmic computersystem where name="%computername%" call rename "%newname%"
cls
echo Computer renamed to %newname%
timeout 2 > nul

endlocal