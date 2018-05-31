#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
;#Include \Lib\Functions.ahk

Root := A_ScriptDir

FileDelete, "Boxy\Include.ahk"
FileDelete, "ScriptFag\Include.ahk"
FileDelete, "YoutubeDL\Include.ahk"

BoxyInclude=
(
#Include %Root%\Lib\Eval.ahk
#Include %Root%\Lib\Functions.ahk
#Include %Root%\Lib\Gdip_All.ahk
#Include %Root%\Lib\TrayMenu.ahk
)
FileAppend, %BoxyInclude%, Boxy\Include.ahk

ScriptFagInclude=
(
;#Include %Root%\Lib\Eval.ahk
#Include %Root%\Lib\Functions.ahk
;#Include %Root%\Lib\Gdip_All.ahk
#Include %Root%\Lib\TrayMenu.ahk
)
FileAppend, %ScriptFagInclude%, ScriptFag\Include.ahk

YoutubeDLInclude=
(
;#Include %Root%\Lib\Eval.ahk
#Include %Root%\Lib\Functions.ahk
;#Include %Root%\Lib\Gdip_All.ahk
#Include %Root%\Lib\TrayMenu.ahk
)
FileAppend, %YoutubeDLInclude%, YoutubeDL\Include.ahk

MsgBox, Include paths have now been updated to %root%\Lib\*.*