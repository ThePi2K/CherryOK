@echo off
@title Microsoft 365

if not DEFINED IS_MINIMIZED set IS_MINIMIZED=1 && start "" /min "%~dpnx0" %* && exit
winget install --id Microsoft.Office --accept-source-agreements --force
exit