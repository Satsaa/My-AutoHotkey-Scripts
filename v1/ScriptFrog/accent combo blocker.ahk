
; This should block combining of ´ ` ¨ ^ ~ characters. Eg ¨ + a = ä
; With this those keys output immediately without waiting for space

ReadIniDefUndef(,,"ACB_Enable", 1)

SetTimer, ACB_Init, -1000

goto ACB_Hop

ACB_Init:
Hotkey, ~+´ , ACB_Block, UseErrorLevel
if (ErrorLevel)
  GoTo, ACB_Error
Hotkey, ~´ , ACB_Block, UseErrorLevel
if (ErrorLevel)
  GoTo, ACB_Error
Hotkey, ~+¨ , ACB_Block, UseErrorLevel
if (ErrorLevel)
  GoTo, ACB_Error
Hotkey, ~^!¨ , ACB_Block, UseErrorLevel
if (ErrorLevel)
  GoTo, ACB_Error
Hotkey, ~¨ , ACB_Block, UseErrorLevel
if (ErrorLevel)
  GoTo, ACB_Error
Hotkey, ~!¨ , ACB_Block, UseErrorLevel
if (ErrorLevel)
  GoTo, ACB_Error
Return
ACB_Error:
SetTimer, ACB_Init, -5000
Return

ACB_Block:
if (!ACB_Enable){
  return
}
if GetKeyState("space", "P"){
	send {space Up}
	send {space down}
} else {
	send {space}
}
Return

ACB_Checkbox:
ACB_Enable := !ACB_Enable
IniWrite, %ACB_Enable%, Prefs.ini, All, ACB_Enable
Return

ACB_Hop: