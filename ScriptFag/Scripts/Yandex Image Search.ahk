SC++
HotkeyName[SC] := "Yandex_Image_Search"
HotkeySub[SC] := "YI"
HotkeyDescription[SC] := "Hotkey:`nUse when your url points to and image. Yandex will image search it"
GoTo YI_End

YI_Load:
Return

YI:
Send ^l
GoSub SaveClipboard
Send ^x
ClipWait 0.05
If ErrorLevel {
	ClipFailCount+=1
	If (ClipFailCount=10){
		ClipFailCount=0
		DebugAffix("Failed to copy text at " A_ThisLabel)
		Return
	} else GoTo %A_ThisLabel%
}
Run,% "https://yandex.ru/images/search?url=" UrlEncode(Clipboard) "&rpt=imageview"
GoSub RestoreClipboard
Return

YI_End: