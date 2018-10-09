SC++
HotkeyName[SC] := "Debug_Settings"
HotkeySub[SC] := "DS"
HotkeySettings[SC] := "DebugSetting"
HotkeySettingsDescription[SC] := "DebugSetting:`n1=Log 2=UnderMouseInfo Negative=disabled"
HotkeyDescription[SC] := "Hotkey:`nToggle updating of debug view`n`nShift:`nSelect mode"
HotkeyShift[SC] := 1
ReadIniDefUndef(,,"DebugSetting",1)
Gui, DS:Add, Text,, Debug view settings
Gui, DS:Add, Radio, % (DebugSetting=1 or DebugSetting=-1) ? ("Checked gDS_Log") : ("gDS_Log"), Enable Log
Gui, DS:Add, Radio, % (DebugSetting=2 or DebugSetting=-2) ? ("Checked gDS_WinInfo") : ("gDS_WinInfo"), Enable Window Info
Gui, DS:-MinimizeBox +AlwaysOnTop
GoTo DS_End

DS_Load:
Return

DS:
If !(DebugSetting) {
	Gui, DS:Show,, Debug
} else {
	DebugSetting:=DebugSetting*-1
}
WriteIni(,,"DebugSetting")
Return

DS_Shift:
Gui, DS:Show,, Debug
Return

DS_Log:
DebugPrepend()
DebugSetting=1
WriteIni(,,"DebugSetting")
Return

DS_WinInfo:
DebugSetting=2
WriteIni(,,"DebugSetting")
Return

DS_Settings:
If (Abs(%A_GuiControl%)=1 or Abs(%A_GuiControl%)=2){
	%ChangingSetting% := %A_GuiControl%
	WriteIni(,,"DebugSetting")
	DebugSet(%A_GuiControl% " accepted and saved")
} else {
	DebugSet("DebugSetting must be 1, 2, -1 or -2")
}
Return

DS_End: