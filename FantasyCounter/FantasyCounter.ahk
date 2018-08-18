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

RowNames := []
GuiTitle := RegExReplace(A_ScriptName, ".ahk"),  ;Title for gui
ResDir := DirAscend(A_ScriptDir) "\Res",
Menu, Tray, Icon, %ResDir%\forsenCard.ico

EditHeight:=18,
EditGrow:=5,
VerticalSpacing:=25,
ElementWidth:=35,
TextFormula:= " ym" " Center w" ElementWidth
EditFormula:= " xp-" EditGrow " yp+" VerticalSpacing " wp+" EditGrow*2 " h" EditHeight " "
EditFormula2:= " xp yp+" VerticalSpacing " wp h" EditHeight " "

Row:=0
RowName:="Name"
Row++
RowNames[Row]:=RowName
Gui, Add, Text,% TextFormula, %RowName%
Gui, Add, Edit,% EditFormula " vName"
Gui, Add, Edit,% EditFormula2 "vTeam"
Gui, Add, Edit,% EditFormula2 "vPos"

Gui, Add, Text,% "ym  w" ElementWidth,
Gui, Add, Text,% "vText1 wp yp+" VerticalSpacing+2, Points
Gui, Add, Text, vText2 wp yp+%VerticalSpacing%, Percent
Gui, Add, Text, vText3 wp yp+%VerticalSpacing%, Bonus

RowName:="Kills"
Row++
RowNames[Row]:=RowName
Gui, Add, Text,% TextFormula, %RowName%
Gui, Add, Edit,% EditFormula  " v" RowName "Point gPoint",
Gui, Add, Edit,% EditFormula2 " v" RowName "Percent gPercent",
Gui, Add, Edit,% EditFormula2 " v" RowName "Bonus gBonus",
RowName:="Deaths"
Row++
RowNames[Row]:=RowName
Gui, Add, Text,% TextFormula, %RowName%
Gui, Add, Edit,% EditFormula  " v" RowName "Point gPoint",
Gui, Add, Edit,% EditFormula2 " v" RowName "Percent gPercent",
Gui, Add, Edit,% EditFormula2 " v" RowName "Bonus gBonus",
RowName:="CS"
Row++
RowNames[Row]:=RowName
Gui, Add, Text,% TextFormula, %RowName%
Gui, Add, Edit,% EditFormula  " v" RowName "Point gPoint",
Gui, Add, Edit,% EditFormula2 " v" RowName "Percent gPercent",
Gui, Add, Edit,% EditFormula2 " v" RowName "Bonus gBonus",
RowName:="GPM"
Row++
RowNames[Row]:=RowName
Gui, Add, Text,% TextFormula, %RowName%
Gui, Add, Edit,% EditFormula  " v" RowName "Point gPoint",
Gui, Add, Edit,% EditFormula2 " v" RowName "Percent gPercent",
Gui, Add, Edit,% EditFormula2 " v" RowName "Bonus gBonus",
RowName:="Tower"
Row++
RowNames[Row]:=RowName
Gui, Add, Text,% TextFormula, %RowName%
Gui, Add, Edit,% EditFormula  " v" RowName "Point gPoint",
Gui, Add, Edit,% EditFormula2 " v" RowName "Percent gPercent",
Gui, Add, Edit,% EditFormula2 " v" RowName "Bonus gBonus",
RowName:="Roshan"
Row++
RowNames[Row]:=RowName
Gui, Add, Text,% TextFormula, %RowName%
Gui, Add, Edit,% EditFormula  " v" RowName "Point gPoint",
Gui, Add, Edit,% EditFormula2 " v" RowName "Percent gPercent",
Gui, Add, Edit,% EditFormula2 " v" RowName "Bonus gBonus",
RowName:="Team"
Row++
RowNames[Row]:=RowName
Gui, Add, Text,% TextFormula, %RowName%
Gui, Add, Edit,% EditFormula  " v" RowName "Point gPoint",
Gui, Add, Edit,% EditFormula2 " v" RowName "Percent gPercent",
Gui, Add, Edit,% EditFormula2 " v" RowName "Bonus gBonus",
RowName:="Wards"
Row++
RowNames[Row]:=RowName
Gui, Add, Text,% TextFormula, %RowName%
Gui, Add, Edit,% EditFormula  " v" RowName "Point gPoint",
Gui, Add, Edit,% EditFormula2 " v" RowName "Percent gPercent",
Gui, Add, Edit,% EditFormula2 " v" RowName "Bonus gBonus",
RowName:="Camps"
Row++
RowNames[Row]:=RowName
Gui, Add, Text,% TextFormula, %RowName%
Gui, Add, Edit,% EditFormula  " v" RowName "Point gPoint",
Gui, Add, Edit,% EditFormula2 " v" RowName "Percent gPercent",
Gui, Add, Edit,% EditFormula2 " v" RowName "Bonus gBonus",
RowName:="Runes"
Row++
RowNames[Row]:=RowName
Gui, Add, Text,% TextFormula, %RowName%
Gui, Add, Edit,% EditFormula  " v" RowName "Point gPoint",
Gui, Add, Edit,% EditFormula2 " v" RowName "Percent gPercent",
Gui, Add, Edit,% EditFormula2 " v" RowName "Bonus gBonus",
RowName:="Blood"
Row++
RowNames[Row]:=RowName
Gui, Add, Text,% TextFormula, %RowName%
Gui, Add, Edit,% EditFormula  " v" RowName "Point gPoint",
Gui, Add, Edit,% EditFormula2 " v" RowName "Percent gPercent",
Gui, Add, Edit,% EditFormula2 " v" RowName "Bonus gBonus",
RowName:="Stuns"
Row++
RowNames[Row]:=RowName
Gui, Add, Text,% TextFormula, %RowName%
Gui, Add, Edit,% EditFormula  " v" RowName "Point gPoint",
Gui, Add, Edit,% EditFormula2 " v" RowName "Percent gPercent",
Gui, Add, Edit,% EditFormula2 " v" RowName "Bonus gBonus",
RowName:="Total"
Row++
RowNames[Row]:=RowName
Gui, Add, Text,% TextFormula, %RowName%
Gui, Add, Edit,% EditFormula  " v" RowName "Point",
Gui, Add, Edit,% EditFormula2 " v" RowName "Percent",
Gui, Add, Edit,% EditFormula2 " v" RowName "Bonus gBonus",

RowName:="All"
Gui, Add, Text,% TextFormula, %RowName%
Gui, Add, Edit,% EditFormula  " gSetPoints v" RowName "Point",
Gui, Add, Edit,% EditFormula2 " gSetPercent v" RowName "Percent",

Gui, Add, Button,% "h" EditHeight+2 " ym+" -1 " gToClipboard", &Copy
Gui, Add, Button,% "wp hp yp+" VerticalSpacing " gFromClipboard", &Paste

Gui, Add, Button,% "h" EditHeight+2 " ym+" -1 " gImport", &Import
Gui, Add, Button,% "wp hp yp+" VerticalSpacing " gExport", &Export

Gui, Add, Button,% "wp hp yp+" VerticalSpacing*2-2 " gReload", &Reload

OnExit SaveIni
ReadIniDefUndef(,,"GuiLoadY",100,"GuiloadX",100)
Gui, Show, x%GuiLoadX% y%GuiLoadY% , %GuiTitle%
Return


SaveIni:
Gui, 1: +LastFound
WinGetPos,GuiX,GuiY,GuiW
If !(GuiX<150-GuiW or GuiY<0){
	IniWrite, %GuiX%, Prefs.ini, All, GuiLoadX
	IniWrite, %GuiY%, Prefs.ini, All, GuiLoadY
}
ExitApp
Return

GuiClose:
ExitApp
Return

Point:
Gui, Submit, NoHide
AddLen:=-2
TotalPoints:=0
Loop,% Row-2 {
	Parse:=RowNames[A_index+1] "Point"
	If (%Parse%){
		TotalPoints:=TotalPoints+%Parse%
	}
} TotalPoints:=TrimTrailingZeros(TotalPoints)
EditType:=SubStr(A_GuiControl,1 ,StrLen(A_GuiControl)-7-AddLen)
Goto UpdateTotals

Percent:
Gui, Submit, NoHide
AddLen:=0
EditType:=SubStr(A_GuiControl,1 ,StrLen(A_GuiControl)-7-AddLen)

UpdateTotals:
GuiControl,,% "TotalPoint",% TotalPoints

Bonus:
Gui, Submit, NoHide  ;Update because bonuses are updated automatically
GuiControl,,% EditType "Bonus",% TrimTrailingZeros(%EditType%Point*(%EditType%Percent/100))
TotalBonus:=0
Loop,% Row-2 {
	Parse:=RowNames[A_index+1] "Bonus"
	If (%Parse%){
		TotalBonus:=TotalBonus+%Parse%
	}
} TotalBonus:=TrimTrailingZeros(TotalBonus)
GuiControl,,% "TotalBonus",% TotalBonus
GuiControl,,% "TotalPercent",% TrimTrailingZeros(((TotalPoints+TotalBonus)/TotalPoints-1)*100)
Return

SetPoints:
Gui, Submit, NoHide
Loop,% Row-1 {
	Parse:=RowNames[A_index+1] "Point"
	GuiControl,,% Parse,% %A_GuiControl%
}
Goto, SetRefresh
SetPercent:
Gui, Submit, NoHide
Loop,% Row-1 {
	Parse:=RowNames[A_index+1] "Percent"
	GuiControl,,% Parse,% %A_GuiControl%
}
Goto, SetRefresh
SetRefresh:
;GoSub UpdateTotals
GuiControl,,% "Text1", Points
GuiControl,,% "Text2", Percent
GuiControl,,% "Text3", Bonus
Return

Export:
If (!FileExist(RootDir "\Profiles")){
	FileCreateDir,% A_ScriptDir "\Profiles"
}
FileSelectFile, ExportPath , 16,% A_ScriptDir "\Profiles\"  ((Name)?(Name):(A_YYYY "-" A_MM "-" A_DD)) ".txt", Export Fantasy Profile, *.txt
SplitPath, ExportPath,,, ExportExt,
If !(ExportExt){
	ExportPath:=ExportPath ".txt"
}
OldClipboard:=ClipboardAll
GoSub ToClipboard
If !(ExportPath=""){
	FileRecycle, %ExportPath%
	FileAppend, %Clipboard%, %ExportPath%
	If (ErrorLevel){
		MsgBox, 16,Error, Error saving file
		Return
	}
} else {
	Clipboard:=OldClipboard
	Return
}
Clipboard:=OldClipboard
Return

Import:
If (!FileExist(RootDir "\Profiles")){
	FileCreateDir,% A_ScriptDir "\Profiles"
}
FileSelectFile, ImportPath,,% A_ScriptDir "\Profiles\", Export Fantasy Profile, *.txt
OldClipboard:=ClipboardAll
If !(ImportPath=""){
	FileRead, Clipboard, %ImportPath%
} else {
	Clipboard:=OldClipboard
	Return
}
GoSub FromClipboard
Clipboard:=OldClipboard
Return

FromClipboard:
ClipLines:=0
SmallClipLines:=2
Loop, Parse, Clipboard, "`n"
{
	ClipLines++
}
Loop, Parse, Clipboard, "`n"
{
	If (A_Index=1 and ClipLines>SmallClipLines){  ;Name
		GuiControl,,% "Name",% TrimWhitespace(A_LoopField)
	} else {
		If (A_Index=2 and ClipLines>SmallClipLines){  ;Team
			GuiControl,,% "Team",% TrimWhitespace(A_LoopField)
		} else {
			If (A_Index=3 or (ClipLines<=SmallClipLines and A_Index=1)){  ;Pos and Points
				If (ClipLines>SmallClipLines){
					RegExMatch(A_LoopField, "^[A-z]*	*", Position)
					Position:=TrimWhitespace(Position)
				}
				GuiControl,,% "Pos",% Position
				Loop, Parse,% TrimWhitespace(RegExReplace(A_LoopField, "^[A-z]*	",,,1)), "	"
				{
					If (A_LoopField!=" "){
						GuiControl,,% RowNames[A_index+1] "Point",% TrimWhitespace(A_LoopField)
					} else {
						GuiControl,,% RowNames[A_index+1] "Point", 
					}
				}
				If (ClipLines=1){
					Break
				}
			} else {
				;Return  ;Disables percent since its bugged
				If (A_Index=4 and ClipLines>SmallClipLines){  ;Total
					
				} else {
					If (A_index>4 and ClipLines>SmallClipLines){  ;Percentages
						Loop, Parse,% A_LoopField, "	"
						{
							If (A_LoopField!=" "){
								GuiControl,,% RowNames[A_index+1] "Percent",% A_LoopField
							}
						}
						If (ClipLines=3){
							Break
						}
					}
				}
			}
		}
	}
}  ;Somehow these get randomly eaten so refresh them
Return
GoSub UpdateTotals
GuiControl,,% "Text1", Points
GuiControl,,% "Text2", Percent
GuiControl,,% "Text3", Bonus

ToClipboard:
Gui, Submit, NoHide
ClipPoints:=
Loop,% Row-2 {
	Parse:=RowNames[A_index+1] "Point"
	If (%Parse%!=""){
		Parse:=TrimTrailingZeros(%Parse%)
		ClipPoints:=ClipPoints Parse "	"
	} else {
		Parse:=" "
		ClipPoints:=ClipPoints Parse "	"
	}
} ClipPoints:=SubStrEnd(ClipPoints,1)

ClipPercent:=
Loop,% Row-2 {
	Parse:=RowNames[A_index+1] "Percent"
	If (%Parse%!=""){
		Parse:=TrimTrailingZeros(%Parse%)
		ClipPercent:=ClipPercent Parse "	"
	} else {
		Parse:=" "
		ClipPercent:=ClipPercent Parse "	"
	}
} ClipPercent:=SubStrEnd(ClipPercent,1)

Clipboard:=Name "`n"
	. Team "`n"
	. Pos "	" ClipPoints "`n"
	. TotalPoints "`n"
	. ClipPercent
Return