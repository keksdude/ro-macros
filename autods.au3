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
Global $cHex = 0x948CA5
Global $ResX = 1680
Global $ResY = 1050
Global $wingPos = [0,0]
Global $wingColor = 0
Global $mPos[20][2] = [[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0]]
$exit = False
$pause = True
$bla = 1
Opt("PixelCoordMode", 0) ;1=absolute, 0=relative, 2=client
Opt("MouseCoordMode", 0) ;1=absolute, 0=relative, 2=client

Func Init()
		 $WindId=WinGetHandle("")
		 $wingPos = MouseGetPos()
		 Sleep(1500)
		 $wingColor = PixelGetColor($wingPos[0],$wingPos[1],$WindId)
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
				Sleep(2)
				$mPos[$t][0] = $tempPos[0]
				$mPos[$t][1] = $tempPos[1]
				$i = $tempPos[0]+40
				$t=$t+1
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
		Sleep(100)
		If PixelGetColor($wingPos[0],$wingPos[1],$WindId) <> $wingColor Then
			ControlSend($WindId, "", "", "9")
			$pause = True
		Else
			ControlSend($WindId, "", "", "5")
			Sleep(300)
		EndIf

	Wend
Wend