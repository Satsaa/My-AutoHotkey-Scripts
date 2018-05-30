;Revision 3
;2018-05-06

;Gui ids that will be shown with show gui
TM_SHOWGUI:=[1]
Menu, tray, NoStandard
Menu, tray, add, Exit, Exit
Menu, tray, add, Reload, Reload
Menu, tray, add, Terminate, Terminate
Menu, tray, add
Menu, tray, add, Pause, Pause
Menu, tray, add, Suspend, Suspend
Menu, tray, add, Show Gui, GuiShow
Menu, Tray, Default, Show Gui
Menu, Tray, Click, 1
Menu, Dev, add, WindowSpy
Menu, Dev, add
Menu, Dev, add, Lines
Menu, Dev, add, Variables
Menu, Dev, add, Hotkeys
Menu, Dev, add, KeyHistory
Menu, Dev, add
Menu, Dev, add, Edit, Edit
Menu, Dev, add, Open Script Folder, OpenScriptFolder
Menu, tray, add
Menu, tray, add, Dev , :Dev
GoTo TM_END

Exit:
ExitApp
Return

Reload:
Reload
Return

Terminate:
Process, Exist
Process, Close, %ErrorLevel%
Return

Pause:
Menu, tray, Check, Pause
Pause, Toggle
Menu, tray, UnCheck, Pause
Return

Suspend:
SuspendToggle := !SuspendToggle
Menu, tray, Check, Suspend
Suspend, Toggle
if !SuspendToggle
	Menu, tray, UnCheck, Suspend
Return

GuiShow:
for index, element in TM_SHOWGUI 
	Gui,%element%:Show
Return

Edit:
Run, "C:\Program Files\Microsoft VS Code\Code.exe" "%A_ScriptFullPath%"
Return

OpenScriptFolder:
Run % "explorer.exe /select, """ A_ScriptDir "\" A_ScriptName """"
Return

WindowSpy:
Run, C:\Program Files\AutoHotkey\WindowSpy.ahk
Return

Lines:
ListLines
Return

Variables:
ListVars
Return

Hotkeys:
ListHotkeys
Return

KeyHistory:
KeyHistory
Return

TM_END: