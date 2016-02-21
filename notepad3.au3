#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.2
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include <Misc.au3>
HotKeySet("{F1}", "Terminate")
HotKeySet("{F4}", "Pause")


Func Pause()
   $pause = Not $pause
EndFunc


Func Terminate()
   $exit = True
EndFunc


$exit = False
$pause = True
$bla = 1

Local $hDLL = DllOpen("user32.dll")

While Not $exit
   if Not $pause Then
   if _IsPressed (20,$hDLL) Then
	  Send("2")
	  Sleep(5)
	  $aPos = MouseGetPos()
	  MouseClick("left", $aPos[0], $aPos[1]+$bla)
	  $bla=$bla*(-1)
	  Send("2")
	  Sleep(5)
   EndIf
   EndIf
Wend