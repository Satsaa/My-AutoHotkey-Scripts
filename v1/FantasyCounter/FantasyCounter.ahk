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
ReadIni(,,"Loaded")
if (!Loaded){
  run "usage.txt"
}
ReadIniDefUndef(,,"Loaded", 1,"GuiLoadY",100,"GuiloadX",100,"AlwaysOnTop","0","ClearOnPaste","1","Stats","")

EditHeight:=18,
EditGrow:=5,
VerticalSpacing:=25,
ElementWidth:=35,
TextFormula:= " ym" " Center w" ElementWidth,
PosArray:=[],PosArray[1]:="Core",PosArray[2]:="Support",PosArray[3]:="Offlane"

Row:=0
Row++
RowName:="Player"
RowNames[Row]:=RowName
Gui, Add, Text,% TextFormula, %RowName%
Gui, Add, Edit,% "xp-" EditGrow " yp+" VerticalSpacing " wp+" EditGrow*2 " h" EditHeight " vName gName"
Gui, Add, Edit,% "xp yp+" VerticalSpacing " wp h" EditHeight " vTeam gTeam"
Gui, Add, Edit,% "xp yp+" VerticalSpacing " wp h" EditHeight " vPos gPos"

Gui, Add, Text,% "ym  w" ElementWidth,
Gui, Add, Text,% "vText1 wp yp+" VerticalSpacing+2, Points
Gui, Add, Text,% "vText2 wp yp+" VerticalSpacing, Percent
Gui, Add, Text,% "vText3 wp yp+" VerticalSpacing, Bonus

NameList:="Kills,Deaths,CS,GPM,Tower,Roshan,Team,Wards,Camps,Runes,Blood,Stuns,Total"
Loop, Parse, NameList, "`,"
{
	RowName:=A_LoopField
	RowNames[A_Index+1]:=A_LoopField
	Row++
	Gui, Add, Text,% TextFormula, %RowName%
}
Loop, Parse, NameList, "`," ;Source points
{
	RowName:=A_LoopField
	If (A_Index=1){
		Gui, Add, Edit,% "x" VerticalSpacing*3+30 " yp+" EditHeight+7 " w" ElementWidth+7 " h" EditHeight " v" RowName "Point gPoint",
	} else {
		Gui, Add, Edit,% "xp+" ElementWidth+10 " yp wp h" EditHeight " v" RowName ((A_LoopField="Total")?("Point ReadOnly"):("Point gPoint"))
	}
}
Loop, Parse, NameList, "`," ;Bonus percentages
{
	RowName:=A_LoopField
	If (A_Index=1){
		Gui, Add, Edit,% "x" VerticalSpacing*3+30 " yp+" EditHeight+7 " w" ElementWidth+7 " h" EditHeight " v" RowName ((A_LoopField="Total")?("Percent"):("Percent gPercent")),
	} else {
		Gui, Add, Edit,% "xp+" ElementWidth+10 " yp wp h" EditHeight " v" RowName ((A_LoopField="Total")?("Percent ReadOnly"):("Percent gPercent")),
	}
}
Loop, Parse, NameList, "`," ;Bonus points
{
	RowName:=A_LoopField
	If (A_Index=1){
		Gui, Add, Edit,% "x" VerticalSpacing*3+30 " yp+" EditHeight+7 " w" ElementWidth+7 " h" EditHeight " v" RowName ((A_LoopField="Total")?("Bonus"):("Bonus gBonus")) " ReadOnly",
	} else {
		Gui, Add, Edit,% "xp+" ElementWidth+10 " yp wp h" EditHeight " v" RowName ((A_LoopField="Total")?("Bonus"):("Bonus gBonus")) " ReadOnly",
	}
}
Gui, Add, Button,% "h" EditHeight+2 " ym+" -1 " gToClipboard", &Copy
Gui, Add, Button,% "wp hp yp+" VerticalSpacing " gFromClipboard", &Paste

Gui, Add, Button,% "h" EditHeight+2 " ym-" -1 " xp+" ElementWidth+5 " gImport", &Import
Gui, Add, Button,% "wp hp yp+" VerticalSpacing " gExport", &Export


OnExit SaveIni
If (AlwaysOnTop=1){
	Gui, +AlwaysOnTop
} else {
	Gui, -AlwaysOnTop
}
Gui, Add, Checkbox,% ((AlwaysOnTop=1) ? ("Checked ") : ("")) " xp-" ElementWidth+5 " yp+" VerticalSpacing  " vAlwaysOnTop gCheckBoxAlwaysOnTop", Always on top
Gui, Add, Checkbox,% ((ClearOnPaste=1) ? ("Checked ") : ("")) " xp" " yp+" VerticalSpacing " vClearOnPaste gCheckBoxClearOnPaste", Clear on paste
Gui, Add, Button,% "h" EditHeight+2 " ym-" -1 " xp+" ElementWidth*2+20 " gParseCards", Parse CardData.txt
Gui, Add, Button,% "wp hp yp+" VerticalSpacing " -wrap gParsePlayers", Parse PlayerData.txt
Gui, Add, Text,% "vHint wp yp+" VerticalSpacing, 100`%

Gui, Add, Button,% "w" 20 " hp+" 7 " yp+" VerticalSpacing " gHelp", ?
Gui, Add, Button,% "w" 76 " hp yp xp+" 25 " gReload", &Reload

Gui, Add, Button,% "h" EditHeight+2 " ym-" -1 " xp+" 86 " w" ElementWidth*3 " gGetHighestByPlayer", Best Card By Player
Gui, Add, Button,% "wp hp yp+" VerticalSpacing " gGetHighestByTeam", Best Card by Team
Gui, Add, Button,% "wp hp yp+" VerticalSpacing " gGetHighestByPos", Best Card by Pos
Gui, Add, Button,% "wp hp yp+" VerticalSpacing " gGetHighest", Best Card

Gui, Show, x%GuiLoadX% y%GuiLoadY% , %GuiTitle%
MoveGuiToBounds(1)
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
Run, usage.txt
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

ParseCards:  ;Parse your card stats
CardName := [],
CardTeamID := [],  ;Cards teamid
CardTeam := [],  ;Cards team name
CardPos := [],
CardBonus1 := [], CardBonus2 := [], CardBonus3 := [], CardBonus4 := [], CardBonus5 := [],
CardBonusID1 := [], CardBonusID2 := [], CardBonusID3 := [], CardBonusID4 := [], CardBonusID5 := [],

CardName:=,CardTeamID:=,CardTeam:=,TeamIdToName:=,CardPos:=,CardBonus1:=,CardBonus2:=,CardBonus3:=,CardBonus4:=,CardBonus5:=,
CardBonusID1:=,CardBonusID2:=,CardBonusID3:=,CardBonusID4:=,CardBonusID5:=
CardPlayerList:="", CardTeamList:="", Line:=0, CardEnd:=0, BonusIndex:=0, BonusLine:=0, Card:=0

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
				If !(InStr(CardPlayerList, CardName[Card] , 1)){  ;Put player name in to list if its not already in it
					CardPlayerList.=CardName[Card] ","
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
				CardTeam[Card]:=SubStr(A_LoopField, 3, StrLen(A_LoopField)-5)
				If !(InStr(CardTeamList, CardTeam[Card] , 1)){  ;Put Team name in to list if its not already in it
					CardTeamList.=CardTeam[Card] ","
				}
			}
		}
	} else If (Line=7) {
		Loop, Parse, A_LoopField, `:  ;Get role
		{
			If (A_Index=2){
				CardPos[Card]:=SubStr(A_LoopField, 2, StrLen(A_LoopField)-3)
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
			CardEnd:=0, BonusIndex:=0, Line:=0, BonusLine:=0
		} else If (BonusLine=1){
			BonusIndex++
			Loop, Parse, A_LoopField, `:  ;Get bonus ID
			{
				If (A_Index=2){
					CardBonusID%BonusIndex%[Card]:=SubStr(A_LoopField, 2, StrLen(A_LoopField)-3)+1
				}
			}
		} else If (BonusLine=2){
			Loop, Parse, A_LoopField, `:  ;Get bonus amount
			{
				If (A_Index=2){
					CardBonus%BonusIndex%[Card]:=SubStr(A_LoopField, 2, StrLen(A_LoopField)-2)
				}
			}
		} else If (BonusLine=4){  ;4 lines passed so reset counter
			BonusLine=0
		}
	}
}
GuiControl,,% "Hint",% "Parsed cards!"
CardPlayerList:=SubStrEnd(CardPlayerList,1), CardTeamList:=SubStrEnd(CardTeamList,1), CardPlayerCount:=0
Loop, Parse, CardPlayerList, `,
	CardPlayerCount++
Return

ParsePlayers:  ;Parse player specific stats
PlayerName := [],
PlayerNameToID := [], ;PlayerNameToID[{Players name}]={Players index} Name corresponds to the relevant id that works with player*[] arrays
PlayerTeam := [],
PlayerPos := [],
Loop, 12
	PlayerPoints%A_Index% := [],
PlayerTotal := [],

PlayerName:=,PlayerNameToID:=,PlayerTeam:=,PlayerPos:=,PlayerTotal:=,
PointPlayerList:="",
Loop, 12
	PlayerPoints%A_Index%:=,
Line:=0, Player:=0, PlayerLine:=0,

PlayerDataLines=0
Loop, Parse, PlayerData, `n
	PlayerDataLines++
FileRead, PlayerData, PlayerData.txt
PlayerDataStart := false
Loop, Parse, PlayerData, `n
{
	Line++
  if (InStr(A_LoopField, "Total Score")) {
    PlayerDataStart := True
    Continue
  }
  if (A_LoopField = "`r") {
    Continue
  }
	If (PlayerDataStart = true){
	  PlayerLine++
	  If (PlayerLine=1){
	  	Player++
	  	PlayerName[Player]:=SubStrEnd(A_LoopField)  ;Alot of outputs from playerdata have newlines at the end so many of these vars are cut from the end
	  	PlayerNameToID[PlayerName[Player]]:=Player ;Conversion table
	  	PointPlayerList.=PlayerName[Player] ","  ;Name list
	  } else If (PlayerLine=2){
	  	PlayerTeam[Player]:=SubStrEnd(A_LoopField)
	  	If (PlayerTeam[Player]=""){
	  		MsgBox,% PlayerTeam[Player] "," PlayerName[Player] "," PlayerNameToID[PlayerName[Player]] ","
	  	}
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
	  	PlayerTotal[Player]:=SubStrEnd(A_LoopField)
	  	PlayerLine=0
	  }
  }
}
GuiControl,,% "Hint",% "Parsed players!"
PointPlayerList:=SubStrEnd(PointPlayerList,1)
Return

GetHighestByPlayer: ;Get best card by already entered name
If (A_ThisLabel="GetHighestByPlayer"){
	If !(CardPlayerList){
		GoSub ParseCards
	}
	If !(PlayerName[1]){
		GoSub ParsePlayers
	}
	If (Name=""){
		MsgBox, Please fill in the name
		Return
	}
	MatchingName=0
	Loop, Parse, CardPlayerList, `,
	{
		If (Name=A_LoopField){
			MatchingName=1
		}
	}
	SimilarName5:="",Similarity5:="",SimilarName4:="",Similarity4:="",SimilarName3:="",Similarity3:="",SimilarName2:="",Similarity2:="",SimilarName:="",HighestSimilarity:=""
	If !(MatchingName){  ;Get closest name
		If (name="Noone"){
			SimilarName:="No[o]ne-"
		} else {
			Loop, Parse, CardPlayerList, `,
			{
				Similarity:=Compare(Name,A_LoopField)
				If (Similarity>HighestSimilarity){
					SimilarName5:=SimilarName4, Similarity5:=Similarity4, SimilarName4:=SimilarName3, Similarity4:=Similarity3,
					SimilarName3:=SimilarName2, Similarity3:=Similarity2, SimilarName2:=SimilarName, Similarity2:=HighestSimilarity,
					SimilarName:=A_LoopField, HighestSimilarity:=Similarity
				}
			}
		}
		Msgbox,3,,% "Current name """ Name """ didn't match any parsed name. Do you want to set name to the closest encounter " SimilarName "?"
				. "`nOther names: " SimilarName2 (SimilarName3?(", "SimilarName3):"") (SimilarName4?(", " SimilarName4):"") (SimilarName5?(", "5SimilarName):"") "."
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
}
GetHighestByTeam:  ;Get best player and card by team
If (A_ThisLabel="GetHighestByTeam"){
	If !(CardTeamList){
		GoSub ParseCards
	}
	If !(PlayerTeam[1]){
		GoSub ParsePlayers
	}
	If (Team=""){
		MsgBox, Please fill in the Team
		Return
	}
	MatchingTeam=0
	Loop, Parse, CardTeamList, `,
	{
		If (Team=A_LoopField){
			MatchingTeam=1
		}
	}
	SimilarTeam5:="",Similarity5:="",SimilarTeam4:="",Similarity4:="",SimilarTeam3:="",Similarity3:="",SimilarTeam2:="",Similarity2:="",SimilarTeam:="",HighestSimilarity:=""
	If !(MatchingTeam){  ;Get closest Team
		Loop, Parse, CardTeamList, `,
		{
			Similarity:=Compare(Team,A_LoopField)
			If (Similarity>HighestSimilarity){
				SimilarTeam5:=SimilarTeam4, Similarity5:=Similarity4, SimilarTeam4:=SimilarTeam3, Similarity4:=Similarity3,
				SimilarTeam3:=SimilarTeam2, Similarity3:=Similarity2, SimilarTeam2:=SimilarTeam, Similarity2:=HighestSimilarity,
				SimilarTeam:=A_LoopField, HighestSimilarity:=Similarity
			}
		}
		Msgbox,3,,% "Current Team """ Team """ didn't match any parsed Team. Do you want to set Team to the closest encounter " SimilarTeam "?"
				. "`nOther Teams: " SimilarTeam2 (SimilarTeam3?(", "SimilarTeam3):"") (SimilarTeam4?(", " SimilarTeam4):"") (SimilarTeam5?(", "5SimilarTeam):"") "."
		IfMsgBox, Yes
		{
			Team:=SimilarTeam
			GuiControl,, Team,% SimilarTeam
		} else {
			IfMsgBox, Cancel
			{
				Return
			}
		}
	}
}
GetHighestByPos:  ;Get best player and card by position
If (A_ThisLabel="GetHighestByPos"){
	If !(CardPosArray){
		GoSub ParseCards
	}
	If !(PlayerPos[1]){
		GoSub ParsePlayers
	}
	If (Pos=""){
		MsgBox, Please fill in the Pos
		Return
	}
	Loop, 3 {
		If (A_Index=4){
			MsgBox, Invalid position.`n Valid positions are "Core", "Support" and "Offlane".
		}
		If (PosArray[A_Index]:=Pos){
			Break
		}
	}
}
GetHighest:  ;Get the best card ever
HighestPoints:="",HighestCard:="",HighestName:="",HighestPlayerIndex:=""
HighestCard:="", HighestBonus:=0,Parsed:=0,Skipped:=0
If !(CardPlayerList){
	GoSub ParseCards
}
If !(PlayerName[1]){
	GoSub ParsePlayers
}
Loop, Parse, CardPlayerList, `,  ;Loop thru names
{
	GuiControl,,% "Hint",% Round((A_Index/CardPlayerCount)*100) "%"
	If (A_ThisLabel="GetHighestByPlayer" and  A_LoopField!=Name){
		Skipped+=Row
		Continue
	} else If (A_ThisLabel="GetHighestByPos" and  PlayerPos[A_Index]!=Pos){
		Skipped+=Row
		Continue
	}
	Loop, %Card% {  ;Loop thru all cards
		If (CardName[A_index]=A_LoopField){  ;Found match. Matches a card to a player.
			;MsgBox,% CardName[A_index] "=" A_LoopField  ;Announce matches
			Parsed++
			ThisPoints=0
			CardIndex:=A_Index
			PlayerIndex:=PlayerNameToID[A_LoopField]
			If (A_ThisLabel="GetHighestByTeam" and CardTeam[CardIndex]!=Team){
				Skipped++
				Continue
			}
			If !(PlayerIndex){
				ParseName:=A_LoopField
				If (A_LoopField="Ceb")  ;Manual aliases here. Sorry compare() is not perfect and valve cant do consistent naming
					PlayerIndex:=PlayerNameToID["7Mad"]
				else If (A_LoopField="MSS-")
					PlayerIndex:=PlayerNameToID["MSS"]
				else If (A_LoopField="No[o]ne-")
					PlayerIndex:=PlayerNameToID["Noone"]
				else If (A_LoopField="rtz")
					PlayerIndex:=PlayerNameToID["Arteezy"]
				else If (A_LoopField="冰冰冰")
					PlayerIndex:=PlayerNameToID["iceiceice"]
				else If (ParseName=A_LoopField){
					SimilarName:="", HighestSimilarity:=""
					Loop, Parse, PointPlayerList, `,
					{
						Similarity:=Compare(ParseName,A_LoopField)
						If (Similarity>HighestSimilarity and Similarity!=0){
							SimilarName:=A_LoopField, HighestSimilarity:=Similarity
						}
					}
					PlayerIndex:=PlayerNameToID[SimilarName]
					If !(PlayerIndex){
						MsgBox, Error getting PlayerIndex. No similar name found for %A_LoopField%. Probably bugged.
					}
					;MsgBox,% "Replaced """ A_LoopField """ with """ SimilarName """. Id is set to """ PlayerIndex """"  ;Announce replaced names
				}
			}
			Loop, 5 {  ;Point indexes
				If (CardBonusID%A_Index%[CardIndex]){
					PointIndex:=CardBonusID%A_Index%[CardIndex]
					ThisPoints:=ThisPoints+PlayerPoints%PointIndex%[PlayerIndex]*((CardBonus%A_Index%[CardIndex]/100))
				}
			}
			Loop, 12 {  ;Points
				ThisPoints:=ThisPoints+PlayerPoints%A_Index%[PlayerIndex]
			}
			If !(ThisPoints){
				MsgBox,% "Failed to gather total points `nA_LoopField " A_LoopField " `nParseName " ParseName " `nCardIndex " CardIndex " `nPlayerIndex " PlayerIndex " `nSimilarName " SimilarName " `nHighestSimilarity " HighestSimilarity 
			}
			If (ThisPoints>HighestPoints){
				HighestPoints:=TrimTrailingZeros(ThisPoints)
				HighestCard:=CardIndex
				HighestName:=PlayerName[PlayerIndex]
				HighestPlayerIndex:=PlayerIndex
			}
		}
	}
}
GuiControl,,% "Hint",% "Search finished!"
;MsgBox, 1, A_ThisLabel,% "Checked " Parsed " cards." ((Skipped)?(" Skipped " Skipped " cards"):("")) "`n"
;	. "Card " HighestCard " with " HighestPoints " points. " HighestName " from " CardTeam[HighestCard] ". " PosArray[CardPos[HighestCard]] ".`n"
IfMsgBox, Cancel
	Return
If (HighestCard=""){
	MsgBox, No card was found?
	Return
}
Loop, %Row% {   ;Reset 
	GuiControl,,% RowNames[A_Index+1] "Percent",% ""
	GuiControl,,% RowNames[A_Index+1] "Point",% ""
	GuiControl,,% "Name",% ""
	GuiControl,,% "Team",% ""
	GuiControl,,% "Pos",% ""
}
GuiControl,,% "Name",% PlayerName[HighestPlayerIndex]
GuiControl,,% "Team",% PlayerTeam[HighestPlayerIndex]
GuiControl,,% "Pos",% PlayerPos[HighestPlayerIndex]
Loop, 12 {  ;Set points
	GuiControl,,% RowNames[A_Index+1] "Point",% PlayerPoints%A_Index%[HighestPlayerIndex]
}
Loop, 5 {  ;Set percentages
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
GuiControl,,% "Text1", Points
GuiControl,,% "Text2", Percent
GuiControl,,% "Text3", Bonus
Return
