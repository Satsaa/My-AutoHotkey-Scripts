
If (!DummyCount and DummyCount!=0)
	DummyCount=1 
Loop, %DummyCount% {	;Create similarly stupid dummy scripts
	SC++
	HotkeyName[SC] := "Dummy"
	HotkeySub[SC] := "Dummy"
	HotkeySettings[SC] := "FakeVariable"
	HotkeySettingsDescription[SC] := "FakeVariable:`nPlease note that this variable doesnt exist"
	HotkeyDescription[SC] := "Im`na`ndummy`n:)"
}
GoTo Dummy_End

Dummy_Load:
Return

Dummy:
DebugPrepend("Dummy hit")
Return

Dummy_Settings:
DebugPrepend("YOU JUST CHANGED NOTHING")
Return

Dummy_End:
