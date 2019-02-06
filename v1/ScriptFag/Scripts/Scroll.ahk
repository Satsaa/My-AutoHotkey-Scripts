SC++
HotkeyName[SC] := "Scroll_Up"
HotkeySub[SC] := "SL_U"
HotkeySettings[SC] := "SL_Speed,SL_EnableShift"
HotkeySettingsDescription[SC] := "SL_Speed:`nScroll amount (shared)`n`nSL_EnableShift:`nEnable shift hotkey (single scroll per press)"
HotkeyDescription[SC] := "Any:`nScroll up`n`nShift:`nSingle scroll (if enabled)`n`nScroll speeds depend on your system's mouse settings"
HotkeyAny[SC] := 1
GoTo SL_U_End

SL_U_Load:
ReadIniDefUndef(Profile,,"SL_Speed",1,"SL_EnableShift",0)
Return

SL_U_Any:
if (SL_EnableShift && GetKeyState("Shift", "P")){
  Send {WheelUp}
  sleep, 1
  debugPrepend(A_ThisLabel)
  Return
} else {
  Loop, %SL_Speed% {
    Send {WheelUp}
    sleep, 1
  }
}
Return

SL_U_Settings:
if (ChangingSetting = "SL_Speed"){
  If IsNumber(%A_GuiControl%){
    %A_GuiControl% := Floor(%A_GuiControl%)
    GoTo SettingsSuccess
  } else {
    DebugSet(ChangingSetting " must be a number")
  }
} else if (ChangingSetting = "SL_EnableShift"){
  If (%A_GuiControl% = 1 or %A_GuiControl% = 0){
    GoTo SettingsSuccess
  } else {
    DebugSet(ChangingSetting " must be 0 or 1")
  }
}
Return

SL_U_End:

;;;;;;;;;;;;;;;;;;;;;;

SC++
HotkeyName[SC] := "Scroll_Down"
HotkeySub[SC] := "SL_D"
HotkeyDescription[SC] := "Any:`nScroll down`n`nShift:`nSingle scroll (if enabled)`n`nScroll speeds depend on your system's mouse settings"
HotkeyAny[SC] := 1
GoTo SL_D_End

SL_D_Load:
Return

SL_D_Any:
if (SL_EnableShift && GetKeyState("Shift", "P")){
  Send {WheelDown}
  sleep, 1
  debugPrepend(A_ThisLabel)
  Return
} else {
  Loop, %SL_Speed% {
    Send {WheelDown}
    sleep, 1
  }
}
Return

SL_D_End: