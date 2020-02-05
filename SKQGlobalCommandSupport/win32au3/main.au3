#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=..\..\code\favicon.ico
#AutoIt3Wrapper_Outfile=streamkeyshelper.exe
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Res_Comment=A helper application for StreamKeysQuantum Firefox extension. 100% Open source, see github
#AutoIt3Wrapper_Res_Description=A helper application for StreamKeysQuantum Firefox extension. 100% Open source, see github
#AutoIt3Wrapper_Res_Fileversion=1.7.6.1
#AutoIt3Wrapper_Res_ProductName=Stream Keys Quantum Global Command Support Helper
#AutoIt3Wrapper_Res_ProductVersion=1.7.6.1
#AutoIt3Wrapper_Res_CompanyName=efprojects.com
#AutoIt3Wrapper_Res_LegalCopyright=(c) Egor Aristov, 2018
#AutoIt3Wrapper_Res_LegalTradeMarks=(c) efprojects.com
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

; StreamKeys-Quantum Firefox Extension helper by Egor3f
; Global Command Support
; version 0.1

;#include <MsgBoxConstants.au3>
;MsgBox($MB_SYSTEMMODAL, "Test", "test")

Global $commandConfig = IniReadSection("config.ini", "commands")
Global $commandsLength = $commandConfig[0][0]

For $i = 1 to $commandsLength
	HotKeySet($commandConfig[$i][1], "processCommand")
	; ConsoleWrite($commandConfig[$i][1])
Next

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

While 1
    Sleep(100)
WEnd
