@echo off
chcp 65001 > nul
setlocal enabledelayedexpansion

cd ..

echo Loading Customer file...
for %%A in (_media\clienti.csv) do set "lastdate=%%~tA"
echo The file was last modified on %lastdate%
echo.
:restartcustomer
set /p customerNumber=Enter the customer number (5 digits): 

:: CHECKING CUSTOMER NUMBER ::
cls
for /f "tokens=2,3 delims=," %%a in (_media\clienti.csv) do (
    if "%%a" equ "%customerNumber%" (
        set customerName=%%b
    )
)
echo Customer: %customerName%

choice /C YN /N /M "Is this correct? [Y or N]"
if errorlevel 2 (
    timeout 1 > nul
    cls
    goto restartcustomer
)
timeout 2 > nul
cls

:: CHECKING CUSTOMER IN ATERA ::
set customerFound=0
for /f "tokens=2,3,4 delims=," %%a in (_media\atera_modified.csv) do (
    if "%%a" equ "%customerNumber%" (
        set "curl=%%c"
        set customerFound=1
    )
)

:: INSTALLING ATERA ::
if not exist "C:\Program Files\ATERA Networks\AteraAgent\AteraAgent.exe" (
    if not "%customerFound%" equ "1" (
        echo Installing unassigned Atera Agent...
        timeout /t 1 > nul
        start Programme/AteraAgent.msi
    ) else (
        echo Installing Atera Agent for %customerName%...
        timeout /t 1 > nul
        cmd /c "!curl!" && del setup.msi
        )
	)
) else echo Atera is already installed!
timeout 2 > nul
cls