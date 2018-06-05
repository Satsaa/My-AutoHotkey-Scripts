SC++
HotkeyName[SC] := "Annihilate"
HotkeySub[SC] := "AN"
HotkeyDescription[SC] := "Ctrl+Alt:`nKill the script immediately`n`nThis hotkey will be active in all profiles"
HotkeyGlobal[SC] := 1
HotkeyDisableMain[SC] := 1 
HotkeyCtrlAlt[SC] := 1
GoTo AN_End

AN_Load:
Return

AN_CtrlAlt:
GoTo Terminate
Return

AN_End: