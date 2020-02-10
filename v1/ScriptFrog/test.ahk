#Include C:\Users\sampp\Desktop\HNN - BU\AutoHotkey\v1\Lib\Functions.ahk

;First we have to declare class:
Class MacroFunctions {

  Macro(MacroData) {
  For Key, Macro in MacroData
    {
      this[Macro[1]](Macro[2])
    }
  }

  Text(Text="") {
    Send, %Text%
  }
  Paste(Text="") {
    Paste(Text)
  }
  Down(Key="") {
    Send, {%Key% Down}
  }
  Up(Key="") {
    Send, {%Key% Up}
  }
  Mouse(mouseX, mouseY, Relative) {
    MouseMove, %mouseX%, %mouseY%, %Relative%
  }
  Right(Count=1, Up=false, Down=false){
    if (Up)
      Click, %Up%, R, %Count%
    else if (Down)
      Click, %Down%, R, %Count%
    else 
      Click, R, %Count%
  }
  Middle(Count=1, Up=false, Down=false){
    if (Up)
      Click, %Up%, M, %Count%
    else if (Down)
      Click, %Down%, M, %Count%
    else 
      Click, M, %Count%
  }
  Left(Count=1, Up=false, Down=false){
    if (Up)
      Click, %Up%, L, %Count%
    else if (Down)
      Click, %Down%, L, %Count%lol
    else 
      Click, L, %Count%
  }
  macros := {}  ; { MACRONAME: { Handler: FUNC, Description: TEXT, Options: [{ Validator: FUNC, Description: TEXT, Type: range|bool|text|num, Opts: TYPE_DEPENDENT }] } }
}

MacroInstance := new MacroFunctions

MacroInstance.test := MacroInstance.Paste

MacroInstance.test("POGGERS")

ExitApp, 0