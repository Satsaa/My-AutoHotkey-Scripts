SC++
HotkeyName[SC] := "Dota_Trash"
HotkeySub[SC] := "DT"
HotkeySettings[SC] := "DT_Sleep"
HotkeySettingsDescription[SC] := "DT_Sleep:`nSleep duration between clicks (ms)"
HotkeyDescription[SC] := "Hotkey:`nWhen held, click and sleep at your will`n`nShift:`nAdjust sleep. Set to ""skip"" If you really want to fuck around"
HotkeyAllowModifiers[SC] := 1
;Trace
DT_X1 := [ 0.1, 0.25, 0.44, 0.6 ]
DT_Y1 := [-0.1,-0.25,-0.30,-0.25]
;Trash
DA_Trash:=1
DT_XT := [ 0.51 -0.04 , 0.51 +0.05, 0.51 -0.005, 0.51 -0.03, 0.51 +0.04 ]
DT_YT := [-0.29+0.016 ,-0.29-0.06 ,-0.29+0.06  ,-0.29-0.08 ,-0.29+0.005]
;Trash Can
DT_X2 := [ 0.8, 0.4,0.5 ,0.78, 0.8, 0.6 ]
DT_Y2 := [-0.2,-0.2,0.35,0.35,-0.2,-0.44]
GoTo DT_End

DT_Load:
Return

DT:
MouseGetPos, DT_MX1, DT_MY1
While GetKeyState(RemoveModifiers(A_ThisHotkey), "P"){
}
BlockInput, MouseMove
sleep, 32
MouseGetPos, DT_MX2, DT_MY2
DT_Angle := 0
DT_Dist := (DT_MX2-DT_MX1)*1.2666
;Trace
MouseMove,% Rotate(DT_X1[1]*DT_Dist+DT_MX1, DT_Y1[1]*DT_Dist+DT_MY1, DT_Angle, DT_MX1, DT_MY1),% Rotate(,,,,, 1)
sleep, 32
Send {Ctrl down}
click down
Loop,% DT_X1.MaxIndex()-DA_Trash {
	sleep, 32
	MouseMove,% Rotate(DT_X1[A_Index]*DT_Dist+DT_MX1+1, DT_Y1[A_Index]*DT_Dist+DT_MY1, DT_Angle, DT_MX1, DT_MY1),% Rotate(,,,,, 1)
	sleep, 32
	MouseMove,% Rotate(DT_X1[A_Index]*DT_Dist+DT_MX1, DT_Y1[A_Index]*DT_Dist+DT_MY1, DT_Angle, DT_MX1, DT_MY1),% Rotate(,,,,, 1)
}
sleep, 64
Click up
Send {Ctrl Up}
;Trash
If (DA_Trash){
	MouseMove,% Rotate(DT_XT[1]*DT_Dist+DT_MX1, DT_YT[1]*DT_Dist+DT_MY1, DT_Angle, DT_MX1, DT_MY1),% Rotate(,,,,, 1)
	sleep, 32
	Send {Ctrl down}
	click down
	Loop,% DT_XT.MaxIndex() {
		sleep, 32
		MouseMove,% Rotate(DT_XT[A_Index]*DT_Dist+DT_MX1+1, DT_YT[A_Index]*DT_Dist+DT_MY1, DT_Angle, DT_MX1, DT_MY1),% Rotate(,,,,, 1)
		sleep, 32
		MouseMove,% Rotate(DT_XT[A_Index]*DT_Dist+DT_MX1, DT_YT[A_Index]*DT_Dist+DT_MY1, DT_Angle, DT_MX1, DT_MY1),% Rotate(,,,,, 1)
	}
	sleep, 64
	Click up
	Send {Ctrl Up}
}
;Trash Can
MouseMove,% Rotate(DT_X2[1]*DT_Dist+DT_MX1, DT_Y2[1]*DT_Dist+DT_MY1, DT_Angle, DT_MX1, DT_MY1),% Rotate(,,,,, 1)
sleep, 32
Send {Ctrl down}
click down
Loop,% DT_X2.MaxIndex() {
	sleep, 32
	MouseMove,% Rotate(DT_X2[A_Index]*DT_Dist+DT_MX1+1, DT_Y2[A_Index]*DT_Dist+DT_MY1, DT_Angle, DT_MX1, DT_MY1),% Rotate(,,,,, 1)
	sleep, 32
	MouseMove,% Rotate(DT_X2[A_Index]*DT_Dist+DT_MX1, DT_Y2[A_Index]*DT_Dist+DT_MY1, DT_Angle, DT_MX1, DT_MY1),% Rotate(,,,,, 1)
}
sleep, 64
Click up
Send {Ctrl Up}

MouseMove,% DT_MX2,% DT_MY2
BlockInput, MouseMoveOff
Return

DT_End: