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
#Include %A_ScriptDir%\Scripts\_Init.ahk
#Include %A_ScriptDir%\Descriptions.txt

#Include %A_ScriptDir%\Scripts\Pin Unpin Tab.ahk
#Include %A_ScriptDir%\Scripts\Flickr Sizes.ahk
#Include %A_ScriptDir%\Scripts\Increase Page.ahk
#Include %A_ScriptDir%\Scripts\Drag and Drop Image.ahk
#Include %A_ScriptDir%\Scripts\Yandex Image Search.ahk
#Include %A_ScriptDir%\Scripts\VS Code Find Label.ahk
#Include %A_ScriptDir%\Scripts\Debug Settings.ahk
#Include %A_ScriptDir%\Scripts\Gimp Resize.ahk
#Include %A_ScriptDir%\Scripts\Click Location.ahk
#Include %A_ScriptDir%\Scripts\Click 2 Locations.ahk
#Include %A_ScriptDir%\Scripts\Spam Click.ahk
#Include %A_ScriptDir%\Scripts\Spam Ping Map.ahk
#Include %A_ScriptDir%\Scripts\Annihilate.ahk
#Include %A_ScriptDir%\Scripts\Open Url.ahk
#Include %A_ScriptDir%\Scripts\Krita Statistics.ahk

DummyCount:=0
#Include %A_ScriptDir%\Scripts\Dummy.ahk



;These keys are assigned to Dota2 hotkeys (items, courier etc)
CustomKey1  := "F13", CustomKey2  := "F14", CustomKey3  := "F15",
CustomKey4  := "F16", CustomKey5  := "F17", CustomKey6  := "F18",
CustomKey7  := "F19", CustomKey8  := "F20", CustomKey9  := "F21",
CustomKey10 := "F22", CustomKey11 := "F23", CustomKey12 := "F24",
;Unimpletemented ban system
DefaultBanList :="Spam_Ping_Map,Annihilate"
DotaBanList :="Pin_Unpin_Chrome,Flickr_Sizes,Increase_Page,Increase_Page_Inverse,,Drag_and_Drop_Image,Yandex_Image_Search,VS_Code_Find_Label,Annihilate"
WitcherBanList :="Pin_Unpin_Chrome,Flickr_Sizes,Increase_Page,Increase_Page_Inverse,Spam_Ping_Map,Drag_and_Drop_Image,Yandex_Image_Search,VS_Code_Find_Label,Annihilate"
PubgBanList :="Pin_Unpin_Chrome,Flickr_Sizes,Increase_Page,Increase_Page_Inverse,Spam_Ping_Map,Drag_and_Drop_Image,Yandex_Image_Search,VS_Code_Find_Label,Annihilate"
TPS := 64,  ;Not precise, refreshes per second max 64
MaxPerColumn := 8,  ;Initial maximum amount of hotkeys per column
HotkeySize := 120,  ;Width for hotkey controls
SettingSize := 40,  ;Width for settings edit boxes
ButtonSize := 50,
Ru := -265092071, Fi := 67830793,	;Input layout codes
ProfileList := "Default,Dota,Pubg,Witcher"
Profile := "Default",
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
	{	
		GreetFails++
		If (GreetFails=1){
			MsgBox, 16, Error, Please be nice :), 2
		} else {
			If (GreetFails=2){
				MsgBox, 16, Error, Stop being a fokken chunt, 2
			} else {
				If (GreetFails=3){
					MsgBox, 16, Error, WOW! You are so funnyy xD, 2
				} else {
					If (GreetFails>=4 and GreetFails<69){
						MsgBox, 16, Error, Treasure awaits!`n`nYou have been resilient %GreetFails% times. Can you make it to 69?,
					} else {
						If (GreetFails=69){
							GoTo SecretLevel
						}
					}
				}
			}
		}
	GoTo, Greet
	}
	WriteIni(,,"FirstLoad")
}
If Mod(SC, MaxPerColumn){  ;Calculate nice hotkey button layout
	MaxPerColumn := Ceil(SC/((SC - Mod(SC, MaxPerColumn))/MaxPerColumn + 1))
}
MaxGuiHeight := (48*MaxPerColumn)
Hotkey, ~!Shift, LayoutFi
Hotkey, ~+Alt, LayoutRu
Gui, Add, Tab3,% " gTabControl vTab -wrap w" (HotkeySize+10)*Ceil(SC/(MaxPerColumn))+11, Hotkeys|Macros|Settings|%GuiTitle%

Tab = Hotkeys
Gui, Tab, Hotkeys
GuiAddX(,,-HotkeySize+9)
Loop, %SC% {  ;HOTKEYS
	If (HotkeyGlobal[A_Index]){
		Gui, font, c7a0004
	}
	If !(Mod(A_Index-1, MaxPerColumn)){ ;New row of hotkeys
		Gui, Add, Text,% "y34 " GuiAddX(HotkeySize+10),% RegExReplace(HotkeyName[A_Index], "_" , " ")
	} else {  ;Continue the row
		Gui, Add, Text,,% RegExReplace(HotkeyName[A_Index], "_" , " ")
	}
	Gui, font,
	Gui, Add, Hotkey,% "v" A_Index  " gHotkeyCreate w" HotkeySize 
	Gui, Add, Text,% "vSpecialText" A_Index " xp yp w22 Hidden" , 
}

Gui, Tab, Macros
GuiAddX(,"Macros",-HotkeySize+9)
Loop, %SC% {  ;Macros
	If !(Mod(A_Index-1, MaxPerColumn)){ ;New row of hotkeys
		Gui, Add, Text,% "y34 w" HotkeySize " " GuiAddX(HotkeySize+10,"Macros"), Placeholder text
	} else {  ;Continue the row
		Gui, Add, Text,, Placeholder text
	}
	Gui, Add, Hotkey,% "v" A_Index  "Macro gMacroCreate w" HotkeySize 
	Gui, Add, Text,% "vSpecialTextMacro" A_Index " xp yp w22 Hidden" , 
}

Gui, Tab, Settings  ;BuildSettingsTab
GuiAddX(,"Settings",-HotkeySize+9)
Loop, %SC% {  ;SETTINGS
	If !(Mod(A_Index-1, MaxPerColumn)){  ;New row of settings
		Gui, Add, Text,% "y34 " GuiAddX(HotkeySize+10,"Settings"),% RegExReplace(HotkeyName[A_Index], "_" , " ")
	} else {  ;Continue the row
		Gui, Add, Text,,% RegExReplace(HotkeyName[A_Index], "_" , " ")
	} 
	If (HotkeySettings[A_Index]){
		temp=
		Loop, Parse,% HotkeySettings[A_Index], `,  ;Parse script settings list array 
		{
			If (A_Index=1){
				FirstSetting:=A_LoopField
			}
			temp.=A_LoopField "|"
		}
		temp:=SubStr(temp,1,StrLen(temp)-1)
		gui, font, s8, Tahoma
		Gui, Add, DropDownList,% "v" A_Index "Settings gSettingUpdate Choose1 w" HotkeySize-((SettingSize*1)+5), %temp%
		gui, font,
		Gui, Add, Edit,% "w" SettingSize " v" A_Index "SettingsEdit gSettingsEdit r1 yp xp",% %FirstSetting%
	} else {
		Gui, Add, DropDownList, Disabled w%HotkeySize%, 
	}
}
Loop, %SC% {  ;Conveniently fix edit box positioning
	CurrentColumn := (Floor((A_Index-1)/MaxPerColumn))+1
	GuiControl, Move, %A_Index%SettingsEdit,% "x+" (HotkeySize-(SettingSize-7))+((CurrentColumn-1)*(HotkeySize+10))
}

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

Gui, Tab, %GuiTitle%
Gui, Add, Button, w%HotkeySize% gExportHotkeys, Export Hotkeys
Gui, Add, Button, w%HotkeySize% gImportHotkeys, Import Hotkeys
Gui, Add, Button, w%HotkeySize% gExportSettings, Export Settings
Gui, Add, Button, w%HotkeySize% gImportSettings, Import Settings
Gui, Tab,
Gui, Add, StatusBar,,
If (!GuiLoadY or !GuiLoadY){
	GuiLoadY := 0, GuiLoadX := 0
}
If (DebugSetting<1)
	DebugAffix("Debug view is set to not update.",,1)
RestoreHotkeys()
RemoveDuplicateHotkeys()
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
DebugAffix("Script initialized. Loaded " SC " Scripts")
Return

DoTick:
If (PauseTick=1){
	Return
}
Tick ++
DoubleTick ++
SubTick ++
OldActiveTitle := ActiveTitle
WinGetActiveTitle, ActiveTitle
If (SubStr(ActiveTitle, 1 , 1)=" "){  ;Fixes an odd Krita bug and hopefully more
	ActiveTitle:=SubStr(ActiveTitle, 2)
}
If (OldActiveTitle!=ActiveTitle and ActiveTitle and ActiveTitle!=GuiTitle  ;Activates on window change (ignores some changes)
	and ActiveTitle!=PrevActiveTitle and ActiveTitle!=A_ScriptName){
	GoSub DotaHotkeys
	GoSub PubgHotkeys
	GoSub WitcherHotkeys
	Gosub SB_Title
	FH_Enable=0
	If InStr(ActiveTitle, "| Flickr -"){
		FH_Enable=1
	} else {
		If (ActiveTitle="This is an unregistered copy"){
			WinClose, This is an unregistered copy
		}
	}
	PrevActiveTitle := ActiveTitle
}
Loop, %SC% {  ;Hotkey Tick
	If (HotkeyTick[A_Index]){
		GoSub,% HotkeySub[A_Index] "_Tick" 
	}
}
If (DoubleTick=2){
	If (DebugSetting=2){
		DebugSet(GetUnderMouseInfo(TPS/4))  ;Full update 2 times a second (TPS)
	}
	DoubleTick=0
}
If (SubTick=10){
	If (FH_Enable){
		GoSub, FlickerHide
	}
	SubTick=0
}
GuiControl, , GuiHint,% Tick
Return

TickPerSec:
TickEnd := Tick
If (TickEnd - TickStart < 1){
	GuiControl, Hide, TickTime,
} else {
	GuiControl, Show, TickTime,
	If (TickEnd - TickStart = TPS){
		GuiControl,, TickTime,% (TickEnd - TickStart) " tps*"
	} else {
		GuiControl,, TickTime,% (TickEnd - TickStart) " tps"
	}
}
TickStart := Tick
Return

MacroCreate:
DebugAffix("Macro " A_GuiControl)
Return

HotkeyCreate:
CreateKey := %A_GuiControl%
PrevName := "HotkeyPrev"
;Invalidate hotkeys with modIfiers
If InStr(%A_GuiControl%, "+"){	;Shift
	GoTo InvalidHotkey
}
If InStr(%A_GuiControl%, "^"){	;Control
	GoTo InvalidHotkey
}
If InStr(%A_GuiControl%, "!"){	;Alt
	GoTo InvalidHotkey
}
If GetKeyState("RWin","P"){		;Windows
	DebugSet("Windows key")
	GoTo InvalidHotkey
}  
Duplicate=0  ;Check for duplicated, because not all hotkeys have a main function that would block using duplicates
If !(%A_GuiControl%=""){
	Loop, %SC% {  ;Check if current hotkey might be a duplicate
		If (%A_GuiControl%=HotkeyPrev[A_Index]){
			GuiControl,, %A_GuiControl%,% HotkeyPrev[A_GuiControl]
			%A_GuiControl% := HotkeyPrev[A_GuiControl]
			Duplicate=1
		}
	}
}
;Create new hotkeys and disable old ones
If (HotkeyShift[A_GuiControl]){
	Hotkey,% "+"%PrevName%[A_GuiControl], Off, UseErrorLevel
	If (%A_GuiControl%){
		Hotkey,% "+"%A_GuiControl%,% HotkeySub[A_GuiControl] . "_Shift"
		Hotkey,% "+"%A_GuiControl%, On
	}
}
If (HotkeyAlt[A_GuiControl]){
	Hotkey,% "!"%PrevName%[A_GuiControl], Off, UseErrorLevel
	If (%A_GuiControl%){
		Hotkey,% "!"%A_GuiControl%,% HotkeySub[A_GuiControl] . "_Alt"
		Hotkey,% "!"%A_GuiControl%, On
	}
}
If (HotkeyCtrlAlt[A_GuiControl]){
	Hotkey,% "^!"%PrevName%[A_GuiControl], Off, UseErrorLevel
	If (%A_GuiControl%){
		Hotkey,% "^!"%A_GuiControl%,% HotkeySub[A_GuiControl] . "_CtrlAlt"
		Hotkey,% "^!"%A_GuiControl%, On
	}
}
If (HotkeyCtrlShift[A_GuiControl]){
	Hotkey,% "^+"%PrevName%[A_GuiControl], Off, UseErrorLevel
	If (%A_GuiControl%){
		Hotkey,% "^+"%A_GuiControl%,% HotkeySub[A_GuiControl] . "_CtrlShift"
		Hotkey,% "^+"%A_GuiControl%, On
	}
}
If (HotkeyGlobal[A_GuiControl]){  ;Apply to all profiles
	Loop, Parse, ProfileList, `,
	{
		DebugAffix(A_LoopField)
		IniWrite,% %A_GuiControl%, Hotkeys.ini, %A_LoopField%,% HotkeyName[A_GuiControl]
	}
}
If !(HotkeyDisableMain[A_GuiControl]){
	Hotkey,% %PrevName%[A_GuiControl], Off, UseErrorLevel
	Hotkey,% %A_GuiControl%,% HotkeySub[A_GuiControl], UseErrorLevel
	Hotkey,% %A_GuiControl%, On, UseErrorLevel
}
If !(Duplicate){
	%PrevName%[A_GuiControl] := %A_GuiControl%
	If (A_GuiControl!=SC){
		send {Tab}  ;Go to the next hotkey control if not at last hotkey
	}
}
GoTo SpecialHotkey

;Some keys need custom controlling because they dont show up in hotkey controls
;F13-F24 are G1-G12 in accordance to my current mouse
SpecialHotkey:
GuiControlGet, %A_GuiControl%, Pos, %A_GuiControl%
If (%A_GuiControl%W = HotkeySize){
	If (IsSpecialHotkey(%A_GuiControl%)){
	 	GuiControl, Show, SpecialText%A_GuiControl%
		GuiControl,, SpecialText%A_GuiControl%,% TrimSpecialHotkey(%A_GuiControl%)
		GuiControl, Move, SpecialText%A_GuiControl%,% "x" %A_GuiControl%X-10 " y" %A_GuiControl%Y-25
		GuiControl, Move, %A_GuiControl%,% "w" HotkeySize-25 " x" %A_GuiControl%X+%A_GuiControl%W-HotkeySize+13
	}
} else {
	If (%A_GuiControl%W = HotkeySize-25){
		If (IsSpecialHotkey(%A_GuiControl%)){
			GuiControl, Show, SpecialText%A_GuiControl%
			GuiControl,, SpecialText%A_GuiControl%,% TrimSpecialHotkey(%A_GuiControl%)
			Return
		}
		GuiControl, Hide, SpecialText%A_GuiControl%
		GuiControl, Move, %A_GuiControl%,% "w" HotkeySize " x" %A_GuiControl%X-37
	}
}
Return
InvalidHotkey:
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
}

SaveHotkeys(Save="Default"){
	global
	If (Tab="Hotkeys"){
		DebugAffix(A_ThisFunc)
		Loop, %SC% {
			IniWrite,% %A_Index%, Hotkeys.ini, %Save%,% HotkeyName[A_Index]
			Hotkey,% %A_Index%, Off, UseErrorLevel
			Hotkey,% "+"%A_Index%, Off, UseErrorLevel
			Hotkey,% "!"%A_Index%, Off, UseErrorLevel
			Hotkey,% "^"%A_Index%, Off, UseErrorLevel
			Hotkey,% "+!"%A_Index%, Off, UseErrorLevel
			Hotkey,% "^!"%A_Index%, Off, UseErrorLevel
			Hotkey,% "^+"%A_Index%, Off, UseErrorLevel
			%A_Index% =
			GuiControl,, %A_Index%,
		}
	} else {
		DebugAffix(A_ThisFunc " ignored in " Tab " tab")
	}
}
RestoreHotkeys(Save="Default"){
	global
	Profile := Save
	DebugAffix(A_ThisFunc)
	Loop, %SC% {
		GoSub,% HotkeySub[A_index] "_Load"
	}
	LoadIndex++
	DebugAffix("Pass " LoadIndex ". " A_ThisFunc)
	Loop, %SC% {
		IniRead, %A_Index%, Hotkeys.ini, %Save%,% HotkeyName[A_Index], %A_Space%
		If (%A_Index%){
			If (HotkeySub[A_Index]){  ;If no subroute defined for hotkey, skip it
				Hotkey,% %A_Index%,% HotkeySub[A_Index], UseErrorLevel
				Hotkey,% %A_Index%, On, UseErrorLevel
			}
			GuiControl, , %A_Index%,% %A_Index%  ;Update control contents
			If (HotkeyShift[A_Index]){
				Hotkey,% "+"%A_Index%,% HotkeySub[A_Index] . "_Shift", UseErrorLevel
				Hotkey,% "+"%A_Index%, On, UseErrorLevel
			} 
			If (HotkeyAlt[A_Index]){
				Hotkey,% "!"%A_Index%,% HotkeySub[A_Index] . "_Alt", UseErrorLevel
				Hotkey,% "!"%A_Index%, On, UseErrorLevel
			} 
			If (HotkeyCtrlAlt[A_Index]){
				Hotkey,% "^!"%A_Index%,% HotkeySub[A_Index] . "_CtrlAlt", UseErrorLevel
				Hotkey,% "^!"%A_Index%, On, UseErrorLevel
			}
			If (HotkeyCtrlShift[A_Index]){
				Hotkey,% "^+"%A_Index%,% HotkeySub[A_Index] . "_CtrlShift", UseErrorLevel
				Hotkey,% "^+"%A_Index%, On, UseErrorLevel
			}
		}
		HotkeyPrev[A_Index] := %A_Index%
		;Handle moving of controls to allow having text show next to them if its a "special" hotkey
		GuiControlGet, %A_Index%, Pos, %A_Index%
		If (IsSpecialHotkey(%A_Index%)){
			GuiControl, Show, SpecialText%A_Index%
			GuiControl,, SpecialText%A_Index%,% TrimSpecialHotkey(%A_Index%)
			GuiControl, Move, SpecialText%A_Index%,% "x" %A_Index%X+%A_Index%W-HotkeySize-10 " y" %A_Index%Y-25
			GuiControl, Move, %A_Index%,% "w" HotkeySize-25 " x" %A_Index%X+%A_Index%W-HotkeySize+13
		} else {
			GuiControl, Hide, SpecialText%A_Index%
			GuiControl,, SpecialText%A_Index%, :(
			If (%A_Index%W = HotkeySize-25){
				GuiControl, Move, %A_Index%,% "w" HotkeySize " x" %A_Index%X-37
			}
		}
	}
	If (Tab="settings"){
		SettingsRefresh()
	}
}
RemoveDuplicateHotkeys(){
	Global
	Local GlobalID
	Loop, %SC% {
		If (HotkeyGlobal[A_Index]){
			If (%A_Index%){
			GlobalID := A_Index
				Loop, %SC% {
					If (%A_Index%=%GlobalID% and A_Index!=GlobalID){
						DebugAffix(%A_Index% "/" %GlobalID%)
						%A_Index% =
						GuiControl,, %A_Index%,
					}
				}
			}
		}
	}
}

WM_MOUSEMOVE(){  ;Description handling
	global
	If (SubStr(A_GuiControl, "1", "1")="["){  ;Ignore controls with "[" to avoid errors
		Return
	}
	If (A_GuiControl=PrevA_GuiControl){
		Return
	}
	PrevA_GuiControl:=A_GuiControl
	If !(A_GuiControl){
		If (DebugSetting=1 and Tab!="Settings"){
			SetTimer, DescriptionTimeout, -500
		}
	}
	GuiControlPrefix := PrefixNum(A_GuiControl)
	If (GuiControlPrefix){
		If (DebugSetting=1){
			If (Tab="Settings"){
				If (HotkeySettingsDescription[GuiControlPrefix]){
					DebugSet(StrReplace(HotkeyName[GuiControlPrefix], "_", " ") "`n`n" HotkeySettingsDescription[GuiControlPrefix])
					SetTimer, DescriptionTimeout, Off
				} else {
					DebugAffix(HotkeyName[GuiControlPrefix] " has no settings description!")
				}
			} else {
				DebugSet(StrReplace(HotkeyName[GuiControlPrefix], "_", " ") "`n`n" HotkeyDescription[GuiControlPrefix])
				SetTimer, DescriptionTimeout, Off
			}
		}
	} else {
		DebugDescription := "Description" StrReplace(StrReplace(A_GuiControl, "&"), " ")
		If !(%DebugDescription%){
			%DebugDescription%:="Undescribed"
			FileAppend,% "`n" DebugDescription " = Undescribed", Descriptions.txt,
			DebugAffix(A_GuiControl " added to Descriptions.txt")
		} else {
			If (%DebugDescription%!="Undescribed"){
				If (DebugSetting=1){
					DebugSet(%DebugDescription%)
					SetTimer, DescriptionTimeout, Off
				}
			}
		}
		;else DebugSet(DebugDescription)  ;Uncomment to show undescribed. For example DescriptionDebug, DescriptionDefaultProfile
	}
}
WM_NCMOUSELEAVE(){
	Global
	If (DebugSetting=1 and Tab!="Settings"){
		SetTimer, DescriptionTimeout, -500
	}
}
DescriptionTimeout:
If (DebugSetting=1 and Tab!="Settings"){
	DebugAffix()
}
Return
ExportSettings:
ExportIni:="Prefs.ini"
Goto ExportProfile

ExportHotkeys:
ExportIni:="Hotkeys.ini"
Goto ExportProfile

ExportProfile:
If (ExportWindowExists){
	Gui, Export:Show
	Return
}
ExportIndex=0
ExportCurrentSection=
Gui, Export:Add, Text,, Which sections to export
Loop, read, %ExportIni%
{
	If (SubStr(A_LoopReadLine, "1", "1")="["){
		ExportIndex++
		ExportSection:=RegExReplace(A_LoopReadLine, "\[|\]")
		ExportSection%ExportIndex% := A_LoopReadLine
		Gui, Export:Add, Checkbox, gExportCheckbox vExportCheckbox%ExportIndex% Checked, %A_LoopReadLine%
		Export%ExportIndex% := A_LoopReadLine
	} else {
		ExportSection%ExportIndex% .= "`n" A_LoopReadLine
	}
}
Gui, Export:Add, Button, gExportExport, Export
Gui, Export:Add, Text, ym, Output preview
Gui, Export:Add, Edit, Readonly w400 h500 vExportPreview
ExportWindowExists=1
DebugAffix("Export Gui Created")
Gui, Export:Show
Gui, Export: +AlwaysOnTop
Gui, Export:Submit, NoHide
GoTo GetExport

ExportCheckbox:
Gui, Export:Submit, NoHide
ExportCheckboxID := SuffixNum(A_GuiControl)
GoTo GetExport
		
ExportExport:
FileSelectFile, ExportPath, S 24, RootDir\ScriptFagExport.txt,, *.txt
If !(ExportPath=""){
	FileRecycle, %ExportPath%
	FileAppend, %Export%, %ExportPath%
	If (ErrorLevel){
		MsgBox, 16,Error, Error saving file
		Return
	}
} else {
	Return
}
;No return
ExportGuiClose:
ExportWindowExists=0
Gui, Export:Destroy
DebugAffix("Export Gui Destroyed")
Return
GetExport:
Export=
Loop {
	If (ExportCheckbox%A_Index%){
		Export .= (Export)?( "`n`n" ExportSection%A_Index%):(ExportSection%A_Index%)
	} else {
		If (A_Index>ExportIndex){
			Break
		}
	}
}
Export := "ScriptFagIni Dont remove this first line`n" Export
GuiControl,Export:, ExportPreview,% Export
Return

ImportHotkeys:
ImportIni := "Hotkeys.ini"
GoTo Import

ImportSettings:
ImportIni := "Prefs.ini"

Import:
FileSelectFile, ImportPath,,,, *.txt
If (ImportPath=""){  ;Canceled
	Return
}
MsgBox, 36, Reset?, Do you want to reset all other values? No = Merge
ImportMerge=0
IfMsgBox, No
{
	ImportMerge=1
}
If (ImportMerge){
	DebugAffix("Merging from " ImportPath)
} else {
	DebugAffix("Importing from " ImportPath)
}
If (ImportMerge){
	Loop, read, %ImportPath%
	{
		If (A_Index=1){
			If !(A_LoopReadLine="ScriptFagIni Dont remove this first line"){
				MsgBox, 52, Warning, This file is not tagged as an export file.`nDo you want to continue?
				IfMsgBox, No
				{
					Return
				}	
			}
		} else {
			If (SubStr(A_LoopReadLine, 1, 1)="["){
				ImportSection := RegExReplace(A_LoopReadLine, "\[|\]")
			} else {
				Loop, Parse, A_LoopReadLine, =
				{
					If (A_Index=1){
						InportKey := A_LoopField
		} else {
						IniWrite, %A_LoopField%, %ImportIni%, %ImportSection%, %InportKey%
					}
				}	
			}
		}
	}
} else {
	If !(ImportMerge){
			FileCopy, %ImportPath%, %ImportIni%, 1  ;1 overwrite
	}
}
Reload
Return

IsSpecialHotkey(Hotkey){
	If (SubStr(Hotkey, 1, 1)=="F"){
		If (Hotkey = "F13" or Hotkey = "F14" or Hotkey = "F15" or Hotkey = "F16"
		 or Hotkey = "F17" or Hotkey = "F18" or Hotkey = "F19" or Hotkey = "F20"
		 or Hotkey = "F21" or Hotkey = "F22" or Hotkey = "F23" or Hotkey = "F24")
			Return 1
	}
	If (Hotkey="Pause"){
		Return 1
	}
	Return 0
}
TrimSpecialHotkey(Trim){
	StringTrimLeft, Trim, Trim, 1
	Trim -= 12
	Return "G" . Trim
}

SecretLevel:
Gui, Add, Picture, vBilly1_0, %ResDir%\Billy\0.png
Loop, 10{
	Gui, Add, Picture,xp yp Hidden vBilly1_%A_Index%, %ResDir%\Billy\%A_Index%.png			;Top Left
}
Gui, Add, Picture,xm  vBilly2_0, %ResDir%\Billy\0.png
Loop, 10{
	Gui, Add, Picture,xp yp Hidden vBilly2_%A_Index%, %ResDir%\Billy\%A_Index%.png			;Bottom Left
}
Gui, Add, Picture,ym, %ResDir%\Billy\secret.jpg												;Middle
Gui, Add, Picture,ym  vBillyRev1_0, %ResDir%\Billy\Rev0.png
Loop, 10{
	Gui, Add, Picture,xp yp Hidden vBillyRev1_%A_Index%, %ResDir%\Billy\Rev%A_Index%.png		;Top Right
}
Gui, Add, Picture, vBillyRev2_0, %ResDir%\Billy\Rev0.png
Loop, 10{
	Gui, Add, Picture,xp yp Hidden vBillyRev2_%A_Index%, %ResDir%\Billy\Rev%A_Index%.png		;Top Left
}
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
	}
	secret=1
}
Return

TabControl:
SaveHotkeys(Profile)
Gui, Submit, NoHide

	If (Tab="Hotkeys"){
		RestoreHotkeys(Profile)
	} else {
		If (Tab="Settings"){
			SettingsRefresh()
			DebugSet("Note that most of these settings can also be changed with hotkey+shift")
		}
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
		If (%temp%){
			GuiControl,, %A_Index%SettingsEdit,% %temp%
		}
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
PauseTick:=1
InputBox, TestInput, Variable content, Type a variable and show its content,
IfMsgBox, Cancel
{
	PauseTick:=0
	Return
}
If (TestInput){
	InputBox, TestInput, %TestInput%, %TestInput% content,,,,,,,,% %TestInput%
}
PauseTick:=0
TestInput=
Return

PubgOverride:
ActiveTitle := "S BATTLEGROUNDS"
PubgHotkeys:
If InStr(ActiveTitle, "S BATTLEGROUNDS"){
	If InStr(ActiveTitle, "Google"){
		Return
	}
	If !(PubgEnabled){
		GoSub DisableHotkeyProfiles
		SaveHotkeys()
		Hotkey, ~!Shift, Off
		Hotkey, ~+Alt, Off
		RestoreHotkeys("Pubg")
		RemoveDuplicateHotkeys()
		PubgEnabled=1
		GoSub LayoutFi
		Gosub SB_Profile
		DebugAffix("Enabled Pubg")
	}
	Return
} else {
	If (!PubgEnabled or ActiveTitle="Search" or !ActiveTitle or ActiveTitle=GuiTitle){
		Return
	} else {
		If InStr(ActiveTitle, "S BATTLEGROUNDS"){
			Return
		}
	}
}
DisablePubg:
SaveHotkeys("Pubg")
Hotkey, ~!Shift, LayoutFi
Hotkey, ~+Alt, LayoutRu
Hotkey, ~!Shift, On
Hotkey, ~+Alt, On
RestoreHotkeys()
RemoveDuplicateHotkeys()
PubgEnabled=0
Gosub SB_Profile
DebugAffix("Disabled Pubg")
Return

DotaOverride:
ActiveTitle := "Dota 2"
DotaHotkeys:
If (!DotaEnabled and ActiveTitle="Dota 2"){
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
	RemoveDuplicateHotkeys()
	DotaEnabled=1
	Gosub SB_Profile
	DebugAffix("Enabled dota")
	Return
} else {
	If (!DotaEnabled or ActiveTitle="Search" or ActiveTitle="Dota 2" or !ActiveTitle or ActiveTitle=GuiTitle){
		Return
	}
}
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
RemoveDuplicateHotkeys()
DotaEnabled=0
Gosub SB_Profile
DebugAffix("Disabled dota")
Return

WitcherOverride:
ActiveTitle := "The Witcher 3"
WitcherHotkeys:
If (ActiveTitle="The Witcher 3" and !WitcherEnabled){
	GoSub DisableHotkeyProfiles
	SaveHotkeys()
	Hotkey, ~!Shift, Off
	Hotkey, ~+Alt, Off
	RestoreHotkeys("Witcher")
	RemoveDuplicateHotkeys()
	WitcherEnabled=1
	GoSub LayoutFi
	Gosub SB_Profile
	DebugAffix("Enabled Witcher")
	Return
} else {
	If (!WitcherEnabled or ActiveTitle="Search" or ActiveTitle="The Witcher 3" or !ActiveTitle or ActiveTitle=GuiTitle){
		Return
	}
}
DisableWitcher:
SaveHotkeys("Witcher")
Hotkey, ~!Shift, LayoutFi
Hotkey, ~+Alt, LayoutRu
Hotkey, ~!Shift, On
Hotkey, ~+Alt, On
RestoreHotkeys()
RemoveDuplicateHotkeys()
WitcherEnabled=0
Gosub SB_Profile
DebugAffix("Disabled Witcher")
Return

DefaultOverride:
DisableHotkeyProfiles:
DebugAffix("Disabling all profiles")
If (DotaEnabled){
	GoSub DisableDota
}
If (PubgEnabled){
	GoSub DisablePubg
}
If (WitcherEnabled){
	GoSub DisableWitcher
}
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
If GetKeyState("LButton", "P"){
	Return
}
If GetKeyState("MButton", "P"){
	Return
}
WinGetPos WinX, WinY, WinW, WinH, A
ImageSearch, ImageX, ImageY, WinX+WinW-105, WinY+WinH-235, WinX+WinW-80, WinY+WinH-10, *2 %ResDir%\X\FlickrPopUpX.png
If errorlevel {
	If (errorlevel=2){
		DebugAffix("Problem opening resource file in "A_ThisLabel)
	}
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
If (WinW!=368){
	Return
}
MouseGetPos,,,, WinControl
If (WinControl!="Intermediate D3D Window1"){
	Return
}
BlockInput, MouseMove
MousePos("Save")
MouseMove, WinX+350, WinY+15
Click, WinX+350, WinY+15
MousePos("Restore")
BlockInput, MouseMoveOff
Return

LayoutFi:
If (Layout=Fi){
	Return
}
PostMessage 0x50, 0, Fi,, A
Layout = %Fi%
Gosub SB_Layout
If !(PubgEnabled)
	Soundplay, %A_WinDir%\Media\Speech Misrecognition.wav
Return
LayoutRu:
If (Layout=Ru){
	Return
}
PostMessage 0x50, 0, Ru,, A
Layout := RU
Gosub SB_Layout
Soundplay, %A_WinDir%\Media\Windows Default.wav
Return

;#####################################################################################
;;This section will be removed if development continues
;#####################################################################################

SettingsSuccess:
%ChangingSetting% := %A_GuiControl%
WriteIni(Profile,,ChangingSetting)
DebugSet(ChangingSetting ":`n" %A_GuiControl% "`n`n Accepted and saved")
Return

;Template

SC++
HotkeyName[SC] := "Name_of_Script"
HotkeySub[SC] := "SHORT"  ;Subroute when hotkey is pressed without modifier
HotkeySettings[SC] := "Variable,Variable2,Var3"  ;Variables that will be shown in Settings tab
HotkeyDescription[SC] := "Description when hovering"
HotkeySettingsDescription[SC] := "Description when hovering in Settings tab"
HotkeyGlobal[SC] := 1  ;If enabled hotkey will be set for all profiles
HotkeyDisableMain[SC] := 1  ;If enabled hotkey WILL NOT USE MAIN LABEL		Label 
HotkeyShift[SC] := 1  ;If enabled shift+hotkey will go to the				_Shift label
HotkeyAlt[SC] := 1  ;If enabled alt+hotkey will go to the					_Alt label
HotkeyCtrlAlt[SC] := 1  ;If enabled ctrl+alt+hotkey will go to the			_CtrlAlt label
HotkeyCtrlShift[SC] := 1  ;If enabled ctrl+shift+hotkey will go to the		_CtrlShift label
;Profile specific variables, where "default" will be set when it is not in ini. Loaded when profile is changed
ReadIniDefUndef(Profile,,"Variable","default","Variable2","default")
If !(LoadIndex){
	;Execute only on the first time
}
GoTo HopSHORT
SHORT:
;code when main hotkey is pressed
Return
SHORT_Shift:
;code when shift is also pressed
Return
SHORT_Alt:
;code when Alt is also pressed
Return
SHORT_CtrlAlt:
;code when CtrlAlt is also pressed
Return
SHORT_CtrlShift:
;code when CtrlShift is also pressed
Return
SHORT_Settings:
;code when settings changed in settings tab. Only required for those that are enabled in settings tab
Return
HopSHORT:
