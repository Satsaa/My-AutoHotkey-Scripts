#NoEnv
#SingleInstance, force
#InstallKeybdHook
SetWinDelay 0
SetBatchLines, -1
SetControlDelay, 0
SetDefaultMouseSpeed, 0
SetMouseDelay, -1
SendMode Input
CoordMode, Pixel, Screen
CoordMode, Mouse, Screen
#Include %A_ScriptDir%\Include.ahk
TM_SHOWGUI := [1,2]

IDC_ARROW := 32512
IDC_HAND := 32649
IDC_SIZEALL := 32646
IDC_SIZENESW := 32643
IDC_SIZENS := 32645
IDC_SIZENWSE := 32642
IDC_SIZEWE := 32644

ScreenshotFolder:="Screenshot\",
ResDir := DirAscend(A_ScriptDir) "\Res"
FileCreateDir, %ScreenshotFolder%
MaxImgDim:=750,  ;The maximum height or width for the screenshot review
CornerX:=0, CornerY:=0,
Hotkey, ~*LButton Up, Off, UseErrorLevel 
GuiTitle := RegExReplace(A_ScriptName, ".ahk")
ReadIniDefUndef("Settings",,"MatchTitle","A","RelativeCorner",0,"Looping",0
	,"InputX",100,"InputY",100,"InputX2",200,"InputY2",200
	,"BoxX",100,"BoxY",100,"BoxW",100,"BoxH",100
	,"Hotkeys",1,"GuiLoadX",250,"GuiLoadY",250,"Delay",0)
Gui, Color, EEAA99
Gui, +LastFound +AlwaysOnTop -ToolWindow -Caption +Border +HwndHwnd +Owner 
WinSet, TransColor, EEAA99
Menu, Tray, Icon, %ResDir%\forsenBoxE.ico

gui, font, q3 c354144
Gui, Add, Text, vBoxXHint x2 y2 w100,
Gui, Add, Text, vBoxYHint x2 yp+15 w100,
Gui, Add, Text, vBoxWHint x2 yp+15 w100,
Gui, Add, Text, vBoxHHint x2 yp+15 w100,
Gui, Add, Pic, vArrowResizeUpLeft gGuiResize, %ResDir%\BoxyArrow\UpLeft.png
Gui, Add, Pic, vArrowResizeUp gGuiResize, %ResDir%\BoxyArrow\Up.png
Gui, Add, Pic, vArrowResizeUpRight gGuiResize, %ResDir%\BoxyArrow\UpRight.png
Gui, Add, Pic, vArrowResizeLeft gGuiResize, %ResDir%\BoxyArrow\Left.png
Gui, Add, Pic, vDragPic gGuiDrag, %ResDir%\Drag\CircleHard.png
Gui, Add, Pic, vArrowResizeRight gGuiResize, %ResDir%\BoxyArrow\Right.png
Gui, Add, Pic, vArrowResizeDownLeft gGuiResize, %ResDir%\BoxyArrow\DownLeft.png
Gui, Add, Pic, vArrowResizeDown gGuiResize, %ResDir%\BoxyArrow\Down.png
Gui, Add, Pic, vArrowResizeDownRight gGuiResize, %ResDir%\BoxyArrow\DownRight.png
Gui, 1: +LastFound
WinGet, BoxID , Id
GuiControl, Hide, ArrowResizeUpLeft
GuiControl, Hide, ArrowResizeUp
GuiControl, Hide, ArrowResizeUpRight
GuiControl, Hide, ArrowResizeLeft
GuiControl, Hide, DragPic
GuiControl, Hide, ArrowResizeRight
GuiControl, Hide, ArrowResizeDownLeft
GuiControl, Hide, ArrowResizeDown
GuiControl, Hide, ArrowResizeDownRight

Menu, ScreenshotContextMenu, Add, Open Image, OpenImage
Menu, ScreenshotContextMenu, Add, Open Folder, OpenFolder
Menu, ScreenshotContextMenu, Add, Copy Image, CopyImage
Menu, ScreenshotContextMenu, Add, Copy Path, CopyPath
Menu, ScreenshotContextMenu, Add, Hide Image, HideImage
Gui, 2:Add, Edit, vRelativeTitle gInputUpdate w180,% MatchTitle
Gui, 2:Add, Text,, Relative to this window (title matching)

Gui, 2:Add, Radio,% "gRadio Checked" ((RelativeCorner=1) ? (1) : (0)), Up Left
Gui, 2:Add, Radio,% "gRadio Checked" ((RelativeCorner=2) ? (1) : (0)), Down Left
Gui, 2:Add, Radio,% "gRadio x85 y50 Checked" ((RelativeCorner=3) ? (1) : (0)), Up Right
Gui, 2:Add, Radio,% "gRadio Checked" ((RelativeCorner=4) ? (1) : (0)), Down Right
Gui, 2:Add, Radio,% "gRadio xm Checked" ((RelativeCorner=0) ? (1) : (0)), Screen

Gui, 2:Add, Text, xm y+8, X
Gui, 2:Add, Edit, gInputUpdate vInputX xm+15 yp-3 w125,% InputX
Gui, 2:Add, Text, vInputXHint xm+145 yp+5 w30,% InputX
Gui, 2:Add, Text, xm y+8, Y
Gui, 2:Add, Edit, gInputUpdate vInputY xm+15 yp-3 w125,% InputY
Gui, 2:Add, Text, vInputYHint xm+145 yp+5 w30,% InputY
Gui, 2:Add, Text, xm-3 y+8, X2
Gui, 2:Add, Edit, gInputUpdate vInputX2 xm+15 yp-3 w125,% InputX2
Gui, 2:Add, Text, vInputX2Hint xm+145 yp+5 w30,% InputX2
Gui, 2:Add, Text, xm-3 y+8, Y2
Gui, 2:Add, Edit, gInputUpdate vInputY2 xm+15 yp-3 w125,% InputY2
Gui, 2:Add, Text, vInputY2Hint xm+145 yp+5 w30,% InputY2

Gui, 2:Add, Checkbox, gToggleHotkeys vHotkeys Checked%Hotkeys% xm, Adjust with shift and arrow keys
Gui, 2:Add, Slider, gDelayUpdate vDelay Range0-5000 NoTicks AltSubmit wp-17 x2,% Delay
DelaySec := SubStr(Delay/1000, 1, 3)
Gui, 2:Add, Text, vDelayHint xm+145 yp+5 w25,% DelaySec " s"
Gui, 2:Add, Button, gSetRectangle xm yp+22, Set Rectangle
Gui, 2:Add, Button, gLoopToggle xm, Toggle Loop
Gui, 2:Add, Button, gScreenshot xm, Screenshot
Gui, 2:Add, Text, vLoopHint xm w170, Not looping
Gui, 2: +HwndGui
Gui, 2:Show, x%GuiLoadX% y%GuiLoadY%, %GuiTitle%
Gui, 2:Add, Text, ym vScreenshotText , Loading Image %A_space%  %A_space% %A_space% %A_space% %A_space%
Gui, 2:Add, Pic, vScreenshot gScreenShotClick, %ImageFile%
Gui, 2: +LastFound
WinGet, MainID , Id
OnExit, GuiClose
if Looping {
	Looping = 0
	GoSub LoopToggle
}
SetTimer, GetHover, 20
GoSub LoadCursors
GoSub InputUpdate
GoSub ToggleHotkeys
OnMessage(0x200,"WM_MOUSEMOVE")
OnMessage(0x201,"WM_LBUTTONDOWN")
GoTo BoxUpdate

DelayUpdate:
DelaySec := SubStr(Delay/1000, 1, 3)
ToolTip,% "Delay " DelaySec " sec",,,1
GuiControl,2:, DelayHint,% DelaySec " s"
if GetKeyState("LButton", "P")
	Return
ToolTip,,,,1
Return

DelayAnim:
Delay -= 16
DelaySec := SubStr(Delay/1000, 1, 3)
GuiControl,2:, Delay,% Delay
GuiControl,2:, DelayHint,% DelaySec " s"
If (Delay<=0) {
	Delay := OldDelay
	DelaySec := SubStr(Delay/1000, 1, 3)
	SetTimer, DelayAnim, off
	GuiControl,2:, Delay,% Delay
	GuiControl,2:, DelayHint,% DelaySec " s"
}Return

PrintScreen::
Screenshot:
If (Delay!<=0.01) {
	OldDelay := Delay
	SetTimer, ScreenshotHop,% -Delay
	SetTimer, DelayAnim, 15  ;16 ms
	Return
} ScreenshotHop:
SetTimer, DelayAnim, off
GoSub SaveClipboard
ImageCopy=
ImageDateCurrent := A_YYYY "-" A_MM "-" A_DD 
ReadIni("FileName",, "ImageDate", "Increment")
If (ImageDate!=ImageDateCurrent){
	Increment=0
	ImageDate:=ImageDateCurrent
	WriteIni("FileName",,"ImageDate","Increment")
} else {
	Increment++
	WriteIni("FileName",,"Increment")
} 
ImageFile:= ScreenshotFolder ImageDate "_" Increment ".png"
GuiControl,2:, ScreenshotText, Loading Image
pToken := Gdip_Startup()
Gui,1: +LastFound
Winset, Transparent, 0
Gui,2: +LastFound
Winset, Transparent, 0
Sleep, 20
Screenshot := Gdip_BitmapFromScreen(BoxX+1 "|" BoxY+1 "|" BoxW "|" BoxH)
Winset, Transparent, 255
Gui,1: +LastFound
Winset, Transparent, 255
WinSet, TransColor, EEAA99
Gdip_SaveBitmapToFile(Screenshot, ImageFile)
If (ImageHidden) {
	GuiControl,2:Show, Screenshot,
	GuiControl,2:Show, ScreenshotText,
	ImageHidden=
}
IfNotExist, %ImageFile%
{	
	Gdip_ShutDown(pToken)
	GuiControl,2:, ScreenshotText, FATAL ERROR ????
	Return
}
if (BoxW>MaxImgDim or BoxH>MaxImgDim){
	If (BoxW>BoxH)
		ImageWidth:=MaxImgDim, ImageHeight:=-1
	else
		ImageWidth:=-1, ImageHeight:=MaxImgDim
}
else ImageWidth:="", ImageHeight:=""
GuiControl,2:, Screenshot,% "*w" ImageWidth " *h" ImageHeight " " ImageFile
GuiControl,2:, ScreenshotText,% SubStr(ImageFile, 12, 20)
Gui, 2:Show, autosize NoActivate
Gdip_SetBitmapToClipboard(Screenshot)
ImageCopy := ClipboardAll
Gdip_DisposeImage(Screenshot)
Gdip_ShutDown(pToken)
GoTo RestoreClipboard
Return

ToggleHotkeys:
Gui, 2:Submit, NoHide
If (Hotkeys) {
	Hotkey, ~*Right, On
	Hotkey, ~*Left, On
	Hotkey, ~*Up, On
	Hotkey, ~*Down, On
} else {
	Hotkey, ~*Right, Off
	Hotkey, ~*Left, Off
	Hotkey, ~*Up, Off
	Hotkey, ~*Down, Off
} Return

2GuiClose:
GuiClose:
WriteIni("Settings",,"MatchTitle","RelativeCorner","Looping","InputX","InputY","InputX2","InputY2",
		,"BoxX","BoxY","BoxW","BoxH","Hotkeys","Delay")
GoSub UnloadCursors
Gui, 2: +LastFound
WinGetPos,GuiLoadX,GuiLoadY,VirGuiW
if !(GuiLoadX<150-VirGuiW or GuiLoadY<0){
	WriteIni("Settings",,"GuiLoadX","GuiLoadY")
}
exitApp
Return

LoadCursors:
CursorArrow:=DllCall("LoadCursor", "UInt", NULL,"Int", IDC_ARROW, "UInt")
CursorHand:=DllCall("LoadCursor", "UInt", NULL,"Int", IDC_HAND, "UInt")
CursorSizeAll:=DllCall("LoadCursor", "UInt", NULL,"Int", IDC_SIZEALL, "UInt")
CursorSizeNESW:=DllCall("LoadCursor", "UInt", NULL,"Int", IDC_SIZENESW, "UInt")
CursorSizeNS:=DllCall("LoadCursor", "UInt", NULL,"Int", IDC_SIZENS, "UInt")
CursorSizeNWSE:=DllCall("LoadCursor", "UInt", NULL,"Int", IDC_SIZENWSE, "UInt")
CursorSizeWE:=DllCall("LoadCursor", "UInt", NULL,"Int", IDC_SIZEWE, "UInt")
Return

UnloadCursors:
DllCall("DestroyCursor","Uint", CursorArrow)
DllCall("DestroyCursor","Uint", CursorHand)
DllCall("DestroyCursor","Uint", CursorSizeAll)
DllCall("DestroyCursor","Uint", CursorSizeNESW)
DllCall("DestroyCursor","Uint", CursorSizeNS)
DllCall("DestroyCursor","Uint", CursorSizeNWSE)
DllCall("DestroyCursor","Uint", CursorSizeWE)
Return

WM_LBUTTONDOWN(wParam, lParam){
	global ImageFile
	if (A_Gui=2) {
		MouseGetPos,,,, ctrl
			if (ctrl == "Static12") {
				Run, %ImageFile%
			}
}}

WM_MOUSEMOVE(wParam, lParam) {
	global CursorSizeWE, CursorSizeNWSE, CursorSizeNS, CursorSizeNESW, CursorSizeAll, CursorHand, CursorArrow
	If (A_Gui=1){
		MouseGetPos,,,, ctrl
		if (ctrl == "Static5")
			DllCall("SetCursor","UInt",CursorSizeNWSE)
		else if (ctrl == "Static6")
			DllCall("SetCursor","UInt",CursorSizeNS)
		else if (ctrl == "Static7")
			DllCall("SetCursor","UInt",CursorSizeNESW)
		else if (ctrl == "Static8")
			DllCall("SetCursor","UInt",CursorSizeWE)
		else if (ctrl == "Static9")
			DllCall("SetCursor","UInt",CursorSizeAll)
		else if (ctrl == "Static10")
			DllCall("SetCursor","UInt",CursorSizeWE)
		else if (ctrl == "Static11")
			DllCall("SetCursor","UInt",CursorSizeNESW)
		else if (ctrl == "Static12")
			DllCall("SetCursor","UInt",CursorSizeNS)
		else if (ctrl == "Static13")
			DllCall("SetCursor","UInt",CursorSizeNWSE)
	} else if (A_Gui=2) {
		MouseGetPos,,,, ctrl
		if (ctrl == "Static12")
			DllCall("SetCursor","UInt",CursorHand)
	}
}

ScreenShotClick:
If (A_GuiEvent="Doubleclick")
	GoTo OpenImage
return

CopyImage:
If ImageCopy
	Clipboard:=ImageCopy
Return

CopyPath:
if ImageFile
	Clipboard := A_ScriptDir "\" ImageFile
Else
	MsgBox, No image
Return

OpenImage:
if ImageFile
	Run, %ImageFile%
Return

HideImage:
ImageHidden=1
ImageFile=
GuiControl,2:Hide, Screenshot,
GuiControl,2:Hide, ScreenshotText,
Gui, 2:Show, autosize
Return

OpenFolder:
if ImageFile
	Run % "explorer.exe /select, """ A_ScriptDir "\" ImageFile """"
else
	Run, explore %A_ScriptDir%\Screenshot
Return

2GuiContextMenu:
If A_GuiControl!=Screenshot
	Return
Menu, ScreenshotContextMenu, Show, %A_VirGuiX%, %A_VirGuiY%
Return

SaveClipboard:
SavedClipboard := ClipboardAll
Clipboard =
Return
RestoreClipboard:
Clipboard := SavedClipboard
SavedClipboard=
Return

LoopToggle:
if (Looping := !Looping){
	SetTimer, SetRectangleLoop, 10
	if (BoxX="" or BoxY="" or BoxW="" or BoxH=""){
			GuiControl,2:, LoopHint, Bad values
		ErrorValues:=1, Reverted:=1
	} else GuiControl,, LoopHint, Looping
} else {
	SetTimer, SetRectangleLoop, Off
	GuiControl,, LoopHint, Not looping
	Looping=0
} Return

InputUpdate:
Gui, 2:Submit, NoHide
if Relativetitle {
	WinGetPos, WinX, WinY, WinW, WinH, %RelativeTitle%,
}
EvalX:=Eval(InputX)[1]
EvalY:=Eval(InputY)[1]
GuiControl,2:, InputXHint,% EvalX
GuiControl,2:, InputYHint,% EvalY
GuiControl,2:, InputX2Hint,% EvalW:=Eval(InputX2)[1]
GuiControl,2:, InputY2Hint,% EvalH:=Eval(InputY2)[1]
EvalW-=EvalX
EvalH-=EvalY
Return

SetRectangleloop:
if (!ErrorValues){
	if not Reverted
		GuiControl,2:, LoopHint, Looping
	Reverted:=1, ErrorValues:=1
}
SetRectangle:
WinGetPos, WinX, WinY, WinW, WinH, %RelativeTitle%,
GoSub GetCorners
BoxX:=EvalX+CornerX
BoxY:=EvalY+CornerY
BoxW:=EvalW
BoxH:=EvalH
GoTo BoxUpdate

BoxUpdate:
if (BoxX="" or BoxY="" or BoxW="" or BoxH="") {
	if !Reverted=0
		GuiControl,2:, LoopHint, Bad values
	ErrorValues:=1, Reverted:=0
	Return
} else ErrorValues:=0
if (BoxW>0 and BoxH>0){
		Gui, 1:Show,% "NA x" BoxX " y" BoxY " w" BoxW " h" BoxH
		VirGuiX:=BoxX, VirGuiY:=BoxY, VirGuiW:=BoxW, VirGuiH:=BoxH 
	} else if (BoxW<0 and BoxH<0){
		Gui, 1:Show,% "NA x" BoxX+BoxW " y" BoxY+BoxH " w" BoxW*-1 " h" BoxH*-1
		VirGuiX:=BoxX+BoxW, VirGuiY:=BoxY+BoxH, VirGuiW:=BoxW*-1, VirGuiH:=BoxH*-1
	} else if (BoxW>0 and BoxH<0){
		Gui, 1:Show,% "NA x" BoxX " y" BoxY+BoxH " w" BoxW " h" BoxH*-1
		VirGuiX:=BoxX, VirGuiY:=BoxY+BoxH, VirGuiW:=BoxW, VirGuiH:=BoxH*-1
	} else if (BoxW<0 and BoxH>0){
		Gui, 1:Show,% "NA x" BoxX+BoxW " y" BoxY " w" BoxW*-1 " h" BoxH
		VirGuiX:=BoxX+BoxW, VirGuiY:=BoxY, VirGuiW:=BoxW*-1, VirGuiH:=BoxH
} if !Dragging 
	BoxX:=VirGuiX, BoxY:=VirGuiY, BoxW:=VirGuiW, BoxH:=VirGuiH
GuiControl,1:, BoxXHint, %BoxX%
GuiControl,1:, BoxYHint, %BoxY%
GuiControl,1:, BoxWHint, %BoxW%
GuiControl,1:, BoxHHint, %BoxH%
Return

GetHover:
MouseGetPos, MouseX, MouseY
If (MouseX>=VirGuiX and MouseY>=VirGuiY and MouseX<=VirGuiX+VirGuiW and MouseY<=VirGuiY+VirGuiH){
	If (!Hover){
		Hover=1
		GoTo UiUpdate
}} else {
	if (!Dragging) {
		Hover=0
		GoTo UiHide
}}
Return

Radio:
GoSub InputUpdate
Gui, 2:Submit, Nohide
if A_GuiControl=Screen
	RelativeCorner:=0
else if A_GuiControl=Up Left
	RelativeCorner:=1
else if A_GuiControl=Down Left
	RelativeCorner:=2
else if A_GuiControl=Up Right
	RelativeCorner:=3
else if A_GuiControl=Down Right
	RelativeCorner:=4
If (RelativeCorner) {
	SetTimer, GetRelativeWin, 20
} Else SetTimer, GetRelativeWin, Off
GoTo GetCorners

GetCorners:
if RelativeCorner=0
	CornerX:=0, CornerY:=0
else if RelativeCorner=1
	CornerX:=WinX, CornerY:=WinY
else if RelativeCorner=2
	CornerX:=WinX, CornerY:=WinY+WinH
else if RelativeCorner=3
	CornerX:=WinX+WinW, CornerY:=WinY
else if RelativeCorner=4
	CornerX:=WinX+WinW, CornerY:=WinY+WinH
Return

GetRelativeWin:
if Dragging
	Return
WinGetPos, WinX, WinY, WinW, WinH, %RelativeTitle%,
if (RelativeCorner=1){
	BoxX+=WinX-PrevWinX
	BoxY+=WinY-PrevWinY
} else if (RelativeCorner=2){
	BoxY+=(WinY+WinH)-(PrevWinY+PrevWinH)
	BoxX+=WinX-PrevWinX
} else if (RelativeCorner=3){
	BoxX+=(WinX+WinW)-(PrevWinX+PrevWinW)
	BoxY+=WinY-PrevWinY
} else if (RelativeCorner=4){
	BoxX+=WinX-PrevWinX
	BoxY+=WinY-PrevWinY
	BoxY+=WinH-PrevWinH
	BoxX+=WinW-PrevWinW
} PrevWinX:=WinX, PrevWinY:=WinY, PrevWinW:=WinW, PrevWinH:=WinH
If !Looping
	GoTo BoxUpdate
Return

GuiDrag:
PostMessage, 0xA1, 2,,, A 
	DllCall("SetCursor","UInt",CursorSizeAll)
Dragging=1
SetTimer, GetDrag, 10
Return

GetDrag:
WinGetPos, DragX, DragY,,, ahk_id %hwnd%,
BoxX+=DragX-VirGuiX
BoxY+=DragY-VirGuiY
VirGuiX:=BoxX
VirGuiY:=BoxY
GoSub UiHide
GoSub BoxUpdate
if GetKeyState( "LButton", "P"){
	Return
} else { 
	GoSub UiUpdate
	Dragging=0
}
SetTimer, GetDrag, Off
Return

UiUpdate:
if Looping
	Return
if hidden {
	GuiControl, Show, ArrowResizeUpLeft
	GuiControl, Show, ArrowResizeUp
	GuiControl, Show, ArrowResizeUpRight
	GuiControl, Show, ArrowResizeLeft
	GuiControl, Show, DragPic
	GuiControl, Show, ArrowResizeRight
	GuiControl, Show, ArrowResizeDownLeft
	GuiControl, Show, ArrowResizeDown
	GuiControl, Show, ArrowResizeDownRight
}
GuiControl, MoveDraw, ArrowResizeUpLeft, x5 y5
GuiControl, MoveDraw, ArrowResizeUp,% "x" (VirGuiW-23)/2  " y" 5
GuiControl, MoveDraw, ArrowResizeUpRight,% "x" VirGuiW-22 " y" 5
GuiControl, MoveDraw, ArrowResizeLeft,% "x" 5  " y" (VirGuiH-23)/2
GuiControl, MoveDraw, DragPic,% "x" (VirGuiW-29)/2  " y" (VirGuiH-29)/2
GuiControl, MoveDraw, ArrowResizeRight,% "x" VirGuiW-21  " y" (VirGuiH-23)/2
GuiControl, MoveDraw, ArrowResizeDownLeft,% "x" 5 " y" VirGuiH-22
GuiControl, MoveDraw, ArrowResizeDown,% "x" (VirGuiW-23)/2  " y" VirGuiH-21
GuiControl, MoveDraw, ArrowResizeDownRight,% "x" VirGuiW-22 " y" VirGuiH-22
Hidden=0
Return
Uihide:
if Hidden
	Return
GuiControl, Hide, ArrowResizeUpLeft
GuiControl, Hide, ArrowResizeUp
GuiControl, Hide, ArrowResizeUpRight
GuiControl, Hide, ArrowResizeLeft
GuiControl, Hide, DragPic
GuiControl, Hide, ArrowResizeRight
GuiControl, Hide, ArrowResizeDownLeft
GuiControl, Hide, ArrowResizeDown
GuiControl, Hide, ArrowResizeDownRight
Hidden=1
Return

~*Left::
If Dragging
	Return
If GetKeyState("Shift","P") {
	BoxX++
	BoxW--
} else {
	BoxX--
	BoxW++
} VirGuiX:=BoxX
Hover:=0
GoTo BoxUpdate
~*Right::
If Dragging
	Return
If GetKeyState("Shift","P")
	BoxW--
else BoxW++
VirGuiW:=BoxW
Hover:=0
GoTo BoxUpdate
~*Up::
If Dragging
	Return
If GetKeyState("Shift","P"){
	BoxY++
	BoxH--
} else {
	BoxY--
	BoxH++
} VirGuiY:=BoxY
Hover:=0
GoTo BoxUpdate
~*Down::
If Dragging
	Return
If GetKeyState("Shift","P")
	BoxH--
else BoxH++
VirGuiH:=BoxH
Hover:=0
GoTo BoxUpdate

GuiResize:
MouseGetPos, MouseX, MouseY
Dragging:=1, UpdateRate:=10
if (A_GuiControl="ArrowResizeLeft"){
	GoSub UiHide
	ResizeX:=MouseX
	SetTimer, ResizeLeft, %UpdateRate%
} else if (A_GuiControl="ArrowResizeRight"){
	GoSub UiHide
	ResizeX:=MouseX
	SetTimer, ResizeRight, %UpdateRate%
} else if (A_GuiControl="ArrowResizeUp"){
	GoSub UiHide
	ResizeY:=MouseY
	SetTimer, ResizeUp, %UpdateRate%
} else if (A_GuiControl="ArrowResizeDown"){
	GoSub UiHide
	ResizeY:=MouseY
	SetTimer, ResizeDown, %UpdateRate%
} else if (A_GuiControl="ArrowResizeUpLeft"){
	GoSub UiHide
	ResizeY:=MouseY
	ResizeX:=MouseX
	SetTimer, ResizeUp, %UpdateRate%
	SetTimer, ResizeLeft, %UpdateRate%
} else if (A_GuiControl="ArrowResizeUpRight"){
	GoSub UiHide
	ResizeY:=MouseY
	ResizeX:=MouseX
	SetTimer, ResizeUp, %UpdateRate%
	SetTimer, ResizeRight, %UpdateRate%
} else if (A_GuiControl="ArrowResizeDownLeft"){
	GoSub UiHide
	ResizeY:=MouseY
	ResizeX:=MouseX
	SetTimer, ResizeDown, %UpdateRate%
	SetTimer, ResizeLeft, %UpdateRate%
} else if (A_GuiControl="ArrowResizeDownRight"){
	GoSub UiHide
	ResizeY:=MouseY
	ResizeX:=MouseX
	SetTimer, ResizeDown, %UpdateRate%
	SetTimer, ResizeRight, %UpdateRate%
} else Dragging=0
Return

ResizeLeft:
if not GetKeyState( "LButton", "P") {
	Dragging=0
	Hover=0
	GoSub BoxUpdate
	SetTimer, ResizeLeft, Off
} If (MouseX=ResizeX)
	Return
BoxX-=ResizeX-MouseX
BoxW+=ResizeX-MouseX
ResizeX:=MouseX
GoTo BoxUpdate
ResizeRight:
if not GetKeyState( "LButton", "P"){
	Dragging=0
	Hover=0
	GoSub BoxUpdate
	SetTimer, ResizeRight, Off
} If (MouseX=ResizeX)
	Return
Boxw-=ResizeX-MouseX
ResizeX:=MouseX
GoTo BoxUpdate
ResizeUp:
if not GetKeyState( "LButton", "P"){
	Dragging=0
	Hover=0
	GoSub BoxUpdate
	SetTimer, ResizeUp, Off
} If (MouseY=ResizeY)
	Return
BoxY-=ResizeY-MouseY
BoxH+=ResizeY-MouseY
ResizeY:=MouseY
GoTo BoxUpdate
ResizeDown:
if not GetKeyState( "LButton", "P"){
	Dragging=0
	Hover=0
	GoSub BoxUpdate
	SetTimer, ResizeDown, Off
} If (MouseY=ResizeY)
	Return
BoxH-=ResizeY-MouseY
ResizeY:=MouseY
GoTo BoxUpdate