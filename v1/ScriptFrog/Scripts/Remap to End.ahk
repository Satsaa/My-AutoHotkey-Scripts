SC++
HotkeyName[SC] := "Remap_to_End"
HotkeySub[SC] := "RTE"
HotkeyDescription[SC] := "Hotkey:`nCauses this key to act as the End key"
HotkeyAllowModifiers[SC] := 1
HotkeyAny[SC] := 1
GoTo RTE_End

RTE_Load:
Return

RTE_Any:
send {Blind} {End}
Return

RTE_End: