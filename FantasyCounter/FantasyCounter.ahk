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
ReadIniDefUndef(,,"GuiLoadY",100,"GuiloadX",100,"AlwaysOnTop","0","ClearOnPaste","1","Stats","")

EditHeight:=18,
EditGrow:=5,
VerticalSpacing:=25,
ElementWidth:=35,
TextFormula:= " ym" " Center w" ElementWidth,
RoleList:="Core,Support,Offlane"

Row:=0
Row++
RowName:="Name"
RowNames[Row]:=RowName
Gui, Add, Text,% TextFormula, %RowName%
Gui, Add, Edit,% "xp-" EditGrow " yp+" VerticalSpacing " wp+" EditGrow*2 " h" EditHeight " vName gName"
Gui, Add, Edit,% "xp yp+" VerticalSpacing " wp h" EditHeight " vTeam gTeam"
Gui, Add, Edit,% "xp yp+" VerticalSpacing " wp h" EditHeight " vPos gPos"

Gui, Add, Text,% "ym  w" ElementWidth,
Gui, Add, Text,% "vText1 wp yp+" VerticalSpacing+2, Points
Gui, Add, Text,% "vText2 wp yp+" VerticalSpacing, Percent
Gui, Add, Text,% "vText3 wp yp+" VerticalSpacing, Bonus

NameList:="Kills,Deaths,CS,GPM,Tower,Roshan,Team,Wards,Camps,Runes,Blood,Stuns,Total,All"
Loop, Parse, NameList, "`,"
{
	RowName:=A_LoopField
	If (A_LoopField!="All"){
		RowNames[A_Index+1]:=A_LoopField
		Row++
	}
	Gui, Add, Text,% TextFormula, %RowName%
}
Loop, Parse, NameList, "`,"
{
	RowName:=A_LoopField
	If (A_Index=1){
		Gui, Add, Edit,% "x" VerticalSpacing*3+30 " yp+" EditHeight+7 " w" ElementWidth+7 " h" EditHeight " v" RowName "Point gPoint",
	} else {
		Gui, Add, Edit,% "xp+" ElementWidth+10 " yp wp h" EditHeight " v" RowName ((A_LoopField="All")?("Point gSetPoints"):((A_LoopField="Total")?("Point"):("Point gPoint"))),
	}
}
Loop, Parse, NameList, "`,"
{
	RowName:=A_LoopField
	If (A_Index=1){
		Gui, Add, Edit,% "x" VerticalSpacing*3+30 " yp+" EditHeight+7 " w" ElementWidth+7 " h" EditHeight " v" RowName ((A_LoopField="Total")?("Percent"):("Percent gPercent")),
	} else {
		Gui, Add, Edit,% "xp+" ElementWidth+10 " yp wp h" EditHeight " v" RowName ((A_LoopField="All")?("Percent gSetPercent"):((A_LoopField="Total")?("Percent"):("Percent gPercent"))),
	}
}
Loop, Parse, NameList, "`,"
{
	RowName:=A_LoopField
	If (A_Index=1){
		Gui, Add, Edit,% "x" VerticalSpacing*3+30 " yp+" EditHeight+7 " w" ElementWidth+7 " h" EditHeight " v" RowName ((A_LoopField="Total")?("Bonus"):("Bonus gBonus")),
	} else {
		If (A_LoopField!="All"){
			Gui, Add, Edit,% "xp+" ElementWidth+10 " yp wp h" EditHeight " v" RowName ((A_LoopField="Total")?("Bonus"):("Bonus gBonus")),
		}
	}
}
Gui, Add, Button,% "h" EditHeight+2 " ym+" -1 " gToClipboard", &Copy
Gui, Add, Button,% "wp hp yp+" VerticalSpacing " gFromClipboard", &Paste

Gui, Add, Button,% "h" EditHeight+2 " ym-" -1 " xp+" ElementWidth+5 " gImport", &Import
Gui, Add, Button,% "wp hp yp+" VerticalSpacing " gExport", &Export

Gui, Add, Button,% "wp hp yp+" VerticalSpacing*2-2 " gReload", &Reload

OnExit SaveIni
If (AlwaysOnTop=1){
	Gui, +AlwaysOnTop
} else {
	Gui, -AlwaysOnTop
}
Gui, Add, Checkbox,% ((AlwaysOnTop=1) ? ("Checked ") : ("")) " xp-" ElementWidth+5 " yp-" VerticalSpacing-5 " vAlwaysOnTop gCheckBoxAlwaysOnTop", Always on top
Gui, Add, Checkbox,% ((ClearOnPaste=1) ? ("Checked ") : ("")) " xp-" ElementWidth*2-21 " yp+" VerticalSpacing " vClearOnPaste gCheckBoxClearOnPaste", Clear on paste
Gui, Add, Button,% "h" EditHeight+2 " ym-" -1 " xp+" ElementWidth*4+5 " gParse", Parse CardData.txt
Gui, Add, Button,% "wp hp yp+" VerticalSpacing " gGetHighestByPlayer", Get best card
;Gui, Add, Button,% "wp hp yp+" VerticalSpacing " gParsePoints", Parse PointData.txt
;Gui, Add, Button,% "wp hp yp+" VerticalSpacing " gGetHighestByTeam", Best Card by Team
;Gui, Add, Button,% "wp hp yp+" VerticalSpacing " gGetHighestByPos", Best Card by Pos
;Gui, Add, Button,% "wp hp yp+" VerticalSpacing " gGetHighest", Best Card

Gui, Add, Button,% "w" 20 " hp yp+" VerticalSpacing " gHelp", ?
Gui, Show, x%GuiLoadX% y%GuiLoadY% , %GuiTitle%
PrevClipboard:=ClipboardAll
Clipboard:=StrReplace(Stats, "``n", "`n")
GoSub FromClipboard
Clipboard:=PrevClipboard
Return


SaveIni:
Gui, 1: +LastFound
PrevClipboard:=ClipboardAll
Gosub ToClipboard
Clipboard:=StrReplace(Clipboard, "`n", "``n")
IniDelete, Prefs.ini, All, Stats
IniWrite, %Clipboard%, Prefs.ini, All, Stats
Clipboard:=PrevClipboard
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

Name:
Team:
Pos:
Gui, Submit, NoHide
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
GuiControl,,% "Text1", Points
GuiControl,,% "Text2", Percent
GuiControl,,% "Text3", Bonus
Return
SetPercent:
Gui, Submit, NoHide
Loop,% Row-1 {
	Parse:=RowNames[A_index+1] "Percent"
	GuiControl,,% Parse,% %A_GuiControl%
}
GuiControl,,% "Text1", Points
GuiControl,,% "Text2", Percent
GuiControl,,% "Text3", Bonus
Return

CheckBoxClearOnPaste:
Gui, Submit, NoHide
AlwaysOnTop:=%A_GuiControl%
WriteIni(,,"ClearOnPaste")
Return
CheckBoxAlwaysOnTop:
Gui, Submit, NoHide
AlwaysOnTop:=%A_GuiControl%
If (AlwaysOnTop=1){
	Gui, +AlwaysOnTop
} else {
	Gui, -AlwaysOnTop
}
WriteIni(,,"AlwaysOnTop")
Return

Help:
MsgBox,4, Pasting data, You can copy-paste data from http://fantasy.prizetrac.kr/international2018/average by copying one "player" row. Copying the full row is intended, but might work in other situations. `n`n Press yes if you want to visit the link
IfMsgBox, Yes
	Run, http://fantasy.prizetrac.kr/international2018/average
MsgBox,4, Getting parse data, You need to visit http://www.dota2.com/fantasy and copy the cards array. How to do it on Chrome: Login if you aren't already. Right click and click inspect. Go to Console and store the Object -> cards: array as a global variable. Then type below in the console copy(temp1). Now the array is on your clipboard. Overwrite CardData.txt with that. `n`n Press yes if you want to visit the link
IfMsgBox, Yes
	Run, http://www.dota2.com/fantasy
Return

Export:
If (Name!=PrevName and Name){
	Exports:=0
}
Exports++
PrevName:=Name
If (!FileExist(A_ScriptDir "\Profiles")){
	FileCreateDir,% A_ScriptDir "\Profiles"
}
If (AlwaysOnTop=1){
	Gui, -AlwaysOnTop
}
FileSelectFile, ExportPath , 16,% A_ScriptDir "\Profiles\" (((Exports)?(((Name)?(Name "-"):("")) Exports):("")) "-" TrimTrailingZeros(TotalBonus+TotalPoints)) ".txt", Export Fantasy Profile, *.txt
If (AlwaysOnTop=1){
	Gui, +AlwaysOnTop
}
If (ErrorLevel){
	Return
}
SplitPath, ExportPath,,, ExportExt,
If (!ExportExt){
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
If (AlwaysOnTop=1){
	Gui, -AlwaysOnTop
}
FileSelectFile, ImportPath,,% A_ScriptDir "\Profiles\", Export Fantasy Profile, *.txt
If (AlwaysOnTop=1){
	Gui, +AlwaysOnTop
}
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
				;Clear percentages
				If (ClearOnPaste=1){
					Loop, %Row%
					{
						GuiControl,,% RowNames[A_index+1] "Percent",
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
GuiControl,,% "Text1", Points
GuiControl,,% "Text2", Percent
GuiControl,,% "Text3", Bonus
Return

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

Parse:
CardName := [],
CardTeamID := [],
TeamIdName := [],
CardRole := [],
CardBonus1 := [], CardBonus2 := [], CardBonus3 := [], CardBonus4 := [], CardBonus5 := [],
CardBonusID1 := [], CardBonusID2 := [], CardBonusID3 := [], CardBonusID4 := [], CardBonusID5 := [],

CardName:=,CardTeamID:=,CardRole:=,CardBonus1:=,CardBonus2:=,CardBonus3:=,CardBonus4:=,CardBonus5:=,
CardBonusID1:=,CardBonusID2:=,CardBonusID3:=,CardBonusID4:=,CardBonusID5:=, PlayerList:=, 
Line:=0, CardEnd:=0, Bonuses:=0, BonusLine:=0, Card:=0

FileRead, CardData, CardData.txt
Loop, Parse, CardData, `n
{
	Line++
	If (Line=4){
		Card++
		Loop, Parse, A_LoopField, `:  ;Get card name
		{
			If (A_Index=2){
				CardName[Card]:=SubStr(A_LoopField, 3, StrLen(A_LoopField)-5)
				If !(InStr(PlayerList, CardName[Card] , 1)){
					PlayerList.=CardName[Card] ","
				}
			}
		}
	} else If (Line=5) {
		Loop, Parse, A_LoopField, `:  ;Get team id
		{
			If (A_Index=2){
				CardTeamID[Card]:=SubStr(A_LoopField, 2, StrLen(A_LoopField)-3)
			}
		}
	} else If (Line=6) {
		Loop, Parse, A_LoopField, `:  ;Get team id
		{
			If (A_Index=2){
				TeamName:=SubStr(A_LoopField, 3, StrLen(A_LoopField)-5)
				TeamIdName[CardTeamID[Card]]:=TeamName
			}
		}
	} else If (Line=7) {
		Loop, Parse, A_LoopField, `:  ;Get role
		{
			If (A_Index=2){
				CardRole[Card]:=SubStr(A_LoopField, 2, StrLen(A_LoopField)-3)
			}
		}
	} else If (Line>=10) {
		BonusLine++
		Loop, Parse, A_LoopField, `:
		{
			If (A_Index=1){
				If (A_LoopField="    ""item_id"""){  ;Check for item id. Pointing that end has been reached
					CardEnd=1
				}
			}
		}
		If (CardEnd=1){
			CardEnd:=0, Bonuses:=0, Line:=0, BonusLine:=0
		} else If (BonusLine=1){
			Bonuses++
			Loop, Parse, A_LoopField, `:  ;Get bonus ID
			{
				If (A_Index=2){
					CardBonusID%Bonuses%[Card]:=SubStr(A_LoopField, 2, StrLen(A_LoopField)-3)+1
				}
			}
		} else If (BonusLine=2){
			Loop, Parse, A_LoopField, `:  ;Get bonus amount
			{
				If (A_Index=2){
					CardBonus%Bonuses%[Card]:=SubStr(A_LoopField, 2, StrLen(A_LoopField)-2)
				}
			}
		} else If (BonusLine=4){  ;4 lines passed so reset counter
			BonusLine=0
		}
	}
}
PlayerList:=SubStrEnd(PlayerList,1)
Return

ParsePoints:
PlayerName := [],
PlayerNameID := [], ;Make this. PlayerNameID[Cr1t-]=1 Name corresponds to the relevant id that works with player*[] arrays
PlayerTeam := [],
PlayerPos := [],
Loop, 12
	PlayerPoints%A_Index% := [],
PlayerTotal := [],

Line:=0, Player:=0, PlayerLine:=0

FileRead, PointData, PointData.txt
Loop, Parse, PointData, `n
{
	Line++
	If (Line>=14){
		PlayerLine++
		If (PlayerLine=1){
			Player++
			PlayerName[Player]:=A_LoopField
		} else If (PlayerLine=2){
			PlayerTeam[Player]:=A_LoopField
		} else If (PlayerLine=3){
			Loop, Parse, A_LoopField, "	"
			{
				If (A_Index=1){
					PlayerPos[Player]:=A_LoopField
				} else If (A_index<Row){
					PointIndex:=A_Index-1
					PlayerPoints%PointIndex%[Player]:=A_LoopField
				}
			}
		} else If (PlayerLine=4){
			PlayerTotal[Player]:=A_LoopField
			PlayerLine=0
		} 
	}
}
Return

GetHighestByPlayer: ;Get best card by data already entered (name and points)
If (Name=""){
	MsgBox, Please fill in the name
	Return
}
loop, parse, PlayerList, `,
{
	Loop {
		If (PlayerName[A_Index]){
			msgbox,% PlayerName[A_Index] " = " A_LoopField
			If (PlayerName[A_Index]=A_LoopField){
				PlayerNameID[A_LoopField]:=A_Index
				MSgBox,% PlayerNameID[A_LoopField] " = " A_Index
			}
		} else break
	}
}
MatchingName=0
Loop, Parse, PlayerList, `,
{
	If (Name=A_LoopField){
		MatchingName=1
	}
}
SimilarName:=, HighestSimilarity:=
If !(MatchingName){  ;Get closest name
	Loop, Parse, PlayerList, `,
	{
		Similarity:=Compare(Name,A_LoopField)
		If (Similarity>HighestSimilarity){
			FifthSimilarName:=FourthSimilarName, FifthSimilarity:=FourthSimilarity, FourthSimilarName:=ThirdSimilarName, FourthSimilarity:=ThirdSimilarity, ThirdSimilarName:=SecondSimilarName, ThirdSimilarity:=SecondSimilarity, SecondSimilarName:=SimilarName, SecondSimilarity:=HighestSimilarity, SimilarName:=A_LoopField, HighestSimilarity:=Similarity
		}
	}
	Msgbox,3,,% "Current name """ Name """ didn't match any parsed name. Do you want to set name to the closest encounter " SimilarName "?"
			. "`nOther names: " SecondSimilarName (ThirdSimilarName?(", "ThirdSimilarName):"") (FourthSimilarName?(", " FourthSimilarName):"") (FifthSimilarName?(", "FifthSimilarName):"") "."
	IfMsgBox, Yes
	{
		Name:=SimilarName
		GuiControl,, Name,% SimilarName
	} else {
		IfMsgBox, Cancel
		{
			Return
		}
	}
	
}

HighestCard:=0, HighestBonus:=0
Loop, %Card% {  ;Get best for this player
	If (CardName[A_index]=name){
		FoundAt:=A_Index
		ThisBonus:=0
		Loop, 5 {
			LoopIndex:=A_Index
			If (CardBonusID%A_Index%[FoundAt]!=""){
				Loop, Parse, NameList, `,
				{
					If (CardBonusID%LoopIndex%[FoundAt]=A_Index){
						ThisBonus:=ThisBonus+%A_LoopField%Point*(CardBonus%LoopIndex%[FoundAt]/100)
					}
				}
			}
		}
		If (ThisBonus>HighestBonus){
			HighestCard:=FoundAt
			HighestBonus:=ThisBonus
		}
	}
}
If !(HighestCard){  ;None found
	MsgBox, No card was found for %name%! Make sure the name is found in CardData.txt and you have his card.
}
Loop, %Row% {  ;reset percents
	GuiControl,,% RowNames[A_Index+1] "Percent",% ""
}
Loop, 5 {  ;Set percents
	LoopIndex:=A_Index
	If (CardBonusID%A_Index%[HighestCard]!=""){
		Loop, Parse, NameList, `,
		{
			If (CardBonusID%LoopIndex%[HighestCard]=A_Index){
				GuiControl,,% RowNames[CardBonusID%LoopIndex%[HighestCard]+1] "Percent",% (CardBonus%LoopIndex%[HighestCard])
			}
		}
	}
}
Return
GetHighestByPos:  ;Get best player and card by position
GetHighestByTeam:  ;Get best player and card by team




;WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
/*
PlayerName := [],
PlayerTeam := [],
PlayerPos := [],
Loop, 12
	PlayerPoints%A_Index% := [],
PlayerTotal := [],

CardName := [],
CardTeamID := [],
TeamIdName := [],
CardRole := [],
CardBonus1 := [], CardBonus2 := [], CardBonus3 := [], CardBonus4 := [], CardBonus5 := [],
CardBonusID1 := [], CardBonusID2 := [], CardBonusID3 := [], CardBonusID4 := [], CardBonusID5 := [],

*/

GetHighest:  ;Get the best card ever

HighestCard:=0, HighestBonus:=0,
If !(PlayerList){
	MsgBox, You must parse CardData.text
	Return
}
Loop, Parse, PlayerList, `,  ;Loop thru names
{
	Loop, %Card% {  ;Loop thru all cards
		ThisPoints:=0
		If (CardName[A_index]=A_LoopField){  ;Found match
			MsgBox, Card start
			FoundAt:=A_Index
			Loop, 12 {
				Loop, 5 {
					If (CardBonusID%A_Index%[FoundAt]){
						ThisPoints:=ThisPoints
						FoundBonusID:=1+ PlayerPoints[FoundAt]*(CardBonus%LoopIndex%[FoundAt]/100)
					}
				}
			}
		}
	}
}

MsgBox, HighestName %HighestName%
If !(HighestCard){
	MsgBox, No card was found! Make sure you have parsed everything.
}


Loop, %Row% {   ;Reset 
	GuiControl,,% RowNames[A_Index+1] "Percent",% ""
	;GuiControl,,% RowNames[A_Index+1] "Point",% ""
	;GuiControl,,% "Name",% ""
	;GuiControl,,% "Team",% ""
	;GuiControl,,% "Pos",% ""
}
Loop, 5 {
	LoopIndex:=A_Index
	If (CardBonusID%A_Index%[HighestCard]!=""){
		Loop, Parse, NameList, `,
		{
			If (CardBonusID%LoopIndex%[HighestCard]=A_Index){
				GuiControl,,% RowNames[CardBonusID%LoopIndex%[HighestCard]+1] "Percent",% (CardBonus%LoopIndex%[HighestCard])
			}
		}
	}
}
Return
