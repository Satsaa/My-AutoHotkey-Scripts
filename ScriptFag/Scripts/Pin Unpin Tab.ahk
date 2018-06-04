SC++
HotkeyName[SC] := "Pin_Unpin_Tab"
HotkeySub[SC] := "PIN"
HotkeyDescription[SC] := "Hotkey:`nPin or unpin a Chrome tab below the mouse"
GoTo PIN_End

PIN_Load:
Return

PIN:
MouseGetPos,,, WinId,
WinGet Process, ProcessName, ahk_id %WinId%
If (Process!="chrome.exe"){
	Return
}
Click Right
SendInput p
SendInput u
Return

PIN_End: