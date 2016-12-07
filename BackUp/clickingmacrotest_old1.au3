Sleep(3000); allow 3 secs to activate web browser to test jump forward,x2 or jump back with x1 mouse button send click

_MouseClickPlus(ControlGetHandle("","",""), "x1") ;  WinGetHandle("")

;
; Function Name: _MouseClickPlus()
; Version added: 0.1
; Description: Sends a click to window
; minimized.
; Parameter(s): $Window = Title of the window to send click to
; $Button = "left" or "right" mouse button
; $X = X coordinate
; $Y = Y coordinate
; $Clicks = Number of clicks to send
; Remarks: You MUST be in "MouseCoordMode" 0 to use this without bugs.
; Author(s): Insolence <insolence_9@yahoo.com>
;Modified: Malkey - Added X1 an X2 Mouse buttons and other bits.
;http://www.autoitscript.com/forum/index.php?s=&showtopic=88517&view=findpost&p=636051
;===============================================================================
Func _MouseClickPlus($hwnd, $sButton = "left", $X = "", $Y = "", $Clicks = 1)
    Local $MK_LBUTTON = 0x0001
    Local $WM_LBUTTONDOWN = 0x0201
    Local $WM_LBUTTONUP = 0x0202

    Local $MK_RBUTTON = 0x0002
    Local $WM_RBUTTONDOWN = 0x0204
    Local $WM_RBUTTONUP = 0x0205

    Global $MK_XBUTTON1 = 0x00010020; 0x20
    Global $WM_XBUTTONDOWN = 0x20B;x1Button Left side of mouse - Back
    Global $WM_XBUTTONUP = 0x20C

    Global $MK_XBUTTON2 = 0x00020040;;x2Button right side of mouse - forward
    Global $WM_NCXBUTTONDOWN = 0x00AB
    Global $WM_NCXBUTTONUP = 0x00AC

    Local $WM_MOUSEMOVE = 0x0200

    Local $i = 0

    Select
        Case $sButton = "x2"
            $Button = $MK_XBUTTON2
            $ButtonDown = $WM_NCXBUTTONDOWN
            $ButtonUp = $WM_NCXBUTTONUP
        Case $sButton = "x1"
            $Button = $MK_XBUTTON1
            $ButtonDown = $WM_XBUTTONDOWN
            $ButtonUp = $WM_XBUTTONUP
        Case $sButton = "left"
            $Button = $MK_LBUTTON
            $ButtonDown = $WM_LBUTTONDOWN
            $ButtonUp = $WM_LBUTTONUP
        Case $sButton = "right"
            $Button = $MK_RBUTTON
            $ButtonDown = $WM_RBUTTONDOWN
            $ButtonUp = $WM_RBUTTONUP
    EndSelect

    If $X = "" Or $Y = "" Then
        $MouseCoord = MouseGetPos()
        $X = $MouseCoord[0]
        $Y = $MouseCoord[1]
    EndIf

    For $i = 1 To $Clicks
        DllCall("user32.dll", "int", "SendMessage", "hwnd", $hwnd, "int", $WM_MOUSEMOVE, "int", 0, "long", _MakeLong($X, $Y))

        DllCall("user32.dll", "int", "SendMessage", "hwnd", $hwnd, "int", $ButtonDown, "int", $Button, "long", _MakeLong($X, $Y))

        DllCall("user32.dll", "int", "SendMessage", "hwnd", $hwnd, "int", $ButtonUp, "int", $Button, "long", _MakeLong($X, $Y))
    Next
EndFunc  ;==>_MouseClickPlus


Func _MakeLong($LoWord, $HiWord)
    Return BitOR($HiWord * 0x10000, BitAND($LoWord, 0xFFFF))
EndFunc  ;==>_MakeLong