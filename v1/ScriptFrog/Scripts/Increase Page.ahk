SC++
HotkeyName[SC] := "Increase_Page"
HotkeySub[SC] := "PI"
HotkeySettings[SC] := "PI_Velocity,PI_Replace"
HotkeySettingsDescription[SC] := "PI_Velocity:`nThe amount to add or substract (shared)"
HotkeyDescription[SC] := "Hotkey:`nAdd to the url's most right number`n`nShift:`nChoose the amount to add or substract (shared)"
HotkeyShift[SC] := 1

SC++
HotkeyName[SC] := "Increase_Page_Inverse"
HotkeySub[SC] := "PII"
HotkeyDescription[SC] := "Hotkey:`nSubstract from the url's most right number`n`nShift:`nChoose the amount to add or substract (shared)"
HotkeyShift[SC] := 1

GoTo PI_End

PI_Load:
    ReadIniDefUndef(Profile,,"PI_Velocity",1, "PI_Replace","\/?\?t=\d+.\d")
PII_load:
Return

PII:
    PI_Invert=1
    GoTo PI_Start
PI:
    PI_Invert=0
    GoTo PI_Start
PI_Start:
    MouseGetPos,,, PI_WinId,
    WinGet Process, ProcessName, ahk_id %PI_WinId%
    If (Process!="chrome.exe" and Process!="brave.exe"){
        Return
    }
    If !(PI_Velocity){
        GoTo PI_Shift
    }
    Send ^l
    Clipboard(1)
    Send ^c
    ClipWait 0.05
    If (ErrorLevel){
        Clipboard(0)
        ClipFailCount++
        If (ClipFailCount=10){
            ClipFailCount=0
            DebugPrepend("Failed to copy text at " A_ThisLabel)
            Return
        } else {
            GoTo %A_ThisLabel%
        }
    }
    ClipFailCount=0
    PI_Url := Clipboard
    If (PI_Url != ""){
        PI_Url := RegExReplace(PI_Url, PI_Replace)
    }
    PI_MatchPos := RegExMatch(PI_Url, "(-?\d+)(\D*$)", PI_Extract)
    If (!PI_MatchPos or ErrorLevel)
        Return
    PI_DubiousFormat := RegExMatch(SubStr(PI_Url, PI_MatchPos - 1, 1), "\w") == 1 ; Dubious formats like: "page-5" / "p5"
    If (PI_Invert){
        PI_Extract := PI_Extract1 - ((PI_DubiousFormat and PI_Extract1 < 0) ? -PI_Velocity : PI_Velocity) . PI_Extract2
    } else {
        PI_Extract := PI_Extract1 + ((PI_DubiousFormat and PI_Extract1 < 0) ? -PI_Velocity : PI_Velocity) . PI_Extract2
    }
    Send ^l
    Paste(RegExReplace(PI_Url, "-?\d+\D*$", PI_Extract))
    Send {Enter}
    sleep 1
    Clipboard(0)
Return

PII_Shift:
PI_Shift:
    InputBox, Temp, , Page increase amount? (number),,,,,,,,%PI_Velocity%
    If (!ErrorLevel){
        PI_Velocity:=Temp
        WriteIni(Profile,,"PI_Velocity")
    }
Return

PI_Settings:
    If (ChangingSetting="PI_Velocity" ){
        If IsNumber(%A_GuiControl%){
            %A_GuiControl% := Floor(%A_GuiControl%)
            GoTo SettingsSuccess
        } else {
            DebugSet(ChangingSetting " must be a number")
        }
    } else If (ChangingSetting="PI_Replace"){
        %A_GuiControl% := %A_GuiControl%
        GoTo SettingsSuccess
    }
Return

PI_End: