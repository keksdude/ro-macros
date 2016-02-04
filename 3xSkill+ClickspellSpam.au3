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

;One button sets
HotKeySet("{F5}", "Set1")
HotKeySet("{F6}", "Set2")
HotKeySet("{F7}", "Set3")
;One button + click set
HotKeySet("{F8}", "Set4")

;Desets
HotKeySet("^{F5}", "DeSet1")
HotKeySet("^{F6}", "DeSet2")
HotKeySet("^{F7}", "DeSet3")
HotKeySet("^{F8}", "DeSet4")

;Keys to press ; qe = use e only when q goesnt work (ex. use bragi than encore only); qq = to reduce input problems and moving wizzards^^
Global $Key1 = "qe"
Global $Key2 = "qe"
Global $Key3 = "q"
Global $Key4 = "qq"

;Bools if set or not
Global $b1set = False
Global $b2set = False
Global $b3set = False
Global $b4set = False

;Spam cooldowns in ms
Global $i1cd = 4000
Global $i2cd = 1500
Global $i3cd = 1500
Global $i4cd = 50

;Variables to calc time differences
Global $lastused1
Global $lastused2
Global $lastused3
Global $lastused4

;Window ID's
Global $WinID1 = 0
Global $WinID2 = 0
Global $WinID3 = 0
Global $WinID4 = 0

;Saved mouse position for click spam
Global $mousePosition

Global $exit = False
Global $pause = True

Opt("PixelCoordMode", 0) ;1=absolute, 0=relative, 2=client
Opt("MouseCoordMode", 0) ;1=absolute, 0=relative, 2=client

;Text init
Global $hwnd = GUICreate("Text Region", @DesktopWidth, @DesktopHeight, 10, 10, $WS_POPUP, BitOR($WS_EX_TOPMOST,$WS_EX_TOOLWINDOW))
GUISetBkColor(0xFF0000) ; text color
UpdateText()

Func Set1()
         $WinID1=WinGetHandle("")
		 Global $b1set = True
		 UpdateText()
EndFunc

Func DeSet1()
		 Global $b1set = False
		 UpdateText()
EndFunc

Func Set2()
         $WinID2=WinGetHandle("")
		 Global $b2set = True
		 UpdateText()
EndFunc

Func DeSet2()
		 Global $b2set = False
		 UpdateText()
EndFunc

Func Set3()
         $WinID3=WinGetHandle("")
		 Global $b3set = True
		 UpdateText()
EndFunc

Func DeSet3()
		 Global $b3set = False
		 UpdateText()
EndFunc

Func Set4()
         $WinID4=WinGetHandle("")
		 Global $mousePosition = MouseGetPos()
		 Global $b4set = True
		 UpdateText()
EndFunc

Func DeSet4()
		 Global $b4set = False
		 UpdateText()
EndFunc

Func Pause()
   $pause = Not $pause
   UpdateText()
EndFunc

Func Terminate()
	GUIDelete ($hwnd)
   $exit = True
EndFunc


While Not $exit
   if Not $pause Then
		If $b1Set Then
			$now = TimerInit()
			$timediff = TimerDiff($lastused1)
			If $timediff > $i1cd Then
				ControlSend($WinID1, "", "", $Key1)
				$lastused1 = TimerInit();
			EndIf
		EndIf

		If $b2Set Then
			$now = TimerInit()
			$timediff = TimerDiff($lastused2)
			If $timediff > $i2cd Then
				ControlSend($WinID2, "", "", $Key2)
				$lastused2 = TimerInit();
			EndIf
		EndIf

		If $b3Set Then
			$now = TimerInit()
			$timediff = TimerDiff($lastused3)
			If $timediff > $i3cd Then
				ControlSend($WinID3, "", "", $Key3)
				$lastused3 = TimerInit();
			EndIf
		EndIf

		If $b4Set Then
			$now = TimerInit()
			$timediff = TimerDiff($lastused4)
			If $timediff > $i4cd Then
				ControlSend($WinID4, "", "", $Key4)
				$lastused4 = TimerInit();
			EndIf
		EndIf
   EndIf
Wend

Func UpdateText()
   Global $text = "Macro "
   If $pause Then
		$text = $text & "off, "
   Else
		$text = $text & "on, "
   EndIf

   If $b1set Then
		$text = $text & "F5 on, "
   Else
		$text = $text & "F5 off, "
   EndIf

   If $b2set Then
		$text = $text & "F6 on, "
   Else
		$text = $text & "F6 off, "
   EndIf

   If $b3set Then
		$text = $text & "F7 on, "
   Else
		$text = $text & "F7 off, "
   EndIf

   If $b4set Then
		$text = $text & "F8 on, "
   Else
		$text = $text & "F8 off, "
   EndIf

   $rgn = CreateTextRgn($hwnd,$text,20,"Arial",500)
   SetWindowRgn($hwnd,$rgn)
   GUISetState()
EndFunc

; Calculated the number of seconds since EPOCH (1970/01/01 00:00:00)
		;Local $iDateCalc = _DateDiff('s', "1970/01/01 00:00:00", _NowCalc())
		;MsgBox($MB_SYSTEMMODAL, "", "Number of seconds since EPOCH: " & $iDateCalc)

;Text on Screen Stuff
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