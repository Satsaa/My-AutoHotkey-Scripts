SC++
HotkeyName[SC] := "Krita_Statistics"
HotkeySub[SC] := "KS"
HotkeySettings[SC] := "KS_Enable"
HotkeySettingsDescription[SC] := "KS_Enable:`nEnable this script?`n`n"
HotkeyDescription[SC] := "Hotkey:`nPrint those sweet statisctics`n`nShift:`nToggle surveillance"
HotkeyTick[SC] := 1
KS_TimeOut:=5  ;~Seconds untill counting pauses when mouse is not moved
ReadIniDefUndef("Krita","Surveillance.ini","KS_OpenTimeSec","0","KS_DrawTimeSec","0")
GoTo KS_End

KS_Load:
If !(KS_Loaded=1){
	KS_OpenTime:=KS_OpenTimeSec*TPS
	KS_DrawTime:=KS_DrawTimeSec*TPS
	KS_Loaded:=1
}
Return

KS:
DebugAffix(Round((%KS_FileName%OpenTime)/TPS/60) " minutes spent on this file`n"
	. "This file " Round((%KS_FileName%OpenTime)/TPS) "/" Round(%KS_FileName%DrawTime/TPS) "s (" Round(%KS_FileName%DrawTime/%KS_FileName%OpenTime*100) "%)`n"
	. "All files " Round(KS_OpenTime/TPS) "/" Round(KS_DrawTime/TPS) "s (" Round(KS_DrawTime/KS_OpenTime*100) "%)`n",0)
Return

KS_Tick:
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
			If (KS_Exe="krita.exe" and Instr(ActiveTitle, "[")){
				KS_KritaActive=1
				RegExMatch(ActiveTitle, ".*\[" , KS_FileName)
				If (KS_FileName="["){
					KS_FileName:="Untitled"
				} else {
					KS_FileName:=SubStr(KS_FileName, 1, StrLen(KS_FileName)-2)
					SplitPath, KS_FileName ,,,, KS_FileName,
				}
				ReadIniDefUndef("Krita","Surveillance.ini",KS_FileName "OpenTimeSec",0,KS_FileName "DrawTimeSec",0)
				%KS_FileName%OpenTime:=%KS_FileName%OpenTimeSec*TPS
				%KS_FileName%DrawTime:=%KS_FileName%DrawTimeSec*TPS
			} else {
				KS_KritaActive:=0
			}
	} else {
		KS_KritaActive:=0
	}
}
If (KS_KritaActive=1){
	If (KS_AFK=1){
		MouseGetPos, KS_MouseX2, KS_MouseY2,
		If (KS_MouseX2=KS_MouseX and KS_MouseY2=KS_MouseY){
			KS_MouseX:=KS_MouseX2
			KS_MouseY:=KS_MouseY2
		} else {
			KS_AFK=0
			DebugAffix("Surveillance resumed")
		}
	} else {
		%KS_FileName%OpenTime++
		KS_OpenTime++
		If (GetKeyState("LButton","P")){
			KS_DrawTime++
			%KS_FileName%DrawTime++
		}
	}
	KS_SubTick++
	If (KS_SubTick=TPS*KS_TimeOut){
			KS_SubTick:=0
			MouseGetPos, KS_MouseX2, KS_MouseY2,
			If (KS_MouseX2=KS_MouseX and KS_MouseY2=KS_MouseY){
				KS_AFK:=1
				DebugAffix("Surveillance paused")
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

KS_Tick2:
If (KS_KritaTitle!=ActiveTitle){
	KS_Tick++
	If (KS_Tick=10){
		If InStr(ActiveTitle, "Krita"){
			WinGet, KS_Exe, ProcessName, A
			If (KS_Exe="krita.exe"){
				KS_KritaTitle:=ActiveTitle
				DebugAffix("In krita")
			} else {
				DebugAffix("Not actual krita")
				KS_KritaTitle:=-1
			}
		}
	} else If (KS_Tick=100){
		Ks_Tick:=0
	}
} else {
	If (GetKeyState("LButton","P")){
		DebugAffix("We are so clicking rn")
	}
}
Return

KS_Shift:
If (KS_Enable){
	KS_Enable:=0
	DebugAffix("Krita surveillance is now disabled")
} else {
	KS_Enable:=1
	DebugAffix("Krita surveillance is now enabled")
}
WriteIni(Profile,,"KS_Enable")
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