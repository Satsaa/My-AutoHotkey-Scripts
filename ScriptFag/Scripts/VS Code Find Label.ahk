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
	DebugAffix("Not in vs code")
	Return
}
GoSub SaveClipboard
send ^f
send ^x
ClipWait, 0.2
send !r
Paste("(" Clipboard "\(\S*\)\s*\{)|(" Clipboard ":)")
loop 5 {
	If GetKeyState("LButton", "P"){
		Break
	}
	If GetKeyState("RButton", "P"){
		Break
	}
	If GetKeyState("MButton", "P"){
		Break
	}
	send {enter}
	sleep, 50
}
send !r
send {esc}
GoSub RestoreClipboard
Return

VS_End: