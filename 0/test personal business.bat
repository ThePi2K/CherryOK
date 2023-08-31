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