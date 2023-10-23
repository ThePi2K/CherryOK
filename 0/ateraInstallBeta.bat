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
for /f "tokens=2,3,4 delims=," %%a in (_media\atera.csv) do (
    if "%%a" equ "%customerNumber%" (
        echo Kundennr.: %%a
        echo Atera ID: %%b
        echo curl: %%c

        set curl=%%c
        set customerFound=1
    )
)

echo HIER IST FERTIG...
pause > nul
exit


:: INSTALLING ATERA ::
if not exist "C:\Program Files\ATERA Networks\AteraAgent\AteraAgent.exe" (
    if not "%customerFound%" equ "1" (
        start Programme/AteraAgent.msi
    ) else (
        echo !curl!   REM Hier verwenden wir "!" anstelle von "%", um die doppelten Anführungszeichen zu bewahren
        pause
	)
)