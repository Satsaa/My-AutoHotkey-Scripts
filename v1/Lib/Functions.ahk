﻿;Cross use functions

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
;Gives a similarity score for string A and B


Compare(StringA, StringB){
	Score := 0, SearchLength := 0, LengthA := StrLen(StringA), LengthB := StrLen(StringB)
	Loop % (LengthA < LengthB ? LengthA : LengthB) * 2 {
		If Mod(A_Index, 2)
			SearchLength += 1, Needle := "A", Haystack := "B"
		Else Needle := "B", Haystack := "A"
		StartAtHaystack := 1, StartAtNeedle := 1
		While (StartAtNeedle + SearchLength <= Length%Needle% + 1) {
			SearchText := SubStr(String%Needle%, StartAtNeedle, SearchLength)
			If (Pos := InStr(String%Haystack%, SearchText, 0, StartAtHaystack)) {
				StartAtHaystack := Pos + SearchLength, StartAtNeedle += SearchLength, Score += SearchLength**2
				If (StartAtHaystack + SearchLength > Length%Haystack% + 1)
					Break
			} Else StartAtNeedle += 1
	}} Return Score / (LengthA > LengthB ? LengthA : LengthB)
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
	RegExMatch(haystack, "\d*$", match)
	Return match
}
;#####################################################################################
;Returns reversed string

StrRev(in){
	DllCall("msvcrt\_" (A_IsUnicode ? "wcs":"str") "rev", "UInt",&in, "CDecl")
	return in
}

;#####################################################################################
;Returns string with a number of chars removed from the end

SubStrEnd(str,len=1){
	return SubStr(str,1,StrLen(var)-len)
}

;#####################################################################################
;Returns 1 if "a" is a number otherwise returns 0

IsNumber(a){
	If (a="")
		return 0
	If a is Number
		return 1
	else return 0
}

;#####################################################################################
;Clamps Val within Min and Max

Clamp(ByRef Val, Min, Max) {
	If (Val < Min)
		Val := Min
	If (Val > Max)
		Val := Max
}

;#####################################################################################
;Rotate coordinates. Clockwise and y down, x right.
;To ease usage, GetLastY must be used to get y variable from last call of Rotate()

Rotate(x=0, y=0, angle=0, cx=0, cy=0, GetLastY=0){
	static ny
	If (GetLastY){
		return ny
	}
	radians := (3.14159265359 / 180) * (angle * -1),
	cos := cos(radians),
	sin := sin(radians),
	ny := (cos * (y - cy)) - (sin * (x - cx)) + cy
	nx := (cos * (x - cx)) + (sin * (y - cy)) + cx,
	return nx
}

RotateX(x, y,angle, cx=0, cy=0){
	radians := (3.14159265359 / 180) * (angle * -1),
	nx := := (cos * (x - cx)) + (sin * (y - cy)) + cx,
	return nx
}
RotateY(x, y,angle, cx=0, cy=0){
	radians := (3.14159265359 / 180) * (angle * -1),
	ny := (cos * (y - cy)) - (sin * (x - cx)) + cy
	return ny
}

;#####################################################################################
;Get angle between 2 points. y down, x right.

Angle(x1,y1,x2,y2){
	Return atan2(y1 - y2, x2 - x1) * 180 / 3.14159265359 -90
}

;#####################################################################################
;Get distance between 2 points.

Distance(x1,y1,x2,y2){
	Return Sqrt((y2-y1)**2 + (x2-x1)**2)
}

;#####################################################################################
;Atan2 math function

Atan2(x,y) {  ;4-quadrant atan
	Return dllcall("msvcrt\atan2","Double",y, "Double",x, "CDECL Double")
}

;#####################################################################################
;Returns a random number. For float output, input floats, like (0.0,1.0).

Random(min=0, max=100) {
	Random, r, min, max
	Return r
}

;#####################################################################################
;Returns a random number generated with normal distribution in mind.

RandomNormal(min=0, max=100, skew=1) {
	Return ((sqrt( -2.0 * log( random(0.0,1.0) ) ) * cos( 2.0 * 3.14159265359 * random(0.0,1.0) ))/10.0 + 0.5)**skew*(max-min)+min
}

;#####################################################################################
;Returns Hotkey without typical modifers (!^+)

RemoveModifiers(Hotkey){
	Return RegExReplace(Hotkey, "^\+?\^?\!?")
}

;#####################################################################################
;Returns number with trailing zeroes removed. 10.00->10  4.380->4.38  120->120

TrimTrailingZeros(number) { 
	If number is float
		return regexReplace(number, "\.?0*$")
	else return number
}

;#####################################################################################
;Returns str without leading or trailing whitespace "	sd  `n"->"sd"

TrimWhitespace(str) {
	Return regexreplace(regexreplace(str, "^\s+"), "\s+$") ;trim beginning and ending whitespace
}


;#####################################################################################
;Key(script var) = Key(ini value) will match when using these functions
;Read/write ini for Keys*. Keys* usage: Key, Key, Key... 

ReadIni(Section="All",File="Prefs.ini",Keys*){
	global
	local key
	static i
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
	Local ii,i,key
	for i, Key in Keys {
		ii++
		if (ii=1){
			KeyWrite:=Key
			IniRead, %key%, %File%, %Section%, %key%, %A_Space%
		} else {
			ii=0
			If (%KeyWrite%=""){
				%KeyWrite%:=key
				IniWrite,% %KeyWrite%, %File%, %Section%, %KeyWrite%
}}}}

;#####################################################################################
;Deletes values or keys in an ini file in section or everywhere.
;Add "-" to section to remove keys/vals from other sections only

IniDelValues(Section=" ",File="Prefs.ini", Values*){
	FirstChar := SubStr(Section, 1, 1)
	If (FirstChar="-"){
		Uninclusive=1
		Section:=SubStr(Section, 2)
	}
	Loop, read, %File%
	{
		If (A_LoopReadLine){
			If (SubStr(A_LoopReadLine, 1, 1)="[")
				ParseSection := StrReplace(StrReplace(A_LoopReadLine, "["),"]") 
			else If ((!Uninclusive and (Section=" " or ParseSection=Section)) or (Uninclusive and ParseSection!=Section)){
				Loop, Parse, A_LoopReadLine, "="
				{
					If (A_Index=1)
						ParseKey := A_LoopField
					else For i, Value in Values
						{
							If (A_LoopField=Value){
								IniDelete, %File%, %ParseSection%, %ParseKey%
								Break
}}}}}}}

IniDelKeys(Section=" ",File="Prefs.ini", Keys*){
	FirstChar := SubStr(Section, 1, 1)
	If (FirstChar="-"){
		Uninclusive=1
		Section:=SubStr(Section, 2)
	}
	Loop, read, %File%
	{
		If (A_LoopReadLine){
			If (SubStr(A_LoopReadLine, 1, 1)="[")
				ParseSection := StrReplace(StrReplace(A_LoopReadLine, "["),"]") 
			else If ((!Uninclusive and (Section=" " or ParseSection=Section)) or (Uninclusive and ParseSection!=Section)){
				Loop, Parse, A_LoopReadLine, "="
				{
					For i, Key in Keys
					{
						If (A_LoopField=Key){
							IniDelete, %File%, %ParseSection%, %Key%
						} Break
}}}}}}


;#####################################################################################
;Fastest way to send text. Returns 1 for success, 0 for timeout

Paste(data, select = false){
  _handleKeyStates()
	Clipboard= 
	Clipboard := data
	Clipwait, 1
	if ErrorLevel {
		DebugPrepend("Paste failed at " %A_ThisLabel%)
    _handleKeyStates(true)
		return 0
	}
  lefts := strLen(data) - 2
  send ^v
  sleep, 16
  if (select) {
    send {Left}{Shift down}{Left %lefts%}{Shift up}
  }
  _handleKeyStates(true)
	return 1
}

_handleKeyStates(reset = false){
  static _Shift, _Ctrl, _Alt
  sleep 1
  if (reset) {
    if (!_Ctrl) {
      send {Ctrl down}
    }
    if (!_Alt) {
      send {Alt down}
    }
    if (!_Shift) {
      send {Shift down}
    }
  } else {
    If GetKeyState("Control","P") {
      _Ctrl = true
    } else {
      _Ctrl = false
    }
    If GetKeyState("Alt","P") {
      _Alt = true
    } else {
      _Alt = false
    }
    If GetKeyState("Shift","P") {
      _Shift = true
    } else {
      _Shift = false
    }
    send {Ctrl up}
    send {Alt up}
    send {Shift up}
  }
}

;#####################################################################################
;Save or restore clipboard contents

Clipboard(c=1){  ;1 to save. Otherwise restore.
	static
	If (c=1){
		s:=ClipboardAll
		Clipboard=
	} else {
		Clipboard:=s
	}
}

;#####################################################################################
;Returns time in Y years, D days, MM:HH:SS

FormatSeconds(TimeSec){
	Years:=Floor(TimeSec/31536000)
	TimeLeftOver:=Mod(TimeSec,31536000)
	Days:=Floor(TimeLeftOver/86400)
	TimeLeftOver:=Mod(TimeSec,86400)
	Hours:=Floor(TimeLeftOver/3600)
	TimeLeftOver:=Mod(TimeSec,3600)
	Mins:=Floor(TimeLeftOver/60)
	TimeLeftOver:=Mod(TimeSec,60)
	Secs:=Floor(TimeLeftOver)
	Return ((Years=0)?(""):(Years " years, ")) ((Days=0)?(""):(Days " days, ")) ((StrLen(Hours)=1)?("0" Hours):(Hours)) ":" ((StrLen(Mins)=1)?("0" Mins):(Mins)) ":" ((StrLen(Secs)=1)?("0" Secs):(Secs))
}

;#####################################################################################
;Returns string converted into url compatible format. " "=%20 etc

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
;Prepend/Append to a string that is set to a control named Debug.
;Prepend and Append work independently and dont share strings. 
;Only updates if DebugSetting is 1. However, stored string is still updated.
;Calling without defining text will update/show current debug text.

DebugPrepend(Text="",AddPrefix=1,force=0){  
	Global DebugSetting, Debug_PrevText
	Static Count = 0, String
  Debug_PrevText := ""
	if (Text=""){
		GuiControl,1:, Debug, %String%
		Return
	} Count++
	If (AddPrefix=1)
		String:= Count ": " Text "`n" String
	else String:= Text "`n" String
	if (DebugSetting=1 or force=1)
		GuiControl,1:, Debug, %String%
}

DebugAppend(Text="",AddPrefix=1,force=0){
	Global DebugSetting, Debug_PrevText
	Static Count = 0, String
  Debug_PrevText := ""
	if (Text=""){
		GuiControl,1:, Debug, %String%
		Return
	} Count++
	If (AddPrefix=1)
		String:= ((Count=1)?(String Count ": " Text):(String "`n" Count ": " Text))
	else String:= ((Count=1)?(String Count Text):(String "`n" Text)) 
	if (DebugSetting=1 or force=1)
		GuiControl,1:, Debug, %String%
}

;Sets text in control named Debug
DebugSet(Text){
  Global Debug_PrevText
  if (Debug_PrevText != Text){
  	GuiControl,1:, Debug, %Text%
  }
  Debug_PrevText := Text
}

;#####################################################################################
;Bad way to do guis. Returns stored value and adds to it

GuiAddX(Add=0,Var="Default",Set=""){
	static
	if !(Set="")
		%Var% := Set
	else %Var% += Add
	Return "x" %Var%
}


;#####################################################################################
;Move gui inside screen bounds partially or completely.
;Takes traywnd in to account but doesnt care how its positioned!

MoveGuiToBounds(Gui,Aggressive=0){
	SysGet, VW, 78
	SysGet, VH, 79
	Gui, %Gui%: +LastFound
	WinGetPos, GX, GY, GW, GH,
	WinGetPos,,,, TBH, ahk_class Shell_TrayWnd
	if (TBH = "")
		TBH = 40 ; Get pos fails e.g. when the start menu is open
	If (Aggressive=1)
		Gui, %Gui%:Show,% ((GX<0)?(" x-2 "):(((GX+GW>VW)?(" x" VW-GW+2):("")))) ((GY<0)?(" y0 "):(((GY+GH>VH-TBH-2)?(" y" VH-GH-TBH+2):(""))))
	else Gui, %Gui%:Show,% ((GX+GW<0)?(" x-2 "):(((GX>VW)?(" x" VW-GW+2):("")))) ((GY+GH<0)?(" y0 "):(((GY>VH-TBH-2)?(" y" VH-GH-TBH+2):(""))))
}

;#####################################################################################
;Returns accurately how many seconds have passed between QPC(1) and QPC(0)

QPC(R := 0){
  static P := 0, F := 0, Q := DllCall("QueryPerformanceFrequency", "Int64P", F)
  return ! DllCall("QueryPerformanceCounter", "Int64P", Q) + (R ? (P := Q) / F : (Q - P) / F) 
}

;#####################################################################################
;Returns path one or more folders up. 

DirAscend(Folder,Up=1){
	Loop, %Up% {
		SplitPath, Folder,,Folder,,,Drv
	}
	Return Folder
}

;#####################################################################################
;Returns keyboard layout id

GetLayout(){
	Return DllCall("GetKeyboardLayout", Int,DllCall("GetWindowThreadProcessId", int,WinActive("A"), Int,0))
}

;#####################################################################################
;Hide or show cursor

SystemCursor(OnOff=1){  ; INIT = "I","Init"; OFF = 0,"Off"; TOGGLE = -1,"T","Toggle"; ON = others
   static AndMask, XorMask, $, h_cursor
      ,c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13  ; system cursors
        , b1,b2,b3,b4,b5,b6,b7,b8,b9,b10,b11,b12,b13  ; blank cursors
        , h1,h2,h3,h4,h5,h6,h7,h8,h9,h10,h11,h12,h13  ; handles of default cursors
   if (OnOff = "Init" or OnOff = "I" or $ = "")       ; init when requested or at first call
   {
      $ = h                                           ; active default cursors
      VarSetCapacity( h_cursor,4444, 1 )
      VarSetCapacity( AndMask, 32*4, 0xFF )
      VarSetCapacity( XorMask, 32*4, 0 )
      system_cursors = 32512,32513,32514,32515,32516,32642,32643,32644,32645,32646,32648,32649,32650
      StringSplit c, system_cursors, `,
      Loop %c0%
      {
         h_cursor   := DllCall( "LoadCursor", "uint",0, "uint",c%A_Index% )
         h%A_Index% := DllCall( "CopyImage",  "uint",h_cursor, "uint",2, "int",0, "int",0, "uint",0 )
         b%A_Index% := DllCall("CreateCursor","uint",0, "int",0, "int",0
                             , "int",32, "int",32, "uint",&AndMask, "uint",&XorMask )
      }
   }
   if (OnOff = 0 or OnOff = "Off" or $ = "h" and (OnOff < 0 or OnOff = "Toggle" or OnOff = "T"))
      $ = b       ; use blank cursors
   else
      $ = h       ; use the saved cursors

   Loop %c0%
   {
      h_cursor := DllCall( "CopyImage", "uint",%$%%A_Index%, "uint",2, "int",0, "int",0, "uint",0 )
      DllCall( "SetSystemCursor", "uint",h_cursor, "uint",c%A_Index% )
   }
}

;#####################################################################################
;Shows a targetting "device" to gather coordinates. Returns %x%,%y% or -1 if cancelled

Target(TargetX=-1, TargetY=-1, OnlyX:=0, OnlyY:=0){
	Static DragID
	Global FuncTargetCancel, ResDir
	While, (GetKeyState("Enter","P") or GetKeyState("Esc","P")){  ;Dont immediately exit when Target() is called when enter/esc is already pressed
		sleep, 100
	}
	Radius=15
	SysGet, VirtualWidth, 78
	SysGet, VirtualHeight, 79
	TargetCoord := []
	If (TargetX<0)
		TargetX:=A_ScreenWidth/2
	If (TargetY<0)
		TargetY:=A_ScreenHeight/2
	If !(Init){  ;Create guis
		Gui, FuncTargetHorizontal:Color, d85d52
		Gui, FuncTargetHorizontal:+LastFound +AlwaysOnTop -ToolWindow -Caption +Owner -Caption +E0x20 HwndWinY
		WinSet, Transparent, 200,
		
		Gui, FuncTargetVertical:Color, d85d52
		Gui, FuncTargetVertical:+LastFound +AlwaysOnTop -ToolWindow -Caption +Owner -Caption +E0x20 HwndWinX
		WinSet, Transparent, 200,
		
		Gui, FuncTargetMover:Add, Pic,, %ResDir%\Drag\CircleHard.png
		Gui, FuncTargetMover:+LastFound +AlwaysOnTop -ToolWindow -Caption +Owner +HwndDragID
		WinSet, Transparent, 1,
		Gui, FuncTargetMover:-Caption
	}  ;Show guis
	If !OnlyY
		Gui, FuncTargetVertical:Show, x%TargetX% y0 w1 h%VirtualHeight%
	If !OnlyX
		Gui, FuncTargetHorizontal:Show, x0 y%TargetY% h1 w%VirtualWidth%
	Gui FuncTargetMover:Show,% "x" TargetX-24 " y" TargetY-20
	While, (GetKeyState("Enter","P") and GetKeyState("Esc","P")){  ;Wait that exit keys are lifted before showing target
		sleep, 100
	}
	;Start loopy loop
	While, (!GetKeyState("Enter","P") and !GetKeyState("Esc","P") and !FuncTargetCancel){  ;End when enter pressed or cancel with esc
		MouseGetPos, MouseX, MouseY, Window,
		If !(OnlyX or onlyY){  ;Check if mouse is close
			If (MouseX<TargetX+Radius and MouseY<TargetY+Radius and MouseX>TargetX-Radius and MouseY>TargetY-Radius){
				Gui, FuncTargetVertical:Color, 21a831
				Gui, FuncTargetHorizontal:Color, 21a831
				WinMove, ahk_id %DragId%,, TargetX-24, TargetY-20,
			} else {
				Gui, FuncTargetVertical:Color, d85d52
				Gui, FuncTargetHorizontal:Color, d85d52
				WinMove, ahk_id %DragId%,, -100,-100
			}
		} else If (OnlyX and !OnlyY){
			If (MouseX<TargetX+Radius and MouseX>TargetX-Radius){
				Gui, FuncTargetVertical:Color, 21a831
				WinMove, ahk_id %DragId%,, TargetX-24, MouseY-20,
				TargetY := MouseY  ;Sync
			} else {
				Gui, FuncTargetVertical:Color, d85d52
				WinMove, ahk_id %DragId%,, -100,-100
			}
		} else If (OnlyY and !OnlyX){
			If (MouseY<TargetY+Radius and MouseY>TargetY-Radius){
				Gui, FuncTargetHorizontal:Color, 21a831
				WinMove, ahk_id %DragId%,, MouseX-24, TargetY-20,
				TargetX := MouseX  ;Sync
			} else {
				Gui, FuncTargetHorizontal:Color, d85d52
				WinMove, ahk_id %DragId%,, -100,-100
			}
		} else {  ;Disabled both lines 
			MsgBox, Why the fuck did you disable both lines? We aint showing you any target now. %A_ThisFunc%() `n Both axises were disabled.
			FuncTargetCancel=0
			Return -1
		} If (GetKeyState("LButton","P") and (Window = DragID)){
			MouseMove, TargetX, TargetY
			WinMove, ahk_id %DragId%,, -100,-100
			While, ((GetKeyState("LButton","P")) and !FuncTargetCancel){  ;Drag
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
			WinMove, ahk_id %DragId%,, MouseX-24, MouseY-20,
		}
		sleep, 1
	}  ;Close guis
	Gui FuncTargetMover:Cancel
	Gui FuncTargetHorizontal:Cancel
	Gui FuncTargetVertical:Cancel
	If (GetKeyState("Esc") or FuncTargetCancel){  ;Cancelled
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
;Laggy things are updated when the function is called %subtick% times.
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
		. "Mouse screen pos (" MouseX ", " MouseY ")`n"
		. "BGR color: " BGR_Color " (" HexToDec("0x" SubStr(BGR_Color, 3, 2)) ", "
		. HexToDec("0x" SubStr(BGR_Color, 5, 2)) ", "
		. HexToDec("0x" SubStr(BGR_Color, 7, 2)) ")`n"
	i++
	Return WindowInfo
}

;#####################################################################################
