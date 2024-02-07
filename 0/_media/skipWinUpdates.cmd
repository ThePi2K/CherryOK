@echo off
@title Cherry OK

:: START AS ADMIN ::
set isAdminDir=C:\Windows\CherryTestAdmin
mkdir %isAdminDir% > nul
cls
if not exist %isAdminDir% (
	set "params=%*"
	exit
)
rmdir %isAdminDir%

:: CREATE FILE ::
echo true > C:\Windows\Cherry\SkipUpdates.txt

echo Start "restartCherryOK.cmd" to restart the Cherry OK process
pause > nul