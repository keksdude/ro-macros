; Script Start - Add your code below here
#include <GUIConstants.au3>
;~ Global Const $WS_POPUP                = 0x80000000
;~ Global Const $WS_EX_TOOLWINDOW            = 0x00000080
;~ Global Const $WS_EX_TOPMOST                = 0x00000008

#include <Misc.au3>
#include <MsgBoxConstants.au3>
#include <AutoItConstants.au3>
#include <Date.au3>
#include <GUIConstantsEx.au3>

HotKeySet("{F1}", "CloseButton")
HotKeySet("{PAUSE}", "Pause")

HotKeySet("{F5}", "F5Pressed")
HotKeySet("{F6}", "F6Pressed")
HotKeySet("{F7}", "F7Pressed")
HotKeySet("{F8}", "F8Pressed")

;Keys to press ; qe = use e only when q goesnt work (ex. use bragi than encore only); qq = to reduce input problems and moving wizzards^^
Global $Key1 = "qe"
Global $Key2 = "qe"
Global $Key3 = "qe"
Global $Key4 = "m"
Global $KeyAutoguard = "m"
Global $KeyDevo = "b"
Global $KeyManual = "{SPACE}"

;Spam cooldowns in ms
Global $i1cd = 2000
Global $i2cd = 2000
Global $i3cd = 20000
Global $i4cd = 5000
Global $itargetcd = 1500
Global $iautoguardcd = 290000

Global $bautoguard = true

;Bools if set or not
Global $b1set = False
Global $b2set = False
Global $b3set = False
Global $b4set = False

Global $ihpmin1 = 90
Global $ihpmin2 = 90
Global $ihpmin3 = 90
Global $ihpmin4 = 90

Global $ihpmax1 = 100
Global $ihpmax2 = 100
Global $ihpmax3 = 100
Global $ihpmax4 = 100

Global $ispmin1 = 90
Global $ispmin2 = 90
Global $ispmin3 = 90
Global $ispmin4 = 90

Global $ispmax1 = 100
Global $ispmax2 = 100
Global $ispmax3 = 100
Global $ispmax4 = 100

Global $bhpheal1 = False
Global $bhpheal2 = False
Global $bhpheal3 = False
Global $bhpheal4 = False

Global $bspheal1 = False
Global $bspheal2 = False
Global $bspheal3 = False
Global $bspheal4 = False

Global $pausezwischenskillundclick = 5

;Variables to calc time differences
Global $lastused1
Global $lastused2
Global $lastused3
Global $lastused4
Global $lastusedautoguard = 1500
Global $iautoguardcd = 290000

Global $lasthpsp1
Global $lasthpsp2
Global $lasthpsp3
Global $lasthpsp4

Global $ihpspcd1 = 200
Global $ihpspcd2 = 200
Global $ihpspcd3 = 200
Global $ihpspcd4 = 200

;Window ID's
Global $WinID1 = 0
Global $WinID2 = 0
Global $WinID3 = 0
Global $WinID4 = 0

Global $ProcessID1 = 0
Global $ProcessID2 = 0
Global $ProcessID3 = 0
Global $ProcessID4 = 0

;Saved mouse position for click spam
Global $mousePosition

Global $exit = False
Global $pause = True


Opt("PixelCoordMode", 0) ;1=absolute, 0=relative, 2=client
Opt("MouseCoordMode", 0) ;1=absolute, 0=relative, 2=client
Opt("GUIOnEventMode", 1) ; Change to OnEvent mode

Local $hMainGUI = GUICreate("op macro", 200, 180,0,0)
GUISetOnEvent($GUI_EVENT_CLOSE, "CloseButton")
Local $pauseButton = GUICtrlCreateButton("paused", 10, 7, 180, 20)

Local $lF5 = GUICtrlCreateLabel("F5",12, 35, 16, 20)
Local $tbKey1 = GUICtrlCreateInput($Key1,28, 32, 30, 17)
Local $tbCD1 = GUICtrlCreateInput($i1cd,60, 32, 40, 17)
GUICtrlCreateLabel("hp",103, 35, 15, 20)
Local $tbHP1 = GUICtrlCreateInput($ihpmin1, 117, 32, 20, 17)
GUICtrlCreateLabel("sp",140, 35, 15, 20)
Local $tbSP1 = GUICtrlCreateInput($ispmin1, 154, 32, 20, 17)

Local $lF6 = GUICtrlCreateLabel("F6",12, 55, 16, 20)
Local $tbKey2 = GUICtrlCreateInput($Key2,28, 52, 30, 17)
Local $tbCD2 = GUICtrlCreateInput($i2cd,60, 52, 40, 17)
GUICtrlCreateLabel("hp",103, 55, 15, 20)
Local $tbHP2 = GUICtrlCreateInput($ihpmin2, 117, 52, 20, 17)
GUICtrlCreateLabel("sp",140, 55, 15, 20)
Local $tbSP2 = GUICtrlCreateInput($ispmin2, 154, 52, 20, 17)

Local $lF7 = GUICtrlCreateLabel("F7",12, 75, 16, 20)
Local $tbKey3 = GUICtrlCreateInput($Key3,28, 72, 30, 17)
Local $tbCD3 = GUICtrlCreateInput($i3cd,60, 72, 40, 17)
GUICtrlCreateLabel("hp",103, 75, 15, 20)
Local $tbHP3 = GUICtrlCreateInput($ihpmin3, 117, 72, 20, 17)
GUICtrlCreateLabel("sp",140, 75, 15, 20)
Local $tbSP3 = GUICtrlCreateInput($ispmin3, 154, 72, 20, 17)

Local $lF8 = GUICtrlCreateLabel("F8",12, 95, 16, 20)
Local $tbKey4 = GUICtrlCreateInput($Key4,28, 92, 30, 17)
Local $tbCD4 = GUICtrlCreateInput($ihpmin4,60, 92, 40, 17)
GUICtrlCreateLabel("hp",103, 95, 15, 20)
Local $tbHP4 = GUICtrlCreateInput($ihpmin4, 117, 92, 20, 17)
GUICtrlCreateLabel("sp",140, 95, 15, 20)
Local $tbSP4 = GUICtrlCreateInput($ispmin4, 154, 92, 20, 17)

GUICtrlCreateLabel("target:",12, 115, 40, 20)
Local $iTargets = GUICtrlCreateLabel("0",47, 115, 8, 20)
Local $tbDevoKey = GUICtrlCreateInput($KeyDevo, 58, 112, 20, 17)
Local $tbCDtarget = GUICtrlCreateInput($itargetcd, 80, 112, 40, 17)

GUICtrlCreateLabel("guard:",12, 135, 55, 20)
Local $tbautoguardbutton = GUICtrlCreateInput($KeyAutoguard, 58, 132, 20, 17)
Local $tbautoguardcd = GUICtrlCreateInput($iautoguardcd, 80, 132, 50, 17)
Local $ckautoguard = GUICtrlCreateCheckbox("",  137, 132, 50, 17)

GUICtrlCreateLabel("manual:",12, 155, 55, 20)
Local $tbmanualbutton = GUICtrlCreateInput($KeyManual, 58, 152, 50, 17)

GUISetState()

While Not $exit
	If Not $pause Then
		If $b1set Then
			$now = TimerInit()
			$timediff = TimerDiff($lasthpsp1)
			If $timediff > $ihpspcd1 Then
				$ihpmin1 = String(GUICtrlRead($tbHP1))
				$ispmin1 = String(GUICtrlRead($tbSP1))
				;$ihpmax1 = String(GUICtrlRead($tbSP1))
				;$ihpmax1 = String(GUICtrlRead($tbSP1))

				If $ihpmax1 > $ihpmin1 And $ihpmin1 <> 0 And $ihpmax1 <> 0 Then
					$hp = _MemoryRead(0xCA2118, $ProcessID1)
					$currenthp = _MemoryRead(0xCA2114, $ProcessID1)

					Local $procenthp = $currenthp / $hp * 100

					If  Not $bhpheal1 And $procenthp  < $ihpmin1 And $procenthp > 1 Then
						$bhpheal1 = true
					EndIf

					If $bhpheal1 And $procenthp < $ihpmax1 Then
						ControlSend($WinID1, "", "", $HPKey)
						$lasthpsp1 = TimerInit()
					EndIf

					If $bhpheal1 And $procenthp >= $ihpmax1 Then
						$bhpheal1 = false
					EndIf
				ElseIf Not $bhpheal1 And $ispmax1 > $ispmin1 And $ispmin1 <> 0 And $ispmax1 <> 0 Then
					$sp = _MemoryRead(0xCA2120, $ProcessID1)
					$currentsp = _MemoryRead(0xCA211C, $ProcessID1)

					Local $procentsp = $currentsp / $sp * 100

					If  Not $bspheal1 And $procentsp  < $ispmin1 And $procentsp > 1 Then
						$bspheal1 = true
					EndIf

					If $bspheal1 And $procentsp < $ispmax1 Then
						ControlSend($WinID1, "", "", $SPKey)
						$lasthpsp1 = TimerInit()
					EndIf

					If $bspheal1 And $procentsp >= $ispmax1 Then
						$bspheal1 = false
					EndIf
				EndIf
			EndIf

			$now = TimerInit()
			$timediff = TimerDiff($lastused1)
			If $timediff > $i1cd Then
				$Key1 = String(GuiCtrlRead($tbKey1))
				$i1cd = String(GuiCtrlRead($tbCD1))
				If $Key1 <> "" And $ilcd > 0 Then
					ControlSend($WinID1, "", "", $Key1)
					$lastused1 = TimerInit();
				EndIf
			EndIf
		EndIf

		If $b2set Then
			$now = TimerInit()
			$timediff = TimerDiff($lasthpsp2)
			If $timediff > $ihpspcd2 Then
				$ihpmin2 = String(GUICtrlRead($tbHP2))
				$ispmin2 = String(GUICtrlRead($tbSP2))
				;$ihpmax1 = String(GUICtrlRead($tbSP1))
				;$ihpmax1 = String(GUICtrlRead($tbSP1))

				If $ihpmax2 > $ihpmin2 And $ihpmin2 <> 0 And $ihpmax2 <> 0 Then
					$hp = _MemoryRead(0xCA2118, $ProcessID2)
					$currenthp = _MemoryRead(0xCA2114, $ProcessID2)

					Local $procenthp = $currenthp / $hp * 100

					If  Not $bhpheal2 And $procenthp  < $ihpmin2 And $procenthp > 1 Then
						$bhpheal2 = true
					EndIf

					If $bhpheal2 And $procenthp < $ihpmax2 Then
						ControlSend($WinID2, "", "", $HPKey)
						$lasthpsp2 = TimerInit()
					EndIf

					If $bhpheal1 And $procenthp >= $ihpmax2 Then
						$bhpheal1 = false
					EndIf
				ElseIf Not $bhpheal1 And $ispmax2 > $ispmin2 And $ispmin2 <> 0 And $ispmax <> 0 Then
					$sp = _MemoryRead(0xCA2120, $ProcessID2)
					$currentsp = _MemoryRead(0xCA211C, $ProcessID2)

					Local $procentsp = $currentsp / $sp * 100

					If  Not $bspheal2 And $procentsp  < $ispmin2 And $procentsp > 1 Then
						$bspheal2 = true
					EndIf

					If $bspheal2 And $procentsp < $ispmax2 Then
						ControlSend($WinID2, "", "", $SPKey)
						$lasthpsp2 = TimerInit()
					EndIf

					If $bspheal2 And $procentsp >= $ispmax2 Then
						$bspheal2 = false
					EndIf
				EndIf
			EndIf

			$now = TimerInit()
			$timediff = TimerDiff($lastused2)
			If $timediff > $i2cd Then
				$Key2 = String(GuiCtrlRead($tbKey2))
				$i2cd = String(GuiCtrlRead($tbCD2))
				If $Key2 <> "" And $i2cd > 0 Then
					ControlSend($WinID2, "", "", $Key2)
					$lastused2 = TimerInit();
				EndIf
			EndIf
		EndIf

		If $b3set Then
			$now = TimerInit()
			$timediff = TimerDiff($lasthpsp3)
			If $timediff > $ihpspcd3 Then
				$ihpmin2 = String(GUICtrlRead($tbHP2))
				$ispmin2 = String(GUICtrlRead($tbSP2))
				;$ihpmax1 = String(GUICtrlRead($tbSP1))
				;$ihpmax1 = String(GUICtrlRead($tbSP1))

				If $ihpmax2 > $ihpmin2 And $ihpmin2 <> 0 And $ihpmax2 <> 0 Then
					$hp = _MemoryRead(0xCA2118, $ProcessID2)
					$currenthp = _MemoryRead(0xCA2114, $ProcessID2)

					Local $procenthp = $currenthp / $hp * 100

					If  Not $bhpheal2 And $procenthp  < $ihpmin2 And $procenthp > 1 Then
						$bhpheal2 = true
					EndIf

					If $bhpheal2 And $procenthp < $ihpmax2 Then
						ControlSend($WinID2, "", "", $HPKey)
						$lasthpsp2 = TimerInit()
					EndIf

					If $bhpheal1 And $procenthp >= $ihpmax2 Then
						$bhpheal1 = false
					EndIf
				ElseIf Not $bhpheal1 And $ispmax2 > $ispmin2 And $ispmin2 <> 0 And $ispmax <> 0 Then
					$sp = _MemoryRead(0xCA2120, $ProcessID2)
					$currentsp = _MemoryRead(0xCA211C, $ProcessID2)

					Local $procentsp = $currentsp / $sp * 100

					If  Not $bspheal2 And $procentsp  < $ispmin2 And $procentsp > 1 Then
						$bspheal2 = true
					EndIf

					If $bspheal2 And $procentsp < $ispmax2 Then
						ControlSend($WinID2, "", "", $SPKey)
						$lasthpsp2 = TimerInit()
					EndIf

					If $bspheal2 And $procentsp >= $ispmax2 Then
						$bspheal2 = false
					EndIf
				EndIf
			EndIf

			$now = TimerInit()
			$timediff = TimerDiff($lastused2)
			If $timediff > $i2cd Then
				$Key2 = String(GuiCtrlRead($tbKey2))
				$i2cd = String(GuiCtrlRead($tbCD2))
				If $Key2 <> "" And $i2cd > 0 Then
					ControlSend($WinID2, "", "", $Key2)
					$lastused2 = TimerInit();
				EndIf
			EndIf
		EndIf
	EndIf
WEnd

Func F5Pressed()
	$b1set = true
	$ProcessID1 = WinGetProcess("")
	$WinID1 = WinGetHandle("")
	GUICtrlSetColor($lF5, 0x08A60B)

EndFunc

Func F6Pressed()
	$b2set = true
	$ProcessID2 = WinGetProcess("")
	$WinID2 = WinGetHandle("")
	GUICtrlSetColor($lF6, 0x08A60B)

EndFunc

Func F7Pressed()
	$b3set = true
	$ProcessID3 = WinGetProcess("")
	$WinID3 = WinGetHandle("")
	GUICtrlSetColor($lF7, 0x08A60B)

EndFunc

Func F8Pressed()
	$b4set = true
	$ProcessID4 = WinGetProcess("")
	$WinID4 = WinGetHandle("")
	GUICtrlSetColor($lF8, 0x08A60B)

EndFunc


Func HpRadio()
	;$bHpRadioOn = GUICtrlGetState($hpRadioOn)
;~ 	If $bHpRadioOn Then
;~ 		$bAutopotHpOn = True
;~ 	Else
;~ 		$bAutopotHpOn = False
;~ 	EndIf
EndFunc

Func SpRadio()
	;$bSpRadioOn = GUICtrlGetState($spRadioOn)
;~ 	If $bSpRadioOn Then
;~ 		$bAutopotSpOn = True
;~ 	Else
;~ 		$bAutopotSpOn = False
;~ 	EndIf
EndFunc

Func ToggleHPMode()
	;If $iAutopotHpMode = 100 Then
		;$iAutopotHpMode = 10
		;GUICtrlSetData($buttonHPModeToggle,"10%")
	;Else
		;$iAutopotHpMode = 100
		;GUICtrlSetData($buttonHPModeToggle,"100%")
	;EndIf
EndFunc

Func ToggleSPMode()
	;If $iAutopotSpMode = 100 Then
		;$iAutopotSpMode = 10
		;GUICtrlSetData($buttonSPModeToggle,"10%")
	;Else
		;$iAutopotSpMode = 100
		;GUICtrlSetData($buttonSPModeToggle,"100%")
	;EndIf
EndFunc


;~ GuiCtrlCreateGroup("one button macros", 10, 190, 95, 65)
;~ Local $tbKey1 = GUICtrlCreateInput("qe",15, 205, 40, 20)
;~ Local $tbCD1 = GUICtrlCreateInput("2000",60, 205, 40, 20)
;~ Local $buttonSet1 = GUICtrlCreateButton("set",15, 230, 40, 20)
;~ Local $buttonToggleOnOff1 = GUICtrlCreateButton("off",60, 230, 40, 20)
;~ GUICtrlSetOnEvent($buttonSet1, "SetOB1")
;~ GUICtrlSetOnEvent($buttonToggleOnOff1, "ToggleOB1")
;~ GUICtrlCreateGroup("", -99, -99, 1, 1) ;close group

Local $i1WinID = 0
Local $b1OnOff = False
GUISetState(@SW_SHOW, $hMainGUI)

;~ Func SetOB1()
;~ 	GUICtrlSetData($buttonSet1, "press f1")
;~ 	$f1_setter_state = 2
;~ EndFunc

;~ Func ToggleOB1()
;~ 	If $b1OnOff Then
;~ 		$b1OnOff = False
;~ 		GUICtrlSetData($buttonToggleOnOff1,"off")
;~ 	Else
;~ 		$b1OnOff = True
;~ 		GUICtrlSetData($buttonSPModeToggle,"on")
;~ 	EndIf
;~ EndFunc

Local $devoWindowID = 0
Local $bAutoDevo = False

;~ Func ToggleAutodevo()
;~ 	If $bAutoDevo Then
;~ 		$bAutoDevo = False
;~ 		GUICtrlSetData($autoDevoToggleOnOff,"off")
;~ 	Else
;~ 		$bAutoDevo = True
;~ 		GUICtrlSetData($autoDevoToggleOnOff,"on")
;~ 	EndIf
;~ EndFunc

;~ Func SetDevo1()
;~ 	GUICtrlSetData($setDevoTarget1, "press f1")
;~ 	$f1_setter_state = 4
;~ EndFunc

;~ Func SetDevo2()
;~ 	GUICtrlSetData($setDevoTarget2, "press f1")
;~ 	$f1_setter_state = 5
;~ EndFunc

;~ Func SetDevo3()
;~ 	GUICtrlSetData($setDevoTarget3, "press f1")
;~ 	$f1_setter_state = 6
;~ EndFunc

;~ Func SetDevo4()
;~ 	GUICtrlSetData($setDevoTarget4, "press f1")
;~ 	$f1_setter_state = 7
;~ EndFunc

;~ Func SetWindow()
;~ 	Switch $f1_setter_state
;~ 		Case 0
;~ 			ControlSend("", "", "", "{F1}")
;~ 		Case 1
;~ 			$AutopotWindowId = WinGetHandle("")

;~ 			$f1_setter_state = 0
;~ 		Case 2
;~ 			$i1WinID = WinGetHandle("")
;~ 			GUICtrlSetData($buttonSet1, String($i1WinID))
;~ 			$f1_setter_state = 0
;~ 		Case 3
;~ 			$devoWindowID  = WinGetHandle("")
;~ 			GUICtrlSetData($buttonSetDevoWinID, String($devoWindowID))
;~ 			$f1_setter_state = 0
;~ 		Case 4
;~ 			$mDevoPos1 = MouseGetPos()
;~ 			GUICtrlSetData($setDevoTarget1, String($mDevoPos1[0]) & "," & String($mDevoPos1[1]))
;~ 			$f1_setter_state = 0
;~ 		Case 5
;~ 			$mDevoPos2 = MouseGetPos()
;~ 			GUICtrlSetData($setDevoTarget1, String($mDevoPos2[0]) & "," & String($mDevoPos2[1]))
;~ 			$f1_setter_state = 0
;~ 		Case 6
;~ 			$mDevoPos3 = MouseGetPos()
;~ 			GUICtrlSetData($setDevoTarget1, String($mDevoPos3[0]) & "," & String($mDevoPos3[1]))
;~ 			$f1_setter_state = 0
;~ 		Case 7
;~ 			$mDevoPos4 = MouseGetPos()
;~ 			GUICtrlSetData($setDevoTarget1, String($mDevoPos4[0]) & "," & String($mDevoPos4[1]))
;~ 			$f1_setter_state = 0
;~ 	EndSwitch
;~ EndFunc   ;==>Set1


Func Pause()
	$pause = Not $pause
EndFunc   ;==>Pause

Func Terminate()
	$exit = True
EndFunc   ;==>Terminate


Func PauseButton()
    ; Note: At this point @GUI_CtrlId would equal $iOKButton,
    ; and @GUI_WinHandle would equal $hMainGUI
    MsgBox($MB_OK, "GUI Event", "You selected OK!")
EndFunc   ;==>OKButton

Func CloseButton()
    ; Note: At this point @GUI_CtrlId would equal $GUI_EVENT_CLOSE,
    ; and @GUI_WinHandle would equal $hMainGUI
    Exit
EndFunc   ;==>CLOSEButton
