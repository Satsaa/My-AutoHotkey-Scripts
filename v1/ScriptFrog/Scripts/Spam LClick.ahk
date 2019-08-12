SC++
HotkeyName[SC] := "Spam_Left_Click"
HotkeySub[SC] := "SLC"
HotkeySettings[SC] := "SLC_Sleep"
HotkeySettingsDescription[SC] := "SLC_Sleep:`nSleep duration between clicks (ms)"
HotkeyDescription[SC] := "Hotkey:`nWhen held, click and sleep at your will`n`nShift:`nAdjust sleep. Set to ""skip"" If you really want to fuck around"
HotkeyAllowModifiers[SC] := 1
GoTo SLC_End

SLC_Load:
ReadIniDefUndef(Profile,,"SLC_Sleep","skip")
Return

SLC:
while GetKeyState(A_ThisHotkey, "P"){
	click, Left
	If !(SLC_Sleep="Skip"){
		sleep, %SLC_Sleep%
	}
}
Return

SLC_Settings:
If IsNumber(%A_GuiControl%){
	%A_GuiControl% := Floor(%A_GuiControl%)
	Goto SettingsSuccess
} else {
	If (%A_GuiControl%="skip"){
		GoTo SettingsSuccess
	} else {
		DebugSet(ChangingSetting " must be a number, nothing or ""skip""")
	}
}
Return

SLC_End: