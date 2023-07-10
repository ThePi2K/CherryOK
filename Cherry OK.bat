@echo off
cd 0
for %%i in ("Cherry OK*.bat") do (
	start "" "%%i"
	exit
)