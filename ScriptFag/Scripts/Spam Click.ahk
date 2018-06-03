SC++
HotkeyName[SC] := "Spam_Click"
HotkeySub[SC] := "SC"
HotkeySettings[SC] := "SC_Sleep"
HotkeySettingsDescription[SC] := "SC_Sleep:`nSleep duration between clicks (ms)"
HotkeyDescription[SC] := "Hotkey:`nWhen held, click and sleep at your will`n`nShift:`nAdjust sleep. Set to ""skip"" If you really want to fuck around"
HotkeyShift[SC] := 1
Return

SC_Load:
ReadIniDefUndef(Profile,,"SC_Sleep","skip")
Return

SC:
while GetKeyState(A_ThisHotkey, "D"){
	click
	If !(SC_Sleep="Skip"){
		sleep, %SC_Sleep%
	}
}
Return

SC_Shift:
InputBox, SC_Sleep, Sleep, Input how long (ms) to sleep between clicks,
WriteIni(Profile,,"SC_Sleep")
Return

SC_Settings:
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