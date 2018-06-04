SC++
HotkeyName[SC] := "Click_Location"
HotkeySub[SC] := "CL"
HotkeySettings[SC] := "CL_ClickX,CL_ClickY"
HotkeySettingsDescription[SC] := "CL_ClickX:`nClick x coordinate`n`nCL_ClickY:`nClick y coordinate"
HotkeyDescription[SC] := "Hotkey:`nClick your chosen location`n`nShift:`nChoose the location"
HotkeyShift[SC] := 1
GoTo CL_End

CL_Load:
ReadIniDefUndef(Profile,,"CL_ClickX",A_ScreenWidth/2,"CL_ClickY",A_Screenheight/2)
Return

CL:
If (CL_ClickX=""){
	GoTo CL_Shift
}
BlockInput, MouseMove
MousePos("Save")
Click, %CL_ClickX%, %CL_ClickY%
MousePos("Restore")
BlockInput, MouseMoveOff
Return

CL_Shift:
SetTimer, CL_Win, -50
Msgbox, 4096,% CL_Title := "Click Location", Mouse over where to click and press enter.
MouseGetPos, CL_ClickX, CL_ClickY
WriteIni(Profile,,"CL_ClickX","CL_ClickY")
Return

CL_Win:
If (WinExist(CL_Title)){
	If (!WinActive(CL_Title)){
		WinActivate, %CL_Title%
	}
	SetTimer, CL_Win, -250
}
Return

CL_Settings:
If (ChangingSetting="CL_ClickX"){
	If (%A_GuiControl%>=0 and %A_GuiControl%<%A_ScreenWidth% and IsNumber(%A_GuiControl%)){
		%A_GuiControl% := Floor(%A_GuiControl%)
		GoTo SettingsSuccess
	} else {
		DebugSet(ChangingSetting " must be within screen boundaries and be a number")
	}
} else {
	If (ChangingSetting="CL_ClickY"){
		If (%A_GuiControl%>=0 and %A_GuiControl%<%A_ScreenHeight% and IsNumber(%A_GuiControl%)){
			%A_GuiControl% := Floor(%A_GuiControl%)
			GoTo SettingsSuccess
		} else {
			DebugSet(ChangingSetting " must be within screen boundaries and be a number")
		}
	}
}
Return

CL_End: