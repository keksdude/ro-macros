#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.2
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include <Misc.au3>
#include <MsgBoxConstants.au3>
#include <AutoItConstants.au3>
HotKeySet("{F1}", "Terminate")
HotKeySet("{F4}", "Pause")
HotKeySet("{F5}", "Init")
HotkeySet("{F3}", "SearchTarget")



Global $WindId = 0
Global $cHex = 0x5D3C46
Global $ResX = 1680
Global $ResY = 1050
Global $mPos[20][2] = [[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0]]
$exit = False
$pause = True
$bla = 1
Opt("PixelCoordMode", 0) ;1=absolute, 0=relative, 2=client
Opt("MouseCoordMode", 0) ;1=absolute, 0=relative, 2=client

Func Init()
		 $WindId=WinGetHandle("")
EndFunc

Func SearchTarget()
	If Not @error Then
		Return $mPos
	Else
		Return False
	EndIf

EndFunc

Func Pause()
   $pause = Not $pause
EndFunc

Func Terminate()
   $exit = True
EndFunc


While Not $exit
	While Not $pause
		$i=1
		$t=0
		$cancel = False
		While $i < ($ResX-80) And Not $cancel
			$tempPos = PixelSearch($i,1,$ResX,$ResY,$cHex)
			If Not @error Then
				$mPos[$t][0] = $tempPos[0]
				$mPos[$t][1] = $tempPos[1]
				$i = $tempPos[0]+70
				$t=$t+1
				Sleep(2)
			Else
				$cancel = True
			EndIf
		Wend

		$i = 0
		While $i < $t
					ControlSend($WindId, "", "", "2")
					Sleep(50)
					MouseClick("left", $mPos[$i][0], $mPos[$i][1],1,2)
					Sleep(300)
					$i=$i+1
		Wend
		Sleep(200)
		ControlSend($WindId, "", "", "5")
		Sleep(150)
	Wend
Wend