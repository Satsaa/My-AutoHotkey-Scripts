SC++
HotkeyName[SC] := "Trim_URL"
HotkeySub[SC] := "TU"
HotkeySettings[SC] := "TU_StartCount,TU_EndCount,TU_Go"
HotkeySettingsDescription[SC] := "TU_StartCount:`nThe amount of characters to remove from the start`n`nTU_EndCount:`nThe amount of characters to remove from the end`n`nTU_Go:`nGo to the resulting URL automatically?"
HotkeyDescription[SC] := "Hotkey:`nRemoves a specific amount of characters from the end and start of the URL"
HotkeyAllowModifiers[SC] := 1
GoTo TU_End

TU_Load:
ReadIniDefUndef(Profile,,"TU_StartCount",0,"TU_EndCount",0,"TU_Go",1)
Return

TU:
MouseGetPos,,, PIN_WinId,
WinGet Process, ProcessName, ahk_id %PIN_WinId%
If (Process!="chrome.exe"){
	Return
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
temp := Clipboard

Send ^l
if (TU_EndCount)
  temp := SubStr(temp, 1, -TU_EndCount)
if (TU_StartCount)
  temp := SubStr(temp, TU_StartCount + 1)

Paste(temp)
if (TU_Go)
  Send {Enter}

sleep 1
Clipboard(0)
Return

TU_Settings:
If (ChangingSetting="TU_StartCount" or ChangingSetting="TU_EndCount"){
  If (IsNumber(%A_GuiControl%) and %A_GuiControl% >= 0){
  	%A_GuiControl% := Floor(%A_GuiControl%)
  	GoTo SettingsSuccess
  } else {
  	DebugSet(ChangingSetting " must be a nonnegative number")
  }
} else If (ChangingSetting="TU_Go"){
  %A_GuiControl% := %A_GuiControl%
	GoTo SettingsSuccess
}
Return

TU_End: