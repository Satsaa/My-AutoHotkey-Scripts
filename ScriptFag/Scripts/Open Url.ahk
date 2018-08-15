SC++
HotkeyName[SC] := "Open Url"
HotkeySub[SC] := "OU"
HotkeySettings[SC] := "OU_UrlSuffix,OU_InsertClipboard,OU_UrlAffix,OU_Copy"
HotkeySettingsDescription[SC] := "OU_UrlSuffix:`nBeginning of url`n`nOU_InsertClipboard:`nInsert clipboard contents?`n`nOU_UrlAffix:`nEnd of url`n`nOU_Copy:`nCopy selected text before opening url?"
HotkeyDescription[SC] := "Hotkey:`nOpen url that you have defined. Insert clipboard contents if enabled`n`nShift:`nAdjust settings`n`nDoes not filter your input so errors might occur"
HotkeyShift[SC] := 1
GoTo OU_End

OU_Load:
ReadIniDefUndef(Profile,,"OU_UrlSuffix","","OU_InsertClipboard",0,"OU_UrlAffix","","OU_Copy","0")
Return

OU:
If (OU_Copy and OU_InsertClipboard){
	GoSub SaveClipboard
	send ^c
	ClipWait, 0.2
}
If (OU_InsertClipboard){
	Run, %OU_UrlSuffix%%Clipboard%%OU_UrlAffix%
} else {
	Run, %OU_UrlSuffix%%OU_UrlAffix%
}
If (OU_Copy and OU_InsertClipboard){
	GoSub RestoreClipboard
}
Return

OU_Shift:

InputBox, Temp,, Url's first half,,,,,,,,%OU_UrlSuffix%
If (!ErrorLevel){
	OU_UrlSuffix:=Temp
	WriteIni(Profile,,"OU_UrlSuffix")
} else {
	Return
}

MsgBox, 3,, Insert Clipboard Contents?,3
IfMsgBox, Yes
{
	OU_InsertClipboard:=1
} else {
	IfMsgBox, No
	{
		OU_InsertClipboard:=0
	}
}

InputBox, Temp,, Url's second half,,,,,,,,%OU_UrlAffix%
If (!ErrorLevel){
	OU_UrlAffix:=Temp
	WriteIni(Profile,,"OU_UrlAffix")
} else {
	Return
}

MsgBox, 3,, Copy highlighted text?`n(Restores clipboard to original state afterwards)
IfMsgBox, Yes
{
	OU_Copy:=1
} else {
	IfMsgBox, No
	{
		OU_Copy:=0
	}
}

Return

OU_Settings:
If (ChangingSetting="OU_UrlSuffix"){
	GoTo SettingsSuccess
} else {
	If (ChangingSetting="OU_UrlAffix"){
		GoTo SettingsSuccess
	} else {
		If (ChangingSetting="OU_InsertClipboard"){
			If (%A_GuiControl%="0" or %A_GuiControl%="1"){
				GoTo SettingsSuccess
			} else {
				DebugSet(ChangingSetting " must be 1 or 0")
			}
		} else {
			If (ChangingSetting="OU_Copy"){
				If (%A_GuiControl%="0" or %A_GuiControl%="1"){
					GoTo SettingsSuccess
				} else {
					DebugSet(ChangingSetting " must be 1 or 0")
				}
			}
		}
	}
}
Return

OU_End: