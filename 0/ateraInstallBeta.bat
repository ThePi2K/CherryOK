:: Cherry OK Script
:: by Felix Peer
:: Designed for Windows 11
:: Semi Automated v7

@echo off

set /p customerNumber=Enter customer number (5 digits): 

:: CHECKING CUSTOMER NUMBER ::
cls
for /f "tokens=2,3 delims=," %%a in (_media\clienti.csv) do (
    if "%%a" equ "%customerNumber%" (
        echo Customer: %%b
    )
)
timeout /t 2

::start _media\atera.csv
::pause

for /f "tokens=2,3,4 delims=," %%a in (_media\atera.csv) do (
    if "%%a" equ "%customerNumber%" (
        echo Kundennr.: %%a
        echo Atera ID: %%b
        echo curl: %%c

        set ateraid=%%b
        set curl=%%c
    )
)

echo Atera ID: %ateraid%
echo curl: %curl%

pause
cls