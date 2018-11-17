
; This should block combining of ´ ` ¨ ^ ~ characters. Eg ¨ + a = ä
; With this those keys output immediately without waiting for a second character

goto hop

~+´::	; `
~´::	; ´
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
if GetKeyState("space", "P"){
	send {space Up}
	send {space down}
} else {
	send {space}
}
Return

hop: