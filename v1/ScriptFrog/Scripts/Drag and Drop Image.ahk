SC++
HotkeyName[SC] := "Drag_and_Drop_Image"
HotkeySub[SC] := "DD"
HotkeyDescription[SC] := "Hotkey:`nDrag and drop an image from the middle of your browser to above the window`n`nShift:`nThis doesnt work when shift is pressed`n`nAlt:`nDrag and drop to right of the window"
HotkeyShift[SC] := 1
HotkeyAlt[SC] := 1
GoTo DD_End

DD_Load:
Return

DD_Shift:
DebugPrepend("Use alt as this scripts modIfier key!")
Return

DD_Alt:
DD_AltMove=1
GoTo DD_Start

DD:
DD_AltMove=0
GoTo DD_Start

DD_Start:
SendMode Event
MouseGetPos,,, DD_Win
WinGetPos DD_WinX, DD_WinY, DD_WinW, DD_WinH, A
If CompareColor(DD_WinX+DD_WinW/2, DD_WinY+DD_WinH/2, "0E0E0E"){
	WaitCount+=1
	If (WaitCount=100){
		WaitCount=0
		DebugPrepend("Image wait timeout " A_ThisLabel)
		Return
	} else {
		GoTo %A_ThisLabel%
	}
}
WinGet, DDProcess, ProcessName, A
If (DDProcess != "chrome.exe"){
	DebugPrepend("Invalid window (not chrome.exe)")
	Return
}
BlockInput, MouseMove
MousePos("Save")
MouseMove, DD_WinX+DD_WinW/2, DD_WinY+DD_WinH/2, 100
Click, down
If !(DD_AltMove){
	MouseMove, DD_WinX+DD_WinW/2, DD_WinY-100, 100  ;Just above the window
} else {
	MouseMove, DD_WinX+DD_WinW+100, DD_WinY+DD_WinH/2, 100  ;Right of the window
}
sleep, 88
MouseMove, 5, 5, 100, R
MouseMove, -5, -5, 100, R
MouseMove, 5, 5, 100, R
MouseMove, -5, -5, 100, R
Click, Up
sleep, 64
SetTitleMatchMode, 3
IfWinExist, Copy File
{
	WinClose, Copy File
	WinActivate, ahk_id %DD_Win%
	sleep, 1
	Send, ^{Tab}
} else {
	WinActivate, ahk_id %DD_Win%
	sleep, 1
	Send, ^{Tab}
}
MousePos("Restore")
BlockInput, MouseMoveOff
Return

DD_End: