@echo off
cls
echo Choose an option:
echo 1. Personal
echo 2. Business
echo.

:choice
set /p c=Your choice: 

if "%c%"=="1" set "customertype=Personal" & goto end
if "%c%"=="2" set "customertype=Business" & goto end

echo Invalid choice. Please enter 1 or 2.
goto choice

:end
echo You have selected "%customertype%".
rem Add your code based on the selected option here.




pause




choice /C YN /N /M "Personal? ("N" for Business) [Y or N]"
if errorlevel 2 (
pause

:: INSTALLING ATERA ::
    start Programme/AteraAgentUnassigned.msi
    cls


:: RENAMING PC
choice /C YN /N /M "Do you want to rename the computer? [Y or N]"
if errorlevel 2 (
    echo Rename operation canceled.
    timeout 1 > nul
    goto skip
)
timeout 2 > nul
cls

:restart
set /p customerNumber=Enter customer number (5 digits): 
set /p deviceType=Enter device type: 
set /p deviceNumber=Enter device number (2 digits): 

for /f "usebackq delims=" %%I in (`powershell "\"%deviceType%\".toUpper()"`) do set "deviceType_upper=%%~I"

set newname=%customerNumber%-%deviceType_upper%-%deviceNumber%
    
cls
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

)
timeout 2 > nul
cls

:skip