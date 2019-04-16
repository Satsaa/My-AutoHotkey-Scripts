SC++
HotkeyName[SC] := "Surround_With_Parens"
HotkeySub[SC] := "SWP"
HotkeyDescription[SC] := "Hotkey:`nCopies and pastes the selection with (parentheses) around it"
HotkeyAllowModifiers[SC] := 1
GoTo SWP_End

SWP_Load:
Return

SWP:
Clipboard(1)
send ^c
sleep, 16
paste("(" Clipboard ")", true)
Clipboard(0)
Return

SWP_End:

SC++
HotkeyName[SC] := "Surround_With_Squares"
HotkeySub[SC] := "SWS"
HotkeyDescription[SC] := "Hotkey:`nCopies and pastes the selection with [square brackets] around it"
HotkeyAllowModifiers[SC] := 1
GoTo SWS_End

SWS_Load:
Return

SWS:
Clipboard(1)
send ^c
sleep, 16
paste("[" Clipboard "]", true)
Clipboard(0)
Return

SWS_End:

SC++
HotkeyName[SC] := "Surround_With_Curlys"
HotkeySub[SC] := "SWC"
HotkeyDescription[SC] := "Hotkey:`nCopies and pastes the selection with {curly brackets} around it"
HotkeyAllowModifiers[SC] := 1
GoTo SWC_End

SWC_Load:
Return

SWC:
Clipboard(1)
send ^c
sleep, 16
paste("{" Clipboard "}", true)
Clipboard(0)
Return

SWC_End: