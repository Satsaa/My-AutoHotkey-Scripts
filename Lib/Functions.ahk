;Independent scripts (local or static)
;Revision 5
;Added Target() TargetCancel()
;2018-05-30

RGBToHex(Red,Green,Blue){
	oldIntFormat := A_FormatInteger
	SetFormat, IntegerFast, hex
	RGB := subStr("0" subStr(Red & 255, 3), -1)
	. subStr("0" subStr(Green & 255, 3), -1)
	. subStr("0" subStr(Blue & 255, 3), -1)
	SetFormat, IntegerFast, %oldIntFormat%
	return RGB
}

HexToDec(HexVal){
	Old_A_FormatInteger := A_FormatInteger
	SetFormat IntegerFast, D
	DecVal := HexVal + 0
	SetFormat IntegerFast, %Old_A_FormatInteger%
	Return DecVal
}

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

PrefixNum(haystack){
Loop, Parse, haystack
{
	If A_LoopField is Number
		Parse .= A_LoopField
	else Break
}
Return Parse
}
SuffixNum(haystack){
DllCall("msvcrt\_" (A_IsUnicode ? "wcs":"str") "rev", "UInt",&haystack, "CDecl")
Loop, Parse, haystack
{
	If A_LoopField is Number
		Parse .= A_LoopField
	else Break
}
Return Parse
}

StrRev(in) {
	DllCall("msvcrt\_" (A_IsUnicode ? "wcs":"str") "rev", "UInt",&in, "CDecl")
	return in
}

ReadIni(Section="All",File="Prefs.ini",Keys*){
	for i, Key in Keys {
		if %Key%
			IniRead, %key%, %File%, %Section%,% key, %A_Space%
}}
WriteIni(Section="All",File="Prefs.ini",Keys*){
	for i, Key in Keys {
		if %Key%
			IniWrite,% %Key%, %File%, %Section%,% key
}}

Paste(data){	;Paste your string/char/num
	Clipboard= 
	Clipboard := data
	Clipwait, 1
	if ErrorLevel {
		DebugAppend("Paste failed at " %A_ThisLabel%)
		return 0
	} send ^v
	return 1
}

UrlEncode(String){	;Make Text URL friendly space=%20 etc
	OldFormat := A_FormatInteger
	SetFormat, Integer, H
	Loop, Parse, String 
	{
		if (A_LoopField is alnum) {
			Out .= A_LoopField
			continue
		}
		Hex := SubStr( Asc( A_LoopField ), 3 )
		Out .= "%" . ( StrLen( Hex ) = 1 ? "0" . Hex : Hex )
	}
	SetFormat, Integer, %OldFormat%

	return Out
}

MousePos(Choice="Save"){
	static X, Y
	if Choice = Save
		MouseGetPos, X, Y
	else if Choice = Restore
		MouseMove, X, Y
}

Beep(Pitch,Duration){	;The beep.ahk is used to work around the sleep caused by SoundBeep
	Run, "Lib\Beep.ahk" %Pitch% %Duration%,,
}

DebugAppend(Text=""){	;Append text into a control named Debug
	global DebugSetting
	Static Count = 0, String
	if (Text=""){
		GuiControl,1:, Debug, %String%
		Return
	} Count ++
	if (DebugSetting=1)
		GuiControl,1:, Debug, %Count%: %Text%`n%String%
	String:= Count ": " Text "`n" String
}

DebugSet(Text){
	GuiControl,1:, Debug, %Text%
}

AddToVar(Add=0,Var="Default",Set=""){
	static
	if !(Set="")
		%Var% := Set
	else %Var% += Add
	Return "x" %Var%
}

GuiAddX(Shift,Gui=1,Reset=0){
	static
	if reset
		%Gui%RowX=
	else if !%Gui%RowX 
		%Gui%RowX=20
	else %Gui%RowX += Shift
	Return "x" %Gui%RowX
}

GetLayout(){
	Return DllCall("GetKeyboardLayout", Int,DllCall("GetWindowThreadProcessId", int,WinActive("A"), Int,0))
}

;Shows a targetting "device" to gather coordinates. Returns x,y or -1 if cancelled
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
			} Else Gui FuncTargetMover:Hide
		} Else If (OnlyX and !OnlyY){
			If (MouseX<TargetX+20 and MouseX>TargetX-20){
				Gui FuncTargetMover:Show,% "y" MouseY-20
				TargetY := MouseY  ;Sync
			} Else Gui FuncTargetMover:Hide
		} Else If (OnlyY and !OnlyX){
			If (MouseY<TargetY+20 and MouseY>TargetY-20){
				Gui FuncTargetMover:Show,% "x" MouseX-24
				TargetX := MouseX  ;Sync
			} Else Gui FuncTargetMover:Hide
		} Else {  ;Disabled both lines 
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
					Else If OnlyY
						DeBugSet("y" MouseY "`nEnter to select`nEsc to cancel")
					Else DeBugSet("x" MouseX ", " "y" MouseY "`nEnter to select`nEsc to cancel")
				} else 
					sleep, 1  ;sleep if not moving
				PrevMouseX:=MouseX, PrevMouseY:=MouseY,
			}
		Gui FuncTargetMover:Show,% "x" MouseX-24 " y" MouseY-20
		}
		sleep, 1
	}  ;Close guis
	Gui FuncTargetMover:Cancel
	Gui FuncTargetHorizontal:Cancel
	Gui FuncTargetVertical:Cancel
	TargetTargeting=0
	If (GetKeyState("Esc") or FuncTargetCancel){  ;Cancelledd
		FuncTargetCancel=0
		Return -1
	} If OnlyX
		 Return TargetX
	Else If OnlyY
		 Return TargetY
	Else Return TargetX "," TargetY
}
TargetCancel(){
	Global FuncTargetCancel=1
}


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
