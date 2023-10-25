@echo off
setlocal enabledelayedexpansion

::set /p customerNumber=Enter customer number (5 digits): 
set customerNumber=00069

:: CHECKING CUSTOMER NUMBER ::
cls
set customerFound=0
for /f "tokens=2,3 delims=," %%a in (_media\clienti.csv) do (
    if "%%a" equ "%customerNumber%" (
        echo Customer: %%b
    )
)



:: CHECKING CUSTOMER IN ATERA ::
for /f "tokens=2,3,4 delims=," %%a in (_media\atera_modified.csv) do (
    if "%%a" equ "%customerNumber%" (
        echo Kundennr.: %%a
        echo Atera ID: %%b
        echo curl: %%c

        set curl=%%c
        set customerFound=1
    )
)

pause

:: INSTALLING ATERA ::
if not exist "C:\Program Files\ATERA Networks\AteraAgent\AteraAgent.exe" (
    echo Atera does not exist [only Beta]
    if not "%customerFound%" equ "1" (
        echo Installing unassigned Atera Agent...
        timeout /t 3 > nul
        echo start Programme/AteraAgent.msi
    ) else (
        echo Installing assigned Atera Agent...
        timeout /t 3 > nul
        echo call !curl!
	)
)

echo HIER IST FERTIG...
pause > nul
exit