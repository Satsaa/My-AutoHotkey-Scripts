#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
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
#Include %A_ScriptDir%\Descriptions.txt



;These keys are assigned to Dota2 hotkeys (items, courier etc)
CustomKey1  := "F13", CustomKey2  := "F14", CustomKey3  := "F15",
CustomKey4  := "F16", CustomKey5  := "F17", CustomKey6  := "F18",
CustomKey7  := "F19", CustomKey8  := "F20", CustomKey9  := "F21",
CustomKey10 := "F22", CustomKey11 := "F23", CustomKey12 := "F24",
HotkeyName := [], HotkeySub := [], HotkeyDescription := [], HotkeySettings := [], HotkeySettingsDescription := [],
HotkeyShIft := [], HotkeyAlt := [], HotkeyCtrlAlt := [], HotkeyCtrlShIft := [], 
HotkeyPrev := [], HotkeyGlobalPrev := [],
TPS := 64,  ;Not precise, refreshes per second max 64
MaxPerColumn := 8,  ;Initial maximum amount of hotkeys per column
HotkeySize := 120,  ;Width for hotkey controls
SettingSize := 40,  ;Width for settings edit boxes
ButtonSize := 50,
Ru := -265092071, Fi := 67830793,	;Input layout codes
Profile := "Default",
Version := "v4.2",
GuiTitle := RegExReplace(A_ScriptName, ".ahk"),  ;Title for gui
ResDir := DirAscend(A_ScriptDir) "\Res",
Layout := GetLayout()
Menu, Tray, Icon, %ResDir%\forsenE.ico
SysGet, VirtualWidth, 78
SysGet, VirtualHeight, 79
ReadIniDefUndef(,,"FirstLoad",1,"GuiLoadY",100,"GuiloadX",100)
If (FirstLoad){
	FirstLoad=0
	Greet:
	MsgBox, 4, Warning, Made by Satsaa`n`nVery nice
	IfMsgBox, No 
	{	GreetFails++
	If GreetFails=1
		MsgBox, 16, Error, Please be nice :), 2
	else If GreetFails=2
		MsgBox, 16, Error, Stop being a fokken chunt, 2
	else If GreetFails=3
		MsgBox, 16, Error, WOW! You are so funnyy xD, 2
	else If (GreetFails>=4 and GreetFails<69)
		MsgBox, 16, Error, Treasure awaits!`n`nYou have been resilient %GreetFails% times. Can you make it to 69?,
	else If GreetFails=69
		GoTo SecretLevel
	GoTo, Greet
	} WriteIni(,,"FirstLoad")
}
GoSub LoadScripts  ;Load scripts and their init values etc
If Mod(SC, MaxPerColumn)  ;Calculate nice hotkey button layout
	MaxPerColumn := Ceil(SC/((SC - Mod(SC, MaxPerColumn))/MaxPerColumn + 1))
MaxGuiHeight := (48*MaxPerColumn)
Hotkey, ~!ShIft, LayoutFi
Hotkey, ~+Alt, LayoutRu
Gui, Add, Tab3,% " gTabControl vTab -wrap w" (HotkeySize+10)*Ceil(SC/(MaxPerColumn))+11, Hotkeys|Globals|Settings|%GuiTitle%
Tab = Hotkeys
Gui, Tab, Hotkeys
AddToVar(,,-HotkeySize+9)
Loop, %SC% {  ;HOTKEYS
	If !(Mod(A_Index-1, MaxPerColumn))  ;New row of hotkeys
		Gui, Add, Text,% "y34 " AddToVar(HotkeySize+10),% RegExReplace(HotkeyName[A_Index], "_" , " ")
	else  ;Continue the row
		Gui, Add, Text,,% RegExReplace(HotkeyName[A_Index], "_" , " ")
	Gui, Add, Hotkey,% "v" A_Index  " gHotkeyCreate w" HotkeySize 
}
Loop, %SC%
	Gui, Add, Text,% "vSpecialText" A_Index " x-25 y-25 w22" , 
Gui, Tab,
Gui, Add, Text, ym, Debug view
Gui, Add, Edit,% "Readonly w255 vDebug h"MaxGuiHeight
Gui, Add, Button, w%ButtonSize% ym gReload, &Reload
Gui, Add, Button, w%ButtonSize%, &Hide
Gui, Add, Button, w%ButtonSize% gEdit, &Edit
Gui, Add, Button, w%ButtonSize%, &Test
Gui, Add, Text, cRed vGuiHint wp r1
Gui, Add, Text, cRed vTickTime wp r1
Gui, Add, Button,% (MaxGuiHeight <253)?("gDefaultOverride w" ButtonSize " ym"):("gDefaultOverride wp xp y"MaxGuiHeight-85), Default
Gui, Add, Button, w%ButtonSize% gDotaOverride, Dota
Gui, Add, Button, w%ButtonSize% gPubgOverride, Pubg
Gui, Add, Button, w%ButtonSize% gWitcherOverride, Witcher
Gui, Tab, Globals
AddToVar(,"Globals",-HotkeySize+9)
Loop, %SC% {  ;GLOBAL hotkeys
	If !(Mod(A_Index-1, MaxPerColumn))  ;New row of hotkeys
		Gui, Add, Text,% "y34 " AddToVar(HotkeySize+10,"Globals"),% RegExReplace(HotkeyName[A_Index], "_" , " ")
	else  ;Continue the row
		Gui, Add, Text,,% RegExReplace(HotkeyName[A_Index], "_" , " ")
	Gui, Add, Hotkey,% "v" A_Index  "Global gGlobalHotkeyCreate w" HotkeySize 
}
Gui, Tab, Settings  ;BuildSettingsTab
AddToVar(,"Settings",-HotkeySize+9)
Loop, %SC% {  ;SETTING list
	If !(Mod(A_Index-1, MaxPerColumn))  ;New row of settings
		Gui, Add, Text,% "y34 " AddToVar(HotkeySize+10,"Settings"),% RegExReplace(HotkeyName[A_Index], "_" , " ")
	else  ;Continue the row
		Gui, Add, Text,,% RegExReplace(HotkeyName[A_Index], "_" , " ")
	If (HotkeySettings[A_Index]){
		temp=
		Loop, Parse,% HotkeySettings[A_Index], `,  ;Parse script settings list array 
		{
			If A_Index=1
				FirstSetting:=A_LoopField
			temp.=A_LoopField "|"
		}
		temp:=SubStr(temp,1,StrLen(temp)-1)
		gui, font, s8, Tahoma
		Gui, Add, DropDownList,% "v" A_Index "Settings gSettingUpdate Choose1 w" HotkeySize-((SettingSize*1)+5), %temp%
		gui, font,
		Gui, Add, Edit,% "w" SettingSize " v" A_Index "SettingsEdit gSettingsEdit r1 yp xp",% %FirstSetting%
	} else {
		Gui, Add, DropDownList, Disabled w%HotkeySize%, 
}}
Loop, %SC% {  ;Conveniently fix edit box positioning
	CurrentColumn := (Floor((A_Index-1)/MaxPerColumn))+1
	GuiControl, Move, %A_Index%SettingsEdit,% "x+" (HotkeySize-(SettingSize-7))+((CurrentColumn-1)*(HotkeySize+10))
}
Gui, Tab, %GuiTitle%
Gui, Add, Button, w%HotkeySize% gExportProfile, Export Profile
Gui, Add, Button, w%HotkeySize% gInportProfile, Inport Profile
Gui, Tab,
Gui, Add, StatusBar,,
Loop, %SC%
	Gui, Add, Text,% "vSpecialText" A_Index "Global x-25 y-25 w22" ,
If !GuiLoadY or !GuiLoadY
	GuiLoadY := 0, GuiLoadX := 0
RestoreHotkeys()
LoadGlobalHotkeys()
SB_SetParts(71, 63)
Gosub SB_Profile
Gosub SB_Layout
Gosub SB_Title
OnExit("SaveIni")
OnMessage(0x200,"WM_MOUSEMOVE")
OnMessage(0x2A2,"WM_NCMOUSELEAVE")
Gui, Show, x%GuiLoadX% y%GuiLoadY%, %GuiTitle%
DebugAffix("Finished Load")
SetTimer, TickPerSec, 1000
SetTimer, DoTick,% 1000/TPS
Return

ExportProfile:
If (ExportWindowExists){
	Gui, Export:Show
	Return
}ExportIndex=0
ExportCurrentSection=
Gui, Export:Add, Text,, Which sections to export
Loop, read, Prefs.ini
{
    Loop, parse, A_LoopReadLine, %A_Tab%
    {
		If (SubStr(A_LoopField, "1", "1")="["){
			ExportIndex++
			ExportSection:=RegExReplace(A_LoopField, "\[|\]")
			ExportSection%ExportIndex% := A_LoopField
			Gui, Export:Add, Checkbox, gExportCheckbox vExportCheckbox%ExportIndex% Checked, %A_LoopField%
			Export%ExportIndex% := A_LoopField
		} else {
			ExportSection%ExportIndex% .= "`n" A_LoopField
		}

    }
}
Gui, Export:Add, Button, gExportExport, Export
Gui, Export:Add, Text, ym, Output preview
Gui, Export:Add, Edit, Readonly w400 h500 vExportPreview
ExportWindowExists=1
DebugAffix("Export Gui Created")
Gui, Export:Show
Gui, Export:Submit, NoHide
Export=
Loop {
	If (ExportCheckbox%A_Index%){
		Export .= (Export)?( "`n`n" ExportSection%A_Index%):(ExportSection%A_Index%)
	}
	else If (A_Index>ExportIndex)
		Break
}
GuiControl,Export:, ExportPreview,% Export
Return

ExportCheckbox:
Gui, Export:Submit, NoHide
ExportCheckboxID := SuffixNum(A_GuiControl)
Export=
Loop {
	If (ExportCheckbox%A_Index%){
		Export .= (Export)?( "`n`n" ExportSection%A_Index%):(ExportSection%A_Index%)
	}
	else If (A_Index>ExportIndex)
		Break
}
GuiControl,Export:, ExportPreview,% Export
Return
ExportExport:
FileSelectFile, ExportFullPath, S 24, RootDir\ScriptFagExport.txt,, *.txt
If !(ExportFullPath=""){
	FileDelete, %ExportFullPath%
	FileAppend, %Export%, %ExportFullPath%
	If ErrorLevel
		MsgBox, Error saving file
	else MsgBox, Saved to %ExportFullPath%
} Else Return
;No return
ExportGuiClose:
ExportWindowExists=0
Gui, Export:Destroy
DebugAffix("Export Gui Destroyed")
Return

InportProfile:
Gui, Submit, NoHide
DebugAffix(A_ThisLabel)
Return

DoTick:
Tick ++
DoubleTick ++
SubTick ++
OldActiveTitle = %ActiveTitle%
WinGetActiveTitle, ActiveTitle
If (OldActiveTitle!=ActiveTitle and ActiveTitle and ActiveTitle!=GuiTitle  ;Activates on window change (ignores some changes)
	and ActiveTitle!=PrevActiveTitle and ActiveTitle!=A_ScriptName){
	GoSub DotaHotkeys
	GoSub PubgHotkeys
	GoSub WitcherHotkeys
	Gosub SB_Title
	FH_Enable=0
	If InStr(ActiveTitle, "| Flickr -")
		FH_Enable=1
	If (ActiveTitle="This is an unregistered copy")
		WinClose, This is an unregistered copy
	PrevActiveTitle = %ActiveTitle%
}

If (DoubleTick=2){
	If DebugSetting=2
		DebugSet(GetUnderMouseInfo(TPS/4))  ;Full update 2 times a second (TPS)
	DoubleTick=0
}
If (SubTick=10){
	If FH_Enable
		GoSub, FlickerHide
	SubTick=0
}
GuiControl, , GuiHint,% Tick
Return

TickPerSec:
TickEnd := Tick
If (TickEnd - TickStart < 1)
	GuiControl, Hide, TickTime,
else {
	GuiControl, Show, TickTime,
	If (TickEnd - TickStart = TPS)
		GuiControl,, TickTime,% (TickEnd - TickStart) " tps*"
	else GuiControl,, TickTime,% (TickEnd - TickStart) " tps"
}
TickStart := Tick
Return

WM_MOUSEMOVE(){  ;Description handling
global
If (SubStr(A_GuiControl, "1", "1")="[")  ;Ignore controls with "[" to avoid errors
	Return
If (A_GuiControl=PrevA_GuiControl)
	Return
PrevA_GuiControl:=A_GuiControl
If !(A_GuiControl)
	If (DebugSetting=1 and Tab!="Settings")
		DebugAffix()
GuiControlPrefix := PrefixNum(A_GuiControl)
If (GuiControlPrefix){
	If (DebugSetting=1){
		If (Tab="Settings"){
			If (HotkeySettingsDescription[GuiControlPrefix])
				DebugSet(StrReplace(HotkeyName[GuiControlPrefix], "_", " ") "`n`n" HotkeySettingsDescription[GuiControlPrefix])
			else 
				DebugAffix(HotkeyName[GuiControlPrefix] " has no settings description!")
		} else 
			DebugSet(StrReplace(HotkeyName[GuiControlPrefix], "_", " ") "`n`n" HotkeyDescription[GuiControlPrefix])
	}
}else{
	DebugDescription := "Description" StrReplace(StrReplace(A_GuiControl, "&"), " ")
	If !(%DebugDescription%){
		%DebugDescription%:="Undescribed"
		FileAppend,% "`n" DebugDescription " = Undescribed", Descriptions.txt,
		DebugAffix(A_GuiControl " added to Descriptions.txt")
	}
	else If (%DebugDescription%!="Undescribed"){
		If (DebugSetting=1)
			DebugSet(%DebugDescription%)
	}  ;else DebugSet(DebugDescription)  ;Uncomment to show undescribed. For example DescriptionDebug, DescriptionDefaultProfile
}}
WM_NCMOUSELEAVE(){
	Global
	If (DebugSetting=1 and Tab!="Settings")
		DebugAffix()
}

GlobalHotkeyCreate:
StringTrimRight, CreateName, A_GuiControl, 6  ;"Global"
PrevName := "HotkeyGlobalPrev"
GoTo CreateStart

HotkeyCreate:
CreateName := A_GuiControl
PrevName := "HotkeyPrev"
GoTo CreateStart

CreateStart:
;Invalidate hotkeys with modIfiers
If InStr(%A_GuiControl%, "+")  ;ShIft
	GoTo InvalidHotkeyCreate
If InStr(%A_GuiControl%, "^")  ;Control
	GoTo InvalidHotkeyCreate
If InStr(%A_GuiControl%, "!")  ;Alt
	GoTo InvalidHotkeyCreate
If GetKeyState("RWin","P"){      ;Windows
	DebugSet("Windows key")
	GoTo InvalidHotkeyCreate
}  
;Create new hotkeys and disable old ones
If (HotkeyShIft[CreateName]){
	Hotkey,% "+"%PrevName%[CreateName], Off, UseErrorLevel
	Hotkey,% "+"%A_GuiControl%,% HotkeySub[CreateName] . "_ShIft"
	Hotkey,% "+"%A_GuiControl%, On
}
If (HotkeyAlt[A_Index]) {
	Hotkey,% "!"%PrevName%[CreateName], Off, UseErrorLevel
	Hotkey,% "!"%A_GuiControl%,% HotkeySub[CreateName] . "_Alt"
	Hotkey,% "!"%A_GuiControl%, On
}
If (HotkeyCtrlAlt[A_Index]) {
	Hotkey,% "^!"%PrevName%[CreateName], Off, UseErrorLevel
	Hotkey,% "^!"%A_GuiControl%,% HotkeySub[CreateName] . "_CtrlAlt"
	Hotkey,% "^!"%A_GuiControl%, On
}
If (HotkeyCtrlShIft[A_Index]) {
	Hotkey,% "^+"%PrevName%[CreateName], Off, UseErrorLevel
	Hotkey,% "^+"%A_GuiControl%,% HotkeySub[CreateName] . "_CtrlShIft"
	Hotkey,% "^+"%A_GuiControl%, On
}
Hotkey,% %PrevName%[CreateName], Off, UseErrorLevel
Hotkey,% %A_GuiControl%,% HotkeySub[CreateName], UseErrorLevel
Hotkey,% %A_GuiControl%, On, UseErrorLevel
%PrevName%[CreateName] := %A_GuiControl%
Hotkey, +, Off, UseErrorLevel
Hotkey, ++, Off, UseErrorLevel
If (CreateName!=SC)
	send {Tab}  ;Send tab when not in last hotkey
Goto SpecialHotkey


;Some keys need custom controlling because they dont show up in hotkey controls
;F13-F24 are G1-G12 in accordance to my current mouse
SpecialHotkey:
GuiControlGet, %A_GuiControl%, Pos, %A_GuiControl%
If (%A_GuiControl%W = HotkeySize) {
	If (IsSpecialHotkey(%A_GuiControl%)){
	 	GuiControl, Show, SpecialText%A_GuiControl%
		GuiControl,, SpecialText%A_GuiControl%,% TrimSpecialHotkey(%A_GuiControl%)
		GuiControl, Move, SpecialText%A_GuiControl%,% "x" %A_GuiControl%X-10 " y" %A_GuiControl%Y-25
		GuiControl, Move, %A_GuiControl%,% "w" HotkeySize-25 " x" %A_GuiControl%X+%A_GuiControl%W-HotkeySize+13
}}
else If (%A_GuiControl%W = HotkeySize-25) {
	If (IsSpecialHotkey(%A_GuiControl%)){
	 	GuiControl, Show, SpecialText%A_GuiControl%
		GuiControl,, SpecialText%A_GuiControl%,% TrimSpecialHotkey(%A_GuiControl%)
		Return
	}
	GuiControl, Hide, SpecialText%A_GuiControl%
	GuiControl, Move, %A_GuiControl%,% "w" HotkeySize " x" %A_GuiControl%X-37
}
Return
InvalidHotkeyCreate:
GuiControl, , %A_GuiControl%,% HotkeyPrev[A_GuiControl]
DebugSet("ModIfiers are not allowed: " %A_GuiControl%)
%A_GuiControl% := HotkeyPrev[A_GuiControl]
Return

SaveIni(){
	global Profile, SC, Tab
	Gui, 1: +LastFound
	WinGetPos,GuiX,GuiY,GuiW
	If !(GuiX<150-GuiW or GuiY<0){
		IniWrite, %GuiX%, Prefs.ini, All, GuiLoadX
		IniWrite, %GuiY%, Prefs.ini, All, GuiLoadY
	}
	SaveHotkeys(Profile)
	SaveGlobalHotkeys()
}

SaveGlobalHotkeys(){
	global
	DebugAffix(A_ThisFunc)
	Loop, %SC% {
		IniWrite,% %A_Index%Global, Prefs.ini, Global,% HotkeyName[A_Index]
}}
LoadGlobalHotkeys(){
	global
	DebugAffix(A_ThisFunc)
	Loop, %SC% {
		IniRead, %A_Index%Global, Prefs.ini, Global,% HotkeyName[A_Index]
		If (%A_Index%Global) {
			Hotkey,% %A_Index%Global, % HotkeySub[A_Index], UseErrorLevel
			GuiControl, , y%A_Index%Global,% %A_Index%Global
			HotkeyGlobalPrev[A_Index] := %A_Index%Global
			If (HotkeyShIft[A_Index])
				Hotkey,% "+"%A_Index%Global,% HotkeySub[A_Index] . "_ShIft", UseErrorLevel
			If (HotkeyAlt[A_Index])
				Hotkey,% "!"%A_Index%Global,% HotkeySub[A_Index] . "_Alt", UseErrorLevel
			If (HotkeyCtrlAlt[A_Index])
				Hotkey,% "^!"%A_Index%Global,% HotkeySub[A_Index] . "_CtrlAlt", UseErrorLevel
			If (HotkeyCtrlShIft[A_Index])
				Hotkey,% "^+"%A_Index%Global,% HotkeySub[A_Index] . "_CtrlShIft", UseErrorLevel
			GuiControlGet, %A_Index%Global, Pos, %A_Index%Global
			If (IsSpecialHotkey(%A_Index%Global)){
				GuiControl, Show, SpecialText%A_Index%Global
				GuiControl,, SpecialText%A_Index%Global,% TrimSpecialHotkey(%A_Index%Global)
				GuiControl, Move, SpecialText%A_Index%Global,% "x" %A_Index%GlobalX+%A_Index%GlobalW-HotkeySize-10 " y" %A_Index%GlobalY-25
				GuiControl, Move, %A_Index%Global,% "w" HotkeySize-25 " x" %A_Index%GlobalX+%A_Index%GlobalW-HotkeySize+13
			} else {
				GuiControl, Hide, SpecialText%A_Index%Global
				GuiControl,, SpecialText%A_Index%Global, :-/
			If (%A_Index%GlobalW = HotkeySize-25)
				GuiControl, Move, %A_Index%Global,% "w" HotkeySize " x" %A_Index%GlobalX-37
			}
		}
		GuiControl, , %A_Index%Global,% %A_Index%Global
}}

SaveHotkeys(Save="Default"){
	global
	If (Tab="Hotkeys"){
		DebugAffix(A_ThisFunc)
		Loop, %SC% {
			IniWrite,% %A_Index%, Prefs.ini, %Save%,% HotkeyName[A_Index]
			Hotkey,% %A_Index%, Off, UseErrorLevel
			Hotkey,% "+"%A_Index%, Off, UseErrorLevel
			Hotkey,% "!"%A_Index%, Off, UseErrorLevel
			Hotkey,% "^"%A_Index%, Off, UseErrorLevel
			Hotkey,% "+!"%A_Index%, Off, UseErrorLevel
			Hotkey,% "^!"%A_Index%, Off, UseErrorLevel
			Hotkey,% "^+"%A_Index%, Off, UseErrorLevel
			%A_Index% =
			GuiControl, , %A_Index%,
	}}
	else DebugAffix(A_ThisFunc " ignored in " Tab " tab")
}
RestoreHotkeys(Save="Default"){
	global
	Profile := Save
	If (Tab="Globals"){
		DebugAffix(A_ThisFunc " ignored in " Tab " tab")
		Return
	}
	DebugAffix(A_ThisFunc)
	GoSub LoadScripts
	Loop, %SC% {
		IniRead, %A_Index%, Prefs.ini, %Save%,% HotkeyName[A_Index], %A_Space%
		Hotkey,% %A_Index%,% HotkeySub[A_Index], UseErrorLevel
		Hotkey,% %A_Index%, On, UseErrorLevel
		GuiControl, , %A_Index%,% %A_Index%
		HotkeyPrev[A_Index] := %A_Index%
		If (HotkeyShIft[A_Index]){
			Hotkey,% "+"%A_Index%,% HotkeySub[A_Index] . "_ShIft", UseErrorLevel
			Hotkey,% "+"%A_Index%, On, UseErrorLevel
		} 
		If (HotkeyAlt[A_Index]) {
			Hotkey,% "!"%A_Index%,% HotkeySub[A_Index] . "_Alt", UseErrorLevel
			Hotkey,% "!"%A_Index%, On, UseErrorLevel
		} 
		If (HotkeyCtrlAlt[A_Index]) {
			Hotkey,% "^!"%A_Index%,% HotkeySub[A_Index] . "_CtrlAlt", UseErrorLevel
			Hotkey,% "^!"%A_Index%, On, UseErrorLevel
		}
		If (HotkeyCtrlShIft[A_Index]) {
			Hotkey,% "^+"%A_Index%,% HotkeySub[A_Index] . "_CtrlShIft", UseErrorLevel
			Hotkey,% "^+"%A_Index%, On, UseErrorLevel
		}
		Hotkey, +, Off, UseErrorLevel
		Hotkey, !, Off, UseErrorLevel
		Hotkey, ++, Off, UseErrorLevel

		GuiControlGet, %A_Index%, Pos, %A_Index%
		If (IsSpecialHotkey(%A_Index%)){
			GuiControl, Show, SpecialText%A_Index%
			GuiControl,, SpecialText%A_Index%,% TrimSpecialHotkey(%A_Index%)
			GuiControl, Move, SpecialText%A_Index%,% "x" %A_Index%X+%A_Index%W-HotkeySize-10 " y" %A_Index%Y-25
			GuiControl, Move, %A_Index%,% "w" HotkeySize-25 " x" %A_Index%X+%A_Index%W-HotkeySize+13
		} else {
			GuiControl, Hide, SpecialText%A_Index%
			GuiControl,, SpecialText%A_Index%, :-/
			If (%A_Index%W = HotkeySize-25)
				GuiControl, Move, %A_Index%,% "w" HotkeySize " x" %A_Index%X-37
		}
	}
	If (Tab="settings")
		SettingsRefresh()
}

IsSpecialHotkey(Hotkey){
	If (SubStr(Hotkey, 1, 1)=="F")
		If (Hotkey = "F13" or Hotkey = "F14" or Hotkey = "F15" or Hotkey = "F16"
		 or Hotkey = "F17" or Hotkey = "F18" or Hotkey = "F19" or Hotkey = "F20"
		 or Hotkey = "F21" or Hotkey = "F22" or Hotkey = "F23" or Hotkey = "F24")
			Return 1
	If (Hotkey="Pause")
		Return 1
	Return 0
}
TrimSpecialHotkey(Trim){
StringTrimLeft, Trim, Trim, 1
Trim -= 12
Return "G" . Trim
}

SecretLevel:
Gui, Add, Picture, vBilly1_0, %ResDir%\Billy\0.png
Loop, 10
	Gui, Add, Picture,xp yp Hidden vBilly1_%A_Index%, %ResDir%\Billy\%A_Index%.png			;Top Left
Gui, Add, Picture,xm  vBilly2_0, %ResDir%\Billy\0.png
Loop, 10
	Gui, Add, Picture,xp yp Hidden vBilly2_%A_Index%, %ResDir%\Billy\%A_Index%.png			;Bottom Left
Gui, Add, Picture,ym, %ResDir%\Billy\secret.jpg												;Middle
Gui, Add, Picture,ym  vBillyRev1_0, %ResDir%\Billy\Rev0.png
Loop, 10
	Gui, Add, Picture,xp yp Hidden vBillyRev1_%A_Index%, %ResDir%\Billy\Rev%A_Index%.png		;Top Right
Gui, Add, Picture, vBillyRev2_0, %ResDir%\Billy\Rev0.png
Loop, 10
	Gui, Add, Picture,xp yp Hidden vBillyRev2_%A_Index%, %ResDir%\Billy\Rev%A_Index%.png		;Top Left
Gui, Add, Text,xm, Gongratulations! You have reached the secret level!
gui,Show
SetTimer, SecretLoop, 50
secret=0
Return

SecretLoop:
GuiControl, Show, Billy1_%secret%
GuiControl, Show, Billy2_%secret%
GuiControl, Show, BillyRev1_%secret%
GuiControl, Show, BillyRev2_%secret%
Secret++
If (Secret=11){
	Loop, 11{
		GuiControl, Hide, Billy1_%A_Index%
		GuiControl, Hide, Billy2_%A_Index%
		GuiControl, Hide, BillyRev1_%A_Index%
		GuiControl, Hide, BillyRev2_%A_Index%
	}secret=1
}Return

TabControl:
SaveHotkeys(Profile)
Gui, Submit, NoHide
If (Tab="Globals"){
	DebugAffix("Leave globals tab to re-enable hotkeys")
} else If (Tab="Hotkeys") {
	RestoreHotkeys(Profile)
} else If (Tab="Settings"){
	SettingsRefresh()
	DebugSet("Note that most of these settings can also be changed with hotkey+shift")
}
Return

SettingUpdate:
Gui, Submit, NoHide
temp := PrefixNum(A_GuiControl) "Settings"
temp := %temp%  ;Advance dynamic variable
GuiControl,,% PrefixNum(A_GuiControl) "SettingsEdit" ,% %temp%
Return
SettingsEdit:
Gui, Submit, NoHide
temp := PrefixNum(A_GuiControl) "Settings"
ChangingSetting := %temp%
SettingsSub := HotkeySub[PrefixNum(A_GuiControl)] "_Settings"
GoTo,% HotkeySub[PrefixNum(A_GuiControl)] "_Settings"  ;Scripts dedicated Settings Handler
Return
SettingsRefresh(){
	global
	Loop, %SC% {
		temp := %A_Index%Settings  ;Advance dynamic variable
		If (%temp%)
			GuiControl,, %A_Index%SettingsEdit,% %temp%
	}
}

SaveClipboard:
SavedClipboard := ClipboardAll
Clipboard =
Return
RestoreClipboard:
Clipboard := SavedClipboard
Return

SB_Profile:  ;Status Bar
SB_SetText(Profile " profile")
Return
SB_Layout:
SB_SetText((Layout=Ru) ? ("Rus layout") : (Layout=Fi) ? ("En Fi layout") : ("Unknown layout"),2)
Return
SB_Title:
SB_SetText((ActiveTitle) ? (ActiveTitle) : ("No active window"),3)
Return

GuiClose:
ExitApp
Return
ButtonHide:
Gui, Show, Hide
Return
ButtonTest:
InputBox, TestInput, Variable content, Type a variable and show its content,
If TestInput
	InputBox, TestInput, %TestInput%, %TestInput% content,,,,,,,,% %TestInput%
TestInput=
Return

PubgOverride:
ActiveTitle := "S BATTLEGROUNDS"
PubgHotkeys:
If InStr(ActiveTitle, "S BATTLEGROUNDS"){
	If InStr(ActiveTitle, "Google")
		Return
	If !(PubgEnabled){
		GoSub DisableHotkeyProfiles
		SaveHotkeys()
		Hotkey, ~!ShIft, Off
		Hotkey, ~+Alt, Off
		RestoreHotkeys("Pubg")
		PubgEnabled=1
		GoSub LayoutFi
		Gosub SB_Profile
		DebugAffix("Enabled Pubg")
		Return
	}
}
If !(PubgEnabled=1 and ActiveTitle!=GuiTitle and ActiveTitle!="Search" and ActiveTitle)
	Return
DisablePubg:
SaveHotkeys("Pubg")
Hotkey, ~!ShIft, LayoutFi
Hotkey, ~+Alt, LayoutRu
Hotkey, ~!ShIft, On
Hotkey, ~+Alt, On
RestoreHotkeys()
PubgEnabled=0
Gosub SB_Profile
DebugAffix("Disabled Pubg")
Return

DotaOverride:
ActiveTitle := "Dota 2"
DotaHotkeys:
If ((!DotaEnabled and ActiveTitle="Dota 2")){
	GoSub DisableHotkeyProfiles
	SaveHotkeys()
	Hotkey, *%CustomKey1%, DotaZ
	Hotkey, *%CustomKey1%, On
	Hotkey, *%CustomKey2%, DotaX
	Hotkey, *%CustomKey2%, On
	Hotkey, *%CustomKey3%, DotaC
	Hotkey, *%CustomKey3%, On
	Hotkey, *%CustomKey4%, DotaV
	Hotkey, *%CustomKey4%, On
	Hotkey, *%CustomKey5%, DotaB
	Hotkey, *%CustomKey5%, On
	Hotkey, *%CustomKey6%, DotaN
	Hotkey, *%CustomKey6%, On

	Hotkey, *%CustomKey7%, DotaQuickBuy
	Hotkey, *%CustomKey7%, On
	Hotkey, *%CustomKey8%, DotaCour
	Hotkey, *%CustomKey8%, On

	RestoreHotkeys("Dota")
	DotaEnabled=1
	Gosub SB_Profile
	DebugAffix("Enabled dota")
	Return
}
else If (!DotaEnabled or ActiveTitle="Search" or ActiveTitle="Dota 2" or !ActiveTitle or ActiveTitle=GuiTitle)
	Return
DisableDota:
SaveHotkeys("Dota")
Hotkey, *%CustomKey1%, Off	
Hotkey, *%CustomKey2%, Off
Hotkey, *%CustomKey3%, Off
Hotkey, *%CustomKey4%, Off
Hotkey, *%CustomKey5%, Off
Hotkey, *%CustomKey6%, Off

Hotkey, *%CustomKey7%, Off
Hotkey, *%CustomKey8%, Off
RestoreHotkeys()
DotaEnabled=0
Gosub SB_Profile
DebugAffix("Disabled dota")
Return

WitcherOverride:
ActiveTitle := "The Witcher 3"
WitcherHotkeys:
If (ActiveTitle = "The Witcher 3") {
	If !(WitcherEnabled){  ;Enables Witcher Hotkeys
		GoSub DisableHotkeyProfiles
		SaveHotkeys()
		Hotkey, ~!ShIft, Off
		Hotkey, ~+Alt, Off
		RestoreHotkeys("Witcher")
		WitcherEnabled=1
		GoSub LayoutFi
		Gosub SB_Profile
		DebugAffix("Enabled Witcher")
		Return
}}
If !(WitcherEnabled=1 and ActiveTitle!=GuiTitle and ActiveTitle!="Search" and ActiveTitle)
	Return
DisableWitcher:
SaveHotkeys("Witcher")
Hotkey, ~!ShIft, LayoutFi
Hotkey, ~+Alt, LayoutRu
Hotkey, ~!ShIft, On
Hotkey, ~+Alt, On
RestoreHotkeys()
WitcherEnabled=0
Gosub SB_Profile
DebugAffix("Disabled Witcher")
Return

DefaultOverride:
DisableHotkeyProfiles:
DebugAffix("Disabling all profiles")
If DotaEnabled
	GoSub DisableDota
If PubgEnabled 
	GoSub DisablePubg
If WitcherEnabled
	GoSub DisableWitcher
Return

;#####################################################################################
;;Automatic scripts. Non-hotkeyable
;#####################################################################################

DotaZ:
Send {Blind}{z down}
KeyWait, %CustomKey1%
Send {Blind}{z up}
Return
DotaX:
Send {Blind}{x down}
KeyWait, %CustomKey2%
Send {Blind}{x up}
Return
DotaC:
Send {Blind}{c down}
KeyWait, %CustomKey3%
Send {Blind}{c up}
Return
DotaV:
Send {Blind}{v down}
KeyWait, %CustomKey4%
Send {Blind}{v up}
Return
DotaB:
Send {Blind}{b down}
KeyWait, %CustomKey5%
Send {Blind}{b up}
Return
DotaN:
Send {Blind}{n down}
KeyWait, %CustomKey6%
Send {Blind}{n up}
Return

DotaCour:
Send {f2}
Return
DotaQuickBuy:
Send {f5}
Return

FlickerHide:
If GetKeyState("LButton", "P")
	Return
If GetKeyState("MButton", "P")
	Return
WinGetPos WinX, WinY, WinW, WinH, A
ImageSearch, ImageX, ImageY, WinX+WinW-105, WinY+WinH-235, WinX+WinW-80, WinY+WinH-10, *2 %ResDir%\X\FlickrPopUpX.png
If errorlevel {
	If errorlevel = 2 
		DebugAffix("Problem opening resource file in "A_ThisLabel)
	Return	
}
BlockInput, MouseMove
MousePos("Save")
Click, %ImageX%, %ImageY%
MousePos("Restore")
BlockInput, MouseMoveOff
DebugAffix("Finished "A_ThisLabel)
Return

;Middle MouseMiddle Mouse Middle
~*MButton Up::
MouseGetPos,,, WinId,
WinGetPos WinX, WinY, WinW, WinH, ahk_id %WinId%
If (WinW!=368)
	Return
MouseGetPos,,,, WinControl
If (WinControl!="Intermediate D3D Window1")
	Return
BlockInput, MouseMove
MousePos("Save")
MouseMove, WinX+350, WinY+15
Click, WinX+350, WinY+15
MousePos("Restore")
BlockInput, MouseMoveOff
Return

LayoutFi:
If Layout = %Fi%
	Return
PostMessage 0x50, 0, Fi,, A
Layout = %Fi%
Gosub SB_Layout
If !PubgEnabled
	Soundplay, %A_WinDir%\Media\Speech Misrecognition.wav
Return
LayoutRu:
If Layout = %Ru%
	Return
PostMessage 0x50, 0, Ru,, A
Layout = %Ru%
Gosub SB_Layout
Soundplay, %A_WinDir%\Media\Windows Default.wav
Return

;#####################################################################################
;;Hotkeyable scripts
;;To disable a script comment the whole thing or hop over it
;#####################################################################################

LoadScripts:
SC=0
;GoTo SkipToDummy

SC++
HotkeyName[SC] := "Pin_Unpin_Chrome"
HotkeySub[SC] := "Pin"
HotkeyDescription[SC] := "Hotkey:`nPin or unpin a Chrome tab below the mouse"
GoTo HopPin
Pin:
MouseGetPos,,, WinId,
WinGet Process, ProcessName, ahk_id %WinId%
If Process!=chrome.exe
	Return
Click Right
SendInput p
SendInput u
Return
HopPin:

SC++
HotkeyName[SC] := "Flickr_Sizes"
HotkeySub[SC] := "FS"
HotkeyDescription[SC] := "Hotkey:`nModIfy the url to show sizes in Flickr. If already in sizes, opens the image AND CLOSES WINDOW"
GoTo HopFS
FS:
If !InStr(ActiveTitle, "| Flickr -"){  ;Not in Flickr
	DebugAffix("Not in flickr")
	Return
}
If InStr(ActiveTitle, "All sizes"){  ;Open image
	MousePos("Save")
	WinGetPos, FS_WinX, FS_WinY, FS_WinW, FS_WinH, A
	MouseClick, right, FS_WinX+FS_WinW/2, FS_WinY+FS_WinH/2
	sleep, 16
	send, {Enter 2} ^w
	MousePos("Restore")
}
else {  ;Add shit to url
	GoSub SaveClipboard
	Send ^l
	Send ^x
	ClipWait 0.05
	If ErrorLevel {
		ClipFailCount+=1
		If (ClipFailCount=10){
			ClipFailCount=0
			DebugAffix("Failed to copy text at " A_ThisLabel)
			Return
		} else GoTo %A_ThisLabel%
	}
	ClipFailCount=0
	Paste(RegExReplace(Clipboard, "\/in\/.+") FS_UrlStart "/sizes/o")
	sleep 12
	Send {enter}
	GoSub RestoreClipboard
} Return
HopFS:

SC++
HotkeyName[SC] := "Increase_Page"
HotkeySub[SC] := "PI"
HotkeySettings[SC] := "PI_Velocity"
HotkeySettingsDescription[SC] := "PI_Velocity:`nThe amount to add or substract (shared)"
HotkeyDescription[SC] := "Hotkey:`nAdd to the url's most right number`n`nShIft:`nChoose the amount to add or substract (shared)"
HotkeyShIft[SC] := 1
ReadIniDefUndef(Profile,,"PI_Velocity",1)

SC++
HotkeyName[SC] := "Increase_Page_Inverse"
HotkeySub[SC] := "PII"
HotkeyDescription[SC] := "Hotkey:`nSubstract from the url's most right number`n`nShIft:`nChoose the amount to add or substract (shared)"
HotkeyShIft[SC] := 1

GoTo HopPI
PII:
PI_Invert=1
GoTo PI_Start
PI:
PI_Invert=0
GoTo PI_Start
PI_Start:
If !PI_Velocity
	GoTo PI_ShIft
Send ^l
GoSub SaveClipboard
Send ^x
ClipWait 0.05
If ErrorLevel {
	GoSub RestoreClipboard
	ClipFailCount++
	If (ClipFailCount=10){
		ClipFailCount=0
		DebugAffix("Failed to copy text at " A_ThisLabel)
		Return
	} else GoTo %A_ThisLabel%
} ClipFailCount=0
PI_Url := Clipboard
RegExMatch(PI_Url, "(-?\d+)(\D*$)", PI_Extract)
If PI_Invert
	PI_Extract := PI_Extract1+PI_Velocity*-1 . PI_Extract2
else PI_Extract := PI_Extract1+PI_Velocity . PI_Extract2 
Send ^l
Paste(RegExReplace(PI_Url, "\d+\D*$", PI_Extract))
Send {Enter}
sleep 1
GoSub RestoreClipboard
Return
PII_ShIft:
PI_ShIft:
InputBox, PI_Velocity, , Page increase amount? (number),,,,,,,,1
If PI_Velocity is number
	WriteIni(Profile,,"PI_Velocity")
Return

PI_Settings:
If %A_GuiControl% is Number
{
	%ChangingSetting% := %A_GuiControl%
	WriteIni(Profile,,ChangingSetting)
	DebugSet(%A_GuiControl% " accepted and saved")
} else DebugSet(ChangingSetting " must be a number")
Return
HopPI:

SC++
HotkeyName[SC] := "Click_Location"
HotkeySub[SC] := "CL"
HotkeySettings[SC] := "CL_ClickX,CL_ClickY"
HotkeySettingsDescription[SC] := "CL_ClickX:`nClick x coordinate`n`nCL_ClickY:`nClick y coordinate"
HotkeyDescription[SC] := "Hotkey:`nClick your chosen location`n`nShIft:`nChoose the location"
HotkeyShIft[SC] := 1
ReadIniDefUndef(Profile,,"CL_ClickX",A_ScreenWidth/2,"CL_ClickY",A_Screenheight/2)
GoTo HopCL
CL:
If CL_ClickX=
	GoTo CL_ShIft
BlockInput, MouseMove
MousePos("Save")
Click, %CL_ClickX%, %CL_ClickY%
MousePos("Restore")
BlockInput, MouseMoveOff
Return
CL_ShIft:
SetTimer, CL_Win, -50
Msgbox, 4096,% CL_Title := "Click Location", Mouse over where to click and press enter.
MouseGetPos, CL_ClickX, CL_ClickY
WriteIni(Profile,,"CL_ClickX","CL_ClickY")
Return
CL_Win:
If (WinExist(CL_Title)){
	If ( !WinActive(CL_Title) )
		WinActivate, %CL_Title%
	SetTimer, CL_Win, -250
} Return
CL_Settings:
If (ChangingSetting="CL_ClickX"){
	If (%A_GuiControl%>=0 and !%A_GuiControl%>%A_ScreenWidth%)
		GoTo SM_SettingsSuccess
	else DebugSet(ChangingSetting " must be within screen boundaries")
} else If (ChangingSetting="CL_ClickY"){
	If (%A_GuiControl%>=0 and !%A_GuiControl%>%A_ScreenHeight%)
		GoTo SM_SettingsSuccess
	else DebugSet(ChangingSetting " must be within screen boundaries")
}
Return
CL_SettingsSuccess:
%ChangingSetting% := %A_GuiControl%
WriteIni(Profile,,ChangingSetting)
DebugSet(%A_GuiControl% " accepted and saved")
Return
HopCL:

SC++
HotkeyName[SC] := "Click_2_Locations"
HotkeySub[SC] := "C2L"
HotkeySettings[SC] := "C2L_Click1X,C2L_Click1Y,C2L_Click2X,C2L_Click2Y,C2L_CloseWin"
HotkeySettingsDescription[SC] := "C2L_Click1X:`nFirst click x coordinate`n`nC2L_Click1Y:`nFirst click y coordinate`n`nC2L_Click2X:`nSecond click x coordinate`n`nC2L_Click2Y:`nSecond click y coordinate`n`nC2L_CloseWin:`n1 or 0; Desides If the tab will be closed`n`n"
HotkeyDescription[SC] := "Hotkey:`nClick your chosen locations and optionally close tab (ctrl+w)`n`nShIft:`nChoose the locations and If to close the tab"
HotkeyShIft[SC] := 1
ReadIniDefUndef(Profile,,"C2L_Click1X",A_ScreenWidth/2,"C2L_Click1Y",A_ScreenHeight/2
	,"C2L_Click2X",A_ScreenWidth/2+10,"C2L_Click2Y",A_ScreenHeight/2+10,"C2L_CloseWin",0)
GoTo HopC2L
C2L:
If C2L_Click1X=
	GoTo C2L_ShIft
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
C2L_ShIft:
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
	C2L_CloseWin = 1
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
	If (%A_GuiControl%>=0 and !%A_GuiControl%>%A_ScreenWidth%)
		GoTo SM_SettingsSuccess
	else DebugSet(ChangingSetting " must be within screen boundaries")
} else If (ChangingSetting="C2L_Click1Y" or ChangingSetting="C2L_Click2Y"){
	If (%A_GuiControl%>=0 and !%A_GuiControl%>%A_ScreenHeight%)
		GoTo SM_SettingsSuccess
	else DebugSet(ChangingSetting " must be within screen boundaries")
} else If (ChangingSetting="C2L_CloseWin"){
	If (%A_GuiControl%="0" or %A_GuiControl%="1")
		GoTo SM_SettingsSuccess
	else DebugSet(ChangingSetting " must 1 or 0")
}
Return
C2L_SettingsSuccess:
%ChangingSetting% := %A_GuiControl%
WriteIni(Profile,,ChangingSetting)
DebugSet(%A_GuiControl% " accepted and saved")
Return
HopC2L:

SC++
HotkeyName[SC] := "Spam_Click"
HotkeySub[SC] := "SC"
HotkeySettings[SC] := "SC_Sleep"
HotkeySettingsDescription[SC] := "SC_Sleep:`nSleep duration between clicks (ms)"
HotkeyDescription[SC] := "Hotkey:`nWhen held, click and sleep at your will`n`nShIft:`nAdjust sleep. Set to ""skip"" If you really want to fuck around"
HotkeyShIft[SC] := 1
ReadIniDefUndef(Profile,,"SC_Sleep","skip")
GoTo HopSC
SC:
while GetKeyState(A_ThisHotkey, "D"){
	click
	If !(SC_Sleep="Skip")
		sleep, %SC_Sleep%
} Return
SC_ShIft:
InputBox, SC_Sleep, Sleep, Input how long (ms) to sleep between clicks,
WriteIni(Profile,,"SC_Sleep")
Return
SC_Settings:
If %A_GuiControl% is digit
	Goto SC_SettingsSuccess
else If (%A_GuiControl%="skip")
	GoTo SC_SettingsSuccess
else
 	DebugSet(ChangingSetting " must be a number or nothing or ""skip""")
Return
SC_SettingsSuccess:
%ChangingSetting% := %A_GuiControl%
WriteIni(Profile,,ChangingSetting)
DebugSet(%A_GuiControl% " accepted and saved")
Return
HopSC:

GoTo HopSM  ;Disables
SC++
HotkeyName[SC] := "Spam_Ping_Map"
HotkeySub[SC] := "SM"
HotkeySettings[SC] := "SM_Sleep"
HotkeySettingsDescription[SC] := "SM_Sleep:`nSleep duration between pings (ms)"
HotkeyDescription[SC] := "Hotkey:`nPing the Dota 2 map and sleep at your will`n`nShIft:`nAdjust sleep. Set to ""skip"" If you really want to fuck around"
HotkeyShIft[SC] := 1
ReadIniDefUndef(Profile,,"SM_Sleep","skip")
GoTo HopSM
SM:
MousePos("Save")
while GetKeyState(A_ThisHotkey, "D"){
	Random, ranX, 30, 371
	Random, ranY, 1069, 1395
	MouseClick,, ranX, ranY
	If !(SM_Sleep="Skip")
		sleep, %SM_Sleep%
} MousePos("Restore")
Return
SM_shIft:
InputBox, SM_Sleep, Sleep, Input how long (ms) to sleep between pings
WriteIni(Profile,,"SM_Sleep")
Return
SM_Settings:
If %A_GuiControl% is digit
	Goto SM_SettingsSuccess
else If (%A_GuiControl%="skip")
	GoTo SM_SettingsSuccess
else
 	DebugSet(ChangingSetting " must be a number or nothing or ""skip""")
Return
SM_SettingsSuccess:
%ChangingSetting% := %A_GuiControl%
WriteIni(Profile,,ChangingSetting)
DebugSet(%A_GuiControl% " accepted and saved")
Return
HopSM:

SC++
HotkeyName[SC] := "Debug_Settings"
HotkeySub[SC] := "DS"
HotkeySettings[SC] := "DebugSetting"
HotkeySettingsDescription[SC] := "DebugSetting:`n1=Log 2=UnderMouseInfo Negative=disabled"
HotkeyDescription[SC] := "Hotkey:`nToggle updating of debug view`n`nShIft:`nSelect mode"
HotkeyShIft[SC] := 1
If !LoadIndex {
	ReadIniDefUndef(,,"DebugSetting",1)
	Gui, DS:Add, Text,, Debug view settings
	Gui, DS:Add, Radio, % (DebugSetting=1 or DebugSetting=-1) ? ("Checked gDS_Log") : ("gDS_Log"), Enable Log
	Gui, DS:Add, Radio, % (DebugSetting=2 or DebugSetting=-2) ? ("Checked gDS_WinInfo") : ("gDS_WinInfo"), Enable Window Info
	Gui, DS:-MinimizeBox +AlwaysOnTop
} GoTo HopDS
DS:
If (DebugSetting=1 or DebugSetting=-1)
	DebugAffix()
If !DebugSetting
	Gui, DS:Show,, Debug
else DebugSetting:=DebugSetting*-1
WriteIni(,,"DebugSetting")
Return
DS_ShIft:
Gui, DS:Show,, Debug
Return
DS_Log:
DebugAffix()
DebugSetting=1
WriteIni(,,"DebugSetting")
Return
DS_WinInfo:
DebugSetting=2
WriteIni(,,"DebugSetting")
Return
DS_Settings:
If (!%A_GuiControl%=0 and (%A_GuiControl%=1 or %A_GuiControl%=2 or %A_GuiControl%=-1 or %A_GuiControl%=-2)){
	%ChangingSetting% := %A_GuiControl%
	WriteIni(,,"DebugSetting")
	DebugSet("Value accepted and saved")
}else DebugSet("DebugSetting must be 1, 2, -1 or -2")
Return
HopDS:

SC++
HotkeyName[SC] := "Drag_and_Drop_Image"
HotkeySub[SC] := "DD"
HotkeyDescription[SC] := "Hotkey:`nDrag and drop an image from the middle of your browser to above the window`n`nShIft:`nThis doesnt work when shIft is pressed`n`nAlt:`nDrag and drop to right of the window"
HotkeyShIft[SC] := 1
HotkeyAlt[SC] := 1	
GoTo HopDD
DD_ShIft:
DebugAffix("Use alt as this scripts modIfier key!")
Return
DD_Alt:
DD_AltMove=1
GoTo DD_Start
DD:
DD_AltMove=0
DD_Start:
SendMode Event
MouseGetPos,,, DD_Win
WinGetPos DD_WinX, DD_WinY, DD_WinW, DD_WinH, A
If CompareColor(DD_WinX+DD_WinW/2, DD_WinY+DD_WinH/2, "0E0E0E"){
	WaitCount+=1
	If (WaitCount=100){
		WaitCount=0
		DebugAffix("Image wait timeout " A_ThisLabel)
		Return
	} else GoTo %A_ThisLabel%
}
WinGet, DDProcess, ProcessName, A
If (DDProcess != "chrome.exe"){
	DebugAffix("Invalid window (not chrome.exe)")
	Return
}
BlockInput, MouseMove
MousePos("Save")
MouseMove, DD_WinX+DD_WinW/2, DD_WinY+DD_WinH/2, 100
Click, down
If !DD_AltMove
	MouseMove, DD_WinX+DD_WinW/2, DD_WinY-100, 100  ;Just above the window
else 
	MouseMove, DD_WinX+DD_WinW+100, DD_WinY+DD_WinH/2, 100  ;Right of the window
sleep, 88
MouseMove, 5, 5, 100, R
MouseMove, -5, -5, 100, R
MouseMove, 5, 5, 100, R
MouseMove, -5, -5, 100, R
Click, Up
sleep, 64
SetTitleMatchMode, 3
IfWinExist, Copy File
{
	WinClose, Copy File
	WinActivate, ahk_id %DD_Win%
	sleep, 1
	Send, ^{Tab}
} else {
	WinActivate, ahk_id %DD_Win%
	sleep, 1
	Send, ^{Tab}
}
MousePos("Restore")
BlockInput, MouseMoveOff
Return
HopDD:

SC++
HotkeyName[SC] := "Yandex_Image_Search"
HotkeySub[SC] := "YI"
HotkeyDescription[SC] := "Hotkey:`nUse when your url points to and image. Yandex will image search it"
GoTo HopYI
YI:
Send ^l
GoSub SaveClipboard
Send ^x
ClipWait 0.05
If ErrorLevel {
	ClipFailCount+=1
	If (ClipFailCount=10){
		ClipFailCount=0
		DebugAffix("Failed to copy text at " A_ThisLabel)
		Return
	} else GoTo %A_ThisLabel%
}
Run,% "https://yandex.ru/images/search?url=" UrlEncode(Clipboard) "&rpt=imageview"
GoSub RestoreClipboard
Return
HopYI:

SC++
HotkeyName[SC] := "VS_Code_Find_Label"
HotkeySub[SC] := "VS"
HotkeyDescription[SC] := "Hotkey:`nFind selected label or function in the current script file (Visual Studio Code)"
GoTo HopVS
VS:
IfWinNotActive, ahk_exe code.exe
{	DebugAffix("Not in vs code")
	Return
}
GoSub SaveClipboard
send ^f
send ^x
ClipWait, 0.2
send !r
Paste("(" Clipboard "\(\S*\)\s*\{)|(" Clipboard ":)")
loop 5 {
	If GetKeyState("LButton", "P")
		Break
	If GetKeyState("RButton", "P")
		Break
	If GetKeyState("MButton", "P")
		Break
	send {enter}
	sleep, 50
}
send !r
send {esc}
GoSub RestoreClipboard
Return
HopVS:

SC++
HotkeyName[SC] := "Annihilate"
HotkeySub[SC] := "AN"
HotkeyDescription[SC] := "Hotkey:`nPressing this without ctrl+alt doesnt do much`n`nCtrl+Alt:`nKill the script immediately"
HotkeyCtrlAlt[SC] := 1
GoTo HopAN
AN:
DebugAffix("This hotkey needs ctrl+alt")
Return
AN_CtrlAlt:
GoTo Terminate
Return
HopAN:

SkipToDummy:
Loop, 1 {	;Create similarly stupid dummy scripts
	SC++
	HotkeyName[SC] := "Dummy"
	HotkeySub[SC] := "Dummy"
	HotkeySettings[SC] := "FakeVariable"
	HotkeySettingsDescription[SC] := "FakeVariable:`nPlease note that this variable doesnt exist"
	HotkeyDescription[SC] := "Im`na`ndummy`n:)"
}
GoTo HopDummy
Dummy_Settings:
DebugAffix("YOU JUST CHANGED NOTHING")
Return
HopDummy:

LoadIndex++
DebugAffix("Pass " LoadIndex ". Loaded " SC " Scripts")
Return

;Template

SC++
HotkeyName[SC] := "Name_of_Script"
HotkeySub[SC] := "SHORT"
HotkeySettings[SC] := "Variable,Variable2,Var3"  ;Variables that will be shown in Settings tab
HotkeySettingsDescription[SC] := "Description when hovering in Settings tab"
HotkeyDescription[SC] := "Description when hovering"
HotkeyShIft[SC] := 1  ;If enabled shIft+hotkey will go to the				_ShIft label
HotkeyAlt[SC] := 1  ;If enabled alt+hotkey will go to the					_Alt label
HotkeyCtrlAlt[SC] := 1  ;If enabled ctrl+alt+hotkey will go to the			_CtrlAlt label
HotkeyCtrlShIft[SC] := 1  ;If enabled ctrl+shIft+hotkey will go to the		_CtrlShIft label
;Profile specific variables, where "default" will be set when it is not in ini. Loaded when profile is changed
ReadIniDefUndef(Profile,,"Variable","default","Variable2","default")
If !LoadIndex {
	;Execute only on the first time
}
GoTo HopSHORT
SHORT:
;code when main hotkey is pressed
Return
SHORT_ShIft:
;code when shIft is also pressed
Return
SHORT_Alt:
;code when Alt is also pressed
Return
SHORT_CtrlAlt:
;code when CtrlAlt is also pressed
Return
SHORT_CtrlShIft:
;code when CtrlShIft is also pressed
Return
SHORT_Settings:
;code when settings changed in settings tab. Only required for those that are enabled in settings tab
Return
HopSHORT: