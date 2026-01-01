goto DCB_Hop

*MButton::
  If (A_TimeSincePriorHotkey < 64) ;hyperclick
    Return
  sendinput {MButton down}
  KeyWait, MButton
  sendinput {MButton up}
Return

DCB_Hop:
