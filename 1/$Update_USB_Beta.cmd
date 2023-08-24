@echo off
@title Cherry USB Beta

set drive=%CD:~0,3%

echo %drive%
if not exist "C:\Users\FelixPeer\OneDrive - Cherry Computer\Documents\Cherry\Cherry OK Beta\Cherry OK.cmd" exit
if "%drive%"=="C:\" exit

C:

rd /s /q %drive%HP >nul 2>&1
rd /s /q %drive%support >nul 2>&1
rd /s /q %drive%LOST.DIR >nul 2>&1
del %drive%BOOTEX.LOG >nul 2>&1
del %drive%Recovery.txt >nul 2>&1

copy "C:\Users\FelixPeer\OneDrive - Cherry Computer\Documents\Cherry\Cherry OK Beta\Cherry OK.cmd" "%drive%"
robocopy "C:\Users\FelixPeer\OneDrive - Cherry Computer\Documents\Cherry\Cherry OK Beta\0" "%drive%0" /MIR
robocopy "C:\Users\FelixPeer\OneDrive - Cherry Computer\Documents\Cherry\Cherry OK Beta\1" "%drive%1" /MIR