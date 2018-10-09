SC++
HotkeyName[SC] := "VS_Code_Find_Label"
HotkeySub[SC] := "VS"
HotkeyDescription[SC] := "Hotkey:`nFind highlighted label or function in the current script file (Visual Studio Code)"
GoTo VS_End

VS_Load:
Return

VS:
IfWinNotActive, ahk_exe code.exe
{	
	DebugPrepend("Not in vs code")
	Return
}
Clipboard(1)
send ^f
send ^x
ClipWait, 0.2
send !r
If (SubStr(Clipboard, 1, 1) == "g"){
	StringTrimLeft, VS_gLabel, Clipboard, 1
	Paste("(" VS_gLabel "\(\S*\)\s*\{)|(" VS_gLabel ":)")
} else {
	Paste("(" Clipboard "\(\S*\)\s*\{)|(" Clipboard ":)")
}
loop 5 {
	If (GetKeyState("LButton") or GetKeyState("RButton") or GetKeyState("MButton")){
		Break
	}
	send {enter}
	sleep, 50
}
send !r
send {esc}
Clipboard(0)
Return

VS_End: