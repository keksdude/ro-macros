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
HotKeySet("{F5}", "SetWindow1")

Global $WindId[10] = [0,0,0,0,0,0,0,0,0,0]
Global $mPos[10] = [0,0,0,0,0,0,0,0,0,0]
;global $cId
$exit = False
$pause = True
$bla = 1



Func SetWindow1()
		 $iid = 1
		 $WindId[1]=WinGetHandle("")
EndFunc


Func Pause()
   $pause = Not $pause
EndFunc

Func Terminate()
   $exit = True
EndFunc


local $i =0
While Not $exit
   if Not $pause Then
   For $i = 1 To 9
   	  If $WindId[$i] <> 0 Then
		 $a = MouseGetPos()
		 MouseClick("left",$a[0],$a[1])
		 Sleep(500)
		 ControlSend($WindId[$i], "", "", "{ENTER}")
		 Sleep(500)
		 ControlSend($WindId[$i], "", "", "{ENTER}")
		 Sleep(500)
		 ControlSend($WindId[$i], "", "", "{ENTER}")
		 Sleep(500)
		 ControlSend($WindId[$i], "", "", "{ENTER}")
		 Sleep(500)
		 ControlSend($WindId[$i], "", "", "{DOWN}")
		 Sleep(500)
		 ControlSend($WindId[$i], "", "", "{ENTER}")
		 Sleep(500)
		 ControlSend($WindId[$i], "", "", "{ENTER}")
		 Sleep(500)
		 ControlSend($WindId[$i], "", "", "{DOWN}")
		 Sleep(500)
		 ControlSend($WindId[$i], "", "", "{DOWN}")
		 Sleep(500)
		 ControlSend($WindId[$i], "", "", "{ENTER}")
		 Sleep(500)
		 ControlSend($WindId[$i], "", "", "{ENTER}")
		 Sleep(500)
		 ControlSend($WindId[$i], "", "", "10")
		 Sleep(500)
		 ControlSend($WindId[$i], "", "", "{ENTER}")
		 Sleep(500)
		 ControlSend($WindId[$i], "", "", "{ENTER}")
		 Sleep(500)
		 ControlSend($WindId[$i], "", "", "6")
		 Sleep(500)
		 ControlSend($WindId[$i], "", "", "{ENTER}")
		 Sleep(500)
		 ControlSend($WindId[$i], "", "", "{ENTER}")
		 Sleep(500)
		 ControlSend($WindId[$i], "", "", "{ENTER}")
		 Sleep(500)
		 ControlSend($WindId[$i], "", "", "{ENTER}")
		 Sleep(500)
	  EndIf
   Next
   EndIf
Wend