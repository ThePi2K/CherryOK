@echo off
@title Microsoft 365

powershell -window minimized -command ""
winget install --id Microsoft.Office --accept-source-agreements --force
exit