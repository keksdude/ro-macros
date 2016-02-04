#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.2
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

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
HotKeySet("{F3}", "SetPartyWindowPos")
HotKeySet("{F4}", "Pause")
HotKeySet("{F5}", "SetWindow1")
HotKeySet("{F6}", "SetWindow2")
HotKeySet("{F7}", "SetWindow3")
HotKeySet("{F8}", "SetWindow4")

Global $WindId[10] = [0,0,0,0,0,0,0,0,0,0]
Global $mPos[10] = [0,0,0,0,0,0,0,0,0,0]
Global $colors[15]

Global $party_y[8] = [64,88,63,65,66,67,68,69]
Global $hp_x[2] = [27,84]
Global $party_size = 2

;getting party window start pos with mouse
Global $party_pos_set = False
Global $mouse_pos
Global $party_mouse_pos[2] = [29,64]
Global $party_y_dif = 22
Global $party_hp_length = 59
Global $party_size = 1
Global $hp_array[15]
Opt("PixelCoordMode", 0)
Opt("MouseCoordMode", 0)

Func SetPartyWindowPos()
	$party_pos_set = True
EndFunc

Global $hwnd

;global $cId
$exit = False
$pause = True
$bla = 1

local $i =0
local $randtemp = 0

$hwnd = GUICreate("Text Region", @DesktopWidth, @DesktopHeight, 10, 10, $WS_POPUP, BitOR($WS_EX_TOPMOST,$WS_EX_TOOLWINDOW))
GUISetBkColor(0xFF0000) ; text color

While Not $exit
	if Not $pause And $party_pos_set Then
		local $output_string = ""


		For $i = 0 To $party_size -1
			$last_green_j = 0;
			For $j = 0 To $party_hp_length
				$output_string = $output_string & "(" & $party_mouse_pos[0]+$j & "," & $party_mouse_pos[1] + $i & "), "
				$color = PixelGetColor($party_mouse_pos[0]+$j, $party_mouse_pos[1] + $i * $party_y_dif, $WindId[1])
				$output_string = $output_string & $color & ", " & Hex($color,6) & ", "
				If $color = 1109793 Then
					$last_green_j = $j

				Else
					ExitLoop
				EndIf
			Next

			$hp_array[$i] = $last_green_j

			$output_string = $output_string & "(" &$i & "/" & $last_green_j & "), "
		Next

		$rgn = CreateTextRgn($hwnd,$output_string,30,"Arial",500)
		SetWindowRgn($hwnd,$rgn)
		GUISetState()

		;$output_string = $output_string &

		;$output_string = $output_string & "(" & $party_mouse_pos[0] & "/"& $party_mouse_pos[1] & ") #"
		;$color_at_mouse_pos = Hex(PixelGetColor($party_mouse_pos[0], $party_mouse_pos[1], $WindId[1]), 6)
		;$output_string = $output_string & $colors[$i] & ", "

		;local $output_string = ""
		;$a = MouseGetPos()
 ;		$output_string = $output_string & "(" & $a[0] & "/"& $a[1] & ") #"
; 		For $i = 0 To 1
; 			If $WindId[1] <> 0 Then
; 				$colors[$i] = Hex(PixelGetColor($a[0]+$i, $a[1], $WindId[1]), 6)   ;Hex(PixelGetColor($x_start, $y_start+$i, $WindId[1]), 6)
; 				$output_string = $output_string & $colors[$i] & ", "
; 			EndIf
; 		Next
;
; 		$rgn = CreateTextRgn($hwnd,$output_string,30,"Arial",500)
; 		SetWindowRgn($hwnd,$rgn)
; 		GUISetState()


		; Calculated the number of seconds since EPOCH (1970/01/01 00:00:00)
		;Local $iDateCalc = _DateDiff('s', "1970/01/01 00:00:00", _NowCalc())
		;MsgBox($MB_SYSTEMMODAL, "", "Number of seconds since EPOCH: " & $iDateCalc)

	ElseIf $pause And Not $party_pos_set And $WindId[1] <> 0 Then
		local $output_string = ""
		$mouse_pos = MouseGetPos()
		$output_string = $output_string & "(" & $mouse_pos[0] & "/"& $mouse_pos[1] & ") #"
		$color_at_mouse_pos = Hex(PixelGetColor($mouse_pos[0], $mouse_pos[1], $WindId[1]), 6)
		$output_string = $output_string & $color_at_mouse_pos & ", "
		$color_at_mouse_pos = Hex(PixelGetColor($mouse_pos[0]+1, $mouse_pos[1], $WindId[1]), 6)
		$output_string = $output_string & $color_at_mouse_pos & ", "
		$rgn = CreateTextRgn($hwnd,$output_string,30,"Arial",500)
		SetWindowRgn($hwnd,$rgn)
		GUISetState()
	EndIf
	Sleep(200)
Wend
GUIDelete ($hwnd)

Func SetWindow1()
		 $iid = 1
		 $WindId[1]=WinGetHandle("")
EndFunc

Func SetWindow2()
		 $iid = 2
		 $WindId[2]=WinGetHandle("")
EndFunc

Func SetWindow3()
		 $iid = 3
		 $WindId[3]=WinGetHandle("")
EndFunc

Func SetWindow4()
		 $iid = 4
		 $WindId[4]=WinGetHandle("")
EndFunc

Func Pause()
   $pause = Not $pause
EndFunc

Func Terminate()
   $exit = True
EndFunc

Func SetWindowRgn($h_win, $rgn)
    DllCall("user32.dll", "long", "SetWindowRgn", "hwnd", $h_win, "long", $rgn, "int", 1)
EndFunc

Func CreateTextRgn(ByRef $CTR_hwnd,$CTR_Text,$CTR_height,$CTR_font="Microsoft Sans Serif",$CTR_weight=1000)
    Local Const $ANSI_CHARSET = 0
    Local Const $OUT_CHARACTER_PRECIS = 2
    Local Const $CLIP_DEFAULT_PRECIS = 0
    Local Const $PROOF_QUALITY = 2
    Local Const $FIXED_PITCH = 1
    Local Const $RGN_XOR = 3

    If $CTR_font = "" Then $CTR_font = "Microsoft Sans Serif"
    If $CTR_weight = -1 Then $CTR_weight = 1000
    Local $gdi_dll = DLLOpen("gdi32.dll")
    Local $CTR_hDC= DLLCall("user32.dll","int","GetDC","hwnd",$CTR_hwnd)
    Local $CTR_hMyFont = DLLCall($gdi_dll,"hwnd","CreateFont","int",$CTR_height,"int",0,"int",0,"int",0, _
                "int",$CTR_weight,"int",0,"int",0,"int",0,"int",$ANSI_CHARSET,"int",$OUT_CHARACTER_PRECIS, _
                "int",$CLIP_DEFAULT_PRECIS,"int",$PROOF_QUALITY,"int",$FIXED_PITCH,"str",$CTR_font )
    Local $CTR_hOldFont = DLLCall($gdi_dll,"hwnd","SelectObject","int",$CTR_hDC[0],"hwnd",$CTR_hMyFont[0])
    DLLCall($gdi_dll,"int","BeginPath","int",$CTR_hDC[0])
    DLLCall($gdi_dll,"int","TextOut","int",$CTR_hDC[0],"int",0,"int",0,"str",$CTR_Text,"int",StringLen($CTR_Text))
    DLLCall($gdi_dll,"int","EndPath","int",$CTR_hDC[0])
    Local $CTR_hRgn1 = DLLCall($gdi_dll,"hwnd","PathToRegion","int",$CTR_hDC[0])
    Local $CTR_rc = DLLStructCreate("int;int;int;int")
    DLLCall($gdi_dll,"int","GetRgnBox","hwnd",$CTR_hRgn1[0],"ptr",DllStructGetPtr($CTR_rc))
    Local $CTR_hRgn2 = DLLCall($gdi_dll,"hwnd","CreateRectRgnIndirect","ptr",DllStructGetPtr($CTR_rc))
    DLLCall($gdi_dll,"int","CombineRgn","hwnd",$CTR_hRgn2[0],"hwnd",$CTR_hRgn2[0],"hwnd",$CTR_hRgn1[0],"int",$RGN_XOR)
    DLLCall($gdi_dll,"int","DeleteObject","hwnd",$CTR_hRgn1[0])
    DLLCall("user32.dll","int","ReleaseDC","hwnd",$CTR_hwnd,"int",$CTR_hDC[0])
    DLLCall($gdi_dll,"int","SelectObject","int",$CTR_hDC[0],"hwnd",$CTR_hOldFont[0])
    DLLClose($gdi_dll)
    Return $CTR_hRgn2[0]
EndFunc