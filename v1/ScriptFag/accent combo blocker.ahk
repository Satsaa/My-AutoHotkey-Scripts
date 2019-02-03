
; This should block combining of ´ ` ¨ ^ ~ characters. Eg ¨ + a = ä
; With this those keys output immediately without waiting for space

ReadIniDefUndef(,,"ACB_Enable", 1)

debugPrepend(ACB_Enable)
goto ACB_Hop

~+´::	; `
~´::	; ´
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

~+¨::	; ^
~^!¨::	; ~
~¨::	; ¨
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