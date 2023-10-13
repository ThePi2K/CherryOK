:: Cherry OK Script
:: by Felix Peer
:: Designed for Windows 11
:: Semi Automated v7

@echo off

set test=echo hoi

set /p customerNumber=Enter customer number (5 digits): 

:: CHECKING CUSTOMER NUMBER ::
cls
for /f "tokens=2,3 delims=," %%a in (_media\clienti.csv) do (
    if "%%a" equ "%customerNumber%" (
        echo Customer: %%b
    )
)

for /f "tokens=2,3,4 delims=," %%a in (_media\atera.csv) do (
    if "%%a" equ "%customerNumber%" (
        echo Kundennr.: %%a
        echo Atera ID: %%b
        echo curl: %%c

        set ateraid=%%b
        set curl=%%c
        set customerFound=1
    )
)
pause
cls
if not "%customerFound%" equ "1" (
    echo No matching customer found.
    set "curl=curl -o setup.msi "https://sitcomputers.servicedesk.atera.com/GetAgent/Msi/?customerId=51&integratorLogin=felix.peer%40xivtech.de&accountId=0013z00002XjLmlAAF" && msiexec /i setup.msi /qn  IntegratorLogin=felix.peer@xivtech.de CompanyId=51 AccountId=0013z00002XjLmlAAF"
) else (
    echo Atera ID: %ateraid%
    echo curl: %curl%
)

pause
cls

call %test%

pause
cls