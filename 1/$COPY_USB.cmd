@echo off
@title Cherry USB

set drive=%CD:~0,3%

echo %drive%


C:

pause

rd /s /q %drive%HP
rd /s /q %drive%LOST.DIR
del %drive%BOOTEX.LOG

pause



copy "C:\Users\FelixPeer\OneDrive - Cherry Computer\Documents\Cherry\Cherry USB\Cherry OK.cmd" "%drive%"
robocopy "C:\Users\FelixPeer\OneDrive - Cherry Computer\Documents\Cherry\Cherry USB\0" "%drive%0" /MIR
robocopy "C:\Users\FelixPeer\OneDrive - Cherry Computer\Documents\Cherry\Cherry USB\1" "%drive%1" /MIR

pause