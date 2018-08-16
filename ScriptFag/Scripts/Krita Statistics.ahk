SC++
HotkeyName[SC] := "Krita_Statistics"
HotkeySub[SC] := "KS"
HotkeySettings[SC] := "KS_Enable"
HotkeySettingsDescription[SC] := "KS_Enable:`nEnable this script?`n`n"
HotkeyDescription[SC] := "Tracks time spent and time drawn on files.`n`nHotkey:`nPrint those sweet statisctics`n`nShift:`nToggle surveillance"
HotkeyShift[SC] := 1
HotkeyTick[SC] := 1
KS_TimeOut:=10  ;~Seconds untill counting pauses when mouse is not moved
ReadIniDefUndef("Krita","Surveillance.ini","KS_OpenTimeSec","0","KS_DrawTimeSec","0","KS_Enable","0")
GoTo KS_End

KS_Load:
If !(KS_Loaded=1){
	KS_OpenTime:=KS_OpenTimeSec*TPS
	KS_DrawTime:=KS_DrawTimeSec*TPS
	KS_Loaded:=1
}
Return

KS:
If (KS_Enable=0){
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
				ReadIniDefUndef("Krita","Surveillance.ini",KS_FileName "OpenTimeSec",0,KS_FileName "DrawTimeSec",0)
				%KS_FileName%OpenTime:=%KS_FileName%OpenTimeSec*TPS
				%KS_FileName%DrawTime:=%KS_FileName%DrawTimeSec*TPS
			} else {
				If InStr(ActiveTitle, ")  - Krita", 1){
					RegExMatch(ActiveTitle, ".*\(" , KS_FileName)
					KS_FileName:=SubStr(KS_FileName, 1, StrLen(KS_FileName)-2)
					SplitPath, KS_FileName ,,,, KS_FileName,
					;Remove most illegal chars for variable names
					KS_FileName:=RegExReplace(KS_FileName, "\-|\ |\.|\,|\+|\'|\{|\[|\]|\}|\(|\)|\=|\||\<|\>", "_")
					ReadIniDefUndef("Krita","Surveillance.ini",KS_FileName "OpenTimeSec",0,KS_FileName "DrawTimeSec",0)
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
	. "`n",0)
Return

			GuiControl,KS:, KS_CurrentTime,% "Time active: " FormatSeconds(Round(%KS_FileName%OpenTime/tps))
			GuiControl,KS:, KS_CurrentDraw,% "Time drawing: " Round((%KS_FileName%DrawTime/%KS_FileName%OpenTime)*100) "%"
			GuiControl,KS:, KS_AllTime,% "All time active: " FormatSeconds(Round(KS_OpenTime/tps))
			GuiControl,KS:, KS_AllDraw,% "All time drawing: " Round((KS_DrawTime/KS_OpenTime)*100) "%"

KS_Tick:
If (KS_Enable!=1){
	Return
}
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
					GuiControl,KS:, KS_Header,% "Krita Surveillance - Active"
					RegExMatch(ActiveTitle, ".*\[" , KS_FileName)
					If (KS_FileName="["){
						KS_FileName:="Untitled"
					} else {
						KS_FileName:=SubStr(KS_FileName, 1, StrLen(KS_FileName)-2)
						SplitPath, KS_FileName ,,,, KS_FileName,
					}  ;Remove most illegal chars for variable names
					KS_FileName:=RegExReplace(KS_FileName, "\-|\ |\.|\,|\+|\'|\{|\[|\]|\}|\(|\)|\=|\||\<|\>", "_")
					ReadIniDefUndef("Krita","Surveillance.ini",KS_FileName "OpenTimeSec",0,KS_FileName "DrawTimeSec",0)
					%KS_FileName%OpenTime:=%KS_FileName%OpenTimeSec*TPS
					%KS_FileName%DrawTime:=%KS_FileName%DrawTimeSec*TPS
					GuiControl,KS:, KS_CurrentFile,% "Last file: " KS_FileName
					GuiControl,KS:, KS_CurrentTime,% "Time active: " FormatSeconds(Round(%KS_FileName%OpenTime/tps))
					GuiControl,KS:, KS_CurrentDraw,% "Time drawing: " Round((%KS_FileName%DrawTime/%KS_FileName%OpenTime)*100) "%"
				} else {
					If InStr(ActiveTitle, ")  - Krita", 1){
						KS_KritaActive=1
						GuiControl,KS:, KS_Header,% "Krita Surveillance - Active"
						RegExMatch(ActiveTitle, ".*\(" , KS_FileName)
						KS_FileName:=SubStr(KS_FileName, 1, StrLen(KS_FileName)-2)
						SplitPath, KS_FileName ,,,, KS_FileName,
						;Remove most illegal chars for variable names
						KS_FileName:=RegExReplace(KS_FileName, "\-|\ |\.|\,|\+|\'|\{|\[|\]|\}|\(|\)|\=|\||\<|\>", "_")
						ReadIniDefUndef("Krita","Surveillance.ini",KS_FileName "OpenTimeSec",0,KS_FileName "DrawTimeSec",0)
						%KS_FileName%OpenTime:=%KS_FileName%OpenTimeSec*TPS
						%KS_FileName%DrawTime:=%KS_FileName%DrawTimeSec*TPS
						GuiControl,KS:, KS_CurrentFile,% "Last file: " KS_FileName
						GuiControl,KS:, KS_CurrentTime,% "Time active: " FormatSeconds(Round(%KS_FileName%OpenTime/tps))
						GuiControl,KS:, KS_CurrentDraw,% "Time drawing: " Round((%KS_FileName%DrawTime/%KS_FileName%OpenTime)*100) "%"
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
Return

KS_Shift:
Gui, KS:Add, Text, vKS_Header -Wrap w300, Krita Surveillance
Gui, KS:Add, Checkbox,% ((KS_Enable=1) ? ("Checked ") : ("")) " vKS_Enable gKS_CheckBox", Enable surveillance
Gui, KS:Add, Text, vKS_CurrentFile -Wrap w300,
Gui, KS:Add, Text, vKS_CurrentTime -Wrap w300,
Gui, KS:Add, Text, vKS_CurrentDraw -Wrap w300,
Gui, KS:Add, Text, w300,
Gui, KS:Add, Text, vKS_AllTime -Wrap w300,
Gui, KS:Add, Text, vKS_AllDraw -Wrap w300,
If (KS_KritaActive=1){
	GuiControl,KS:, KS_Header,% "Krita Surveillance - Active"
	GuiControl,KS:, KS_CurrentFile,% "Current file:" KS_FileName
	GuiControl,KS:, KS_CurrentTime,% "Time active: " FormatSeconds(Round(%KS_FileName%OpenTime/tps))
	GuiControl,KS:, KS_CurrentDraw,% "Time drawing: " Round((%KS_FileName%DrawTime/%KS_FileName%OpenTime)*100) "%"
} else {
	If (KS_FileName){
		GuiControl,KS:, KS_Header,% "Krita Surveillance - Inactive"
		GuiControl,KS:, KS_CurrentFile,% "Current file: " KS_FileName
		GuiControl,KS:, KS_CurrentTime,% "Time active: " FormatSeconds(Round(%KS_FileName%OpenTime/tps))
		GuiControl,KS:, KS_CurrentDraw,% "Time drawing: " Round((%KS_FileName%DrawTime/%KS_FileName%OpenTime)*100) "%"
	} else {
		GuiControl,KS:, KS_CurrentFile,% "Current file: -"
		GuiControl,KS:, KS_CurrentTime,% "Time active: -"
		GuiControl,KS:, KS_CurrentDraw,% "Time drawing: -"
	}
}
If (KS_Enable=0){
	GuiControl,KS:, KS_Header,% "Krita Surveillance - Disabled"
}
GuiControl,KS:, KS_AllTime,% "All time active: " FormatSeconds(Round(KS_OpenTime/tps))
GuiControl,KS:, KS_AllDraw,% "All time drawing: " Round((KS_DrawTime/KS_OpenTime)*100) "%"
Gui, KS: -MinimizeBox +AlwaysOnTop
Gui, KS:Show, NoActivate, Krita Surveillance

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

KSGuiClose:
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