#include <GUIConstants.au3>
;~ Global Const $WS_POPUP                = 0x80000000
;~ Global Const $WS_EX_TOOLWINDOW            = 0x00000080
;~ Global Const $WS_EX_TOPMOST                = 0x00000008

$hwnd = GUICreate("Text Region", @DesktopWidth, @DesktopHeight, 10, 10, $WS_POPUP, BitOR($WS_EX_TOPMOST,$WS_EX_TOOLWINDOW))
GUISetBkColor(0xFF0000) ; text color

$rgn = CreateTextRgn($hwnd,"This is how you make floating text",100,"Arial",500)
SetWindowRgn($hwnd,$rgn)

GUISetState()
Sleep(3000)
GUIDelete ($hwnd)


Func SetWindowRgn($h_win, $rgn)
    DllCall("user32.dll", "long", "SetWindowRgn", "hwnd", $h_win, "long", $rgn, "int", 1)
EndFunc

;Func CombineRgn(ByRef $rgn1, ByRef $rgn2)
;    DllCall("gdi32.dll", "long", "CombineRgn", "long", $rgn1, "long", $rgn1, "long", $rgn2, "int", 2)
;EndFunc

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