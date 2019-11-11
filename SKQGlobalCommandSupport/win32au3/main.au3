#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=..\..\code\favicon.ico
#AutoIt3Wrapper_Outfile=script\streamkeyshelper.exe
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Res_Comment=A helper application for StreamKeysQuantum Firefox extension. 100% Open source, see github
#AutoIt3Wrapper_Res_Description=A helper application for StreamKeysQuantum Firefox extension. 100% Open source, see github
#AutoIt3Wrapper_Res_Fileversion=1.7.6.2
#AutoIt3Wrapper_Res_ProductName=Stream Keys Quantum Global Command Support Helper
#AutoIt3Wrapper_Res_ProductVersion=1.7.6.2
#AutoIt3Wrapper_Res_CompanyName=efprojects.com
#AutoIt3Wrapper_Res_LegalCopyright=(c) Egor Aristov, 2018-2019
#AutoIt3Wrapper_Res_LegalTradeMarks=(c) efprojects.com
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

; StreamKeys-Quantum Firefox Extension helper by Egor3f
; Global Command Support
; version 0.2

#include <TrayConstants.au3>

Global $commandConfig = IniReadSection("config.ini", "commands")
Global $commandsLength = $commandConfig[0][0]

Func setHotkeys($toEnable=True)
	For $i = 1 to $commandsLength
		If $toEnable Then
			HotKeySet($commandConfig[$i][1], "processCommand")
		Else
			HotKeySet($commandConfig[$i][1])
		EndIf
		; ConsoleWrite($commandConfig[$i][1])
	Next
EndFunc

Func processCommand()
	Dim $command = @HotKeyPressed
	For $i = 1 to $commandsLength
		If $command == $commandConfig[$i][1] Then
			SendFirefoxMessage($commandConfig[$i][0])
			ExitLoop
		EndIf
	Next
EndFunc

Func SendFirefoxMessage($cm)
	Dim $json = '"' & $cm & '"'
	Dim $len = StringLen($json)
	ConsoleWrite(Binary($len))
	ConsoleWrite($json)
EndFunc

Opt("TrayAutoPause", 0)
Opt("TrayMenuMode", 1)
$activeMessage = "SKQ Active — press to disable temporarily (to use other music/movie programs)"
$inactiveMessage = "SKQ Disabled — press to enable again"
$toggleMenuItem = TrayCreateItem($activeMessage)
TrayCreateItem("")
$exitMenuItem = TrayCreateItem("Exit Stream Keys Quantum GCS Helper")
TraySetState($TRAY_ICONSTATE_SHOW)
TrayItemSetState($toggleMenuItem, $TRAY_CHECKED)
$enabled = True
setHotkeys()

While 1
    Switch TrayGetMsg()
		Case $toggleMenuItem
			$enabled = Not $enabled
			setHotkeys($enabled)
			TrayItemSetState($toggleMenuItem, $enabled ? $TRAY_CHECKED : $TRAY_UNCHECKED)
			TrayItemSetText($toggleMenuItem, $enabled ? $activeMessage : $inactiveMessage)
		Case $exitMenuItem
			ExitLoop
	EndSwitch
WEnd
