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
CtrlBoxX:=0, CtrlBoxY:=0, CtrlBoxH:=0, CtrlBoxW:=0, 
Hotkey, ~*LButton Up, Off, UseErrorLevel 
GuiTitle := RegExReplace(A_ScriptName, ".ahk")
ReadIniDefUndef("Settings",,"MatchTitle","A","RelativeCorner",0,"Looping",0
	,"InputX",100,"InputY",100,"InputX2",200,"InputY2",200
	,"BoxX",100,"BoxY",100,"BoxW",100,"BoxH",100
	,"Hotkeys",1,"GuiLoadX",250,"GuiLoadY",250,"Delay",0)
Gui, Color, EEAA99
Gui, +LastFound +AlwaysOnTop -ToolWindow -Caption +Border +HwndBox +Owner 
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
Gui, 1:Show, x-300 y-300
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
WinGetPos,GuiLoadX,GuiLoadY,VirBoxW
if !(GuiLoadX<150-VirBoxW or GuiLoadY<0){
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
Menu, ScreenshotContextMenu, Show, %A_VirBoxX%, %A_VirBoxY%
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
	} else GuiControl,2:, LoopHint, Looping
} else {
	SetTimer, SetRectangleLoop, Off
	GuiControl,2:, LoopHint, Not looping
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
if (BoxW>0 and BoxH>0){  ;DownRight
	VirBoxX:=BoxX, VirBoxY:=BoxY, VirBoxW:=BoxW, VirBoxH:=BoxH
	WinMove, ahk_id %Box%,,% VirBoxX,% VirBoxY,% VirBoxW,% VirBoxH,
} else if (BoxW<0 and BoxH<0){  ;UpLeft
	VirBoxX:=BoxX+BoxW, VirBoxY:=BoxY+BoxH, VirBoxW:=BoxW*-1, VirBoxH:=BoxH*-1
	WinMove, ahk_id %Box%,,% VirBoxX,% VirBoxY,% VirBoxW,% VirBoxH,
} else if (BoxW>0 and BoxH<0){  ;UpRight
	VirBoxX:=BoxX, VirBoxY:=BoxY+BoxH, VirBoxW:=BoxW, VirBoxH:=BoxH*-1
	WinMove, ahk_id %Box%,,% VirBoxX,% VirBoxY,% VirBoxW,% VirBoxH,
} else if (BoxW<0 and BoxH>0){  ;DownLeft
	VirBoxX:=BoxX+BoxW, VirBoxY:=BoxY, VirBoxW:=BoxW*-1, VirBoxH:=BoxH
	WinMove, ahk_id %Box%,,% VirBoxX,% VirBoxY,% VirBoxW,% VirBoxH,
}
if !(Dragging){
	If (VirBoxW<0 and VirBoxH<0){  ;UpLeft
		VirBoxX:=VirBoxX+VirBoxW, VirBoxY:=VirBoxY+VirBoxH, VirBoxW:=VirBoxW*-1, VirBoxH:=VirBoxH*-1,
	} else If (VirBoxW>0 and VirBoxH<0){  ;UpRight
		VirBoxY:=VirBoxY+VirBoxH, VirBoxH:=VirBoxH*-1,
	} else If (VirBoxW<0 and VirBoxH>0){  ;DownLeft
		VirBoxX:=VirBoxX+VirBoxW, VirBoxW:=VirBoxW*-1,
	}
	BoxX:=VirBoxX, BoxY:=VirBoxY, BoxW:=VirBoxW, BoxH:=VirBoxH
}
If (VirBoxW<0 and VirBoxH<0){  ;UpLeft
	VirBoxX:=VirBoxX+VirBoxW, VirBoxY:=VirBoxY+VirBoxH, VirBoxW:=VirBoxW*-1, VirBoxH:=VirBoxH*-1,
} else If (VirBoxW>0 and VirBoxH<0){  ;UpRight
	VirBoxY:=VirBoxY+VirBoxH, VirBoxH:=VirBoxH*-1,
} else If (VirBoxW<0 and VirBoxH>0){  ;DownLeft
	VirBoxX:=VirBoxX+VirBoxW, VirBoxW:=VirBoxW*-1,
}
GuiControl,1:, BoxXHint,% Round(VirBoxX)
GuiControl,1:, BoxYHint,% Round(VirBoxY)
GuiControl,1:, BoxWHint,% Round(VirBoxW)
GuiControl,1:, BoxHHint,% Round(VirBoxH)
Return

GetHover:
MouseGetPos, MouseX, MouseY
If (MouseX>=VirBoxX and MouseY>=VirBoxY and MouseX<=VirBoxX+VirBoxW and MouseY<=VirBoxY+VirBoxH){
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
WinGetPos, DragX, DragY,,, ahk_id %Box%,
BoxX+=DragX-VirBoxX
BoxY+=DragY-VirBoxY
VirBoxX:=BoxX
VirBoxY:=BoxY
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
GuiControl, MoveDraw, ArrowResizeUp,% "x" (VirBoxW-23)/2  " y" 5
GuiControl, MoveDraw, ArrowResizeUpRight,% "x" VirBoxW-22 " y" 5
GuiControl, MoveDraw, ArrowResizeLeft,% "x" 5  " y" (VirBoxH-23)/2
GuiControl, MoveDraw, DragPic,% "x" (VirBoxW-29)/2  " y" (VirBoxH-29)/2
GuiControl, MoveDraw, ArrowResizeRight,% "x" VirBoxW-21  " y" (VirBoxH-23)/2
GuiControl, MoveDraw, ArrowResizeDownLeft,% "x" 5 " y" VirBoxH-22
GuiControl, MoveDraw, ArrowResizeDown,% "x" (VirBoxW-23)/2  " y" VirBoxH-21
GuiControl, MoveDraw, ArrowResizeDownRight,% "x" VirBoxW-22 " y" VirBoxH-22
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
} VirBoxX:=BoxX
Hover:=0
GoTo BoxUpdate
~*Right::
If Dragging
	Return
If GetKeyState("Shift","P")
	BoxW--
else BoxW++
VirBoxW:=BoxW
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
} VirBoxY:=BoxY
Hover:=0
GoTo BoxUpdate
~*Down::
If Dragging
	Return
If GetKeyState("Shift","P")
	BoxH--
else BoxH++
VirBoxH:=BoxH
Hover:=0
GoTo BoxUpdate

GuiResize:
Dragging:=1, UpdateRate:=10
TempX:=BoxX
TempY:=BoxY
TempW:=BoxW
TempH:=BoxH
if (A_GuiControl="ArrowResizeLeft"){
	GoSub UiHide
	MouseMove, BoxX, BoxY+BoxH/2
	BoxX:=TempX+TempW
	BoxW:=TempW*-1
	GoTo, ResizeHorizontal
} else if (A_GuiControl="ArrowResizeRight"){
	GoSub UiHide
	MouseMove, BoxX+BoxW, BoxY+BoxH/2
	GoTo, ResizeHorizontal
} else if (A_GuiControl="ArrowResizeUp"){
	GoSub UiHide
	MouseMove, BoxX+BoxW/2, BoxY
	BoxY:=TempY+TempH
	BoxH:=TempH*-1
	GoTo, ResizeVertical
} else if (A_GuiControl="ArrowResizeDown"){
	GoSub UiHide
	MouseMove, BoxX+BoxW/2, BoxY+BoxH
	ResizeY:=BoxY+BoxH
	GoTo, ResizeVertical
} else if (A_GuiControl="ArrowResizeUpLeft"){
	GoSub UiHide
	MouseMove, BoxX, BoxY
	BoxX:=TempX+TempW
	BoxY:=TempY+TempH
	BoxW:=TempW*-1
	BoxH:=TempH*-1
	GoSub, BoxUpdate
	GoTo, ResizeCorner
} else if (A_GuiControl="ArrowResizeUpRight"){
	GoSub UiHide
	MouseMove, BoxX+BoxW, BoxY
	BoxX:=TempX
	BoxY:=TempY+TempH
	BoxW:=TempW
	BoxH:=TempH*-1
	GoSub, BoxUpdate
	GoTo, ResizeCorner
} else if (A_GuiControl="ArrowResizeDownLeft"){
	GoSub UiHide
	MouseMove, BoxX, BoxY+BoxH
	BoxX:=TempX+TempW
	BoxY:=TempY
	BoxW:=TempW*-1
	BoxH:=TempH
	GoSub, BoxUpdate
	GoTo, ResizeCorner
} else if (A_GuiControl="ArrowResizeDownRight"){
	GoSub UiHide
	MouseMove, BoxX+BoxW, BoxY+BoxH
	GoTo, ResizeCorner
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

;Horizontal
;#####################################################################################

ResizeHorizontal:
Hotkey, Shift Up, ResizeHorizontalShiftUp,
Hotkey, Shift, ResizeHorizontalShiftDown,
Hotkey, Shift Up, ResizeHorizontalShiftUp, On
Hotkey, Shift, ResizeHorizontalShiftDown, On
Hotkey, *Ctrl Up, ResizeHorizontalCtrlUp,
Hotkey, *Ctrl, ResizeHorizontalCtrlDown,
Hotkey, *Ctrl Up, ResizeHorizontalCtrlUp, On
Hotkey, *Ctrl, ResizeHorizontalCtrlDown, On
Hotkey, Alt Up, ResizeHorizontalAltUp,
Hotkey, Alt, ResizeHorizontalAltDown,
Hotkey, Alt Up, ResizeHorizontalAltUp, On
Hotkey, Alt, ResizeHorizontalAltDown, On

StartBoxX:=BoxX
StartBoxY:=BoxY
StartBoxW:=BoxW
StartBoxH:=BoxH
StartMidX:=StartBoxX+StartBoxW/2
StartMidY:=StartBoxY+StartBoxH/2

StartRatio:=BoxW/BoxH
GuiControl, 2:, LoopHint,% StartRatio

While GetKeyState("Lbutton"){
	MouseGetPos, MouseX, MouseY
	If !(MouseY=PrevMouseY and MouseX=PrevMouseX){
		if (!CtrlResize and GetKeyState("Shift", "P")){
			Gosub, ResizeHorizontalShift
		} else {
			If (CtrlResize){
				GoSub, ResizeHorizontalCtrl
			} else {
				BoxW:=MouseX-BoxX
				If (AltResize){
					BoxH:=BoxW
					BoxY:=StartMidY-BoxH/2
				}
			}
		}
		PrevMouseX:=MouseX, PrevMouseY:=MouseY
		GoSub BoxUpdate
	}
	sleep, -1
}
Hotkey, Shift Up, ResizeHorizontalShiftUp, Off
Hotkey, Shift, ResizeHorizontalShiftDown, Off
Hotkey, *Ctrl Up, ResizeHorizontalCtrlUp, Off
Hotkey, *Ctrl, ResizeHorizontalCtrlDown, Off
Hotkey, Alt Up, ResizeHorizontalAltUp, Off
Hotkey, Alt, ResizeHorizontalAltDown, Off
Dragging=0
Hover=0
GoSub BoxUpdate
CtrlResize=0
AltResize=0
ShiftResize=0
Return

ResizeHorizontalShift:
BoxW:=MouseX-BoxX
BoxH:=BoxW/StartRatio
BoxY:=StartBoxY-BoxH/2+StartBoxH/2
Return

ResizeHorizontalCtrl:
BoxX:=StartMidX-(MouseX-StartMidX),
BoxW:=(MouseX-StartMidX)*2
If GetKeyState("Shift", "P"){
	BoxH:=BoxW/StartRatio
	BoxX:=StartMidX-(MouseX-StartMidX)
	BoxY:=StartMidY-BoxH/2
}
If (AltResize){
	GoSub ResizeHorizontalAlt
}
Return
Return

ResizeHorizontalAlt:
BoxH:=BoxW
BoxY:=StartMidY-BoxH/2
Return

ResizeHorizontalShiftDown:
Hotkey, Shift, ResizeHorizontalShiftDown, Off
Hotkey, Alt, ResizeHorizontalAltDown, Off
MouseGetPos, MouseX, MouseY
Gosub, ResizeHorizontalShift
PrevMouseX:=MouseX, PrevMouseY:=MouseY
GoSub BoxUpdate
Return

ResizeHorizontalShiftUp:
Hotkey, Shift, ResizeHorizontalShiftDown, On
Hotkey, Alt, ResizeHorizontalAltDown, On
Return

ResizeHorizontalCtrlDown:
Hotkey, *Ctrl, ResizeHorizontalCtrlDown, Off
Gosub, ResizeHorizontalCtrl
CtrlResize=1
Goto BoxUpdate

ResizeHorizontalCtrlUp:
Hotkey, *Ctrl, ResizeHorizontalCtrlDown, On
BoxX:=StartBoxX
BoxW:=MouseX-BoxX
CtrlResize=0
Goto BoxUpdate

ResizeHorizontalAltDown:
Hotkey, Alt, ResizeHorizontalAltDown, Off
AltResize=1
Gosub, ResizeHorizontalAlt
Goto BoxUpdate

ResizeHorizontalAltUp:
AltResize=0
If !(ShiftResize){
	Hotkey, Alt, ResizeHorizontalAltDown, On
}
Goto BoxUpdate

;Vertical
;#####################################################################################

ResizeVertical:
Hotkey, Shift Up, ResizeVerticalShiftUp,
Hotkey, Shift, ResizeVerticalShiftDown,
Hotkey, Shift Up, ResizeVerticalShiftUp, On
Hotkey, Shift, ResizeVerticalShiftDown, On
Hotkey, *Ctrl Up, ResizeVerticalCtrlUp,
Hotkey, *Ctrl, ResizeVerticalCtrlDown,
Hotkey, *Ctrl Up, ResizeVerticalCtrlUp, On
Hotkey, *Ctrl, ResizeVerticalCtrlDown, On
Hotkey, Alt Up, ResizeVerticalAltUp,
Hotkey, Alt, ResizeVerticalAltDown,
Hotkey, Alt Up, ResizeVerticalAltUp, On
Hotkey, Alt, ResizeVerticalAltDown, On

StartBoxX:=BoxX
StartBoxY:=BoxY
StartBoxW:=BoxW
StartBoxH:=BoxH
StartMidX:=StartBoxX+StartBoxW/2
StartMidY:=StartBoxY+StartBoxH/2

StartRatio:=BoxW/BoxH
GuiControl, 2:, LoopHint,% StartRatio

While GetKeyState("Lbutton"){
	MouseGetPos, MouseX, MouseY
	If !(MouseY=PrevMouseY and MouseX=PrevMouseX){
		if (!CtrlResize and (ShiftResize)){
			Gosub, ResizeVerticalShift
		} else {
			If (CtrlResize){
				GoSub, ResizeVerticalCtrl
			} else {
				BoxH:=MouseY-BoxY
				If (AltResize){
					BoxW:=BoxH
					BoxX:=StartMidX-BoxW/2
				}
			}
		}
		PrevMouseX:=MouseX, PrevMouseY:=MouseY
		GoSub BoxUpdate
	}
	sleep, -1
}
Hotkey, Shift Up, ResizeVerticalShiftUp, Off
Hotkey, Shift, ResizeVerticalShiftDown, Off
Hotkey, *Ctrl Up, ResizeVerticalCtrlUp, Off
Hotkey, *Ctrl, ResizeVerticalCtrlDown, Off
Hotkey, Alt Up, ResizeVerticalAltUp, Off
Hotkey, Alt, ResizeVerticalAltDown, Off
Dragging=0
Hover=0
GoSub BoxUpdate
CtrlResize=0
AltResize=0
ShiftResize=0
Return

ResizeVerticalShift:
BoxH:=MouseY-BoxY
BoxW:=BoxH*StartRatio
BoxX:=StartBoxX-BoxW/2+StartBoxW/2
Return

ResizeVerticalCtrl:
BoxY:=StartMidY-(MouseY-StartMidY),
BoxH:=(MouseY-StartMidY)*2
If (ShiftResize){
	BoxW:=BoxH*StartRatio
	BoxY:=StartMidY-(MouseY-StartMidY)
	BoxX:=StartMidX-BoxW/2
}
If (AltResize){
	GoSub ResizeVerticalAlt
}
Return

ResizeVerticalAlt:
BoxW:=BoxH
BoxX:=StartMidX-BoxW/2
Return

ResizeVerticalShiftDown:
Hotkey, Shift, ResizeVerticalShiftDown, Off
Hotkey, Alt, ResizeVerticalAltDown, Off
ShiftResize=1
MouseGetPos, MouseX, MouseY
Gosub, ResizeVerticalShift
PrevMouseX:=MouseX, PrevMouseY:=MouseY
GoSub BoxUpdate
Return

ResizeVerticalShiftUp:
Hotkey, Shift, ResizeVerticalShiftDown, On
Hotkey, Alt, ResizeVerticalAltDown, On
ShiftResize=0
Return

ResizeVerticalCtrlDown:
Hotkey, *Ctrl, ResizeVerticalCtrlDown, Off
Gosub, ResizeVerticalCtrl
CtrlResize=1
Goto BoxUpdate

ResizeVerticalCtrlUp:
Hotkey, *Ctrl, ResizeVerticalCtrlDown, On
BoxY:=StartBoxY
BoxH:=MouseY-BoxY
CtrlResize=0
Goto BoxUpdate

ResizeVerticalAltDown:
Hotkey, Alt, ResizeVerticalAltDown, Off
AltResize=1
Gosub, ResizeVerticalAlt
Goto BoxUpdate

ResizeVerticalAltUp:
AltResize=0
If !(ShiftResize){
	Hotkey, Alt, ResizeVerticalAltDown, On
}
Goto BoxUpdate

;Corner
;#####################################################################################
ResizeCorner:
Hotkey, Shift Up, ResizeCornerShiftUp,
Hotkey, Shift, ResizeCornerShiftDown,
Hotkey, Shift Up, ResizeCornerShiftUp, On
Hotkey, Shift, ResizeCornerShiftDown, On
Hotkey, *Ctrl Up, ResizeCornerCtrlUp,
Hotkey, *Ctrl, ResizeCornerCtrlDown,
Hotkey, *Ctrl Up, ResizeCornerCtrlUp, On
Hotkey, *Ctrl, ResizeCornerCtrlDown, On
Hotkey, Alt Up, ResizeCornerAltUp,
Hotkey, Alt, ResizeCornerAltDown,
Hotkey, Alt Up, ResizeCornerAltUp, On
Hotkey, Alt, ResizeCornerAltDown, On

StartBoxX:=BoxX
StartBoxY:=BoxY
StartBoxW:=BoxW
StartBoxH:=BoxH
StartMidX:=StartBoxX+StartBoxW/2
StartMidY:=StartBoxY+StartBoxH/2

StartRatio:=Abs(BoxW/BoxH)
GuiControl, 2:, LoopHint,% StartRatio

While GetKeyState("Lbutton"){
	MouseGetPos, MouseX, MouseY
	If !(MouseY=PrevMouseY and MouseX=PrevMouseX){
		if (!CtrlResize and ShiftResize){
			Gosub, ResizeCornerShift
		} else {
			If (CtrlResize){
				GoSub, ResizeCornerCtrl
			} else {
				If (AltResize){
					GoSub, ResizeCornerAlt
				} else {
					BoxW:=MouseX-BoxX, BoxH:=MouseY-BoxY
				}
			}
		}
		PrevMouseX:=MouseX, PrevMouseY:=MouseY
		GoSub BoxUpdate
	}
	sleep, -1
}
Hotkey, Shift Up, ResizeCornerShiftUp, Off
Hotkey, Shift, ResizeCornerShiftDown, Off
Hotkey, *Ctrl Up, ResizeCornerCtrlUp, Off
Hotkey, *Ctrl, ResizeCornerCtrlDown, Off
Hotkey, Alt Up, ResizeCornerAltUp, Off
Hotkey, Alt, ResizeCornerAltDown, Off
Dragging=0
Hover=0
GoSub BoxUpdate
CtrlResize=0
ShiftResize=0
AltResize=0
Return

ResizeCornerShift:
If ((MouseX>=BoxX and MouseY>=BoxY) or (MouseX<=BoxX and MouseY<=BoxY)){  ;UpLeft and DownRight
	If (Abs(MouseX-boxX)>abs(MouseY-boxY)*StartRatio){
		Guicontrol,2:,loophint, 1
		BoxH:=(MouseX-boxX)/StartRatio
		BoxW:=BoxH*StartRatio
	} else {
		Guicontrol,2:,loophint, 2
		BoxW:=(MouseY-boxY)*StartRatio
		BoxH:=BoxW/StartRatio
}} else If (MouseX<BoxX and MouseY>BoxY){  ;DownLeft
	If (Abs(MouseX-boxX)>abs(MouseY-boxY)*StartRatio){
		Guicontrol,2:,loophint, 3
		BoxH:=Abs(MouseX-boxX)/StartRatio
		BoxW:=BoxH*-1*StartRatio
	} else {
		Guicontrol,2:,loophint, 4
		BoxW:=(MouseY-boxY)*-1*StartRatio
		BoxH:=Abs(BoxW)/StartRatio
}} else If (MouseX>BoxX and MouseY<BoxY){  ;UpRight
	If (Abs(MouseX-boxX)>abs(MouseY-boxY)*StartRatio){
		Guicontrol,2:,loophint, 5
		BoxH:=(MouseX-boxX)*-1/StartRatio
		BoxW:=Abs(BoxH)*StartRatio
	} else {
		Guicontrol,2:,loophint, 6
		BoxW:=(MouseY-boxY)*-1*StartRatio
		BoxH:=BoxW*-1/StartRatio
}}
If BoxH<0
	BoxH:=Ceil(BoxH)
If BoxW<0
	BoxW:=Ceil(BoxW)
Return

ResizeCornerAlt:
If (CtrlResize){
	Return
}
If ((MouseX>=BoxX and MouseY>=BoxY) or (MouseX<=BoxX and MouseY<=BoxY)){  ;UpLeft and DownRight
	If (Abs(MouseX-boxX)>abs(MouseY-boxY)){
		BoxH:=MouseX-boxX
		BoxW:=BoxH
	} else if (Abs(MouseX-boxX)<abs(MouseY-boxY)){
		BoxW:=MouseY-boxY
		BoxH:=BoxW
}} else If (MouseX<BoxX and MouseY>BoxY){  ;DownLeft
	If (Abs(MouseX-boxX)>abs(MouseY-boxY)){
		BoxH:=Abs(MouseX-boxX)
		BoxW:=BoxH*-1
	} else if (Abs(MouseX-boxX)<abs(MouseY-boxY)){
		BoxW:=(MouseY-boxY)*-1
		BoxH:=Abs(BoxW)
}} else If (MouseX>BoxX and MouseY<BoxY){  ;UpRight
	If (Abs(MouseX-boxX)>abs(MouseY-boxY)){
		BoxH:=(MouseX-boxX)*-1
		BoxW:=Abs(BoxH)
	} else if (Abs(MouseX-boxX)<abs(MouseY-boxY)){
		BoxW:=(MouseY-boxY)*-1
		BoxH:=BoxW*-1
}}
Return

ResizeCornerCtrl:
BoxX:=StartMidX-(MouseX-StartMidX),
BoxY:=StartMidY-(MouseY-StartMidY),
BoxW:=(MouseX-StartMidX)*2,
BoxH:=(MouseY-StartMidY)*2
If (ShiftResize){
	If (Abs(BoxW/StartRatio)>Abs(BoxH)){  ;Horizontal
		BoxH:=BoxW/StartRatio
		BoxW:=BoxH*StartRatio
		BoxY:=BoxY+(MouseY-StartMidY)-BoxH/2
		BoxX:=BoxX+(MouseX-StartMidX)-BoxW/2
	} else If (Abs(BoxW/StartRatio)<Abs(BoxH)){  ;Vertical
		BoxW:=BoxH*StartRatio
		BoxX:=BoxX+(MouseX-StartMidX)-BoxW/2
}} else If GetKeyState("Alt", "P"){
	If (Abs(BoxW)>Abs(BoxH)){  ;Horizontal
		BoxH:=BoxW
		BoxW:=BoxH
		BoxY:=BoxY+(MouseY-StartMidY)-BoxH/2
		BoxX:=BoxX+(MouseX-StartMidX)-BoxW/2
	} else If (Abs(BoxW)<Abs(BoxH)){  ;Vertical
		BoxW:=BoxH
		BoxX:=BoxX+(MouseX-StartMidX)-BoxW/2
}}
Return

ResizeCornerShiftDown:
Hotkey, Shift, ResizeCornerShiftDown, Off
Hotkey, Alt, ResizeCornerAltDown, Off
ShiftResize=1
MouseGetPos, MouseX, MouseY
Gosub, ResizeCornerShift
If (CtrlResize){
	Gosub ResizeCornerCtrl
}
PrevMouseX:=MouseX, PrevMouseY:=MouseY
GoSub BoxUpdate
Return

ResizeCornerShiftUp:
Hotkey, Shift, ResizeCornerShiftDown, On
Hotkey, Alt, ResizeCornerAltDown, On
ShiftResize=0
MouseGetPos, MouseX, MouseY
BoxW:=MouseX-BoxX
BoxH:=MouseY-BoxY
If (CtrlResize){
	Gosub ResizeCornerCtrl
}
If (AltResize){
	GoSub ResizeCornerAltDown
}
If BoxH=0
	BoxH:=1
If BoxY=0
	BoxY:=1
PrevMouseX:=MouseX, PrevMouseY:=MouseY
GoSub BoxUpdate
Return

ResizeCornerCtrlDown:
Hotkey, *Ctrl, ResizeCornerCtrlDown, Off
CtrlResize=1
Gosub, ResizeCornerCtrl
Goto BoxUpdate

ResizeCornerCtrlUp:
Hotkey, *Ctrl, ResizeCornerCtrlDown, On
CtrlResize=0
BoxX:=StartBoxX
BoxY:=StartBoxY
BoxW:=MouseX-BoxX, BoxH:=MouseY-BoxY
If (AltResize){
	GoSub ResizeCornerAltDown
}
Goto BoxUpdate

ResizeCornerAltDown:
Hotkey, Alt, ResizeCornerAltDown, Off
AltResize=1
If (CtrlResize){
	GoSub, ResizeCornerCtrl
} else If !(ShiftResize){
	Gosub, ResizeCornerAlt
}
Goto BoxUpdate

ResizeCornerAltUp:
Hotkey, Alt, ResizeCornerAltDown, On
If (CtrlResize){
	GoSub, ResizeCornerCtrl
} else If !(ShiftResize){
	BoxX:=StartBoxX
	BoxY:=StartBoxY
	BoxW:=MouseX-BoxX, BoxH:=MouseY-BoxY
}
AltResize=0
Goto BoxUpdate