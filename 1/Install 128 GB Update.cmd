@echo off
echo Installing Update...
for %%f in (windows11.0*.msu) do (
    wusa.exe "%~dp0/%%f" /norestart
)
echo Finished!
pause