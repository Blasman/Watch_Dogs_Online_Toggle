#SingleInstance, Force
if not A_IsAdmin {
    Run *RunAs "%A_ScriptFullPath%"
    ExitApp
}

OnExit, Cleanup

CreateFirewallRules() {
    Run, %comspec% /c netsh advfirewall firewall show rule name="Block UDP 9000" dir=in | findstr /C:"No rules match the specified criteria." && netsh advfirewall firewall add rule name="Block UDP 9000" dir=in action=block protocol=UDP localport=9000 enable=no, , Hide
    Run, %comspec% /c netsh advfirewall firewall show rule name="Block UDP 9103" dir=in | findstr /C:"No rules match the specified criteria." && netsh advfirewall firewall add rule name="Block UDP 9103" dir=in action=block protocol=UDP localport=9103 enable=no, , Hide
    Run, %comspec% /c netsh advfirewall firewall show rule name="Block UDP 9000" dir=out | findstr /C:"No rules match the specified criteria." && netsh advfirewall firewall add rule name="Block UDP 9000" dir=out action=block protocol=UDP localport=9000 enable=no, , Hide
    Run, %comspec% /c netsh advfirewall firewall show rule name="Block UDP 9103" dir=out | findstr /C:"No rules match the specified criteria." && netsh advfirewall firewall add rule name="Block UDP 9103" dir=out action=block protocol=UDP localport=9103 enable=no, , Hide
}

CreateFirewallRules()

Gui, Font, s12, Tahoma Bold
Gui, Add, Button, x15 y45 w100 h30 gBlock_Online, BLOCK
Gui, Add, Button, x125 y45 w100 h30 gUnblock_Online, UNBLOCK
Gui, Font, s17 cGreen, Verdana
Gui, Add, Text, vStatusText x15 y10 w220, ONLINE ENABLED
Gui, Show, w240 h85, WD Online
Return

Block_Online:
    Run, %comspec% /c netsh advfirewall firewall set rule name="Block UDP 9000" new enable=yes && netsh advfirewall firewall set rule name="Block UDP 9103" new enable=yes, , Hide
    GuiControl, Font, StatusText
    GuiControl, +cRed, StatusText
    GuiControl,, StatusText, ONLINE DISABLED
    GuiControl, Move, StatusText, x10
    Return

Unblock_Online:
    Run, %comspec% /c netsh advfirewall firewall set rule name="Block UDP 9000" new enable=no && netsh advfirewall firewall set rule name="Block UDP 9103" new enable=no, , Hide
    GuiControl, Font, StatusText
    GuiControl, +cGreen, StatusText
    GuiControl,, StatusText, ONLINE ENABLED
    GuiControl, Move, StatusText, x15
    Return

GuiClose:
    ExitApp
Return

Cleanup:
    Run, %comspec% /c netsh advfirewall firewall delete rule name="Block UDP 9000", , Hide
    Run, %comspec% /c netsh advfirewall firewall delete rule name="Block UDP 9103", , Hide
    ExitApp
Return
