#include <Misc.au3>
#include <MsgBoxConstants.au3>
#include <AutoItConstants.au3>
#include <Date.au3>

HotKeySet("{F5}", "Set1")
Global $WinID1 = 0
Global $on = true

Opt("PixelCoordMode", 0) ;1=absolute, 0=relative, 2=client
Opt("MouseCoordMode", 0) ;1=absolute, 0=relative, 2=client

while $on

	Sleep(500)

WEnd

Func Set1()
         $WinID1=WinGetHandle("")
		 Local $aCoord[2] = [0,0]
		 Local $iColor = PixelGetColor(937, 159,$WinID1)
		 ;$aCoord = PixelSearch(0, 0, 1000, 1000, 0xffffff,0,1,$WinID1)
		 $aCoord = PixelSearch(0, 0, 1400, 500, 0x24bd24,30,1,$WinID1)
		 Sleep(1000)
		 ConsoleWrite($aCoord[0] & "," &$aCoord[1] & "," &$iColor & "," & Hex($iColor, 6) )
		 $on = false
EndFunc