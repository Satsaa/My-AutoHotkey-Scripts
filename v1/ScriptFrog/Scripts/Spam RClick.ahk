SC++
HotkeyName[SC] := "Spam_Right_Click"
HotkeySub[SC] := "SRC"
HotkeySettings[SC] := "SRC_Sleep"
HotkeySettingsDescription[SC] := "SRC_Sleep:`nSleep duration between clicks (ms)"
HotkeyDescription[SC] := "Hotkey:`nWhen held, click and sleep at your will`n`nShift:`nAdjust sleep. Set to ""skip"" If you really want to fuck around"
HotkeyAllowModifiers[SC] := 1
GoTo SRC_End

SRC_Load:
ReadIniDefUndef(Profile,,"SRC_Sleep","skip")
Return

SRC:
while GetKeyState(A_ThisHotkey, "P"){
	click, Right
	If !(SRC_Sleep="Skip"){
		sleep, %SRC_Sleep%
	}
}
Return

SRC_Settings:
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

SRC_End: