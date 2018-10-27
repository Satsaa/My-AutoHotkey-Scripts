#NoEnv
#MaxHotkeysPerInterval 99000000
#SingleInstance, force
#HotkeyInterval 99000000
#InstallKeybdHook
#UseHook
#KeyHistory 1000
ListLines, on
Process, Priority, , A
SetBatchLines, -1
SetControlDelay, 0
SetDefaultMouseSpeed, 0
SetKeyDelay, -1, -1
SetMouseDelay, -1
SetWinDelay, 0
SendMode Input
CoordMode, Pixel, Screen
CoordMode, Mouse, Screen
#Include %A_ScriptDir%\Include.ahk

GuiTitle := RegExReplace(A_ScriptName, ".ahk"),  ;Title for gui
ResDir := DirAscend(A_ScriptDir) "\Res",
Menu, Tray, Icon, %ResDir%\forsenBar.ico
ReadIniDefUndef(,,"GuiLoadY",100,"GuiloadX",100)
OnMessage(0x200,"WM_MOUSEMOVE")
OnMessage(0x2A2,"WM_NCMOUSELEAVE")
OnExit("SaveIni")
SaveIni(){
	global Profile, SC, Tab
	FileDelete, response.html
	Gui, 1: +LastFound
	WinGetPos,GuiX,GuiY,GuiW
	If !(GuiX<150-GuiW or GuiY<0){
		IniWrite, %GuiX%, Prefs.ini, All, GuiLoadX
		IniWrite, %GuiY%, Prefs.ini, All, GuiLoadY
	}
}


MaxIter=100000000  ;How many times to iterate
;HighestCount:=MaxIter  ;Uncomment for real proportions
StartValue:=-10, StartValue--  ;Value for first segment.
Segments=180  ;Number of segments
Segment=2  ;How large of a range of values a single segment presents.
SegmentHeight=6  ;Segment has an outline so at 3 pixels there will be 1 pixel for the visible portion!
SegmentMargin=1  ;Space between segments. Min 1
Laziness:=  ;Sleep time. Leave empty for no sleep.
UpdateIter:=(Laziness!="")?(0):(40000)  ;Max iterations between updates
LoadAnim := ["▝", "▘","▖","▗"]
MinFontSize:=6, MaxFontSize:=68
Gui, Font,% "c2d2d2d s" ((SegmentHeight-3<MinFontSize)?(MinFontSize):((SegmentHeight-3>MaxFontSize)?(MaxFontSize):(SegmentHeight-3))), Verdana
Loop, %Segments% {
	Count%A_Index%:=
	Gui, Add, Progress,% "x5 yp+" ((A_index!=1)?(SegmentHeight+SegmentMargin-2):(5)) " w500 h" SegmentHeight " c3fa3e2 Backgrounde2e2e2 vCount" A_Index " Range0-" MaxIter, 0
	If (Mod(A_Index-1, ceil((MinFontSize+1)/(SegmentHeight-1)))=0){
		Gui, Add, Text, yp x510 BackgroundTrans,% Round(A_Index*Segment-Segment+StartValue, ((InStr(Segment, "."))?(StrLen(Segment)-InStr(Segment, ".")):(0))) ((Segment="1")?(""):("-" Round(A_Index*Segment+StartValue, ((InStr(Segment, "."))?(StrLen(Segment)-InStr(Segment, ".")):(0)))))
	}
}
Gui, Font, 
Gui, Add, Button, xm gReload, &Reload
Gui, Add, Progress,% "yp+7 xp+50 w100 h10 c3fa3e2 Backgrounda5a5a5 vHint Range0-100", 0
Gui, Add, Text, yp-3 xp+105 w300 vAnim,
Gui, Show, x%GuiLoadX% y%GuiLoadY%, %GuiTitle%
Gui +hwndGuiHwnd

OldTick:=A_TickCount
Loop, %MaxIter% {
	LazyCount++
	Count++
	If (Laziness!=""){
		Sleep, %Laziness%
	}
	;Math:=round(random(-300,1125)*random(-300,1125)/10000-(random(0,1000)/100*9))+100
	;Math:=sqrt( -2.0 * log( random(0.0,1.0) ) ) * cos( 2.0 * 3.14159265359 * random(0.0,1.0) )
	;Math:=((sqrt(-2.0*log(random(0.0,1.0)))*cos(2.0*3.14159265359*random(0.0,1.0)))/10.0+0.5)**2.80)*(700-(-25))+(-25)
	
	Math:=RandomNormal(-5,1005,3.6)
	
	;poststring := "http://api.mathjs.org/v4/?expr=round(pow((sqrt(-2.0*log(random(0,1)))*cos(2.0*3.14159265359*random(0,1)))/10.0%2B0.5,3.6)*1005-5)"
	;URLDownloadToFile,%poststring%, response.html
	;fileread, Math, response.html

	temp:=Ceil(Math/Segment-StartValue/Segment)	;80 / 8 - -10
	;MsgBox,% temp ", " Math  ;Announce
	If (temp>=0)
		Count%temp%++
	;else MsgBox,% temp ", " Math  ;Announce underbound values
	If (LazyCount>=UpdateIter){
		LoadAnimIndex++
		If (LoadAnimIndex>LoadAnim.MaxIndex())
			LoadAnimIndex=1
		Loop, %Segments% { ;Get highest Segment value
			If (Count%A_Index%>HighestCount){
				HighestCount:=Count%A_Index%
			}
		}
		Loop, %Segments% { ;Update Segments
			LazyCount=0
			GuiControl,, Hint,% Count/MaxIter*100
			GuiControl,,% "Count" A_Index,% Count%A_Index%/HighestCount*MaxIter
		}
		;GuiControl,, Anim,% LoadAnim[LoadAnimIndex]
		GuiControl,, Anim,% Round((A_TickCount-OldTick)/Count*1000000) " ns per iteration. Highest probability " Round(HighestCount/Count*100,2)"%"
	}
}
GuiControl,, Anim,% Round((A_TickCount-OldTick)/MaxIter*1000000) " ns per iteration. Highest probability " Round(HighestCount/MaxIter*100,2)"%"
Loop, %Segments% { ;Get highest Segment value
	If (Count%A_Index%>HighestCount){
		HighestCount:=Count%A_Index%
	}
}
Loop, %Segments% { ;Update Segments
	GuiControl,, Hint,% Count/MaxIter*100
	GuiControl,,% "Count" A_Index,% Count%A_Index%/HighestCount*MaxIter
}
GuiControl, +CGreen, Hint,
GuiControl,, Hint, 100
Loop, %Segments% {
	GuiControl,,% "Count" A_Index,% Count%A_Index%/HighestCount*MaxIter
}
LazyCount:=, Count:=
Return

GuiClose:
Exitapp
Return

WM_MOUSEMOVE(){  ;On mouse move above script window
	global
	MouseGetPos, MouseX, MouseY
	If ((MouseX!=PrevMouseX or MouseY!=PrevMouseY) or Count){
		If (A_GuiControl and !InStr(A_GuiControl, "&")){
			ToolTip,% ((A_GuiControl="Hint")?(Round(Count/MaxIter*100,2)):(Round(SubStr(A_GuiControl, 6)*Segment-Segment+StartValue, ((InStr(Segment, "."))?(StrLen(Segment)-InStr(Segment, ".")):(0))) ((Segment="1")?(""):("-" Round(SubStr(A_GuiControl, 6)*Segment+StartValue, ((InStr(Segment, "."))?(StrLen(Segment)-InStr(Segment, ".")):(0))))) ": " ((%A_GuiControl%/((Count)?(Count):(MaxIter))*100>0.02)?(Round(%A_GuiControl%/((Count)?(Count):(MaxIter))*100,2)):(%A_GuiControl%/((Count)?(Count):(MaxIter))*100))))"% " ((A_GuiControl="Hint")?(((Count)?(Count):(MaxIter))" iterations." ):(""))
			PrevA_GuiControl:=A_GuiControl
		DebugDescription := "Description" StrReplace(StrReplace(A_GuiControl, "&"), " ")
		} else If (%PrevA_GuiControl%){
			ToolTip,% ((PrevA_GuiControl="Hint")?(Round(Count/MaxIter*100,2)):(Round(SubStr(PrevA_GuiControl, 6)*Segment-Segment+StartValue, ((InStr(Segment, "."))?(StrLen(Segment)-InStr(Segment, ".")):(0))) ((Segment="1")?(""):("-" Round(SubStr(PrevA_GuiControl, 6)*Segment+StartValue, ((InStr(Segment, "."))?(StrLen(Segment)-InStr(Segment, ".")):(0))))) ": " ((%PrevA_GuiControl%/((Count)?(Count):(MaxIter))*100>0.02)?(Round(%PrevA_GuiControl%/((Count)?(Count):(MaxIter))*100,2)):(%PrevA_GuiControl%/((Count)?(Count):(MaxIter))*100))))"% " ((PrevA_GuiControl="Hint")?(((Count)?(Count):(MaxIter))" iterations." ):(""))
		}
		PrevMouseX:=MouseX, PrevMouseY:=MouseY
	}
	SetTimer, ToolTipTimeout, Off
	SetTimer, ToolTipTimeout, 200
}
WM_NCMOUSELEAVE(){  ;On mouse leave script window
	ToolTip,
}
ToolTipTimeout:

ToolTip,
SetTimer, ToolTipTimeout, Off
Return

nthRoot(x, n) 
{
	return x**(1/n)
}