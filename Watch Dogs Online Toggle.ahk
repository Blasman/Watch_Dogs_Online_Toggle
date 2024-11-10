#SingleInstance, Force
#NoEnv

if not A_IsAdmin {
    Run *RunAs "%A_ScriptFullPath%"
    ExitApp
}

OnExit, Cleanup

Run, %comspec% /c netsh advfirewall firewall show rule name="Block UDP 9000" dir=in | findstr /C:"No rules match the specified criteria." && netsh advfirewall firewall add rule name="Block UDP 9000" dir=in action=block protocol=UDP localport=9000 enable=no, , Hide
Run, %comspec% /c netsh advfirewall firewall show rule name="Block UDP 9103" dir=in | findstr /C:"No rules match the specified criteria." && netsh advfirewall firewall add rule name="Block UDP 9103" dir=in action=block protocol=UDP localport=9103 enable=no, , Hide
Run, %comspec% /c netsh advfirewall firewall show rule name="Block UDP 9000" dir=out | findstr /C:"No rules match the specified criteria." && netsh advfirewall firewall add rule name="Block UDP 9000" dir=out action=block protocol=UDP localport=9000 enable=no, , Hide
Run, %comspec% /c netsh advfirewall firewall show rule name="Block UDP 9103" dir=out | findstr /C:"No rules match the specified criteria." && netsh advfirewall firewall add rule name="Block UDP 9103" dir=out action=block protocol=UDP localport=9103 enable=no, , Hide

Gui, Font, s12, Tahoma Bold
Gui, Add, Button, x15 y45 w100 h30 vBlock_Button gToggle_Online, BLOCK
Gui, Add, Button, x125 y45 w100 h30 vQuick_DC_Button gQuick_DC, QUICK DC
Gui, Font, s17 cGreen, Verdana
Gui, Add, Text, vStatusText x16 y10 w220, ONLINE ENABLED
Gui, Show, w240 h85, WD Online
return

Online_Disable() {
    Run, %comspec% /c netsh advfirewall firewall set rule name="Block UDP 9000" new enable=yes && netsh advfirewall firewall set rule name="Block UDP 9103" new enable=yes, , Hide
    GuiControl, +cRed, StatusText
    GuiControl,, StatusText, ONLINE DISABLED
    GuiControl, Move, StatusText, x10
}

Online_Enable() {
    Run, %comspec% /c netsh advfirewall firewall set rule name="Block UDP 9000" new enable=no && netsh advfirewall firewall set rule name="Block UDP 9103" new enable=no, , Hide
    GuiControl, +cGreen, StatusText
    GuiControl,, StatusText, ONLINE ENABLED
    GuiControl, Move, StatusText, x16
}

Toggle_Online:
    GuiControl, Disable, Block_Button
    GuiControl, Disable, Quick_DC_Button
    if (Toggle_Online_Status := !Toggle_Online_Status) {
        GuiControl,, Block_Button, UNBLOCK
        Online_Disable()
    } else {
        GuiControl,, Block_Button, BLOCK
        Online_Enable()
    }
    Sleep, 300
    GuiControl, Enable, Block_Button
    if (!Toggle_Online_Status) {
        GuiControl, Enable, Quick_DC_Button
    }
return

Quick_DC:
    if WinExist("ahk_exe watch_dogs.exe") {
        WinActivate
      ; Send, {ESC}
    }
    GuiControl, Disable, Block_Button
    GuiControl, Disable, Quick_DC_Button
    Online_Disable()
    Sleep, 6500
    Online_Enable()
    GuiControl, Enable, Block_Button
    GuiControl, Enable, Quick_DC_Button
return

GuiClose:
    ExitApp
return

Cleanup:
    Run, %comspec% /c netsh advfirewall firewall delete rule name="Block UDP 9000", , Hide
    Run, %comspec% /c netsh advfirewall firewall delete rule name="Block UDP 9103", , Hide
    ExitApp
return
