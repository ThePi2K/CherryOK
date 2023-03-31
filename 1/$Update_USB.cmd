@echo off
@title Cherry USB

set drive=%CD:~0,3%

echo %drive%
if not exist "C:\Users\FelixPeer\OneDrive - Cherry Computer\Documents\Cherry\Cherry USB\Cherry OK.cmd" exit
if "%drive%"=="C:\" exit

C:

rd /s /q %drive%HP
rd /s /q %drive%LOST.DIR
del %drive%BOOTEX.LOG

copy "C:\Users\FelixPeer\OneDrive - Cherry Computer\Documents\Cherry\Cherry USB\Cherry OK.cmd" "%drive%"
robocopy "C:\Users\FelixPeer\OneDrive - Cherry Computer\Documents\Cherry\Cherry USB\0" "%drive%0" /MIR
robocopy "C:\Users\FelixPeer\OneDrive - Cherry Computer\Documents\Cherry\Cherry USB\1" "%drive%1" /MIR