SC++
HotkeyName[SC] := "Spam_Ping_Map"
HotkeySub[SC] := "SM"
HotkeySettings[SC] := "SM_Sleep"
HotkeySettingsDescription[SC] := "SM_Sleep:`nSleep duration between pings (ms)"
HotkeyDescription[SC] := "Hotkey:`nPing the Dota 2 map and sleep at your will`n`nShift:`nAdjust sleep. Set to ""skip"" If you really want to fuck around"
HotkeyShift[SC] := 1
GoTo SM_End

SM_Load:
ReadIniDefUndef(Profile,,"SM_Sleep","skip")
Return

SM:
MousePos("Save")
while GetKeyState(A_ThisHotkey, "D"){
	Random, SM_RanX, 30, 371
	Random, SM_RanY, 1069, 1395
	MouseClick,, SM_RanX, SM_RanY
	If !(SM_Sleep="Skip"){
		sleep, %SM_Sleep%
	}
}
MousePos("Restore")
Return

SM_shift:
InputBox, SM_Sleep, Sleep, Input how long (ms) to sleep between pings
WriteIni(Profile,,"SM_Sleep")
Return

SM_Settings:
If IsNumber(%A_GuiControl%){
	%A_GuiControl% := Floor(%A_GuiControl%)
	Goto SettingsSuccess
} else {
	If (%A_GuiControl%="skip"){
		GoTo SettingsSuccess
	} else {
 		DebugSet(ChangingSetting " must be a number or nothing or ""skip""")
	}
}
Return

SM_End: