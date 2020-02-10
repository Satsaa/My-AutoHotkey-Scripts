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

#Include %A_ScriptDir%\accent combo blocker.ahk

#Include %A_ScriptDir%\Scripts\Pin Unpin Tab.ahk
#Include %A_ScriptDir%\Scripts\Increase Page.ahk
#Include %A_ScriptDir%\Scripts\Yandex Image Search.ahk
#Include %A_ScriptDir%\Scripts\VS Code Find Label.ahk
#Include %A_ScriptDir%\Scripts\Debug Settings.ahk
#Include %A_ScriptDir%\Scripts\Gimp Resize.ahk
#Include %A_ScriptDir%\Scripts\Click Location.ahk
#Include %A_ScriptDir%\Scripts\Click 2 Locations.ahk
#Include %A_ScriptDir%\Scripts\Spam LClick.ahk
#Include %A_ScriptDir%\Scripts\Spam RClick.ahk
#Include %A_ScriptDir%\Scripts\Spam Ping Map.ahk
#Include %A_ScriptDir%\Scripts\Reload.ahk
#Include %A_ScriptDir%\Scripts\Annihilate.ahk
#Include %A_ScriptDir%\Scripts\Open Url.ahk
#Include %A_ScriptDir%\Scripts\Krita Statistics.ahk
#Include %A_ScriptDir%\Scripts\Dota Arrow.ahk
#Include %A_ScriptDir%\Scripts\Dota Trash.ahk
#Include %A_ScriptDir%\Scripts\Scroll.ahk
#Include %A_ScriptDir%\Scripts\Surround.ahk
#Include %A_ScriptDir%\Scripts\Remap to End.ahk

DummyCount:=0  ;Create vegetable scripts for UI testing etc.
#Include %A_ScriptDir%\Scripts\Dummy.ahk



;These keys are assigned to Dota2 hotkeys (items, courier etc)
DotaItem := ["F13", "F14", "F15", "F16", "F17", "F18"],
DotaCourier := "F20", DotaQuickBuy := "F19",
LaunchHidden := %1%,  ;If first launch param equals true the gui is hidden on launch
TPS := 64,  ;Not precise. Refreshes per second max at 64
MaxPerColumn := 8,  ;Initial maximum amount of hotkeys per column
HotkeySize := 120,  ;Width for hotkey controls
SettingSize := 40,  ;Width for settings edit boxes
ButtonSize := 50,  ;Width for sidebar buttons
MinTabHeight := 220, ;Minimum height for tab control
WinGet, WinID,, A
ProfileList := "Default,Dota,Minecraft,Witcher"
Profile := "Default",
GuiTitle := RegExReplace(A_ScriptName, ".ahk"),  ;Title for gui
ResDir := DirAscend(A_ScriptDir) "\Res",
Menu, Tray, Icon, %ResDir%\forsenE.ico
SysGet, VirtualWidth, 78
SysGet, VirtualHeight, 79
ReadIniDefUndef(,,"FirstLoad",1,"GuiLoadY",100,"GuiloadX",100,"DebugSetting",1,"MainAOT",0,"CustomAliases",0)
SpecialHotkey := []  ;List of hotkeys with aliases
SpecialHotkey["Pause"] := " | |"
if (CustomAliases) {
  Loop, 12  ;Fill list from F13-F24 to G1-G12
    SpecialHotkey["F" A_index+12] := "G" A_Index
} else {
  Loop, 12  ;Fill list from F13-F24
    SpecialHotkey["F" A_index+12] := "F" A_index+12
}
If (FirstLoad) {
	FirstLoad=0
	Greet:
	MsgBox, 4, Warning, Made by Satsaa`n`nVery nice
	IfMsgBox, No 
	{	
		GreetFails++
		If (GreetFails=1) {
			MsgBox, 16, Error, Please be nice :), 2
		} else {
			If (GreetFails=2) {
				MsgBox, 16, Error, Stop being a fokken chunt, 2
			} else {
				If (GreetFails=3) {
					MsgBox, 16, Error, WOW! You are so funnyy xD, 2
				} else {
					If (GreetFails>=4 and GreetFails<69) {
						MsgBox, 16, Error, Treasure awaits!`n`nYou have been resilient %GreetFails% times. Can you make it to 69?,
					} else {
						If (GreetFails=69) {
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
Gui, Add, Tab3,% (MaxGuiHeight <= 200 ? "h" MinTabHeight : "")" gTabControl vTab -wrap w" (HotkeySize+10)*Ceil(SC/(MaxPerColumn))+11, Hotkeys|Macros|Settings|%GuiTitle%
Tab := "Hotkeys"  ;Tab isnt set automatically at start?
if (MaxGuiHeight < 200) {
  MaxGuiHeight = 200
}

Gui, Tab, Hotkeys
GuiAddX(,,-HotkeySize+9)
Loop, %SC% {  ;HOTKEYS
	If (HotkeyGlobal[A_Index]) {
		Gui, font, c7a0004
	}
	If !(Mod(A_Index-1, MaxPerColumn)){ ;New row of hotkeys
		Gui, Add, Text,% "y34 " GuiAddX(HotkeySize+10),% RegExReplace(HotkeyName[A_Index], "_" , " ")
	} else {  ;Continue the row
		Gui, Add, Text,,% RegExReplace(HotkeyName[A_Index], "_" , " ")
	}
	Gui, font,
	Gui, Add, Hotkey,% "v" A_Index  " gHotkeyCreate w" HotkeySize (!HotkeySub[A_index] ? " Disabled" : "")
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
	If (HotkeySettings[A_Index]) {
		temp=
		Loop, Parse,% HotkeySettings[A_Index], `,  ;Parse script settings list array 
		{
			If (A_Index=1) {
				FirstSetting:=A_LoopField
			}
			temp.=A_LoopField "|"
		}
		temp:=SubStr(temp,1,StrLen(temp)-1)
		gui, font, s8, Tahoma
		Gui, Add, DropDownList,% "v" A_Index "Settings gSettingsUpdate Choose1 w" HotkeySize-((SettingSize*1)+5), %temp%
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
Gui, Add, Text, cRed vTickCount wp r1
Gui, Add, Text, cRed vTickTime wp r1
Gui, Add, Button,% (MaxGuiHeight <253)?("gDefaultOverride w" ButtonSize " ym"):("gDefaultOverride wp xp y"MaxGuiHeight-85), Default
Gui, Add, Button, w%ButtonSize% gDotaOverride, Dota
Gui, Add, Button, w%ButtonSize% gMinecraftOverride, Minecraft
Gui, Add, Button, w%ButtonSize% gWitcherOverride, Witcher

Gui, Tab, %GuiTitle%
Gui, Add, Button, w%HotkeySize% gExportHotkeys, Export Hotkeys
Gui, Add, Button, w%HotkeySize% gImportHotkeys, Import Hotkeys
Gui, Add, Button, w%HotkeySize% gExportSettings, Export Settings
Gui, Add, Button, w%HotkeySize% gImportSettings, Import Settings
Gui, Add, Checkbox, w%HotkeySize% vMainAOT gCheckboxMainAOT Checked%MainAOT% -Wrap, Always on top
Gui, Add, Checkbox, w%HotkeySize% vCustomAliases gCheckboxCustomAliases Checked%CustomAliases% -Wrap, Custom key aliases
if !(ACB_Enable="") {
  Gui, Add, Checkbox, w%HotkeySize% vACB_Enable gACB_Checkbox Checked%ACB_Enable% -Wrap, Block accenting
}
Gui, Tab,
Gui, Add, StatusBar,,
If (DebugSetting<1) {
	DebugSet("Debug view (this box) is set to not update.")
}
RestoreHotkeys("default")
RemoveDuplicateHotkeys()
SB_SetParts(71, 63)
Gosub SB_Profile
Gosub SB_Title
OnExit("SaveScript")
OnMessage(0x200,"WM_MOUSEMOVE")
OnMessage(0x2A2,"WM_NCMOUSELEAVE")
If (LaunchHidden){  ;First launch parameter
	TM_CustomShow:="CustomShowInit"
	Gui, Show, Hide
	Hidden=1
} else {
	TM_CustomShow:="CustomShow"
	Gui, Show, x%GuiloadX% y%GuiloadY% , %GuiTitle%
  MoveGuiToBounds(1)
}
if (MainAOT){ 
  Gui, 1: +AlwaysOnTop
}
DebugPrepend("Finished Load")
SetTimer, TickPerSec, 1000
SetTimer, DoTick,% 1000/TPS
DebugPrepend("Loaded " SC " Scripts.")
DebugPrepend("Script initialized in " QPC(0) " seconds.")
Return

DoTick:
If (PauseTick=1) {
	Return
}
Tick ++
TwoTick ++
TenTick ++
OldActiveTitle := ActiveTitle
WinGetActiveTitle, ActiveTitle
If (SubStr(ActiveTitle, 1 , 1)=" "){  ;Fixes an odd Krita bug and hopefully more
	ActiveTitle:=SubStr(ActiveTitle, 2)
}
If (OldActiveTitle!=ActiveTitle and ActiveTitle and ActiveTitle!=GuiTitle  ;Activates on window change (ignores some changes)
	and ActiveTitle!=PrevActiveTitle and ActiveTitle!=A_ScriptName) {
	GoSub DotaHotkeys
	GoSub MinecraftHotkeys
	GoSub WitcherHotkeys
	Gosub SB_Title
	If (ActiveTitle="This is an unregistered copy") {
		WinClose, This is an unregistered copy
	}
	PrevActiveTitle := ActiveTitle
}
Loop, %SC% {  ;Do hotkey Ticks
	If (HotkeyTick[A_Index]) {
		GoSub,% HotkeySub[A_Index] "_Tick" 
	}
}
If (TwoTick=2) {
	If (DebugSetting=2) {
		DebugSet(GetUnderMouseInfo(TPS/4))  ;Full update 2 times a second (TPS)
	}
	TwoTick=0
}
If (TenTick=10) {
	TenTick=0
}
GuiControl, , TickCount,% Tick
Return

TickPerSec:
TickEnd := Tick
If (TickEnd - TickStart < 1) {
	GuiControl, Hide, TickTime,
} else {
	GuiControl, Show, TickTime,
	If (TickEnd - TickStart = TPS) {
		GuiControl,, TickTime,% (TickEnd - TickStart) " tps*"
	} else {
		GuiControl,, TickTime,% (TickEnd - TickStart) " tps"
	}
}
TickStart := Tick
Return

MacroCreate:
DebugPrepend("Macro " A_GuiControl ". MACROS ARE UNDER PLANNING/DEVELOPMENT")
Return

HotkeyCreate:
CreateKey := %A_GuiControl%
If (!HotkeyAllowModifiers[A_GuiControl]){  ;Invalidate hotkeys with modIfiers if disallowed
	If (InStr(%A_GuiControl%, "+")){  ;Shift
		GoTo InvalidHotkey
	}
	If (InStr(%A_GuiControl%, "^")){  ;Control
		GoTo InvalidHotkey
	}
	If (InStr(%A_GuiControl%, "!")){  ;Alt
		GoTo InvalidHotkey
	}
}
If GetKeyState("RWin","P"){  ;Windows key
	DebugSet("Windows key")
	GoTo InvalidHotkey
}  
Duplicate=0  ;Check for duplicates
If !(%A_GuiControl%="") {
	Loop, %SC% {  ;Check if current hotkey might be a duplicate
		If ( RemoveModifiers(%A_GuiControl%)=RemoveModifiers(HotkeyPrev[A_Index])) {
			GuiControl,, %A_GuiControl%,% HotkeyPrev[A_GuiControl]
			DebugSet("""" %A_GuiControl% """ overlaps with " HotkeyName[A_Index] ": """ %A_Index% """")
			%A_GuiControl% := HotkeyPrev[A_GuiControl]
			Duplicate=1
			Break
		}
	}
}
;Create new hotkeys and disable old ones
If (HotkeyAny[A_GuiControl]) {
  Hotkey,% "*"HotkeyPrev[A_GuiControl], Off, UseErrorLevel
  If (%A_GuiControl%) {
    Hotkey,% "*"%A_GuiControl%,% HotkeySub[A_GuiControl] "_Any"
    Hotkey,% "*"%A_GuiControl%, On
  }
} else {
  If (HotkeyCtrl[A_GuiControl]) {
    Hotkey,% "^"HotkeyPrev[A_GuiControl], Off, UseErrorLevel
    If (%A_GuiControl%) {
      Hotkey,% "^"%A_GuiControl%,% HotkeySub[A_GuiControl] "_Ctrl"
      Hotkey,% "^"%A_GuiControl%, On
    }
  }
  If (HotkeyAlt[A_GuiControl]) {
    Hotkey,% "!"HotkeyPrev[A_GuiControl], Off, UseErrorLevel
    If (%A_GuiControl%) {
      Hotkey,% "!"%A_GuiControl%,% HotkeySub[A_GuiControl] "_Alt"
      Hotkey,% "!"%A_GuiControl%, On
    }
  }
  If (HotkeyShift[A_GuiControl]) {
    Hotkey,% "+"HotkeyPrev[A_GuiControl], Off, UseErrorLevel
    If (%A_GuiControl%) {
      Hotkey,% "+"%A_GuiControl%,% HotkeySub[A_GuiControl] "_Shift"
      Hotkey,% "+"%A_GuiControl%, On
    }
  }
  If (HotkeyCtrlAlt[A_GuiControl]) {
    Hotkey,% "^!"HotkeyPrev[A_GuiControl], Off, UseErrorLevel
    If (%A_GuiControl%) {
      Hotkey,% "^!"%A_GuiControl%,% HotkeySub[A_GuiControl] "_CtrlAlt"
      Hotkey,% "^!"%A_GuiControl%, On
    }
  }
  If (HotkeyCtrlShift[A_GuiControl]) {
    Hotkey,% "^+"HotkeyPrev[A_GuiControl], Off, UseErrorLevel
    If (%A_GuiControl%) {
      Hotkey,% "^+"%A_GuiControl%,% HotkeySub[A_GuiControl] "_CtrlShift"
      Hotkey,% "^+"%A_GuiControl%, On
    }
  }
  If (HotkeyAltShift[A_GuiControl]) {
    Hotkey,% "!+"HotkeyPrev[A_GuiControl], Off, UseErrorLevel
    If (%A_GuiControl%) {
      Hotkey,% "!+"%A_GuiControl%,% HotkeySub[A_GuiControl] "_AltShift"
      Hotkey,% "!+"%A_GuiControl%, On
    }
  }
  If (HotkeyCtrlAltShift[A_GuiControl]) {
    Hotkey,% "^!+"HotkeyPrev[A_GuiControl], Off, UseErrorLevel
    If (%A_GuiControl%) {
      Hotkey,% "^!+"%A_GuiControl%,% HotkeySub[A_GuiControl] "_CtrlAltShift"
      Hotkey,% "^!+"%A_GuiControl%, On
    }
  }
}
DebugPrepend(HotkeyGlobal[A_GuiControl])
DebugPrepend(ProfileList "123")
If (HotkeyGlobal[A_GuiControl]){  ;Apply globals to all profiles
	Loop, Parse, ProfileList, `,
	{
    DebugPrepend(A_LoopField)
		IniWrite,% %A_GuiControl%, Hotkeys.ini, %A_LoopField%,% HotkeyName[A_GuiControl]
	}
}
If !(HotkeyDisableMain[A_GuiControl]) {
	Hotkey,% HotkeyPrev[A_GuiControl], Off, UseErrorLevel
  if (!HotkeyAny[A_GuiControl]){  ; *x hotkey would create duplicates
    Hotkey,% %A_GuiControl%,% HotkeySub[A_GuiControl], UseErrorLevel
    Hotkey,% %A_GuiControl%, On, UseErrorLevel
  }
}
If (!Duplicate) {
	HotkeyPrev[A_GuiControl] := %A_GuiControl%
	If (A_GuiControl!=SC and !HotkeyAllowModifiers[A_GuiControl]){  ;Go to the next hotkey control if not at last hotkey
		send {Tab}
	}
}
GoTo SpecialHotkey

;Some keys need custom controlling because they dont show up in hotkey controls
;F13-F24 are aliased to G1-G12 in accordance to my current mouse
SpecialHotkey:
If !(HotkeySpecial(A_GuiControl)) {
	HotkeyUnspecial(A_GuiControl)
}
Return
HotkeySpecial(Control, Text=""){  ;Checks and moves hotkey controls and REVEALS text under them
	Global HotkeySize, SpecialHotkey
	GuiControlGet, ThisControl, Pos, %Control%
	If (SpecialHotkey[%Control%]) {
		GuiControl, Show, SpecialText%Control%
		If (Text){  ;Custom text
			GuiControl,, SpecialText%Control%,% Text
		} else {
			GuiControl,, SpecialText%Control%,% SpecialHotkey[%Control%]
		}
		If (ThisControlW = HotkeySize){  ;Move controls only when necessary
			GuiControl, Move, SpecialText%Control%,% "x" ThisControlX-10 " y" ThisControlY-25
			GuiControl, Move, %Control%,% "w" HotkeySize-25 " x" ThisControlX+ThisControlW-HotkeySize+13
		}
		Return 1  ;Return 1 if hotkey is special
	}
	Return 0  ;Return 0 if hotkey isn't special
}
HotkeyUnspecial(Control){  ;Checks and moves hotkey controls and HIDES text under them
	Global HotkeySize, SpecialHotkey
	GuiControlGet, ThisControl, Pos, %Control%
	If (ThisControlW = HotkeySize-25 and !SpecialHotkey[%Control%]) {
		GuiControl, Hide, SpecialText%Control%
		GuiControl, Move, %Control%,% "w" HotkeySize " x" ThisControlX-37
	}
}
InvalidHotkey:
GuiControl, , %A_GuiControl%,% HotkeyPrev[A_GuiControl]
DebugSet("ModIfiers are not allowed: " %A_GuiControl%)
%A_GuiControl% := HotkeyPrev[A_GuiControl]
Return

SaveScript() {
  global Profile
  Gui, 1: +LastFound
  WinGetPos,GuiX,GuiY,GuiW
  IniWrite, %GuiX%, Prefs.ini, All, GuiLoadX
  IniWrite, %GuiY%, Prefs.ini, All, GuiLoadY
  SaveHotkeys(Profile)
}

RefreshHotkeys(Save) {
  global
  SaveHotkeys(Save)
  RestoreHotkeys(Save)
}
SaveHotkeys(Save) {
	global
  if (Save="") {
    Throw No params given for %A_ThisFunc%
  }
  DebugPrepend(A_ThisFunc)
  Loop, %SC% {
    IniWrite,% %A_Index%, Hotkeys.ini, %Save%,% HotkeyName[A_Index]
    Hotkey,% %A_Index%, Off, UseErrorLevel
    Hotkey,% "*"%A_Index%, Off, UseErrorLevel
    Hotkey,% "^"%A_Index%, Off, UseErrorLevel
    Hotkey,% "!"%A_Index%, Off, UseErrorLevel
    Hotkey,% "+"%A_Index%, Off, UseErrorLevel
    Hotkey,% "^!"%A_Index%, Off, UseErrorLevel
    Hotkey,% "^+"%A_Index%, Off, UseErrorLevel
    Hotkey,% "!+"%A_Index%, Off, UseErrorLevel
    Hotkey,% "^!+"%A_Index%, Off, UseErrorLevel
    %A_Index% =
    GuiControl,, %A_Index%,
  }
}
RestoreHotkeys(Save) {
	global
  if (Save="") {
    Throw No params given for %A_ThisFunc%
  }
	Profile := Save
	LoadIndex++
	DebugPrepend(A_ThisFunc ". Pass " LoadIndex)
	Loop, %SC% {
		IniRead, %A_Index%, Hotkeys.ini, %Save%,% HotkeyName[A_Index], %A_Space%
		If (%A_Index%) {
			If (!HotkeySub[A_Index]){  ;If no subroute is defined for hotkey, skip it and complain
        DebugPrepend("No hotkey subroute defined for " HotkeyName[A_Index] "!")
      } else {
        GoSub,% HotkeySub[A_index] "_Load"
        If (HotkeyAny[A_Index]) {
          Hotkey,% "*"%A_Index%,% HotkeySub[A_Index] "_Any"
          Hotkey,% "*"%A_Index%, On
        } else {
          Hotkey,% %A_Index%,% HotkeySub[A_Index]
          Hotkey,% %A_Index%, On
          If (HotkeyCtrl[A_Index]) {
            Hotkey,% "^"%A_Index%,% HotkeySub[A_Index] "_Ctrl"
            Hotkey,% "^"%A_Index%, On
          } 
          If (HotkeyAlt[A_Index]) {
            Hotkey,% "!"%A_Index%,% HotkeySub[A_Index] "_Alt"
            Hotkey,% "!"%A_Index%, On
          } 
          If (HotkeyShift[A_Index]) {
            Hotkey,% "+"%A_Index%,% HotkeySub[A_Index] "_Shift"
            Hotkey,% "+"%A_Index%, On
          } 
          If (HotkeyCtrlAlt[A_Index]) {
            Hotkey,% "^!"%A_Index%,% HotkeySub[A_Index] "_CtrlAlt"
            Hotkey,% "^!"%A_Index%, On
          }
          If (HotkeyCtrlShift[A_Index]) {
            Hotkey,% "^+"%A_Index%,% HotkeySub[A_Index] "_CtrlShift"
            Hotkey,% "^+"%A_Index%, On
          }
          If (HotkeyAltShift[A_Index]) {
            Hotkey,% "^+"%A_Index%,% HotkeySub[A_Index] "_AltShift"
            Hotkey,% "^+"%A_Index%, On
          }
          If (HotkeyCtrlAltShift[A_Index]) {
            Hotkey,% "^!+"%A_Index%,% HotkeySub[A_Index] "_CtrlAltShift"
            Hotkey,% "^!+"%A_Index%, On
          }
        }
        GuiControl, , %A_Index%,% %A_Index%  ;Update control contents
			}
		}
		HotkeyPrev[A_Index] := %A_Index%
		;Handle moving of controls to allow having text show next to them if its a "special" hotkey
		If !(HotkeySpecial(A_Index)) {
			HotkeyUnspecial(A_Index)
		}
	}
	If (Tab="settings") {
		Gosub, SettingsRefresh
	}
}
RemoveDuplicateHotkeys() {
	Global
	Local GlobalID, DupeFound=0
	Loop, %SC% {
		If (HotkeyGlobal[A_Index]){  ;Only check duplicates per global
			If (%A_Index%) {
			GlobalID := A_Index
				Loop, %SC% {
					If (RemoveModifiers(%A_Index%)=RemoveModifiers(%GlobalID%) and A_Index!=GlobalID) {
            DebugPrepend("Removed duplicate hotkey: " %A_Index% " / " RegExReplace(HotkeyName[A_Index], "_" , " "))
						DeleteHotkey(A_Index)
            RestoreHotkeys(Profile)
            Return
					}
				}
			}
		}
	}
}
DeleteHotkey(Control){  ;Destroy one of those fuckers
	Global
	IniWrite,% "", Hotkeys.ini, %Profile%,% HotkeyName[Control]
	Hotkey,% %Control%, Off, UseErrorLevel
  Hotkey,% "*"%Control%, Off, UseErrorLevel
  Hotkey,% "^"%Control%, Off, UseErrorLevel
  Hotkey,% "!"%Control%, Off, UseErrorLevel
  Hotkey,% "+"%Control%, Off, UseErrorLevel
  Hotkey,% "^!"%Control%, Off, UseErrorLevel
  Hotkey,% "^+"%Control%, Off, UseErrorLevel
  Hotkey,% "!+"%Control%, Off, UseErrorLevel
  Hotkey,% "^!+"%Control%, Off, UseErrorLevel

	%Control% =
	GuiControl,, %Control%,
}

WM_MOUSEMOVE(){  ;Description handling
	global
	If (SubStr(A_GuiControl, "1", "1")="["){  ;Ignore controls with "[" to avoid errors
		Return
	}
	If (A_GuiControl=PrevA_GuiControl) {
		Return
	}
	PrevA_GuiControl:=A_GuiControl
	If !(A_GuiControl) {
		If (DebugSetting=1 and Tab!="Settings") {
			SetTimer, DescriptionTimeout, -500
		}
	}
	GuiControlPrefix := PrefixNum(A_GuiControl)
	If (GuiControlPrefix) {
		If (DebugSetting=1) {
			If (Tab="Settings") {
				If (HotkeySettingsDescription[GuiControlPrefix]) {
					DebugSet(StrReplace(HotkeyName[GuiControlPrefix], "_", " ") "`n`n" HotkeySettingsDescription[GuiControlPrefix])
					SetTimer, DescriptionTimeout, Off
				} else {
					DebugPrepend(HotkeyName[GuiControlPrefix] " has no settings description!")
				}
			} else {
				DebugSet(StrReplace(HotkeyName[GuiControlPrefix], "_", " ") "`n`n" HotkeyDescription[GuiControlPrefix])
				SetTimer, DescriptionTimeout, Off
			}
		}
	} else {
		DescriptionName := StrReplace(StrReplace(A_GuiControl, "&"), " ")
		If !(Description[DescriptionName]) {
			Description[DescriptionName]:="?"
			FileAppend,% "`nDescription[""" DescriptionName """] := ""?""", Descriptions.txt,
			DebugPrepend(A_GuiControl " added to Descriptions.txt")
		} else {
			If (Description[DescriptionName]!="?" and DebugSetting=1) {
				DebugSet(Description[DescriptionName])
				SetTimer, DescriptionTimeout, Off
			}
		}
		;else DebugSet(DescriptionName)  ;Uncomment to show ?. For example DescriptionDebug, DescriptionDefaultProfile
	}
}
WM_NCMOUSELEAVE() {
	Global
	If (DebugSetting=1 and Tab!="Settings") {
		SetTimer, DescriptionTimeout, -500
	}
}
DescriptionTimeout:
If (DebugSetting=1 and Tab!="Settings") {
	DebugPrepend()
}
Return

ExportSettings:
ExportIni:="Prefs.ini"
ExportType:="Settings"
Goto ExportProfile

ExportHotkeys:
ExportIni:="Hotkeys.ini"
ExportType:="Hotkeys"

ExportProfile:
If (ExportWindowExists) {
	Gui, Export:Show
	Return
}
ExportIndex=0
ExportCurrentSection=
Gui, Export:Add, Text,, Which sections to export
ExportSection := []
Loop, read, %ExportIni%
{
	If (SubStr(A_LoopReadLine, "1", "1")="[") {
		ExportIndex++
		ExportSection[ExportIndex] := A_LoopReadLine
		Gui, Export:Add, Checkbox, gExportCheckbox vExportCheckbox%ExportIndex% Checked, %A_LoopReadLine%
	} else {
		ExportSection[ExportIndex] .= "`n" A_LoopReadLine
	}
}
Gui, Export:Add, Button, gExportExport, Export
Gui, Export:Add, Text, ym, Output preview
Gui, Export:Add, Edit, Readonly w400 h500 vExportPreview
ExportWindowExists=1
Gui, Export:Show
Gui, Export: +AlwaysOnTop
Gui, Export:Submit, NoHide
GoTo GetExport

ExportCheckbox:
Gui, Export:Submit, NoHide
ExportCheckboxID := SuffixNum(A_GuiControl)
GoTo GetExport
		
ExportExport:
If (!FileExist(A_ScriptDir "\Profiles")) {
	FileCreateDir,% A_ScriptDir "\Profiles"
}
Gui, Export: -AlwaysOnTop
FileSelectFile, ExportPath, S 24,% A_ScriptDir "\Profiles\" ExportType "_" A_YYYY "-" A_MM "-" A_DD ".txt",, *.txt
If (ErrorLevel) {
  Gui, Export: +AlwaysOnTop
	Return
}
Gui, Export: +AlwaysOnTop
SplitPath, ExportPath,,, ExportExt,
If !(ExportExt) {
	ExportPath:=ExportPath ".txt"
}
If !(ExportPath="") {
	FileRecycle, %ExportPath%
	FileAppend, %Export%, %ExportPath%
	If (ErrorLevel) {
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
Return
GetExport:
Export=
Loop {
	If (ExportCheckbox%A_Index%) {
		Export .= (Export)?( "`n`n" ExportSection[A_Index]):(ExportSection[A_Index])
	} else {
		If (A_Index>ExportIndex) {
			Break
		}
	}
}
Export := "ScriptFrogIni Dont remove this first line`n" Export
GuiControl,Export:, ExportPreview,% Export
Return

ImportHotkeys:
ImportIni := "Hotkeys.ini"
ExportType:="Hotkeys"
GoTo Import

ImportSettings:
ImportIni := "Prefs.ini"
ExportType:="Settings"
GoTo Import

Import:
If (!FileExist(A_ScriptDir "\Profiles")) {
	FileCreateDir,% A_ScriptDir "\Profiles"
}
FileSelectFile, ImportPath,,% A_ScriptDir "\Profiles",, *.txt
If (ImportPath=""){  ;Canceled
	Return
}
MsgBox, 36, Reset?, Do you want to reset all other values? No = Merge
ImportMerge=0
IfMsgBox, No
{
	ImportMerge=1
}
If (ImportMerge) {
	DebugPrepend("Merging from " ImportPath)
} else {
	DebugPrepend("Importing from " ImportPath)
}
If (ImportMerge) {
	Loop, read, %ImportPath%
	{
		If (A_Index=1) {
			If !(A_LoopReadLine="ScriptFrogIni Dont remove this first line") {
				MsgBox, 52, Warning, This file is not tagged as an export file.`nDo you want to continue?
				IfMsgBox, No
				{
					Return
				}	
			}
		} else {
			If (SubStr(A_LoopReadLine, 1, 1)="[") {
				ImportSection := RegExReplace(A_LoopReadLine, "\[|\]")
			} else {
				Loop, Parse, A_LoopReadLine, =
				{
					If (A_Index=1) {
						ImportKey := A_LoopField
		} else {
						IniWrite, %A_LoopField%, %ImportIni%, %ImportSection%, %ImportKey%
					}
				}	
			}
		}
	}
} else {
	If !(ImportMerge) {
			FileCopy, %ImportPath%, %ImportIni%, 1  ;1 overwrite
	}
}
if (ExportType:="Settings") {
  Reload  ;Have to reload or program all settings to refresh
}
RestoreHotkeys(Profile)
Return

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
Return

SecretLoop:
GuiControl, Show, Billy1_%secret%
GuiControl, Show, Billy2_%secret%
GuiControl, Show, BillyRev1_%secret%
GuiControl, Show, BillyRev2_%secret%
Secret++
If (Secret=11) {
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
Gui, Submit, NoHide
  If (Tab="Settings") {
    Gosub, SettingsRefresh
    DebugSet("Note that some of these settings can also be changed with hotkey+shift")
  }

Return

SettingsUpdate:  ;When a setting type is changed
Gui, Submit, NoHide
temp := PrefixNum(A_GuiControl) "Settings"
temp := %temp%  ;Advance dynamic variable
GuiControl,,% PrefixNum(A_GuiControl) "SettingsEdit" ,% %temp%
Return
SettingsEdit:  ;When a setting is changed
if (BlockSettingInspect) {
  Return
}
Gui, Submit, NoHide
temp := PrefixNum(A_GuiControl) "Settings"
ChangingSetting := %temp%
SettingsSub := HotkeySub[PrefixNum(A_GuiControl)] "_Settings"
GoTo,% HotkeySub[PrefixNum(A_GuiControl)] "_Settings"  ;Scripts dedicated Setting checker label
Return
SettingsSuccess:  ;Save the setting and tell user
%ChangingSetting% := %A_GuiControl%
WriteIni(Profile,,ChangingSetting)
DebugSet(ChangingSetting ":`n" %A_GuiControl% "`n`n Accepted and saved")
Return
SettingsRefresh:  ;Refreshes settings
BlockSettingInspect = 1
Loop, %SC% {
  temp := %A_Index%Settings  ;Advance dynamic variable
  If (%temp%) {
    GuiControl,, %A_Index%SettingsEdit,% %temp%
  }
}
sleep, 1  ;Lets edit boxes run their gLabels
BlockSettingInspect = 0
Return


SB_Profile:  ;Status Bar
SB_SetText(Profile " profile")
Return
SB_Title:
SB_SetText((ActiveTitle) ? (ActiveTitle) : ("No active window"),3)
Return

GuiClose:
ExitApp
Return
CustomShow:  ;Default for show
for index, element in TM_SHOWGUI 
	Gui,%element%:Show
Hidden=0
Return
CustomShowInit:  ;Show when script was started hidden
Gui, Show, x%GuiLoadX% y%GuiLoadY%, %GuiTitle%
Hidden=0
MoveGuiToBounds(1)
TM_CustomShow=CustomShow
Return
ButtonHide:
Gui, Show, Hide
Hidden=1
Return
Class TestClass{
	name:="Click location"
}
ButtonTest:
QPC(1)
testtt = asdasdasdasdqweqwr4523456dfbndcfgste
testttt = asdasdasdasdqweqwr4523456dfbndcfgste
loop, 10000000 {
  if (testtt) {
    
  }
}
DebugPrepend(QPC())
QPC(1)
loop, 10000000 {
  if (testttt) {
    
  }
}
DebugPrepend(QPC())
Return
PauseTick:=1
InputBox, TestInput, Variable/array content, Type a variable/array[key] and show its content,
IfMsgBox, Cancel
{
	PauseTick:=0
	Return
}
If (TestInput) {
	If (InStr(TestInput, "[") and InStr(TestInput, "]")) {
		TestArray:=SubStr(TestInput,1, InStr(TestInput, "[")-1)
		TestKey:=SubStr(TestInput, InStr(TestInput, "[") +1, InStr(TestInput, "]") - InStr(TestInput, "[") -1)
		InputBox, TestInput, %TestInput%,% TestInput " content:`n""" %TestArray%[TestKey] """",,,,,,,,% %TestArray%[TestKey]
		If (TestInput) {
			%TestArray%[TestKey]:=TestInput
		}
	} else {
		InputBox, TestInput, %TestInput%,% TestInput " content:`n""" %TestInput% """",,,,,,,,% %TestInput%
	}
}
PauseTick:=0
TestInput:=,TestArray:=,TestKey:=
Return

CheckboxMainAOT:
MainAOT := !MainAOT
if (MainAOT) {
  Gui, 1: +AlwaysOnTop
} else {
  Gui, 1: -AlwaysOnTop
}
IniWrite, %MainAOT%, Prefs.ini, All, MainAOT
Return

CheckboxCustomAliases:
CustomAliases := !CustomAliases
if (CustomAliases) {
  Loop, 12  ;Fill list from F13-F24 to G1-G12
    SpecialHotkey["F" A_index+12] := "G" A_Index
} else {
  Loop, 12  ;Fill list from F13-F24
    SpecialHotkey["F" A_index+12] := "F" A_index+12
}
SaveHotkeys(Profile)
RestoreHotkeys(Profile)
IniWrite, %CustomAliases%, Prefs.ini, All, CustomAliases
Return

MinecraftOverride:
ActiveTitle := "Minecraft"
MinecraftHotkeys:
If InStr(ActiveTitle, "Minecraft") {
	If InStr(ActiveTitle, "Google") {
		Return
	}
	If !(MinecraftEnabled) {
		GoSub DisableHotkeyProfiles
		SaveHotkeys("default")
		RestoreHotkeys("Minecraft")
		RemoveDuplicateHotkeys()
		MinecraftEnabled=1
		Gosub SB_Profile
		DebugPrepend("Enabled Minecraft")
	}
	Return
} else {
	If (!MinecraftEnabled or ActiveTitle="Search" or !ActiveTitle or ActiveTitle=GuiTitle) {
		Return
	} else {
		If InStr(ActiveTitle, "Minecraft") {
			Return
		}
	}
}
DisableMinecraft:
SaveHotkeys("Minecraft")
RestoreHotkeys("default")
RemoveDuplicateHotkeys()
MinecraftEnabled=0
Gosub SB_Profile
DebugPrepend("Disabled Minecraft")
Return

DotaOverride:
ActiveTitle := "Dota 2"
DotaHotkeys:
If (!DotaEnabled and ActiveTitle="Dota 2") {
	GoSub DisableHotkeyProfiles
	SaveHotkeys("default")
	Hotkey,% "*" DotaItem[1], DotaZ
	Hotkey,% "*" DotaItem[1], On
	Hotkey,% "*" DotaItem[2], DotaX
	Hotkey,% "*" DotaItem[2], On
	Hotkey,% "*" DotaItem[3], DotaC
	Hotkey,% "*" DotaItem[3], On
	Hotkey,% "*" DotaItem[4], DotaV
	Hotkey,% "*" DotaItem[4], On
	Hotkey,% "*" DotaItem[5], DotaB
	Hotkey,% "*" DotaItem[5], On
	Hotkey,% "*" DotaItem[6], DotaN
	Hotkey,% "*" DotaItem[6], On

	Hotkey,% "*" DotaQuickBuy, DotaQuickBuy
	Hotkey,% "*" DotaQuickBuy, On
	Hotkey,% "*" DotaCourier, DotaCourier
	Hotkey,% "*" DotaCourier, On

	RestoreHotkeys("Dota")
	RemoveDuplicateHotkeys()
	DotaEnabled=1
	Gosub SB_Profile
	DebugPrepend("Enabled dota")
	Return
} else {
	If (!DotaEnabled or ActiveTitle="Search" or ActiveTitle="Dota 2" or !ActiveTitle or ActiveTitle=GuiTitle) {
		Return
	}
}
DisableDota:
SaveHotkeys("Dota")
Hotkey,% "*" DotaItem[1], Off	
Hotkey,% "*" DotaItem[2], Off
Hotkey,% "*" DotaItem[3], Off
Hotkey,% "*" DotaItem[4], Off
Hotkey,% "*" DotaItem[5], Off
Hotkey,% "*" DotaItem[6], Off

Hotkey,% "*" DotaQuickBuy, Off
Hotkey,% "*" DotaCourier, Off
RestoreHotkeys("default")
RemoveDuplicateHotkeys()
DotaEnabled=0
Gosub SB_Profile
DebugPrepend("Disabled dota")
Return

WitcherOverride:
ActiveTitle := "The Witcher 3"
WitcherHotkeys:
If (ActiveTitle="The Witcher 3" and !WitcherEnabled) {
	GoSub DisableHotkeyProfiles
	SaveHotkeys("default")
	RestoreHotkeys("Witcher")
	RemoveDuplicateHotkeys()
	WitcherEnabled=1
	Gosub SB_Profile
	DebugPrepend("Enabled Witcher")
	Return
} else {
	If (!WitcherEnabled or ActiveTitle="Search" or ActiveTitle="The Witcher 3" or !ActiveTitle or ActiveTitle=GuiTitle) {
		Return
	}
}
DisableWitcher:
SaveHotkeys("Witcher")
RestoreHotkeys("default")
RemoveDuplicateHotkeys()
WitcherEnabled=0
Gosub SB_Profile
DebugPrepend("Disabled Witcher")
Return

DefaultOverride:
DisableHotkeyProfiles:
DebugPrepend("Disabling all profiles")
If (DotaEnabled) {
	GoSub DisableDota
}
If (MinecraftEnabled) {
	GoSub DisableMinecraft
}
If (WitcherEnabled) {
	GoSub DisableWitcher
}
Return

;#####################################################################################
;;Automatic scripts. Non-hotkeyable
;#####################################################################################

DotaZ:
Send {Blind}{z down}
KeyWait,% DotaItem[1]
Send {Blind}{z up}
Return
DotaX:
Send {Blind}{x down}
KeyWait,% DotaItem[2]
Send {Blind}{x up}
Return
DotaC:
Send {Blind}{c down}
KeyWait,% DotaItem[3]
Send {Blind}{c up}
Return
DotaV:
Send {Blind}{v down}
KeyWait,% DotaItem[4]
Send {Blind}{v up}
Return
DotaB:
Send {Blind}{b down}
KeyWait,% DotaItem[5]
Send {Blind}{b up}
Return
DotaN:
Send {Blind}{n down}
KeyWait,% DotaItem[6]
Send {Blind}{n up}
Return

DotaCourier:
Send {f2}
Return
DotaQuickBuy:
Send {f5}
Return

If GetKeyState("MButton", "P") {
	Return
}
WinGetPos WinX, WinY, WinW, WinH, A
ImageSearch, ImageX, ImageY, WinX+WinW-105, WinY+WinH-235, WinX+WinW-80, WinY+WinH-10, *2 %ResDir%\X\FlickrPopUpX.png
If errorlevel {
	If (errorlevel=2) {
		DebugPrepend("Problem opening resource file in "A_ThisLabel)
	}
	Return	
}
BlockInput, MouseMove
MousePos("Save")
Click, %ImageX%, %ImageY%
MousePos("Restore")
BlockInput, MouseMoveOff
DebugPrepend("Finished "A_ThisLabel)
Return

;Middle MouseMiddle Mouse Middle
~*MButton Up::
MouseGetPos,,, WinId,
WinGetPos WinX, WinY, WinW, WinH, ahk_id %WinId%
If (WinW!=368) {
	Return
}
MouseGetPos,,,, WinControl
If (WinControl!="Intermediate D3D Window1") {
	Return
}
BlockInput, MouseMove
MousePos("Save")
MouseMove, WinX+350, WinY+15
Click, WinX+350, WinY+15
MousePos("Restore")
BlockInput, MouseMoveOff
Return


:*:cosnt::const