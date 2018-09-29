﻿#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;#Include %Root%\Lib\Eval.ahk
;#Include %Root%\Lib\Functions.ahk
;#Include %Root%\Lib\Gdip_All.ahk
;#Include %Root%\Lib\TrayMenu.ahk
;#Include %Root%\Lib\Beep.ahk

Root := A_ScriptDir

FileDelete,% "Boxy\Include.ahk"
FileDelete,% "ScriptFag\Include.ahk"
FileDelete,% "YoutubeDL\Include.ahk"
FileDelete,% "Diarium\Include.ahk"
FileDelete,% "FantasyCounter\Include.ahk"
FileDelete,% "LaunchPad\Include.ahk"
FileDelete,% "Diarie\Include.ahk"
FileDelete,% "BarMan\Include.ahk"



While (FileExist("Diarium\Include.ahk") or  FileExist("ScriptFag\Include.ahk") or  FileExist("YoutubeDL\Include.ahk") or FileExist("Boxy\Include.ahk") or FileExist("LaunchPad\Include.ahk") or FileExist("BarMan\Include.ahk")){
    sleep, 100
    If (A_Index>20){
        MsgBox, Couldnt delete existing Include.ahk files in time. Maybe you have a script open that has one of them open?
        ExitApp
    }
}

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
#Include %Root%\Lib\Functions.ahk
#Include %Root%\Lib\TrayMenu.ahk
)
FileAppend, %ScriptFagInclude%, ScriptFag\Include.ahk

YoutubeDLInclude=
(
#Include %Root%\Lib\Functions.ahk
#Include %Root%\Lib\TrayMenu.ahk
)
FileAppend, %YoutubeDLInclude%, YoutubeDL\Include.ahk

DiariumInclude=
(
#Include %Root%\Lib\Functions.ahk
#Include %Root%\Lib\TrayMenu.ahk
)
FileAppend, %DiariumInclude%, Diarium\Include.ahk

FantasyCounterInclude=
(
#Include %Root%\Lib\Functions.ahk
#Include %Root%\Lib\TrayMenu.ahk
)
FileAppend, %FantasyCounterInclude%, FantasyCounter\Include.ahk

LaunchPadInclude=
(
#Include %Root%\Lib\Functions.ahk
#Include %Root%\Lib\TrayMenu.ahk
)
FileAppend, %LaunchPadInclude%, LaunchPad\Include.ahk

DiarieInclude=
(
#Include %Root%\Lib\Eval.ahk
#Include %Root%\Lib\Functions.ahk
#Include %Root%\Lib\Gdip_All.ahk
#Include %Root%\Lib\TrayMenu.ahk
)
FileAppend, %DiarieInclude%, Diarie\Include.ahk

BarManInclude=
(
#Include %Root%\Lib\Functions.ahk
#Include %Root%\Lib\TrayMenu.ahk
)
FileAppend, %BarManInclude%, BarMan\Include.ahk

MsgBox, Include paths should have been updated to %root%\Lib\*.*