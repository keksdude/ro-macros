; Script Start - Add your code below here
#include <GUIConstants.au3>
;~ Global Const $WS_POPUP                = 0x80000000
;~ Global Const $WS_EX_TOOLWINDOW            = 0x00000080
;~ Global Const $WS_EX_TOPMOST                = 0x00000008

#include <Misc.au3>
#include <MsgBoxConstants.au3>
#include <AutoItConstants.au3>
#include <Date.au3>

HotKeySet("{F1}", "Terminate")
HotKeySet("{F4}", "Pause")


$exit = False
$pause = True
$bla = 1
Global $pause = True
Opt("PixelCoordMode", 0) ;1=absolute, 0=relative, 2=client
Opt("MouseCoordMode", 0) ;1=absolute, 0=relative, 2=client
Opt("MouseClickDelay", 0)
Opt("SendKeyDelay", 0)


Func Pause()
	$pause = Not $pause
EndFunc   ;==>Pause

Func Terminate()
	$exit = True
EndFunc   ;==>Terminate


While Not $exit
	If Not $pause Then
		ControlSend("", "", "", "{ENTER}")
		Sleep(250)
	EndIf
WEnd


