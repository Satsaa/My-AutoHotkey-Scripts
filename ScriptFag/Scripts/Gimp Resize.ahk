SC++
HotkeyName[SC] := "Gimp_Resize"
HotkeySub[SC] := "GR"
HotkeySettings[SC] := "GR_Mode,GR_Width,GR_Height,GR_Interpolation"
HotkeyDescription[SC] := "Hotkey:`nResize image or layer to specified dismesions and with selected interpolation`n`nShift:`nShow customization window"
HotkeyShift[SC] := 1
GR_InterpolationList := "None|Linear|Cubic|NoHalo|LoHalo"
Loop, Parse, GR_InterpolationList, `|
{
	GR_MaxInterpolation++
}
HotkeySettingsDescription[SC] := "GR_Mode:`n1 = Scale image 2 = Scale layer`n`nGR_Width:`nScale width`n`nGR_Height:`nScale height`n`nSupports basic math(+, -, *, /)`n`nGR_Interpolation:`n0 to not change. 1 to " GR_MaxInterpolation " for one of these:`n" GR_InterpolationList "`n`n"
GoTo GR_End

GR_Load:
ReadIniDefUndef(Profile,,"GR_Mode",1,"GR_Width",0,"GR_Height",0,"GR_Interpolation",0)
Return

GR:
If !(InStr(ActiveTitle, " – GIMP")){
	DebugAffix("Not in GIMP")
	Return
}
Send, {AppsKey}
If (GR_Mode=1){
	send, i
} else {
	send l
}
send s
Send {Tab}
send {Enter}
Send +{Tab}
GR_WidthFirstChar := SubStr(GR_Width,1,1)
GR_HeightFirstChar := SubStr(GR_Height,1,1)
If (GR_Width!<1){
	If (GR_WidthFirstChar="-" or GR_WidthFirstChar="+" or GR_WidthFirstChar="*" or GR_WidthFirstChar="/" ){
		Send {Right}
	}
	Send %GR_Width%
}
Send {Tab 2}
If (GR_Height!<1){
	If (GR_HeightFirstChar="-" or GR_HeightFirstChar="+" or GR_HeightFirstChar="*" or GR_HeightFirstChar="/"){
		Send {Right}
	}
	Send %GR_Height%
}
Loop,% (GR_Mode=1)?(9):((GR_Mode=2)?(5):(0)) {  ;Set interpolation and move to scale button 9 for image 5 for layer
	Send {Tab}
	If ((GR_Mode=1 and A_Index=6 and GR_Interpolation!=0) OR (GR_Mode=2 and A_Index=2 and GR_Interpolation!=0)){
		send {Enter}
		send {home}
		Loop,% GR_Interpolation-1 {
			Send {Down}
		}
		send {Enter}
	}
}
send {Enter}
Return

GR_Shift:
Gui, GR:Add, Text,, Mode
Gui, GR:Add, Radio,% (GR_Mode=1) ? ("Checked gGR_Mode") : ("gGR_Mode"), Scale Image
Gui, GR:Add, Radio,% (GR_Mode=2) ? ("Checked gGR_Mode") : ("gGR_Mode"), Scale Layer
Gui, GR:Add, Edit, ym r1 vGR_Width gGR_Edit w60, %GR_Width%
Gui, GR:Add, Edit, r1 vGR_Height gGR_Edit w60, %GR_Height%
Gui, GR:Add, DropDownList,% "ym vGR_InterpolationUnparsed gGR_InterpolationParse Choose"GR_Interpolation+1 " AltSubmit", Don't Change|%GR_InterpolationList%
Gui, GR: -MinimizeBox +AlwaysOnTop
Gui, GR:Show
Return

GRGuiClose:
Gui, GR:Destroy
Return

GR_Edit:
Gui, GR:Submit, NoHide
%A_GuiControl% := %A_GuiControl%
WriteIni(Profile,,A_GuiControl)
Return

GR_InterpolationParse:
Gui, GR:Submit, NoHide
DebugAffix(%A_GuiControl%)
GR_Interpolation:=%A_GuiControl%-1
WriteIni(Profile,,"GR_Interpolation")
Return

GR_Mode:
Gui, GR:Submit, NoHide
DebugAffix("we here " A_GuiControl)
If (A_GuiControl="Scale Image"){
		GR_Mode:=1
		DebugAffix("Now in image mode")
		WriteIni(Profile,,"GR_Mode")
} else {
	If (A_GuiControl="Scale Layer"){
		GR_Mode:=2
		DebugAffix("Now in layer mode")
		WriteIni(Profile,,"GR_Mode")
	}
}
Return

GR_Settings:  ;GR_Mode,GR_Width,GR_Height,GR_Interpolation
If (ChangingSetting="GR_Mode"){
	If (%A_GuiControl%=1 or %A_GuiControl%=2){
		%ChangingSetting% := %A_GuiControl%
		WriteIni(Profile,,"GR_Mode")
		DebugSet((%A_GuiControl%=2)?("Layer scale mode set"):("Image scale mode set"))
	} else {
		DebugSet("GR_Mode must be 1 or 2")
	}
} else {
	If (ChangingSetting="GR_Width" or ChangingSetting="GR_Height"){
		GR_InterpoLationInput := StrReplace(%A_GuiControl%, "*")
		GR_InterpoLationInput := StrReplace(GR_InterpoLationInput, "/")
		GR_InterpoLationInput := StrReplace(GR_InterpoLationInput, "+")
		GR_InterpoLationInput := StrReplace(GR_InterpoLationInput, "-")
		DebugAffix(GR_InterpoLationInput)
		If (IsNumber(GR_InterpoLationInput)){
			GoTo SettingsSuccess
		} else {
			DebugSet("GR_Width and GR_Height must be positive and numbers")
		}
	} else {
		If (ChangingSetting="GR_Interpolation"){
			If (%A_GuiControl%>=0 and %A_GuiControl%<=GR_MaxInterpolation and IsNumber(%A_GuiControl%)){
				GoTo SettingsSuccess
			} else {
				DebugSet("GR_Interpolation must be more than or equal to 0 and less than or equal to " GR_MaxInterpolation)
			}
		}
	} 
}
Return

GR_End: