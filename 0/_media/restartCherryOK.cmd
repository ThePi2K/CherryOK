@echo off
@title Cherry OK

:: STARTING CHERRY OK
wmic LOGICALDISK where driveType=2 get deviceID > C:\tmp 2>&1
for /f "skip=1" %%b IN ('type C:\tmp') DO (echo %%b & %%b & IF EXIST "Cherry OK.cmd" goto openCmd)

:openCmd
del C:\tmp >nul 2>&1
IF EXIST "Cherry OK.cmd" (
	cd 0
	cls
	call "Cherry OK.bat"
) else (
	echo USB is missing...
	pause
	cls
	goto openCmd
)
