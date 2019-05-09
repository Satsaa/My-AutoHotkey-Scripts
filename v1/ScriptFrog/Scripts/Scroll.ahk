SC++
HotkeyName[SC] := "Scroll_Up"
HotkeySub[SC] := "SL_U"
HotkeySettings[SC] := "SL_Speed"
HotkeySettingsDescription[SC] := "SL_Speed:`nScroll amount (shared)"
HotkeyDescription[SC] := "Any:`nScroll up`n`nScroll speeds depend on your system's mouse settings"
HotkeyAny[SC] := 1
GoTo SL_U_End

SL_U_Load:
ReadIniDefUndef(Profile,,"SL_Speed",1)
Return

SL_U_Any:
MouseClick,WheelUp,,,%SL_Speed%,0,D,R
Return

SL_U_Settings:
if (ChangingSetting = "SL_Speed"){
  If IsNumber(%A_GuiControl%){
    %A_GuiControl% := Floor(%A_GuiControl%)
    GoTo SettingsSuccess
  } else {
    DebugSet(ChangingSetting " must be a number")
  }
}
Return

SL_U_End:

;;;;;;;;;;;;;;;;;;;;;;

SC++
HotkeyName[SC] := "Scroll_Down"
HotkeySub[SC] := "SL_D"
HotkeyDescription[SC] := "Any:`nScroll down`n`nScroll speeds depend on your system's mouse settings"
HotkeyAny[SC] := 1
GoTo SL_D_End

SL_D_Load:
Return

SL_D_Any:
MouseClick,WheelDown,,,%SL_Speed%,0,D,R
Return

SL_D_End: