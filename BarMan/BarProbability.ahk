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

MaxCount=100000
Segments=40
Segment=5
SegmentHeight=10
SegmentMargin=0
LazyResetPoint:=((MaxCount/100<2000)?(MaxCount/100):(2000))
Laziness=	;Sleep time. "" = no sleep

Loop, %Segments% {
	Count%A_Index%:=
	Gui, Add, Progress,% "xm w500 h" SegmentHeight " cBlue vCount" A_Index " BackgroundGray Range0-" MaxCount, 0
	Gui, Add, Text, yp x525,% A_Index*Segment-Segment "-" A_Index*Segment
}
Gui, Add, Button, xm, Reload
Gui, Add, Progress,% "xm w50 h" SegmentHeight " cBlue vHint BackgroundGray Range0-100", 0
Gui, Show, x%GuiLoadX% y%GuiLoadY%, %GuiTitle%

Loop, %MaxCount% {
	LazyCount++
	Count++
	If (Laziness!=""){
		Sleep, %Laziness%
	}
	Math:=round(200-nthRoot(Random(0,8000000),3))
	Loop, %Segments% {
		If ((Math<A_Index*Segment) and (Math>=(A_Index-1)*Segment)){
			Count%A_Index%++
		}
	}
	If (LazyCount>=LazyResetPoint){
		Loop, %Segments% { ;Get highest segment Count
			If (Count%A_Index%>HighestCount){
				HighestCount:=Count%A_Index%
			}
		}
		Loop, %Segments% { ;Update segments
			LazyCount=0
			GuiControl,, Hint,% Count "/" MaxCount
			GuiControl,,% "Count" A_Index,% Count%A_Index%/HighestCount*MaxCount
		}
	}
}
GuiControl,, Hint, Done!
Loop, %Segments% {
	GuiControl,,% "Count" A_Index,% Count%A_Index%/HighestCount*MaxCount
}
LazyCount:=, Count:=
Loop, %Segments%
	Count%A_Index%:=
Return

ButtonReload:
reload
Return

Random(1,2){
	Random, O, %1%, %2%
	Return O
}

nthRoot(x, n) 
{
	return x**(1/n)
}