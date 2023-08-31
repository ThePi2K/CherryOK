@echo off

:: PERSONAL OR BUSINESS ::
:choice

cls
echo Choose an option:
echo 1. Personal
echo 2. Business
echo.

set /p c=Your choice: 

if "%c%"=="1" set "customertype=Personal" & goto end
if "%c%"=="2" set "customertype=Business" & goto end

echo Invalid choice. Please enter 1 or 2.
goto choice

:end
echo You have selected "%customertype%".
timeout 2 > nul

if "%customertype%"=="Business" (

:: INSTALL ATERA ::
start Programme/AteraAgentUnassigned.msi

:: RENAMING COMPUTER ::
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
timeout 2 > nul

:: END RENAMING COMPUTER ::

)

cls
echo weiter geahts
timeout 2 > nul