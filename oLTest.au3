#include<oL.au3>

HotKeySet("`","_Find") ;Press tilde to Find All
HotKeySet("~","_Record") ;Press Shift+tilde to Record
HotKeySet('{esc}', '_Exit')

Global $currentpixel,$xy

;_PixelShow_Virtual()

While 1
    $xy = MouseGetPos()
    $currentpixel = PixelGetColor($xy[0],$xy[1])
    ToolTip("Test Waiting")
    Sleep(100)
WEnd

Func _Find()
    $Pixel = IniRead(".\Data.ini","Main","PixelColor",0)
    $chksum = IniRead(".\Data.ini","Main","PixelCheckSum",0)
    $coord = _PixelCheckSumFindAll_Virtual($Pixel, $chksum, 5, 5, 5, 5,0,0, 1680, 1050)
    If IsArray($coord) Then
        ;_ArrayDisplay($coord)
        For $i = 1 to $coord[0][0]
            mousemove($coord[$i][0],$coord[$i][1],20)
        Next
    EndIF
EndFunc

Func _Record()
        $chksum = _PixelCheckSumRecord_Virtual($xy[0]-5, $xy[1]-5, $xy[0]+5, $xy[1]+5)
        IniWrite(".\Data.ini","Main","PixelColor",$currentpixel)
        IniWrite(".\Data.ini","Main","PixelCheckSum",$chksum)
EndFunc

Func _Exit()
    ToolTip('          '&@CRLF&'  EXITING  '&@CRLF&'          ')
    Sleep(500)
    Exit
EndFunc