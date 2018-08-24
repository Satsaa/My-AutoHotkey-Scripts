#NoEnv
#SingleInstance, force
#InstallKeybdHook
SetWinDelay 0
SetBatchLines, -1
SetControlDelay, 0
SetDefaultMouseSpeed, 0
SetMouseDelay, -1
SendMode Input
#KeyHistory 0
ListLines, off
Process, Priority, , A
CoordMode, Pixel, Screen
CoordMode, Mouse, Screen
#Include %A_ScriptDir%\Include.ahk

SysGet, VirtualWidth, 78
SysGet, VirtualHeight, 79
GuiHeight := 480
GuiWidth := 90
TaskBarHeight := 40
ResDir := DirAscend(A_ScriptDir) "\Res"
GuiTitle := RegExReplace(A_ScriptName, ".ahk")
MouseGetPos, MouseX, MouseY

Menu, Tray, Icon, %ResDir%\forsenLaunch.ico

Gui, Add, Picture, w64 gLaunchScriptFag, %ResDir%\forsenE.ico
Gui, Add, Text, wp center, ScriptFag
Gui, Add, Picture, w64 gLaunchBoxy, %ResDir%\forsenBoxE.ico
Gui, Add, Text, wp center, Boxy
Gui, Add, Picture, w64 gLaunchFantasyCounter, %ResDir%\forsenCard.ico
Gui, Add, Text, wp center, Fantasy
Gui, Add, Picture, w64 gLaunchYoutubeDL, %ResDir%\forsenDL.ico
Gui, Add, Text, wp center, YoutubeDL
Gui, Add, Picture, w64 gReload, %ResDir%\forsenLaunch.ico
Gui, Add, Text, wp center, This

Gui, Show,% "x" ((MouseX+GuiWidth<VirtualWidth)?((MouseX-(GuiWidth/2)<1)?(0):(MouseX-(GuiWidth/2))):(VirtualWidth-GuiWidth)) " y" ((MouseY+GuiHeight+TaskBarHeight<VirtualHeight)?((MouseY-150<1)?(0):(MouseY-150)):(VirtualHeight-GuiHeight-TaskBarHeight)) , %GuiTitle%
Return

GuiClose:
ExitApp
Return

LaunchScriptFag:
Run, "C:\Users\sampp\Desktop\HNN - BU\AutoHotkey\ScriptFag\ScriptFag.ahk", C:\Users\sampp\Desktop\HNN - BU\AutoHotkey\ScriptFag\
ExitApp
Return

LaunchBoxy:
Run, "C:\Users\sampp\Desktop\HNN - BU\AutoHotkey\Boxy\Boxy.ahk", C:\Users\sampp\Desktop\HNN - BU\AutoHotkey\ScriptFag\
ExitApp
Return

LaunchFantasyCounter:
Run, "C:\Users\sampp\Desktop\HNN - BU\AutoHotkey\FantasyCounter\FantasyCounter.ahk", C:\Users\sampp\Desktop\HNN - BU\AutoHotkey\FantasyCounter\
ExitApp
Return

LaunchYoutubeDL:
Run, "C:\Users\sampp\Desktop\HNN - BU\AutoHotkey\YoutubeDL\YTDL_HelperGui.ahk", C:\Users\sampp\Desktop\HNN - BU\AutoHotkey\YoutubeDL\
ExitApp
Return

