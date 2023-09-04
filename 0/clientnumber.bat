@echo off
set /p Kundennummer="Geben Sie die Kundennummer ein: "

for /f "tokens=2,3 delims=," %%a in (clienti.csv) do (
    if "%%a" equ "%Kundennummer%" (
        echo Kundennamen: %%b
        pause
    )
)

echo Kundennummer nicht gefunden.
pause