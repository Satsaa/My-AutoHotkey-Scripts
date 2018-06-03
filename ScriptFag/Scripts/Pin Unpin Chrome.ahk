SC++
HotkeyName[SC] := "Pin_Unpin_Chrome"
HotkeySub[SC] := "PIN"
HotkeyDescription[SC] := "Hotkey:`nPin or unpin a Chrome tab below the mouse"
Return

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