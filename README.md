# AutoHotkey-Scripts
 Folder of my AutoHotkey scripts.
 
Only limited testing has been done on other systems to check stability.  
 
 #### Run BuildIncludes.ahk before using
 
 ## ScriptFrog  
 ![ScriptFrog](https://raw.githubusercontent.com/Satsaa/My-AutoHotkey-Scripts/master/v1/Res/Readme/ScriptFrog.png "ScriptFrog") 
<details><summary>Settings Tab</summary>
<p>  
 
 ![ScriptFrog2](https://raw.githubusercontent.com/Satsaa/My-AutoHotkey-Scripts/master/v1/Res/Readme/ScriptFrogSettings.png "ScriptFrog") 

</p>
</details>

###### (There are no macros)  
 ScriptFrog includes a bunch of smaller scripts that you can hotkey.  
 Each of those scripts can have settings that you can edit in the Settings tab.  
 Supports exporting/importing your current hotkeys/settings.  
 Has profiles for a few select programs which are hardcoded (Default, Dota, Minecraft, Witcher). You have to live with them or edit them yourself (usually waits for a specific window title or program).

<details><summary>Adding you own scripts</summary>
<p>
 
 Each script can have a bunch of settings. Each variable is defined for a script like `HotkeyAllowModifiers[SC] := <value>`.  
 Scripts are usually under v1/ScriptFrog/Scripts but this is not needed. #Include the script you made in the start of ScriptFrog.ahk (where all the other ones are included).  
 Subroutes are called as \<HotkeySub\>_\<SubRoute\> (eg. MYSCRIPT_Load, MYSCRIPT_Ctrl, MYSCRIPT).  
 The \<HotkeySub\> label is called when an assigned hotkey is pressed without modifiers.  

```autohotkey
; Required
HotkeyName := [],                   ;Displayed name of the hotkey. Must be a valid variable name. "_" is displayed as a space
HotkeySub := [],                    ;Subroute prefix (_ is added to the end)
HotkeyDescription := [],            ;Description of what each hotkeys do / any text
HotkeySettings := [],               ;Comma separated list of settings that will be shown in the Settings tab
HotkeySettingsDescription := [],    ;Description of what all the settings do / any text

; Optional
HotkeyGlobal := [],                 ;Defines if the hotkey will be globally active
HotkeyAllowModifiers := [],         ;Defines if the hotkey allows modifiers in its hotkey
HotkeyDisableMain[]                 ;Defines if the hotkey's main       subroute is NOT active (Executed when hotkey is pressed without modifiers)
HotkeyAny := [],                    ;Defines if the hotkey's Any        subroute is active (Disables modifier subroutes. Executed when hotkey is pressed with any or no modifiers)
HotkeyCtrl := [],                   ;Defines if the hotkey's Ctrl       subroute is active
HotkeyAlt := [],                    ;Defines if the hotkey's Alt        subroute is active
HotkeyShift := [],                  ;Defines if the hotkey's Shift      subroute is active
HotkeyCtrlAlt := [],                ;Defines if the hotkey's CtrlAlt    subroute is active
HotkeyCtrlShift := [],              ;Defines if the hotkey's CtrlShift  subroute is active
HotkeyAltShift := [],               ;Defines if the hotkey's AltShift   subroute is active
HotkeyCtrlAltShift := [],           ;Defines if the hotkey's CtrlAltShift  subroute is active
HotkeyTick := [],                   ;Defines if the hotkey's Tick       subroute is active  Executed on each tick
```

Here is how the Annihilate script is done. 
`GoTo AN_End` after variables and `AN_End:` at the end is required for each script. (Prevents main script from stopping when including these scripts)

```authotkey
SC++
HotkeyName[SC] := "Annihilate"
HotkeySub[SC] := "AN"
HotkeyDescription[SC] := "Hotkey:`nKill the script immediately`n`nThis hotkey will be active in all profiles"
HotkeyGlobal[SC] := 1
HotkeyAllowModifiers[SC] := 1
GoTo AN_End

AN_Load:
Return

AN:
GoTo Terminate
Return

AN_End:
```
</p>
</details>

 ## Boxy
 ![Boxy](https://raw.githubusercontent.com/Satsaa/My-AutoHotkey-Scripts/master/v1/Res/Readme/Boxy.png "Boxy")   
 Boxy is a snipping tool Gimp box select style control (ctrl-,alt-,shift drag) + math controlling.  
 Main GUI which has settings all the settings and shows your previous screenshot.  
 Also has controls for box X,Y,X2,Y2 values which can use basic math and variables available to the script.  
 These values are relative to the screen or a window you can choose using [WinTitle](https://www.autohotkey.com/docs/misc/WinTitle.htm) parameter format.  
 

 Frame GUI which is a resizeable box that shows the area you would screenshot.  
 This gui can be resized by dragging one of the boxes that appear when you hover near the edges, or moved with the middle box.  
 
 Alt: Restricts the box to 1:1 ratio.  
 Shift: Restricts the box to the original ratio.  
 Ctrl: Restricts the box center to the original center.   
 
 ## FantasyCounter
 ![FantasyCounter](https://raw.githubusercontent.com/Satsaa/My-AutoHotkey-Scripts/master/v1/Res/Readme/FantasyCounter.png "FantasyCounter")  
<details><summary>Ignore Windows</summary>
<p>  
 
 ![FantasyCounter2](https://raw.githubusercontent.com/Satsaa/My-AutoHotkey-Scripts/master/v1/Res/Readme/FantasyCounterIgnores.png "FantasyCounter") 

</p>
</details>

 Allows you to find your best (highest score) Dota 2 Fantasy cards for the current TI.  
 Supports searching by player/team/position.  
 Each player/team/position can be ignored invidually.  
 
 ## YoutubeDL
 ![YoutubeDL](https://raw.githubusercontent.com/Satsaa/My-AutoHotkey-Scripts/master/v1/Res/Readme/YoutubeDl.png "YoutubeDL")   
 YoutubeDL/YTDL_HelperGui.ahk is a simple host for youtube-dl.exe. [Youtube-dl](https://rg3.github.io/youtube-dl)  
 Used to queue downloads of videos/audio by url.  
 Supports setting the command line arguments for youtube-dl.exe.  
 
 ## Misc
<details><summary>Preview</summary>
<p>  
 
 ![BarMan](https://raw.githubusercontent.com/Satsaa/My-AutoHotkey-Scripts/master/v1/Res/Readme/BarMan.png "BarMan")   

</p>
</details> 

 BarMan/BarProbability.ahk  
 Customizeable script which is used to display chances of a specific number output from an algorithm.  
 
<details><summary>Preview</summary>
<p>  
 
 ![LaunchPad](https://raw.githubusercontent.com/Satsaa/My-AutoHotkey-Scripts/master/v1/Res/Readme/LaunchPad.png "LaunchPad") 

</p>
</details>   

 LaunchPad  
 Gui for opening the above scripts (on my taskbar for quick access).  
