#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance, Force
#Include Include.ahk


IniFile:="YTDL_Prefs.ini"
ReadIniDefUndef(,IniFile,"InputOptions","-x --audio-format mp3 -o "/dl2/%(title)s.%(ext)s" --add-metadata --embed-thumbnail --xattrs","InputUrl","https://www.youtube.com/watch?list=PL-Fj1mEvN9BhlqNeNQOi2ciUh5F5sHIxY")
ResDir := DirAscend(A_ScriptDir) "\Res"
Menu, Tray, Icon, %ResDir%\forsenDL.ico
Gui, Add, Text,, Options
Gui, Add, Link, xp+275, <a href="https://github.com/rg3/youtube-dl/blob/master/README.md#readme">Documentation</a>
Gui, Add, Edit, xm w350 vInputOptions gUpdate, %InputOptions%
Gui, Add, Text,, Video url i.e. https://www.youtube.com/watch?v=dQw4w9WgXcQ
Gui, Add, Edit, w350 vInputUrl gUpdate, %InputUrl%
Gui, Add, Text, cC7B337 vCommand w350 -wrap
Gui, Add, Button,, Download
Gui, Add, Text, x80 yp+5 vQueueText w250,
Gui, Show
SetTimer, UpdateQueue, 500
Current=0
DLS=0

Update:
Gui, Submit, NoHide
WriteIni(,IniFile,"InputOptions","InputUrl")
GuiControl, , Command, "youtube-dl.exe" %InputOptions% "%InputUrl%"
Return

ButtonDownload:
DLS++
Command%DLS% = "youtube-dl.exe" %InputOptions% "%InputUrl%"

UpdateQueue:
If (Finished=0){
	Process, Exist, youtube-dl.exe
	If (ErrorLevel = 0) {	;If it IS NOT running
		GuiControl, , QueueText,% "Downloads finished."
		Finished=1
}}
if (DLS=Current) {
	Return
}
Process, Exist, youtube-dl.exe
If (ErrorLevel = 0) {	;If it IS NOT running
	Current++
	Run,% Command%Current%
	Finished=0
}
GuiControl, , QueueText,% ((DLS-Current)!=0) ? ("Downloading " DLS-Current+1 " files.") : ("Downloading 1 file.")
Return


GuiClose:
ExitApp
