@echo off

REM A simple batch file to drop permahacks in Watch_Dogs 1 on PC. Must be ran as an administrator.

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo This script must be run as an administrator.
    pause
    exit
)

REM Set the wait time before restoring online services. '6' seems to work after a few tests. Default is set to '7' just in case.
set waitTime=7

echo *** WATCH_DOGS PERMAHACK DROPPER ***
echo.
netsh advfirewall firewall add rule name="Block UDP 9000" dir=in action=block protocol=UDP localport=9000 enable=yes >nul
netsh advfirewall firewall add rule name="Block UDP 9103" dir=in action=block protocol=UDP localport=9103 enable=yes >nul
netsh advfirewall firewall add rule name="Block UDP 9000" dir=out action=block protocol=UDP localport=9000 enable=yes >nul
netsh advfirewall firewall add rule name="Block UDP 9103" dir=out action=block protocol=UDP localport=9103 enable=yes >nul
echo CONNECTION_INTERRUPTED. Online services will be restored in %waitTime% seconds.
timeout /t %waitTime% /nobreak
netsh advfirewall firewall delete rule name="Block UDP 9000" >nul
netsh advfirewall firewall delete rule name="Block UDP 9103" >nul
exit
