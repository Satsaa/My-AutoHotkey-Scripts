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
GuiTitle := " "
MouseGetPos, MouseX, MouseY

Menu, Tray, Icon, %ResDir%\forsenLauncher.ico

Gui, Add, Picture, w64 gLaunchScriptFrog, %ResDir%\forsenE.ico
Gui, Add, Text, wp center, ScriptFrog
Gui, Add, Picture, w64 gLaunchBoxy, %ResDir%\forsenBoxE.ico
Gui, Add, Text, wp center, Boxy
Gui, Add, Picture, w64 gLaunchFantasyCounter, %ResDir%\forsenCard.ico
Gui, Add, Text, wp center, Fantasy
Gui, Add, Picture, w64 gLaunchYoutubeDL, %ResDir%\forsenDL.ico
Gui, Add, Text, wp center, YoutubeDL
Gui, Add, Picture, w64 gReload, %ResDir%\forsenLauncher.ico
Gui, Add, Text, wp center, This

Gui, -MaximizeBox -MinimizeBox -Caption +ToolWindow +LastFound

WinGet, GuiID, ID
Gui, Show,% "x" MouseX-GuiWidth/2 " y" MouseY-GuiHeight/2
MoveGuiToBounds(1,1)
SetTimer, Tick, 50
Return

Tick:
ifWinNotActive ahk_id %GuiID%
	ExitApp
Return

GuiClose:
ExitApp
Return

LaunchScriptFrog:
Run,% """" DirAscend(A_ScriptDir) "\ScriptFrog\ScriptFrog.ahk""",% DirAscend(A_ScriptDir) "\ScriptFrog\"
ExitApp
Return

LaunchBoxy:
Run,% """" DirAscend(A_ScriptDir) "\Boxy\Boxy.ahk""",% DirAscend(A_ScriptDir) "\Boxy\"
ExitApp
Return

LaunchFantasyCounter:
Run,% """" DirAscend(A_ScriptDir) "\FantasyCounter\FantasyCounter.ahk""",% DirAscend(A_ScriptDir) "\FantasyCounter\"
ExitApp
Return

LaunchYoutubeDL:
Run,% """" DirAscend(A_ScriptDir) "\YoutubeDL\YTDL_HelperGui.ahk""",% DirAscend(A_ScriptDir) "\YoutubeDL\"
ExitApp
Return

