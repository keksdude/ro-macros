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
#include <Date.au3>
HotKeySet("{F1}", "Terminate")
HotKeySet("{F4}", "Pause")
HotKeySet("{F5}", "SetWindow1")
HotKeySet("{F6}", "SetWindow2")
HotKeySet("{F7}", "SetWindow3")
HotKeySet("{F8}", "SetWindow4")

Global $WindId[10] = [0,0,0,0,0,0,0,0,0,0]
Global $mPos[10] = [0,0,0,0,0,0,0,0,0,0]
;global $cId
$exit = False
$pause = True
$bla = 1



; sp song, asp sond, tkm eine taste 58s, 2 crea 1click mit mouse,

Func SetWindow1()
		 $iid = 1
		 $WindId[1]=WinGetHandle("")
EndFunc

Func SetWindow2()
		 $iid = 2
		 $WindId[2]=WinGetHandle("")
EndFunc

Func SetWindow3()
		 $iid = 3
		 $WindId[3]=WinGetHandle("")
EndFunc

Func SetWindow4()
		 $iid = 4
		 $WindId[4]=WinGetHandle("")
EndFunc

Func Pause()
   $pause = Not $pause
EndFunc

Func Terminate()
   $exit = True
EndFunc

local $sleepsum = 0
local $i =0
local $randtemp = 0
While Not $exit
	if Not $pause Then
	For $i = 1 To 9

		;First song
		If $WindId[$i] <> 0 And $i = 1 Then
			ControlSend($WindId[$i], "", "", "qe")
		EndIf

		;Second song
		If $WindId[$i] <> 0 And $i = 2 Then
			ControlSend($WindId[$i], "", "", "qe")
		EndIf

		;tkm
		If $WindId[$i] <> 0 And $i = 3 And $sleepsum < 201 Then
			ControlSend($WindId[$i], "", "", "q")
			$sleepsum += 25000
		EndIf

	  	;first mushroom maker
		If $WindId[$i] <> 0 And $i = 4 Then
			ControlSend($WindId[$i], "", "", "q")
			Sleep(30)
			$a = MouseGetPos()
			MouseClick("left",$a[0],$a[1])
		EndIf

	  ;$randtemp = 10+Random(1,200,1)
	  ;$sleepsum+= $randtemp;
	  ;Sleep($randtemp)
   Next
   EndIf
   $sleepsum -= 200
   Sleep(200)
Wend