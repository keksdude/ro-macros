; Script Start - Add your code below here
#include <MemoryCustom.au3>
#include <GUIConstants.au3>
;~ Global Const $WS_POPUP                = 0x80000000
;~ Global Const $WS_EX_TOOLWINDOW            = 0x00000080
;~ Global Const $WS_EX_TOPMOST                = 0x00000008

#include <Misc.au3>
#include <MsgBoxConstants.au3>
#include <AutoItConstants.au3>
#include <Date.au3>
#include <GUIConstantsEx.au3>


HotKeySet("{F5}", "SetWindow")
HotKeySet("{F4}", "Pause")


;Window ID's
Global $WinID1 = 0

Global $exit = False
Global $pause = True

Opt("PixelCoordMode", 0) ;1=absolute, 0=relative, 2=client
Opt("MouseCoordMode", 0) ;1=absolute, 0=relative, 2=client
Opt("GUIOnEventMode", 1) ; Change to OnEvent mode

Local $hMainGUI = GUICreate("ram read test", 200, 1000, 0, 0)
GUISetOnEvent($GUI_EVENT_CLOSE, "CloseButton")

;Autopot Gui and variables
GUICtrlCreateLabel("HP", 10, 10, 60, 20)
GUICtrlCreateLabel("SP", 10, 30, 60, 20)
GUICtrlCreateLabel("Where", 10, 50, 60, 20)

$hplabel = GUICtrlCreateLabel("qwe", 60, 10, 100, 20)
$splabel = GUICtrlCreateLabel("qwe", 60, 30, 100, 20)
$wherelabel = GUICtrlCreateLabel("qwe", 60, 50, 100, 20)
$explabel = GUICtrlCreateLabel("qwe", 60, 70, 100, 20)

GUISetState()


Func SetWindow()
	$WinID1 = WinGetProcess("")
EndFunc   ;==>SetWindow

Func Pause()
	$pause = Not $pause
EndFunc   ;==>Pause

Func Terminate()
	$exit = True
EndFunc   ;==>Terminate


While Not $exit
	If Not $pause And $WinID1 <> 0 Then
		$ProcessInformation = _MemoryOpen($WinID1)
		$hp = _MemoryRead(0xCA2118, $ProcessInformation)
		$currenthp = _MemoryRead(0xCA2114, $ProcessInformation)

		$sp = _MemoryRead(0xCA2120, $ProcessInformation)
		$currentsp = _MemoryRead(0xCA211C, $ProcessInformation)

		$flywings = _MemoryRead(0x8C7100, $ProcessInformation)
		$x = _MemoryRead(0xC965AC, $ProcessInformation)
		$y = _MemoryRead(0xC965B0, $ProcessInformation)
		$exp = _MemoryRead(0x7AC048, $ProcessInformation)

		_MemoryClose($ProcessInformation)
		GUICtrlSetData($hplabel, String($currenthp) & "/"& String($hp))
		GUICtrlSetData($splabel, String($currentsp) & "/"& String($sp))
		GUICtrlSetData($wherelabel, String($x)& "/"& String($y))
		GUICtrlSetData($explabel, String($explabel))
		Sleep(500)
	EndIf
WEnd


Func PauseButton()
	; Note: At this point @GUI_CtrlId would equal $iOKButton,
	; and @GUI_WinHandle would equal $hMainGUI
	MsgBox($MB_OK, "GUI Event", "You selected OK!")
EndFunc   ;==>PauseButton

Func CloseButton()
	; Note: At this point @GUI_CtrlId would equal $GUI_EVENT_CLOSE,
	; and @GUI_WinHandle would equal $hMainGUI
	Exit
EndFunc   ;==>CloseButton
