:: Cherry OK Script
:: by Felix Peer
:: Designed for Windows 11
:: Semi Automated v7

@echo off
set customerNumber=01806

for /f "tokens=2,3 delims=," %%a in (_media\clienti.csv) do (
    if "%%a" equ "%customerNumber%" (
        echo Customer: %%b
    )
)
timeout 1 > nul


for /f "tokens=2,3,4 delims=," %%x in (_media\monitoring.csv) do (
            set "monitoringNumber=000%%x"
            set "monitoringNumber=!monitoringNumber:~-5!"
            if "!monitoringNumber!" equ "%customerNumber%" (
                echo Customer: %%b
                set "install=%%y"
                echo Install: !install!
            )
        )