SC++
HotkeyName[SC] := "Click_2_Locations"
HotkeySub[SC] := "C2L"
HotkeySettings[SC] := "C2L_Click1X,C2L_Click1Y,C2L_Click2X,C2L_Click2Y,C2L_CloseWin,C2L_Delay"
HotkeySettingsDescription[SC] := "C2L_Click1X:`nFirst click x coordinate`n`nC2L_Click1Y:`nFirst click y coordinate`n`nC2L_Click2X:`nSecond click x coordinate`n`nC2L_Click2Y:`nSecond click y coordinate`n`nC2L_CloseWin:`n1 or 0; Desides If the tab will be closed`n`nC2L_Delay:`nDelay between clicks and window close"
HotkeyDescription[SC] := "Hotkey:`nClick your chosen locations and optionally close tab (ctrl+w)`n`nShift:`nChoose the locations and If to close the tab"
HotkeyShift[SC] := 1
GoTo C2L_End

C2L_Load:
ReadIniDefUndef(Profile,,"C2L_Click1X",A_ScreenWidth/2,"C2L_Click1Y",A_ScreenHeight/2
	,"C2L_Click2X",A_ScreenWidth/2+10,"C2L_Click2Y",A_ScreenHeight/2+10,"C2L_CloseWin",0,"C2L_Delay",64)
Return

C2L:
If (C2L_Click1X=""){
	GoTo C2L_Shift
}
BlockInput, MouseMove
MousePos("Save")
MouseClick,, C2L_Click1X, C2L_Click1Y
Sleep, %C2L_Delay%
MouseClick,, C2L_Click2X, C2L_Click2Y
If (C2L_CloseWin){
	Sleep, %C2L_Delay%
	Send, ^+{Tab}
	Sleep, %C2L_Delay%
	Send, ^w
}
MousePos("Restore")
BlockInput, MouseMoveOff
Return

C2L_Shift:
Hotkey, *Enter, C2L_Enter,
Msgbox, 4096,% C2L_Title := "First Location", Mouse over where to click and press enter.`nClosing this window acts as if you had pressed enter!
MouseGetPos, C2L_Click1X, C2L_Click1Y
Click
Msgbox, 4096,% C2L_Title := "Second Location", Mouse over where to click and press enter.`nClosing this window acts as if you had pressed enter!
Hotkey, *Enter, C2L_Enter, Off
MouseGetPos, C2L_Click2X, C2L_Click2Y
Click
MsgBox, 4100, Close window?, Close existing tab?
C2L_CloseWin = 0
IfMsgBox, yes
{
	C2L_CloseWin = 1
}	
WriteIni(Profile,,"C2L_Click1X","C2L_Click1Y","C2L_Click2X","C2L_Click2Y","C2L_CloseWin")
Return

C2L_Enter:
WinClose, %C2L_Title%,
Return

C2L_Settings:
if (ChangingSetting="C2L_Delay") {
	If (%A_GuiControl%>=0 and IsNumber(%A_GuiControl%)){
		%A_GuiControl% := Floor(%A_GuiControl%)
		GoTo SettingsSuccess
	} else {
		DebugSet(ChangingSetting " must be a number larget than or equal to 0")
	}
} else {
	If (ChangingSetting="C2L_Click1X" or ChangingSetting="C2L_Click2X"){
		If (%A_GuiControl%>=0 and %A_GuiControl%<A_ScreenWidth and IsNumber(%A_GuiControl%)){
			%A_GuiControl% := Floor(%A_GuiControl%)
			GoTo SettingsSuccess
		} else {
			DebugSet(ChangingSetting " must be within screen boundaries and a number")
		}
	} else {
		If (ChangingSetting="C2L_Click1Y" or ChangingSetting="C2L_Click2Y"){
			If (%A_GuiControl%>=0 and %A_GuiControl%<A_ScreenHeight and IsNumber(%A_GuiControl%)){
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
}
Return

C2L_End: