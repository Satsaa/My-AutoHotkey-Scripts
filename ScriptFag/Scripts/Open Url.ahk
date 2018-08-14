SC++
HotkeyName[SC] := "Open Url"
HotkeySub[SC] := "OU"
HotkeySettings[SC] := "OU_UrlSuffix,OU_InsertClipboard,OU_UrlAffix"
HotkeySettingsDescription[SC] := "OU_UrlSuffix:`nBeginning of url`n`nOU_InsertClipboard:`nInsert clipboard contents?`n`nOU_UrlAffix:`nEnd of url`n`n"
HotkeyDescription[SC] := "Hotkey:`nOpen url that you have defined. Insert clipboard contents if enabled`n`nDoes not filter your input so errors might occur"
GoTo OU_End

OU_Load:
ReadIniDefUndef(Profile,,"OU_UrlSuffix","","OU_InsertClipboard",0,"OU_UrlAffix","")
Return

OU:
If (OU_InsertClipboard){
	Run, %OU_UrlSuffix%%Clipboard%%OU_UrlAffix%
} else {
	Run, %OU_UrlSuffix%%OU_UrlAffix%
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
		}
	}
}
Return

OU_End: