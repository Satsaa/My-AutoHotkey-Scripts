#NoEnv
#MaxHotkeysPerInterval 99000000
#SingleInstance force
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
;Menu, Tray, Icon, %ResDir%\forsenE.ico
ReadIniDefUndef(,,"GuiLoadY",100,"GuiloadX",100)
OnMessage(0x200,"WM_MOUSEMOVE")
OnMessage(0x2A2,"WM_NCMOUSELEAVE")
OnExit("SaveIni")
SaveIni(){
	global Profile, SC, Tab
	Gui, 1: +LastFound
	WinGetPos,GuiX,GuiY,GuiW
	If !(GuiX<150-GuiW or GuiY<0){
		IniWrite, %GuiX%, Prefs.ini, All, GuiLoadX
		IniWrite, %GuiY%, Prefs.ini, All, GuiLoadY
	}
}

MaxIter=10000000  ;How many times to iterate
;HighestCount:=MaxIter  ;Uncomment for non dynamic bars 
StartValue=-25  ;Value for first segment. Float at your own risk
Segments=250  ;Number of segments
Segment=1  ;How large of a range of values a single segment presents. Rather let this be non-float
SegmentHeight=5  ;Segment has an outline so at 3 pixels there will be 1 pixel for the main bar!
SegmentMargin=1  ;Space between segments. Min 1
Laziness:=  ;Sleep time. Leave empty for no sleep.
UpdateIter:=(Laziness!="")?(0):(40000)  ;Iterations between updates
LoadAnim := ["▝", "▘","▖","▗"]
MinFontSize:=5, MaxFontSize:=68
Gui, Font,% "cGray s" ((SegmentHeight-3<MinFontSize)?(MinFontSize):((SegmentHeight-3>MaxFontSize)?(MaxFontSize):(SegmentHeight-3))), Verdana
Loop, %Segments% {
	Count%A_Index%:=
	Gui, Add, Progress,% "x5 yp+" ((A_index!=1)?(SegmentHeight+SegmentMargin-2):(5)) " w500 h" SegmentHeight " c3fa3e2 Backgrounde2e2e2 vCount" A_Index " Range0-" MaxIter, 0
	Gui, Add, Text, yp x510 BackgroundTrans,% A_Index*Segment-Segment+StartValue+1 "-" A_Index*Segment+StartValue
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
	Math:=Round(Random(-300,1250)*Random(-300,1250)/10000-(random(0,1000)/100*10))+100

	;poststring := "http://api.mathjs.org/v4/?expr=(((round(random(-300,1250)*random(-300,1250)/10000-random(0,1000)/10)-100)*-1)-200)*-1"
	;URLDownloadToFile,%poststring%, response.html
	;fileread, Math, response.html
	temp:=Ceil(Math/Segment-StartValue/Segment)	;80 / 8 - -10
	;MsgBox,% temp ", " Math
	If (temp>=0)
		Count%temp%++
	;else MsgBox,% temp ", " Math
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
			ToolTip,% ((A_GuiControl="Hint")?(Round(Count/MaxIter*100,2)):(SubStr(A_GuiControl, 6)*Segment-Segment+StartValue+1 "-" SubStr(A_GuiControl, 6)*Segment+StartValue ": " ((%A_GuiControl%/((Count)?(Count):(MaxIter))*100>0.02)?(Round(%A_GuiControl%/((Count)?(Count):(MaxIter))*100,2)):(%A_GuiControl%/((Count)?(Count):(MaxIter))*100))))"%"
			PrevA_GuiControl:=A_GuiControl
		DebugDescription := "Description" StrReplace(StrReplace(A_GuiControl, "&"), " ")
		} else If (%PrevA_GuiControl%){
			ToolTip,% ((PrevA_GuiControl="Hint")?(Round(Count/MaxIter*100,2)):(SubStr(PrevA_GuiControl, 6)*Segment-Segment+StartValue+1 "-" SubStr(PrevA_GuiControl, 6)*Segment+StartValue ": " ((%PrevA_GuiControl%/((Count)?(Count):(MaxIter))*100>0.02)?(Round(%PrevA_GuiControl%/((Count)?(Count):(MaxIter))*100,2)):(%PrevA_GuiControl%/((Count)?(Count):(MaxIter))*100))))"%"
		}
		PrevMouseX:=MouseX, PrevMouseY:=MouseY
	}
	SetTimer, ToolTipTimeout, Off
	SetTimer, ToolTipTimeout, 100
}
WM_NCMOUSELEAVE(){  ;On mouse leave script window
	ToolTip,
}
ToolTipTimeout:

ToolTip,
SetTimer, ToolTipTimeout, Off
Return

Random(1,2){
	Random, O, %1%, %2%
	Return O
}

nthRoot(x, n) 
{
	return x**(1/n)
}
