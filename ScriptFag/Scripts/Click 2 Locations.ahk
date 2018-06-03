SC++
HotkeyName[SC] := "Click_2_Locations"
HotkeySub[SC] := "C2L"
HotkeySettings[SC] := "C2L_Click1X,C2L_Click1Y,C2L_Click2X,C2L_Click2Y,C2L_CloseWin"
HotkeySettingsDescription[SC] := "C2L_Click1X:`nFirst click x coordinate`n`nC2L_Click1Y:`nFirst click y coordinate`n`nC2L_Click2X:`nSecond click x coordinate`n`nC2L_Click2Y:`nSecond click y coordinate`n`nC2L_CloseWin:`n1 or 0; Desides If the tab will be closed`n`n"
HotkeyDescription[SC] := "Hotkey:`nClick your chosen locations and optionally close tab (ctrl+w)`n`nShift:`nChoose the locations and If to close the tab"
HotkeyShift[SC] := 1
Return

C2L_Load:
ReadIniDefUndef(Profile,,"C2L_Click1X",A_ScreenWidth/2,"C2L_Click1Y",A_ScreenHeight/2
	,"C2L_Click2X",A_ScreenWidth/2+10,"C2L_Click2Y",A_ScreenHeight/2+10,"C2L_CloseWin",0)
Return

C2L:
If (C2L_Click1X=""){
	GoTo C2L_Shift
}
BlockInput, MouseMove
MousePos("Save")
MouseClick,, C2L_Click1X, C2L_Click1Y
Sleep, 30
MouseClick,, C2L_Click2X, C2L_Click2Y
MousePos("Restore")
If (C2L_CloseWin){
	Sleep, 30
	Send, ^+{Tab}
	Sleep, 1
	Send, ^w
}
BlockInput, MouseMoveOff
Return

C2L_Shift:
SetTimer, C2L_Win, -50
Msgbox, 4096,% C2L_Title := "First Location", Mouse over where to click and press enter.
MouseGetPos, C2L_Click1X, C2L_Click1Y
Click
SetTimer, C2L_Win, -50
Msgbox, 4096,% C2L_Title := "Second Location", Mouse over where to click and press enter.
MouseGetPos, C2L_Click2X, C2L_Click2Y
MouseGetPos, X, Y
Click
MouseMove, X , Y, 0
MsgBox, 4100, Close window?, Close existing tab?
C2L_CloseWin = 0
IfMsgBox, yes
{
	C2L_CloseWin = 1
}	
WriteIni(Profile,,"C2L_Click1X","C2L_Click1Y","C2L_Click2X","C2L_Click2Y","C2L_CloseWin")
Return
C2L_Win:
If (WinExist(C2L_Title)){
	If ( !WinActive(C2L_Title) )
		WinActivate, %C2L_Title%
	SetTimer, C2L_Win, -250
} Return

C2L_Settings:
If (ChangingSetting="C2L_Click1X" or ChangingSetting="C2L_Click2X"){
	If (%A_GuiControl%>=0 and %A_GuiControl%<%A_ScreenWidth% and IsNumber(%A_GuiControl%)){
		%A_GuiControl% := Floor(%A_GuiControl%)
		GoTo SettingsSuccess
	} else {
		DebugSet(ChangingSetting " must be within screen boundaries and a number")
	}
} else {
	If (ChangingSetting="C2L_Click1Y" or ChangingSetting="C2L_Click2Y"){
		If (%A_GuiControl%>=0 and %A_GuiControl%<%A_ScreenHeight% and IsNumber(%A_GuiControl%)){
			%A_GuiControl% := Floor(%A_GuiControl%)
			GoTo SettingsSuccess
		} else {
			DebugSet(ChangingSetting " must be within screen boundaries and a number")
		}
	} else {
		If (ChangingSetting="C2L_CloseWin"){
			If (%A_GuiControl%="0" or %A_GuiControl%="1"){
				GoTo SettingsSuccess
			} else {
				DebugSet(ChangingSetting " must be 1 or 0")
			}
		}
	}
}
Return