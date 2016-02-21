; Script Start - Add your code below here
#include <GUIConstants.au3>
;~ Global Const $WS_POPUP                = 0x80000000
;~ Global Const $WS_EX_TOOLWINDOW            = 0x00000080
;~ Global Const $WS_EX_TOPMOST                = 0x00000008

#include <MemoryCustom.au3>
#include <Misc.au3>
#include <MsgBoxConstants.au3>
#include <AutoItConstants.au3>
#include <Date.au3>

HotKeySet("{F1}", "Terminate")
HotKeySet("{F4}", "Pause")
HotKeySet("{F5}", "Init")

Global $WindId = 0
Global $ProcessID = 0
Global $hp
Global $currenthp
Global $ProcessInformation
Global $HPKey = "{F9}"
$bla = 1

$exit = False
$pause = True

Global $pause = True
Opt("PixelCoordMode", 0) ;1=absolute, 0=relative, 2=client
Opt("MouseCoordMode", 0) ;1=absolute, 0=relative, 2=client

Global $hwnd
$hwnd = GUICreate("Text Region", @DesktopWidth, @DesktopHeight, 10, 10, $WS_POPUP, BitOR($WS_EX_TOPMOST, $WS_EX_TOOLWINDOW))
GUISetBkColor(0xFF0000) ; text color

$text = "autopot "
$text = $text & "off"
$rgn = CreateTextRgn($hwnd, $text, 20, "Arial", 500)
SetWindowRgn($hwnd, $rgn)
GUISetState()

Func Init()
	If $ProcessInformation <> 0 Then
		_MemoryClose($ProcessInformation)
	EndIf
	$ProcessID = WinGetProcess("")
	$WindId = WinGetHandle("")
	$ProcessInformation = _MemoryOpen($ProcessID)
EndFunc   ;==>Init

Func Pause()
	$pause = Not $pause
	$text = "autopot "
	If $pause Then
		$text = $text & "off"
	Else
		$text = $text & "on"
	EndIf
	$rgn = CreateTextRgn($hwnd, $text, 20, "Arial", 500)
	SetWindowRgn($hwnd, $rgn)
	GUISetState()
EndFunc   ;==>Pause

Func Terminate()
	GUIDelete($hwnd)
	$exit = True
EndFunc   ;==>Terminate

Local $hDLL = DllOpen("user32.dll")


While Not $exit
	If Not $pause Then
		If $WindId <> 0 Then
			$hp = _MemoryRead(0xCA2118, $ProcessInformation)
			$currenthp = _MemoryRead(0xCA2114, $ProcessInformation)
			Local $procent = $currenthp / $hp
			If ($procent) < 0.99 And $currenthp > 1 Then
				ControlSend($WindId, "", "", $HPKey)
			EndIf

			if _IsPressed (20,$hDLL) Then
				Send("{F10}")
				Sleep(5)
				$aPos = MouseGetPos()
				MouseClick("left", $aPos[0], $aPos[1]+$bla)
				$bla=$bla*(-1)
				Send("{F10}")
				Sleep(5)
			Else
				Sleep(50)
			EndIf
		EndIf
	EndIf
WEnd
If $ProcessInformation <> 0 Then
	_MemoryClose($ProcessInformation)
EndIf

Func SetWindowRgn($h_win, $rgn)
	DllCall("user32.dll", "long", "SetWindowRgn", "hwnd", $h_win, "long", $rgn, "int", 1)
EndFunc   ;==>SetWindowRgn

Func CreateTextRgn(ByRef $CTR_hwnd, $CTR_Text, $CTR_height, $CTR_font = "Microsoft Sans Serif", $CTR_weight = 1000)
	Local Const $ANSI_CHARSET = 0
	Local Const $OUT_CHARACTER_PRECIS = 2
	Local Const $CLIP_DEFAULT_PRECIS = 0
	Local Const $PROOF_QUALITY = 2
	Local Const $FIXED_PITCH = 1
	Local Const $RGN_XOR = 3

	If $CTR_font = "" Then $CTR_font = "Microsoft Sans Serif"
	If $CTR_weight = -1 Then $CTR_weight = 1000
	Local $gdi_dll = DllOpen("gdi32.dll")
	Local $CTR_hDC = DllCall("user32.dll", "int", "GetDC", "hwnd", $CTR_hwnd)
	Local $CTR_hMyFont = DllCall($gdi_dll, "hwnd", "CreateFont", "int", $CTR_height, "int", 0, "int", 0, "int", 0, _
			"int", $CTR_weight, "int", 0, "int", 0, "int", 0, "int", $ANSI_CHARSET, "int", $OUT_CHARACTER_PRECIS, _
			"int", $CLIP_DEFAULT_PRECIS, "int", $PROOF_QUALITY, "int", $FIXED_PITCH, "str", $CTR_font)
	Local $CTR_hOldFont = DllCall($gdi_dll, "hwnd", "SelectObject", "int", $CTR_hDC[0], "hwnd", $CTR_hMyFont[0])
	DllCall($gdi_dll, "int", "BeginPath", "int", $CTR_hDC[0])
	DllCall($gdi_dll, "int", "TextOut", "int", $CTR_hDC[0], "int", 0, "int", 0, "str", $CTR_Text, "int", StringLen($CTR_Text))
	DllCall($gdi_dll, "int", "EndPath", "int", $CTR_hDC[0])
	Local $CTR_hRgn1 = DllCall($gdi_dll, "hwnd", "PathToRegion", "int", $CTR_hDC[0])
	Local $CTR_rc = DllStructCreate("int;int;int;int")
	DllCall($gdi_dll, "int", "GetRgnBox", "hwnd", $CTR_hRgn1[0], "ptr", DllStructGetPtr($CTR_rc))
	Local $CTR_hRgn2 = DllCall($gdi_dll, "hwnd", "CreateRectRgnIndirect", "ptr", DllStructGetPtr($CTR_rc))
	DllCall($gdi_dll, "int", "CombineRgn", "hwnd", $CTR_hRgn2[0], "hwnd", $CTR_hRgn2[0], "hwnd", $CTR_hRgn1[0], "int", $RGN_XOR)
	DllCall($gdi_dll, "int", "DeleteObject", "hwnd", $CTR_hRgn1[0])
	DllCall("user32.dll", "int", "ReleaseDC", "hwnd", $CTR_hwnd, "int", $CTR_hDC[0])
	DllCall($gdi_dll, "int", "SelectObject", "int", $CTR_hDC[0], "hwnd", $CTR_hOldFont[0])
	DllClose($gdi_dll)
	Return $CTR_hRgn2[0]
EndFunc   ;==>CreateTextRgn
