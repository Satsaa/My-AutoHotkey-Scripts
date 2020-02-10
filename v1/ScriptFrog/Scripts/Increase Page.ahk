SC++
HotkeyName[SC] := "Increase_Page"
HotkeySub[SC] := "PI"
HotkeySettings[SC] := "PI_Velocity"
HotkeySettingsDescription[SC] := "PI_Velocity:`nThe amount to add or substract (shared)"
HotkeyDescription[SC] := "Hotkey:`nAdd to the url's most right number`n`nShift:`nChoose the amount to add or substract (shared)"
HotkeyShift[SC] := 1

SC++
HotkeyName[SC] := "Increase_Page_Inverse"
HotkeySub[SC] := "PII"
HotkeyDescription[SC] := "Hotkey:`nSubstract from the url's most right number`n`nShift:`nChoose the amount to add or substract (shared)"
HotkeyShift[SC] := 1

GoTo PI_End

PI_Load:
ReadIniDefUndef(Profile,,"PI_Velocity",1)
PII_load:
Return

PII:
PI_Invert=1
GoTo PI_Start
PI:
PI_Invert=0
GoTo PI_Start
PI_Start:
MouseGetPos,,, PIN_WinId,
WinGet Process, ProcessName, ahk_id %PIN_WinId%
If (Process!="chrome.exe"){
	Return
}
If !(PI_Velocity){
	GoTo PI_Shift
}
Send ^l
Clipboard(1)
Send ^x
ClipWait 0.05
If (ErrorLevel){
	Clipboard(0)
	ClipFailCount++
	If (ClipFailCount=10){
		ClipFailCount=0
		DebugPrepend("Failed to copy text at " A_ThisLabel)
		Return
	} else {
		GoTo %A_ThisLabel%
	}
}
ClipFailCount=0
PI_Url := Clipboard
RegExMatch(PI_Url, "(-?\d+)(\D*$)", PI_Extract)
If (PI_Invert){
	PI_Extract := PI_Extract1+PI_Velocity*-1 . PI_Extract2
} else {
	PI_Extract := PI_Extract1+PI_Velocity . PI_Extract2 
}
Send ^l
Paste(RegExReplace(PI_Url, "\d+\D*$", PI_Extract))
Send {Enter}
sleep 1
Clipboard(0)
Return

PII_Shift:
PI_Shift:
InputBox, Temp, , Page increase amount? (number),,,,,,,,%PI_Velocity%
If (!ErrorLevel){
	PI_Velocity:=Temp
	WriteIni(Profile,,"PI_Velocity")
}
Return

PI_Settings:
If IsNumber(%A_GuiControl%){
	%A_GuiControl% := Floor(%A_GuiControl%)
	GoTo SettingsSuccess
} else {
	DebugSet(ChangingSetting " must be a number")
}
Return

PI_End: