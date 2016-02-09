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


HotKeySet("{F1}", "SetWindow")
HotKeySet("{F}", "Pause")


;Window ID's
Global $WinID1 = 0

Global $exit = False
Global $pause = True

Opt("PixelCoordMode", 0) ;1=absolute, 0=relative, 2=client
Opt("MouseCoordMode", 0) ;1=absolute, 0=relative, 2=client
Opt("GUIOnEventMode", 1) ; Change to OnEvent mode

Local $hMainGUI = GUICreate("ram read test", 200, 1000,0,0)
GUISetOnEvent($GUI_EVENT_CLOSE, "CloseButton")

;Autopot Gui and variables
GUICtrlCreateLabel("HP",20, 40, 60, 20)
GUICtrlCreateLabel("SP",20, 60, 60, 20)

$hplabel = GUICtrlCreateLabel("qwe",60, 40, 60, 20)
$splabel = GUICtrlCreateLabel("qwe",60, 60, 60, 20)


GUISetState()


Func SetWindow()
	$WinID1 = WinGetHandle("")
EndFunc

Func Pause()
	$pause = Not $pause
EndFunc   ;==>Pause

Func Terminate()
	$exit = True
EndFunc   ;==>Terminate


While Not $exit
	If Not $pause And $WinID1 <> 0 Then
		$ProcessInformation = _MemoryOpen($WinID1)
		$hp = _MemoryRead(0x8A2118, $ProcessInformation)


		_MemoryClose($ProcessInformation)
		GUICtrlSetData($hplabel,String($hp))
		GUICtrlSetData($splabel,"asd")
		Sleep(500)
	EndIf
WEnd


Func PauseButton()
    ; Note: At this point @GUI_CtrlId would equal $iOKButton,
    ; and @GUI_WinHandle would equal $hMainGUI
    MsgBox($MB_OK, "GUI Event", "You selected OK!")
EndFunc   ;==>OKButton

Func CloseButton()
    ; Note: At this point @GUI_CtrlId would equal $GUI_EVENT_CLOSE,
    ; and @GUI_WinHandle would equal $hMainGUI
    Exit
EndFunc   ;==>CLOSEButton
