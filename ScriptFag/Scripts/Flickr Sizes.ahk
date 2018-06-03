SC++
HotkeyName[SC] := "Flickr_Sizes"
HotkeySub[SC] := "FS"
HotkeyDescription[SC] := "Hotkey:`nModIfy the url to show sizes in Flickr. If already in sizes, opens the image AND CLOSES WINDOW"
Return

FS_Load:
Return

FS:
If !InStr(ActiveTitle, "| Flickr -"){  ;Not in Flickr
	DebugAffix("Not in flickr")
	Return
}
If InStr(ActiveTitle, "All sizes"){  ;Open image
	MousePos("Save")
	WinGetPos, FS_WinX, FS_WinY, FS_WinW, FS_WinH, A
	MouseClick, right, FS_WinX+FS_WinW/2, FS_WinY+FS_WinH/2
	sleep, 16
	send, {Enter 2} ^w
	MousePos("Restore")
} else {  ;Add shit to url
	GoSub SaveClipboard
	Send ^l
	Send ^x
	ClipWait 0.05
	If ErrorLevel {
		ClipFailCount+=1
		If (ClipFailCount=10){
			ClipFailCount=0
			DebugAffix("Failed to copy text at " A_ThisLabel)
			Return
		} else {
			GoTo %A_ThisLabel%
		}
	}
	ClipFailCount=0
	Paste(RegExReplace(Clipboard, "\/in\/.+") FS_UrlStart "/sizes/o")
	sleep 12
	Send {enter}
	GoSub RestoreClipboard
}
Return