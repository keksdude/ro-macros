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


Global $cHex
$exit = False
$pause = True
$bla = 1
Global $pause = True
Opt("PixelCoordMode", 0) ;1=absolute, 0=relative, 2=client
Opt("MouseCoordMode", 0) ;1=absolute, 0=relative, 2=client

Global $hwnd
$hwnd = GUICreate("Text Region", @DesktopWidth, @DesktopHeight, 10, 10, $WS_POPUP, BitOR($WS_EX_TOPMOST, $WS_EX_TOOLWINDOW))
GUISetBkColor(0xFF0000) ; text color

$text = "autopot "
$text = $text & "off"
$rgn = CreateTextRgn($hwnd, $text, 30, "Arial", 500)

SetWindowRgn($hwnd, $rgn)
GUISetState()

Func Init()
	$WindId = WinGetHandle("")
	Global $mPos = MouseGetPos()
	Sleep(1500)
	$cHex = PixelGetColor($mPos[0], $mPos[1], $WindId)
EndFunc   ;==>Init

Func SetDevoTarget()
	$WindId = WinGetHandle("")
	Global $mPos2 = MouseGetPos()
EndFunc   ;==>SetDevoTarget

Func SetDevo2Target()
	$WindId = WinGetHandle("")
	Global $mPos3 = MouseGetPos()
EndFunc   ;==>SetDevo2Target

Func DEVODUDE()
	If Not $pause Then
		If $WindId <> 0 Then
			ControlSend($WindId, "", "", "mm")
			Sleep(20)
			MouseClick("left", $mPos2[0], $mPos2[1], 1, 1)
			Sleep(2500)
			ControlSend($WindId, "", "", "mm")
			Sleep(20)
			MouseClick("left", $mPos3[0], $mPos3[1], 1, 1)
		EndIf
	Else
		ControlSend("", "", "", "{SPACE}")
	EndIf


EndFunc   ;==>DEVODUDE



Func Pause()
	$pause = Not $pause
	$text = "autopot "
	If $pause Then
		$text = $text & "off"
	Else
		$text = $text & "on"
	EndIf
	$rgn = CreateTextRgn($hwnd, $text, 30, "Arial", 500)
	SetWindowRgn($hwnd, $rgn)
	GUISetState()
EndFunc   ;==>Pause

Func Terminate()
	$exit = True
EndFunc   ;==>Terminate


While Not $exit
	If Not $pause Then
			ControlSend($WindId, "", "", "{ENTER}")
			Sleep(250)
		EndIf
	EndIf
WEnd


