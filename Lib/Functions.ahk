;Cross use functions
;Revision 8
;Added IsNumber().
;2018-06-01
;Format: HARDCORE

;#####################################################################################
;Conversions

HexToDec(HexVal){
	Old_A_FormatInteger := A_FormatInteger
	SetFormat IntegerFast, D
	DecVal := HexVal + 0
	SetFormat IntegerFast, %Old_A_FormatInteger%
	Return DecVal
}

RGBToHex(Red,Green,Blue){
	oldIntFormat := A_FormatInteger
	SetFormat, IntegerFast, hex
	RGB := subStr("0" subStr(Red & 255, 3), -1)
	. subStr("0" subStr(Green & 255, 3), -1)
	. subStr("0" subStr(Blue & 255, 3), -1)
	SetFormat, IntegerFast, %oldIntFormat%
	return RGB
}

;#####################################################################################
;Returns boolean. Compares if color in x,y is one in the Colors*  

CompareColor(X,Y,Colors*){
	PixelGetColor, PixelColor, %X%, %Y%
	for i, Color in Colors {
		StringLeft, ColorLeft, Color, 2
		If (ColorLeft!="0x")
			Color:="0x" Color
		if (Color=PixelColor){
			Return 1
	}} Return 0
}

;#####################################################################################
;Returns the number sequence from haystacks start (Prefix) or end (Suffix)

PrefixNum(haystack){
	Loop, Parse, haystack
	{
		If A_LoopField is Number
			Prefix .= A_LoopField
		else Break
	} Return Prefix
}

SuffixNum(haystack){
	DllCall("msvcrt\_" (A_IsUnicode ? "wcs":"str") "rev", "UInt",&haystack, "CDecl")
	Loop, Parse, haystack
	{
		If A_LoopField is Number
			Suffix .= A_LoopField
		else Break
	} DllCall("msvcrt\_" (A_IsUnicode ? "wcs":"str") "rev", "UInt",&Suffix, "CDecl") 
	Return Suffix
}

;#####################################################################################
;Returns reversed string

StrRev(in){
	DllCall("msvcrt\_" (A_IsUnicode ? "wcs":"str") "rev", "UInt",&in, "CDecl")
	return in
}

;#####################################################################################
;Returns reversed string

IsNumber(a){
	If %a% is Number
		return 1
	else return 0
}

;#####################################################################################
;Key(script var) = Key(ini value) will match when using these functions
;Read/write ini for Keys*. Keys* usage: Key, Key, Key... 

ReadIni(Section="All",File="Prefs.ini",Keys*){
	for i, Key in Keys {
		if %Key%
			IniRead, %key%, %File%, %Section%, %key%, %A_Space%
}}

WriteIni(Section="All",File="Prefs.ini",Keys*){
	for i, Key in Keys {
		if %Key%
			IniWrite,% %Key%, %File%, %Section%, %key%
}}

;Read ini for Keys* if not defined set it to next in Keys*. Keys* usage: Key, value, Key... 
ReadIniDefUndef(Section="All",File="Prefs.ini",Keys*){
	Global
	Static KeyWrite
	Local ii
	for i, Key in Keys {
		ii++
		if (ii=1){
			KeyWrite:=Key
			IniRead, %key%, %File%, %Section%,%key%, %A_Space%
		} else {
			ii=0
			If (%KeyWrite%=""){
				%KeyWrite%:=key
				IniWrite,% %KeyWrite%, %File%, %Section%, %KeyWrite%
}}}}

;#####################################################################################
;Fastest way to send text. Returns 1 for success, 0 for timeout

Paste(data){
	Clipboard= 
	Clipboard := data
	Clipwait, 1
	if ErrorLevel {
		DebugAffix("Paste failed at " %A_ThisLabel%)
		return 0
	} send ^v
	return 1
}

;#####################################################################################
;Returns string in a more url compatible format. " "=%20 etc

UrlEncode(String){
	OldFormat := A_FormatInteger
	SetFormat, Integer, H
	Loop, Parse, String 
	{
		if (A_LoopField is alnum){
			Encode .= A_LoopField
			continue
		} Hex := SubStr( Asc( A_LoopField ), 3 )
		Encode .= "%" . ( StrLen( Hex ) = 1 ? "0" . Hex : Hex )
	} SetFormat, Integer, %OldFormat%
	return Encode
}

;#####################################################################################
;Store mouse location or set to previous location. Enter "Save" or "Restore"

MousePos(Choice="Save"){
	static X, Y
	if Choice = Save
		MouseGetPos, X, Y
	else if Choice = Restore
		MouseMove, X, Y
}

;#####################################################################################
;The beep.ahk is used to work around the sleep caused by SoundBeep

Beep(Pitch,Duration){
	Run,% DirAscend(A_ScriptDir) "\Lib\Beep.ahk " Pitch " " Duration,,
}

;#####################################################################################
;Affix/Append to a string that is set to a control named Debug.
;Only shows if DebugSetting is 1. However, stored string is still updated
;Shows string text in debug if no input

DebugAffix(Text="",AddAffix=1){  
	Global DebugSetting
	Static Count = 0, String
	if (Text=""){
		GuiControl,1:, Debug, %String%
		Return
	} Count++
	If (AddAffix=1)
		String:= Count ": " Text "`n" String
	else String:= Text "`n" String
	if (DebugSetting=1)
		GuiControl,1:, Debug, %String%
}

DebugAppend(Text="",AddAffix=1){
	Global DebugSetting
	Static Count = 0, String
	if (Text=""){
		GuiControl,1:, Debug, %String%
		Return
	} Count++
	If (AddAffix=1)
		String:= ((Count=1)?(String Count ": " Text):(String "`n" Count ": " Text))
	else String:= ((Count=1)?(String Count Text):(String "`n" Text)) 
	if (DebugSetting=1)
		GuiControl,1:, Debug, %String%
}

;Sets text in control named Debug
DebugSet(Text){
	GuiControl,1:, Debug, %Text%
}

;#####################################################################################
;Bad way to do guis. Returns stored value and adds to it

AddToVar(Add=0,Var="Default",Set=""){
	static
	if !(Set="")
		%Var% := Set
	else %Var% += Add
	Return "x" %Var%
}

;#####################################################################################
;Returns accurately how many seconds have passed between QPC(1) and QPC(0)

QPC(R := 0)
{
    static P := 0, F := 0, Q := DllCall("QueryPerformanceFrequency", "Int64P", F)
    return ! DllCall("QueryPerformanceCounter", "Int64P", Q) + (R ? (P := Q) / F : (Q - P) / F) 
}

;#####################################################################################
;Returns path one or more folders up. 

DirAscend(Folder,Up=1){
	Loop, %Up% {
		SplitPath, Folder,,Folder,,,Drv
	} Return Folder
}

;#####################################################################################
;Returns keyboard layout id

GetLayout(){
	Return DllCall("GetKeyboardLayout", Int,DllCall("GetWindowThreadProcessId", int,WinActive("A"), Int,0))
}

;#####################################################################################
;Shows a targetting "device" to gather coordinates. Returns %x%,%y% or -1 if cancelled

Target(TargetX=-1, TargetY=-1, OnlyX:=0, OnlyY:=0){
	Static Init, DragID
	Global TargetTargeting, FuncTargetCancel
	TargetTargeting=1
	SysGet, VirtualWidth, 78
	SysGet, VirtualHeight, 79
	TargetCoord := []
	If (TargetX<0)
		TargetX:=A_ScreenWidth/2
	If (TargetY<0)
		TargetY:=A_ScreenHeight/2
	If !(Init){  ;Create guis
		Gui, FuncTargetHorizontal:Color, d85d52
		Gui, FuncTargetHorizontal:+LastFound +AlwaysOnTop -ToolWindow -Caption +Owner -Caption +E0x20
		WinSet, Transparent, 200,
		
		Gui, FuncTargetVertical:Color, d85d52
		Gui, FuncTargetVertical:+LastFound +AlwaysOnTop -ToolWindow -Caption +Owner -Caption +E0x20
		WinSet, Transparent, 200,
		
		Gui, FuncTargetMover:Color, EEAA99
		Gui, FuncTargetMover:Add, Pic,, Res/MoveCircleSmallHard.png
		Gui, FuncTargetMover:+LastFound +AlwaysOnTop -ToolWindow -Caption +Owner +HwndDragID
		WinSet, TransColor, EEAA99 
		Gui, FuncTargetMover:-Caption
		Init=1
	}  ;Show guis
	If !OnlyY
		Gui, FuncTargetVertical:Show, x%TargetX% y0 w1 h%VirtualHeight%
	If !OnlyX
		Gui, FuncTargetHorizontal:Show, x0 y%TargetY% h1 w%VirtualWidth%
	Gui FuncTargetMover:Show,% "x" TargetX-24 " y" TargetY-20
	;Start loopy loop
	While, (!GetKeyState("Enter") and !GetKeyState("Esc") and !FuncTargetCancel){  ;End when enter pressed or cancel with esc
		MouseGetPos, MouseX, MouseY, Window,
		If !(OnlyX or onlyY){  ;Check if mouse is close
			If (MouseX<TargetX+20 and MouseY<TargetY+20 and MouseX>TargetX-20 and MouseY>TargetY-20){
				Gui FuncTargetMover:Show,% "x" TargetX-24 " y" TargetY-20
			} else Gui FuncTargetMover:Hide
		} else If (OnlyX and !OnlyY){
			If (MouseX<TargetX+20 and MouseX>TargetX-20){
				Gui FuncTargetMover:Show,% "y" MouseY-20
				TargetY := MouseY  ;Sync
			} else Gui FuncTargetMover:Hide
		} else If (OnlyY and !OnlyX){
			If (MouseY<TargetY+20 and MouseY>TargetY-20){
				Gui FuncTargetMover:Show,% "x" MouseX-24
				TargetX := MouseX  ;Sync
			} else Gui FuncTargetMover:Hide
		} else {  ;Disabled both lines 
			MsgBox, Why the fuck did you disable both lines? We aint showing you any target now. %A_ThisFunc%( )
			FuncTargetCancel=0
			Return -1
		} If (GetKeyState("LButton") and (Window = DragID)){
			MouseMove, TargetX, TargetY
			Gui FuncTargetMover:Cancel
			While, ((GetKeyState("LButton")) and !FuncTargetCancel){  ;Drag
				MouseGetPos, MouseX, MouseY,
				If (MouseX!=PrevMouseX or MouseY!=PrevMouseY){  ;Check if mouse moved
					TargetX:=MouseX, TargetY:=MouseY
					Gui, FuncTargetHorizontal:+LastFound
					WinMove,, MouseY
					Gui, FuncTargetVertical:+LastFound
					WinMove, MouseX, 
					If OnlyX  ;Debug
						DeBugSet("x" MouseX "`nEnter to select`nEsc to cancel")
					else If (OnlyY)
						DeBugSet("y" MouseY "`nEnter to select`nEsc to cancel")
					else DeBugSet("x" MouseX ", " "y" MouseY "`nEnter to select`nEsc to cancel")
				} else sleep, 1  ;sleep if not moving
				PrevMouseX:=MouseX, PrevMouseY:=MouseY,
			}
		Gui FuncTargetMover:Show,% "x" MouseX-24 " y" MouseY-20
		} sleep, 1
	}  ;Close guis
	Gui FuncTargetMover:Cancel
	Gui FuncTargetHorizontal:Cancel
	Gui FuncTargetVertical:Cancel
	TargetTargeting=0
	If (GetKeyState("Esc") or FuncTargetCancel){  ;Cancelledd
		FuncTargetCancel=0
		Return -1
	} If (OnlyX)
		 Return TargetX
	else If (OnlyY)
		 Return TargetY
	else Return TargetX "," TargetY
}
TargetCancel(){
	Global FuncTargetCancel=1
}

;#####################################################################################
;Returns a lot of info about things uder your mouse.
;Laggy parts are separated and controlled by Subtick value.
;Laggy things are updated when the function is called %subtick% times 
;#####################################################################################

GetUnderMouseInfo(SubTick=1){
	static
	If (i>=SubTick or i=""){
		MouseGetPos, MouseX, MouseY, Window, Control
		PixelGetColor BGR_Color, MouseX, MouseY
		WinGetTitle Title, ahk_id %Window%
		WinGetClass Class, ahk_id %Window%
		WinGetPos WindowX, WindowY, Width, Height, ahk_id %Window%
		WinGet PName, ProcessName, ahk_id %Window%u
		WinGet PID, PID, ahk_id %Window%
		i=0
	} else
		MouseGetPos, MouseX, MouseY
	WindowInfo := "ahk_id " Window "`n"
		. "ahk_class " Class "`n"
		. "ahk_pid: " PID "`n"
		. "ahk_exe " PName "`n"
		. "title: " Title "`n"
		. "control: " Control "`n"
		. "top left (" WindowX ", " WindowY ")`n"
		. "(width x height) (" Width " x " Height ")`n"
		. "↖ Relative to corner (" MouseX-WindowX ", " MouseY-WindowY ")`n"
		. "↗ Relative to corner (" WindowX+Width-MouseX ", " MouseY-WindowY ")`n"
		. "↘ Relative to corner (" MouseX-WindowX ", " WindowY+Height-MouseY ")`n"
		. "↙ Relative to corner (" WindowX+Width-MouseX ", " WindowY+Height-MouseY ")`n"
		. "Mouse's screen pos (" MouseX ", " MouseY ")`n"
		. "BGR color: " BGR_Color " (" HexToDec("0x" SubStr(BGR_Color, 3, 2)) ", "
		. HexToDec("0x" SubStr(BGR_Color, 5, 2)) ", "
		. HexToDec("0x" SubStr(BGR_Color, 7, 2)) ")`n"
	i++
	Return WindowInfo
}

;#####################################################################################
