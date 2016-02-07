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

HotKeySet("{SPACE}", "SpaceSkill")


;Desets
HotKeySet("^{F5}", "DeSet1")
HotKeySet("^{F6}", "DeSet2")

;Keys to press ; qe = use e only when q goesnt work (ex. use bragi than encore only); qq = to reduce input problems and moving wizzards^^
Global $Key1 = "m"  ;devo key
Global $Key2 = "4" ;pneuma key

;Bools if set or not
Global $b1set = False
Global $b2set = False

Global $castingdevo = False

;Spam cooldowns in ms
Global $i1cd = 10000
Global $i2cd = 10000

Global $pausezwischenskillundclick = 30

;Variables to calc time differences
Global $lastused1
Global $lastused2

;Window ID's
Global $WinID1 = 0
Global $WinID2 = 0

;Saved mouse position for click spam
Global $mousePosition1
Global $mousePosition2

Global $exit = False
Global $pause = True

Opt("PixelCoordMode", 0) ;1=absolute, 0=relative, 2=client
Opt("MouseCoordMode", 0) ;1=absolute, 0=relative, 2=client

;Text init
Global $hwnd = GUICreate("Text Region", @DesktopWidth, @DesktopHeight, 10, 10, $WS_POPUP, BitOR($WS_EX_TOPMOST,$WS_EX_TOOLWINDOW))
GUISetBkColor(0xFF0000) ; text color
UpdateText()

Func Set1()
		 $WinID1 = WinGetHandle("")
		Global $mousePosition1 = MouseGetPos()
		Global $b1set = True
		UpdateText()
EndFunc

Func DeSet1()
		 Global $b1set = False
		 UpdateText()
EndFunc

Func Set2()
		 $WinID2 = WinGetHandle("")
		Global $mousePosition2 = MouseGetPos()
		Global $b2set = True
		UpdateText()
EndFunc

Func DeSet2()
		 Global $b2set = False
		 UpdateText()
EndFunc

Func SpaceSkill()
	If Not $pause Then
		If $WinID1 <> 0 And $WinID2 <> 0 And $b1set Then
			$castingdevo = true;
			WinActivate($WinID1)
			Sleep(1000)
			ControlSend($WinID1, "", "", "$Key1")
			Sleep($pausezwischenskillundclick)
			MouseClick("left", $mousePosition1[0], $mousePosition1[1], 1, 1)
			Sleep(2500)
			WinActivate($WinID2)
			Sleep(1000)
			$castingdevo = false;
		EndIf
	Else
		ControlSend("", "", "", "{SPACE}")
	EndIf
EndFunc   ;==>DEVODUDE

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
		If $b2Set And Not $castingdevo Then
			$now = TimerInit()
			$timediff = TimerDiff($lastused2)
			If $timediff > $i2cd Then
				ControlSend($WinID2, "", "", $Key2)
				Sleep($pausezwischenskillundclick)
				MouseClick("left",$mousePosition2[0],$mousePosition2[1])
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