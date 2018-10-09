SC++
HotkeyName[SC] := "Dota_Arrow"
HotkeySub[SC] := "DA"
HotkeySettings[SC] := "DA_Sleep"
HotkeySettingsDescription[SC] := "DA_Sleep:`nSleep duration between clicks (ms)"
HotkeyDescription[SC] := "Hotkey:`nWhen held, click and sleep at your will`n`nShift:`nAdjust sleep. Set to ""skip"" If you really want to fuck around"
HotkeyAllowModifiers[SC] := 1
DA_X := [1.0, 0.7, 0.7, 0.0,0.0,0.7,0.7,1.0]
DA_Y := [0.0,-0.3,-0.1,-0.1,0.1,0.1,0.3,0.0]
GoTo Da_End

Da_Load:
Return

Da:
MouseGetPos, DA_MX1, DA_MY1
While GetKeyState(RemoveModifiers(A_ThisHotkey), "P"){
}
BlockInput, MouseMove
sleep, 32
MouseGetPos, DA_MX2, DA_MY2

DA_Angle := Angle(DA_MX1,DA_MY1,DA_MX2,DA_MY2)
DA_Dist := Distance(DA_MX1,DA_MY1,DA_MX2,DA_MY2)
Send {Ctrl down}
click down
Loop,% DA_X.MaxIndex() {
	sleep, 32
	MouseMove,% Rotate(DA_X[A_Index]*DA_Dist+DA_MX1+1, DA_Y[A_Index]*DA_Dist+DA_MY1, DA_Angle, DA_MX1, DA_MY1),% Rotate(,,,,, 1)
	sleep, 32
	MouseMove,% Rotate(DA_X[A_Index]*DA_Dist+DA_MX1, DA_Y[A_Index]*DA_Dist+DA_MY1, DA_Angle, DA_MX1, DA_MY1),% Rotate(,,,,, 1)
}
sleep, 64
Click up
Send {Ctrl Up}
MouseMove,% DA_MX2,% DA_MY2
BlockInput, MouseMoveOff
Return

Da_End: