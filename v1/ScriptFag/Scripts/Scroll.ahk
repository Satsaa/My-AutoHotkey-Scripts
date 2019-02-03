SC++
HotkeyName[SC] := "Scroll_Up"
HotkeySub[SC] := "SL_U"
HotkeySettings[SC] := "SL_Speed"
HotkeySettingsDescription[SC] := "SL_Speed:`nScroll amount (shared)"
HotkeyDescription[SC] := "Hotkey:`nScroll up`n`nShift:`nSingle scroll`n`nScroll speeds depend on your os' mouse settings"
HotkeyShift[SC] := 1
GoTo SL_U_End

SL_U_Load:
ReadIniDefUndef(Profile,,"SL_Speed",1)
Return

SL_U:
Loop, %SL_Speed% {
  Send {WheelUp}
}
Return

SL_U_Shift:
  Send {WheelUp}
Return

SL_U_Settings:
If IsNumber(%A_GuiControl%){
	%A_GuiControl% := Floor(%A_GuiControl%)
	GoTo SettingsSuccess
} else {
	DebugSet(ChangingSetting " must be a number")
}
Return

SL_U_End:

;;;;;;;;;;;;;;;;;;;;;;

SC++
HotkeyName[SC] := "Scroll_Down"
HotkeySub[SC] := "SL_D"
HotkeyDescription[SC] := "Hotkey:`nScroll down`n`nShift:`nSingle scroll"
HotkeyShift[SC] := 1
GoTo SL_D_End

SL_D_Load:
Return

SL_D:
Loop, %SL_Speed% {
  Send {WheelDown}
}
Return

SL_D_Shift:
  Send {WheelDown}
Return

Return

SL_D_Settings:
If IsNumber(%A_GuiControl%){
	%A_GuiControl% := Floor(%A_GuiControl%)
	GoTo SettingsSuccess
} else {
	DebugSet(ChangingSetting " must be a number")
}
Return

SL_D_End: