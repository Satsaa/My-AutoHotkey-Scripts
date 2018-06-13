#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
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

While (FileExist("Diarium\Include.ahk") or  FileExist("ScriptFag\Include.ahk") or  FileExist("YoutubeDL\Include.ahk") or  FileExist("Boxy\Include.ahk")){
    sleep, 100
    If (A_Index>50){
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

MsgBox, Include paths should have now been updated to %root%\Lib\*.*