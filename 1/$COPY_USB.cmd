@echo off
@title Cherry USB

C:

pause

rd /s /q %CD:~0,3%HP
rd /s /q %CD:~0,3%LOST.DIR
del %CD:~0,3%BOOTEX.LOG

pause



copy "C:\Users\FelixPeer\OneDrive - Cherry Computer\Documents\Cherry\Cherry USB\Cherry OK.cmd" "%CD:~0,3%"
robocopy "C:\Users\FelixPeer\OneDrive - Cherry Computer\Documents\Cherry\Cherry USB\0" "%CD:~0,3%0" /MIR
robocopy "C:\Users\FelixPeer\OneDrive - Cherry Computer\Documents\Cherry\Cherry USB\1" "%CD:~0,3%1" /MIR

pause