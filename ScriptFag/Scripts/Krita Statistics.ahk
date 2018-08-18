SC++
HotkeyName[SC] := "Krita_Statistics"
HotkeySub[SC] := "KS"
HotkeySettings[SC] := "KS_Enable"
HotkeySettingsDescription[SC] := "KS_Enable:`nEnable this script?`n`n"
HotkeyDescription[SC] := "Tracks time spent and time drawn on files.`n`nHotkey:`nPrint those sweet statisctics`n`nShift:`nToggle surveillance"
HotkeyShift[SC] := 1
HotkeyTick[SC] := 1
KS_TimeOut:=10  ;~Seconds untill counting pauses when mouse is not moved
ReadIniDefUndef("Krita","Surveillance.ini","KS_OpenTimeSec","0","KS_DrawTimeSec","0","KS_Enable","0","KS_AlwaysOnTop","1")
GoTo KS_End

KS_Load:
If !(KS_Loaded=1){
	KS_OpenTime:=KS_OpenTimeSec*TPS
	KS_DrawTime:=KS_DrawTimeSec*TPS
	KS_Loaded:=1
	Ks_GuiOpen:=0
}
Return

KS:
If (KS_Enable=1){
	If InStr(ActiveTitle, "Krita", 1){
		WinGet, KS_Exe, ProcessName, A
		If (KS_Exe="krita.exe"){
			If Instr(ActiveTitle, "["){
				RegExMatch(ActiveTitle, ".*\[" , KS_FileName)
				If (KS_FileName="["){
					KS_FileName:="Untitled"
				} else {
					KS_FileName:=SubStr(KS_FileName, 1, StrLen(KS_FileName)-2)
					SplitPath, KS_FileName ,,,, KS_FileName,
				}  ;Remove most illegal chars for variable names
				KS_FileName:=RegExReplace(KS_FileName, "\-|\ |\.|\,|\+|\'|\{|\[|\]|\}|\(|\)|\=|\||\<|\>", "_")
				ReadIniDefUndef("Krita","Surveillance.ini",KS_FileName "OpenTimeSec",0,KS_FileName "DrawTimeSec",0,KS_FileName "FirstSeen",A_YYYY "-" A_MM "-" A_DD)
				%KS_FileName%OpenTime:=%KS_FileName%OpenTimeSec*TPS
				%KS_FileName%DrawTime:=%KS_FileName%DrawTimeSec*TPS
			} else {
				If InStr(ActiveTitle, ")  - Krita", 1){
					RegExMatch(ActiveTitle, ".*\(" , KS_FileName)
					KS_FileName:=SubStr(KS_FileName, 1, StrLen(KS_FileName)-2)
					SplitPath, KS_FileName ,,,, KS_FileName,
					;Remove most illegal chars for variable names
					KS_FileName:=RegExReplace(KS_FileName, "\-|\ |\.|\,|\+|\'|\{|\[|\]|\}|\(|\)|\=|\||\<|\>", "_")
					ReadIniDefUndef("Krita","Surveillance.ini",KS_FileName "OpenTimeSec",0,KS_FileName "DrawTimeSec",0,KS_FileName "FirstSeen",A_YYYY "-" A_MM "-" A_DD)
					%KS_FileName%OpenTime:=%KS_FileName%OpenTimeSec*TPS
					%KS_FileName%DrawTime:=%KS_FileName%DrawTimeSec*TPS
				}
			}
		}
	}
}
DebugAffix("Last file: " KS_FileName
	. "`nTime active: " FormatSeconds(Round(%KS_FileName%OpenTime/tps))
	. "`nTime drawing: " Round((%KS_FileName%DrawTime/%KS_FileName%OpenTime)*100) "%"
	. "`nAll time active: " FormatSeconds(Round(KS_OpenTime/tps))
	. "`nAll time drawing: " Round((KS_DrawTime/KS_OpenTime)*100) "%"
	. "`nCreated: " %KS_FileName%FirstSeen
	. "`n",0)
Return

KS_Tick:
If (KS_Enable=1){
	If (ActiveTitle!=OldActiveTitle){
		If (KS_KritaActive=1){ ;Save values to disk when title changes
			KS_OpenTimeSec:=KS_OpenTime/TPS
			KS_DrawTimeSec:=KS_DrawTime/TPS
			WriteIni("Krita","Surveillance.ini","KS_OpenTimeSec","KS_DrawTimeSec")
			%KS_FileName%OpenTimeSec:=%KS_FileName%OpenTime/TPS
			%KS_FileName%DrawTimeSec:=%KS_FileName%DrawTime/TPS
			WriteIni("Krita","Surveillance.ini", KS_FileName "OpenTimeSec", KS_FileName "DrawTimeSec")
		}
		If InStr(ActiveTitle, "Krita", 1){
				WinGet, KS_Exe, ProcessName, A
				If (KS_Exe="krita.exe"){
					If Instr(ActiveTitle, "["){
						KS_KritaActive=1
						RegExMatch(ActiveTitle, ".*\[" , KS_FileName)
						If (KS_FileName="["){
							KS_FileName:="Untitled"
						} else {
							KS_FileName:=SubStr(KS_FileName, 1, StrLen(KS_FileName)-2)
							SplitPath, KS_FileName ,,,, KS_FileName,
						}  ;Remove most illegal chars for variable names
						KS_FileName:=RegExReplace(KS_FileName, "\-|\ |\.|\,|\+|\'|\{|\[|\]|\}|\(|\)|\=|\||\<|\>", "_")
						ReadIniDefUndef("Krita","Surveillance.ini",KS_FileName "OpenTimeSec",0,KS_FileName "DrawTimeSec",0,KS_FileName "FirstSeen",A_YYYY "-" A_MM "-" A_DD)
						%KS_FileName%OpenTime:=%KS_FileName%OpenTimeSec*TPS
						%KS_FileName%DrawTime:=%KS_FileName%DrawTimeSec*TPS
						GuiControl,KS:, KS_Header,% "Krita Surveillance - Active"
						GuiControl,KS:, KS_CurrentFile,% "Last file: " KS_FileName
						GuiControl,KS:, KS_CurrentTime,% "Time active: " FormatSeconds(Round(%KS_FileName%OpenTime/tps))
						GuiControl,KS:, KS_CurrentDraw,% "Time drawing: " Round((%KS_FileName%DrawTime/%KS_FileName%OpenTime)*100) "%"
						GuiControl,KS:, KS_FirstSeen,% "Created: " %KS_FileName%FirstSeen
					} else {
						If InStr(ActiveTitle, ")  - Krita", 1){
							KS_KritaActive=1
							RegExMatch(ActiveTitle, ".*\(" , KS_FileName)
							KS_FileName:=SubStr(KS_FileName, 1, StrLen(KS_FileName)-2)
							SplitPath, KS_FileName ,,,, KS_FileName,
							;Remove most illegal chars for variable names
							KS_FileName:=RegExReplace(KS_FileName, "\-|\ |\.|\,|\+|\'|\{|\[|\]|\}|\(|\)|\=|\||\<|\>", "_")
							ReadIniDefUndef("Krita","Surveillance.ini",KS_FileName "OpenTimeSec",0,KS_FileName "DrawTimeSec",0,KS_FileName "FirstSeen",A_YYYY "-" A_MM "-" A_DD)
							%KS_FileName%OpenTime:=%KS_FileName%OpenTimeSec*TPS
							%KS_FileName%DrawTime:=%KS_FileName%DrawTimeSec*TPS
							GuiControl,KS:, KS_Header,% "Krita Surveillance - Active"
							GuiControl,KS:, KS_CurrentFile,% "Last file: " KS_FileName
							GuiControl,KS:, KS_CurrentTime,% "Time active: " FormatSeconds(Round(%KS_FileName%OpenTime/tps))
							GuiControl,KS:, KS_CurrentDraw,% "Time drawing: " Round((%KS_FileName%DrawTime/%KS_FileName%OpenTime)*100) "%"
							GuiControl,KS:, KS_FirstSeen,% "Created: " %KS_FileName%FirstSeen
						}
					} 
				} else {
					KS_KritaActive:=0
					GuiControl,KS:, KS_Header,% "Krita Surveillance - Inactive"
				}
		} else {
			GuiControl,KS:, KS_Header,% "Krita Surveillance - Inactive"
			KS_KritaActive:=0
		}
	}
	If (KS_KritaActive=1){
		If (KS_AFK=1){  ;Check if not inactive anymore
			MouseGetPos, KS_MouseX2, KS_MouseY2,
			If (KS_MouseX2=KS_MouseX and KS_MouseY2=KS_MouseY){
				KS_MouseX:=KS_MouseX2
				KS_MouseY:=KS_MouseY2
			} else {
				KS_AFK=0
				GuiControl,KS:, KS_Header,% "Krita Surveillance - Active"
			}
		} else {  ;Active. Count ticks
			%KS_FileName%OpenTime++
			KS_OpenTime++
			KS_CountTick++
			IF (KS_CountTick>=TPS){
				GuiControl,KS:, KS_CurrentTime,% "Time active: " FormatSeconds(Round(%KS_FileName%OpenTime/tps))
				GuiControl,KS:, KS_CurrentDraw,% "Time drawing: " Round((%KS_FileName%DrawTime/%KS_FileName%OpenTime)*100) "%"
				GuiControl,KS:, KS_AllTime,% "All time active: " FormatSeconds(Round(KS_OpenTime/tps))
				GuiControl,KS:, KS_AllDraw,% "All time drawing: " Round((KS_DrawTime/KS_OpenTime)*100) "%"
				KS_CountTick:=0
			}
			If (GetKeyState("LButton","P")){
				KS_DrawTime++
				%KS_FileName%DrawTime++
			}
		}
		;Check if inactive
		KS_SubTick++
		If (KS_SubTick=TPS*KS_TimeOut){
				KS_SubTick:=0
				MouseGetPos, KS_MouseX2, KS_MouseY2,
				If (KS_MouseX2=KS_MouseX and KS_MouseY2=KS_MouseY){
					KS_AFK:=1
					GuiControl,KS:, KS_Header,% "Krita Surveillance - Paused" 
				} else {
					KS_AFK:=0
				}
		} else {
			If (KS_SubTick=1){
				MouseGetPos, KS_MouseX, KS_MouseY,
			}
		}
	}
}
Return

KS_Shift:
If (Ks_GuiOpen=0){
	KS_Width:=300
	Gui, KS:Add, Text, vKS_Header -Wrap w%KS_Width%, Krita Surveillance
	Gui, KS:Add, Checkbox,% ((KS_Enable=1) ? ("Checked ") : ("")) " vKS_Enable gKS_CheckBox", Enable surveillance
	Gui, KS:Add, Checkbox,% ((KS_AlwaysOnTop=1) ? ("Checked ") : ("")) " vKS_AlwaysOnTop gKS_CheckBoxAOT", Always on top
	Gui, KS:Add, Text, vKS_CurrentFile -Wrap w%KS_Width% yp+35,
	Gui, KS:Add, Text, vKS_CurrentTime -Wrap w%KS_Width% yp+18 xm,
	Gui, KS:Add, Edit, vKS_CurrentTimeEdit gKS_CurrentTimeInput -Wrap xp+60 yp wp-60 h17 Number hidden,
	Gui, KS:Add, Text, vKS_CurrentDraw -Wrap w95 yp+18 xm,
	Gui, KS:Add, Slider, vKS_CurrentDrawEdit gKS_CurrentDrawInput AltSubmit -Wrap xp+95 yp w205 h17 Thick15 hidden,
	Gui, KS:Add, Text, vKS_FirstSeen -Wrap w%KS_Width% yp+18 xm,
	Gui, KS:Add, Edit, vKS_FirstSeenEdit gFirstSeenInput -Wrap xp+42 yp wp-42 h17 hidden,
	Gui, KS:Add, Text, vKS_AllTime -Wrap w%KS_Width% yp+35 xm,
	Gui, KS:Add, Edit, vKS_AllTimeEdit gKS_AllTimeInput -Wrap xp+70 yp wp-70 h17 Number hidden,
	Gui, KS:Add, Text, vKS_AllDraw -Wrap w105 yp+18 xm,
	Gui, KS:Add, Slider, vKS_AllDrawEdit gKS_AllDrawInput AltSubmit -Wrap xp+105 yp w195 h17 Thick15 hidden,
	Gui, KS:Add, Button, vKS_Edit gKS_Edit w%KS_Width% yp+18 xm, Edit
	If (KS_KritaActive=1){
		GuiControl,KS:, KS_Header,% "Krita Surveillance - Active"
		GuiControl,KS:, KS_CurrentFile,% "Current file:" KS_FileName
		GuiControl,KS:, KS_CurrentTime,% "Time active: " FormatSeconds(Round(%KS_FileName%OpenTime/tps))
		GuiControl,KS:, KS_CurrentDraw,% "Time drawing: " Round((%KS_FileName%DrawTime/%KS_FileName%OpenTime)*100) "%"
		GuiControl,KS:, KS_FirstSeen,% "Created: " %KS_FileName%FirstSeen
	} else {
		If (KS_FileName){
			GuiControl,KS:, KS_Header,% "Krita Surveillance - Inactive"
			GuiControl,KS:, KS_CurrentFile,% "Current file: " KS_FileName
			GuiControl,KS:, KS_CurrentTime,% "Time active: " FormatSeconds(Round(%KS_FileName%OpenTime/tps))
			GuiControl,KS:, KS_CurrentDraw,% "Time drawing: " Round((%KS_FileName%DrawTime/%KS_FileName%OpenTime)*100) "%"
			GuiControl,KS:, KS_FirstSeen,% "Created: " %KS_FileName%FirstSeen
		} else {
			GuiControl,KS:, KS_CurrentFile,% "Current file: None"
			GuiControl,KS:, KS_CurrentTime,% "Time active: -"
			GuiControl,KS:, KS_CurrentDraw,% "Time drawing: -"
			GuiControl,KS:, KS_FirstSeen,% "Created: -"
		}
	}
	If (KS_Enable!=1){
		GuiControl,KS:, KS_Header,% "Krita Surveillance - Disabled"
	}
	GuiControl,KS:, KS_AllTime,% "All time active: " FormatSeconds(Round(KS_OpenTime/tps))
	GuiControl,KS:, KS_AllDraw,% "All time drawing: " Round((KS_DrawTime/KS_OpenTime)*100) "%"
	ReadIniDefUndef("Krita","Surveillance.ini","KS_GuiLoadX",A_ScreenWidth/2,"KS_GuiLoadY",A_ScreenHeight/2)
	If (KS_AlwaysOnTop=1){
		Gui, KS: -MinimizeBox +AlwaysOnTop
		Gui, KS:Show, NoActivate x%KS_GuiLoadX% y%KS_GuiLoadY%, Krita Surveillance
	} else {
		Gui, KS: -MinimizeBox -AlwaysOnTop
		Gui, KS:Show, x%KS_GuiLoadX% y%KS_GuiLoadY%, Krita Surveillance
	}
	Ks_GuiOpen:=1
} else {  ;Close gui if gui was open
	Gui, KS: +LastFound
	WinClose,
}
Return

ReadIniDefUndef("Krita","Surveillance.ini",KS_FileName "OpenTimeSec",KS_FileName "DrawTimeSec",KS_FileName "FirstSeen")

KS_CurrentTimeInput:
Gui, KS:Submit, NoHide
KS_Enable:=0
%KS_FileName%OpenTime:=%A_GuiControl%*tps
%KS_FileName%OpenTimeSec:=%A_GuiControl%
WriteIni("krita","Surveillance.ini",KS_FileName "OpenTimeSec")
Return

KS_CurrentDrawInput:
Gui, KS:Submit, NoHide
KS_Enable:=0
%KS_FileName%DrawTimePercent:=%A_GuiControl%
%KS_FileName%DrawTime:=%KS_FileName%OpenTime*(%KS_FileName%DrawTimePercent/100)
%KS_FileName%DrawTimeSec:=%KS_FileName%DrawTime/TPS
GuiControl,KS:, KS_CurrentDraw,% "Time drawing: " Round((%KS_FileName%DrawTime/%KS_FileName%OpenTime)*100) "%"
Return

FirstSeenInput:
Gui, KS:Submit, NoHide
KS_Enable:=0
WriteIni("krita","Surveillance.ini",KS_FileName "FirstSeen")
%KS_FileName%FirstSeen:=%A_GuiControl%
Return

KS_AllTimeInput:
Gui, KS:Submit, NoHide
KS_Enable:=0
KS_OpenTime:=%A_GuiControl%*tps
KS_OpenTimeSec:=%A_GuiControl%
WriteIni("krita","Surveillance.ini","KS_OpenTimeSec")
Return

KS_AllDrawInput:
Gui, KS:Submit, NoHide
KS_Enable:=0
KS_DrawTimePercent:=%A_GuiControl%
KS_DrawTime:=KS_OpenTime*(KS_DrawTimePercent/100)
KS_DrawTimeSec:=KS_DrawTime/TPS
GuiControl,KS:, KS_AllDraw,% "All time drawing: " Round((KS_DrawTime/KS_OpenTime)*100) "%"
Return

KS_Edit:
If (!KS_EditShow){  ;Edit
	KS_EnableOld:=KS_Enable
	KS_EditShow:=1
	KS_Enable:=0
	GuiControl,KS:, KS_Edit, Apply
	GuiControl,KS:, KS_CurrentTimeEdit,% %KS_FileName%OpenTime/tps
	%KS_FileName%DrawTimePercent:=(%KS_FileName%DrawTime/%KS_FileName%OpenTime)*100
	GuiControl,KS:, KS_CurrentDrawEdit,% %KS_FileName%DrawTimePercent
	GuiControl,KS:, KS_AllTimeEdit,% KS_OpenTime/tps
	GuiControl,KS:, KS_Header,% "Krita Surveillance - Paused"
	KS_DrawTimePercent:=(KS_DrawTime/KS_OpenTime)*100
	GuiControl,KS:, KS_AllDrawEdit,% KS_DrawTimePercent
	GuiControl,KS:, KS_FirstSeenEdit,% %KS_FileName%FirstSeen
	GuiControl, Disable, KS_Enable
	GuiControl, Show, KS_CurrentTimeEdit
	GuiControl, Show, KS_CurrentDrawEdit
	GuiControl, Show, KS_FirstSeenEdit
	GuiControl, Show, KS_AllTimeEdit
	GuiControl, Show, KS_AllDrawEdit
} else {  ;Apply
	KS_EditShow=0
	KS_Enable:=KS_EnableOld
	If (KS_Enable=0){
		GuiControl,KS:, KS_Header,% "Krita Surveillance - Disabled"
	} else {
		GuiControl,KS:, KS_Header,% "Krita Surveillance - Inactive"
	}
	%KS_FileName%DrawTime:=%KS_FileName%OpenTime*(%KS_FileName%DrawTimePercent/100)
	%KS_FileName%DrawTimeSec:=%KS_FileName%DrawTime/TPS
	KS_DrawTime:=KS_OpenTime*(KS_DrawTimePercent/100)
	KS_DrawTimeSec:=KS_DrawTime/TPS
	WriteIni("Krita","Surveillance.ini",KS_FileName "DrawTimeSec","KS_DrawTimeSec")
	GuiControl,KS:, KS_Edit, Edit
	GuiControl,KS:, KS_CurrentTime,% "Time active: " FormatSeconds(Round(%KS_FileName%OpenTime/tps))
	GuiControl,KS:, KS_CurrentDraw,% "Time drawing: " Round((%KS_FileName%DrawTime/%KS_FileName%OpenTime)*100) "%"
	GuiControl,KS:, KS_AllTime,% "All time active: " FormatSeconds(Round(KS_OpenTime/tps))
	GuiControl,KS:, KS_AllDraw,% "All time drawing: " Round((KS_DrawTime/KS_OpenTime)*100) "%"
	GuiControl,KS:, KS_FirstSeen,% "Created: " %KS_FileName%FirstSeen
	GuiControl, Enable, KS_Enable
	GuiControl, Hide, KS_CurrentTimeEdit
	GuiControl, Hide, KS_CurrentDrawEdit
	GuiControl, Hide, KS_FirstSeenEdit
	GuiControl, Hide, KS_AllTimeEdit
	GuiControl, Hide, KS_AllDrawEdit
}
Return

KS_CheckBox:
Gui, KS:Submit, NoHide
KS_Enable:=%A_GuiControl%
WriteIni("Krita","Surveillance.ini","KS_Enable")
If (KS_Enable=0){
	GuiControl,KS:, KS_Header,% "Krita Surveillance - Disabled"
} else {
	GuiControl,KS:, KS_Header,% "Krita Surveillance - Inactive"
}
Return

KS_CheckBoxAOT:
Gui, KS:Submit, NoHide
KS_AlwaysOnTop:=%A_GuiControl%
WriteIni("Krita","Surveillance.ini","KS_AlwaysOnTop")
If (KS_AlwaysOnTop=1){
	Gui, KS: +AlwaysOnTop
} else {
	Gui, KS: -AlwaysOnTop
}
Return

KSGuiClose:
KS_EditShow:=0
Ks_GuiOpen:=0
Gui, KS: +LastFound
WinGetPos,KS_GuiLoadX,KS_GuiLoadY,KS_GuiW
If !(KS_GuiLoadX<150-KS_GuiW or KS_GuiLoadY<0){
	WriteIni("Krita","Surveillance.ini","KS_GuiLoadX","KS_GuiLoadY")
}
Gui, KS:Destroy
Return

KS_Settings:
If (ChangingSetting="KS_Enable"){
	If (%A_GuiControl%="0" or %A_GuiControl%="1")
		GoTo SettingsSuccess
} else {
	DebugSet(ChangingSetting " must be 1 or 0")
}
Return

KS_End: