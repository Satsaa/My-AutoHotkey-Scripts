; Required
HotkeyName := [],                   ;Displayed name of the hotkey. Must be a valid variable name. "_" is displayed as a space
HotkeySub := [],                    ;Subroute prefix 
HotkeyDescription := [],            ;Description of what each hotkeys do / any text
HotkeySettings := [],               ;Comma separated list of settings that will be shown in the Settings tab
HotkeySettingsDescription := [],    ;Description of what all the settings do / any text

HotkeyPrev := [],                   ;Internal

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
QPC(1)                              ;Internal; Query performance counter