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

HotKeySet("{F1}", "SetWindow")
HotKeySet("{PAUSE}", "Pause")

;Keys to press ; qe = use e only when q goesnt work (ex. use bragi than encore only); qq = to reduce input problems and moving wizzards^^
Global $Key1 = "qe"
Global $Key2 = "qe"
Global $Key3 = "q"
Global $Key4 = "m"

;Spam cooldowns in ms
Global $i1cd = 2000
Global $i2cd = 2000
Global $i3cd = 20000
Global $i4cd = 5

;Bools if set or not
Global $b1set = False
Global $b2set = False
Global $b3set = False
Global $b4set = False

Global $pausezwischenskillundclick = 5

;Variables to calc time differences
Global $lastused1
Global $lastused2
Global $lastused3
Global $lastused4

;Window ID's
Global $WinID1 = 0
Global $WinID2 = 0
Global $WinID3 = 0
Global $WinID4 = 0

;Saved mouse position for click spam
Global $mousePosition

Global $exit = False
Global $pause = True

Global $f1_setter_state = 0

Opt("PixelCoordMode", 0) ;1=absolute, 0=relative, 2=client
Opt("MouseCoordMode", 0) ;1=absolute, 0=relative, 2=client
Opt("GUIOnEventMode", 1) ; Change to OnEvent mode

Local $hMainGUI = GUICreate("op macro", 200, 1000,0,0)
GUISetOnEvent($GUI_EVENT_CLOSE, "CloseButton")
Local $pauseButton = GUICtrlCreateButton("paused", 10, 10, 60, 20)

;Autopot Gui and variables
GUICtrlCreateLabel("Autopot",20, 40, 60, 20)

Local $buttonSetAutopotWinID = GUICtrlCreateButton("set window",10, 60, 80, 20)
GUICtrlSetOnEvent($buttonSetAutopotWinID, "SetAutopotWindow")
Local $AutopotWindowId = 0;


GuiCtrlCreateGroup("hp", 10, 90, 70, 100)
Local $buttonHPModeToggle = GUICtrlCreateButton("100%",15, 105, 40, 20)
GUICtrlSetOnEvent($buttonHPModeToggle, "ToggleHPMode")
Local $hpRadioOn = GUICtrlCreateRadio("On", 15, 130, 40, 20)
Local $hpRadioOff = GUICtrlCreateRadio("Off", 15, 160, 40, 20)
GUICtrlCreateGroup("", -99, -99, 1, 1) ;close group

GUICtrlSetOnEvent($hpRadioOn, "HpRadio")
GUICtrlSetOnEvent($hpRadioOff, "HpRadio")

GuiCtrlCreateGroup("sp", 85, 90, 70, 100)
Local $buttonSPModeToggle = GUICtrlCreateButton("100%",90, 105, 50,20)
GUICtrlSetOnEvent($buttonHPModeToggle, "ToggleSPMode")
Local $spRadioOn = GUICtrlCreateRadio("On", 90, 130, 50, 20)
Local $spRadioOff = GUICtrlCreateRadio("Off", 90, 160, 60, 20)
GUICtrlCreateGroup("", -99, -99, 1, 1) ;close group

GUICtrlSetState($hpRadioOff, True)
GUICtrlSetState($spRadioOff, True)

Local $bAutopotHpOn = false
Local $bAutopotSpOn = false
Local $iAutopotHpMode = 100
Local $iAutopotSpMode = 100

Func SetAutopotWindow()
	GUICtrlSetData($buttonSetAutopotWinID, "press f1")
	$f1_setter_state = 1
EndFunc

Func HpRadio()
	$bHpRadioOn = GUICtrlGetState($hpRadioOn)
	If $bHpRadioOn Then
		$bAutopotHpOn = True
	Else
		$bAutopotHpOn = False
	EndIf
EndFunc

Func SpRadio()
	$bSpRadioOn = GUICtrlGetState($spRadioOn)
	If $bSpRadioOn Then
		$bAutopotSpOn = True
	Else
		$bAutopotSpOn = False
	EndIf
EndFunc

Func ToggleHPMode()
	If $iAutopotHpMode = 100 Then
		$iAutopotHpMode = 10
		GUICtrlSetData($buttonHPModeToggle,"10%")
	Else
		$iAutopotHpMode = 100
		GUICtrlSetData($buttonHPModeToggle,"100%")
	EndIf
EndFunc

Func ToggleSPMode()
	If $iAutopotSpMode = 100 Then
		$iAutopotSpMode = 10
		GUICtrlSetData($buttonSPModeToggle,"10%")
	Else
		$iAutopotSpMode = 100
		GUICtrlSetData($buttonSPModeToggle,"100%")
	EndIf
EndFunc


GuiCtrlCreateGroup("one button macros", 10, 190, 95, 65)
Local $tbKey1 = GUICtrlCreateInput("qe",15, 205, 40, 20)
Local $tbCD1 = GUICtrlCreateInput("2000",60, 205, 40, 20)
Local $buttonSet1 = GUICtrlCreateButton("set",15, 230, 40, 20)
Local $buttonToggleOnOff1 = GUICtrlCreateButton("off",60, 230, 40, 20)
GUICtrlSetOnEvent($buttonSet1, "SetOB1")
GUICtrlSetOnEvent($buttonToggleOnOff1, "ToggleOB1")
GUICtrlCreateGroup("", -99, -99, 1, 1) ;close group

Local $i1WinID = 0
Local $b1OnOff = False
GUISetState(@SW_SHOW, $hMainGUI)

Func SetOB1()
	GUICtrlSetData($buttonSet1, "press f1")
	$f1_setter_state = 2
EndFunc

Func ToggleOB1()
	If $b1OnOff Then
		$b1OnOff = False
		GUICtrlSetData($buttonToggleOnOff1,"off")
	Else
		$b1OnOff = True
		GUICtrlSetData($buttonSPModeToggle,"on")
	EndIf
EndFunc

GuiCtrlCreateGroup("autodevo", 10, 255, 150, 205)
Local $buttonSetDevoWinID = GUICtrlCreateButton("set", 15, 270, 40, 20)
GUICtrlCreateLabel("key devo", 20, 295, 50, 15)
GUICtrlCreateLabel("key autoguard", 20, 315, 70, 15)

GUICtrlCreateLabel("devotarget1", 20, 335, 50, 15)
GUICtrlCreateLabel("devotarget2", 20, 355, 50, 15)
GUICtrlCreateLabel("devotarget3", 20, 375, 50, 15)
GUICtrlCreateLabel("devotarget4", 20, 395, 50, 15)

GUICtrlCreateLabel("key do devo", 20, 415, 70, 20)

GUICtrlCreateLabel("refresh time", 20, 435, 60, 20)
GUICtrlCreateLabel("key do devo", 20, 415, 70, 20)

Local $autoDevoToggleOnOff = GUICtrlCreateButton("off",60, 270, 40, 20)
Local $tbDevoKey = GUICtrlCreateInput("m",90, 295, 60, 20)
Local $tbAutoguardKey = GUICtrlCreateInput("b",90, 315, 60, 20)

Local $setDevoTarget1 = GUICtrlCreateButton("set",90, 335, 60, 20)
Local $setDevoTarget2 = GUICtrlCreateButton("set",90, 355, 60, 20)
Local $setDevoTarget3 = GUICtrlCreateButton("set",90, 375, 60, 20)
Local $setDevoTarget4 = GUICtrlCreateButton("set",90, 395, 60, 20)

Local $tbManualDevoKey = GUICtrlCreateInput("{SPACE}",90, 415, 60, 20)
Local $tbDevoRefreshTime = GUICtrlCreateInput("1000",90, 435, 40, 20)
GUICtrlCreateGroup("", -99, -99, 1, 1) ;close group

GUICtrlSetOnEvent($buttonSetDevoWinID, "SetDevoWindow")
GUICtrlSetOnEvent($autoDevoToggleOnOff, "ToggleAutodevo")
GUICtrlSetOnEvent($setDevoTarget1, "SetDevo1")
GUICtrlSetOnEvent($setDevoTarget2, "SetDevo2")
GUICtrlSetOnEvent($setDevoTarget3, "SetDevo3")
GUICtrlSetOnEvent($setDevoTarget4, "SetDevo4")

Global $mDevoPos1
Global $mDevoPos2
Global $mDevoPos3
Global $mDevoPos4

Local $devoWindowID = 0
Local $bAutoDevo = False

Func SetDevoWindow()
	GUICtrlSetData($buttonSetDevoWinID, "press f1")
	$f1_setter_state = 3
EndFunc

Func ToggleAutodevo()
	If $bAutoDevo Then
		$bAutoDevo = False
		GUICtrlSetData($autoDevoToggleOnOff,"off")
	Else
		$bAutoDevo = True
		GUICtrlSetData($autoDevoToggleOnOff,"on")
	EndIf
EndFunc

Func SetDevo1()
	GUICtrlSetData($setDevoTarget1, "press f1")
	$f1_setter_state = 4
EndFunc

Func SetDevo2()
	GUICtrlSetData($setDevoTarget2, "press f1")
	$f1_setter_state = 5
EndFunc

Func SetDevo3()
	GUICtrlSetData($setDevoTarget3, "press f1")
	$f1_setter_state = 6
EndFunc

Func SetDevo4()
	GUICtrlSetData($setDevoTarget4, "press f1")
	$f1_setter_state = 7
EndFunc

Func SetWindow()
	Switch $f1_setter_state
		Case 0
			ControlSend("", "", "", "{F1}")
		Case 1
			$AutopotWindowId = WinGetHandle("")
			GUICtrlSetData($buttonSetAutopotWinID, String($AutopotWindowId))
			$f1_setter_state = 0
		Case 2
			$i1WinID = WinGetHandle("")
			GUICtrlSetData($buttonSet1, String($i1WinID))
			$f1_setter_state = 0
		Case 3
			$devoWindowID  = WinGetHandle("")
			GUICtrlSetData($buttonSetDevoWinID, String($devoWindowID))
			$f1_setter_state = 0
		Case 4
			$mDevoPos1 = MouseGetPos()
			GUICtrlSetData($setDevoTarget1, String($mDevoPos1[0]) & "," & String($mDevoPos1[1]))
			$f1_setter_state = 0
		Case 5
			$mDevoPos2 = MouseGetPos()
			GUICtrlSetData($setDevoTarget1, String($mDevoPos2[0]) & "," & String($mDevoPos2[1]))
			$f1_setter_state = 0
		Case 6
			$mDevoPos3 = MouseGetPos()
			GUICtrlSetData($setDevoTarget1, String($mDevoPos3[0]) & "," & String($mDevoPos3[1]))
			$f1_setter_state = 0
		Case 7
			$mDevoPos4 = MouseGetPos()
			GUICtrlSetData($setDevoTarget1, String($mDevoPos4[0]) & "," & String($mDevoPos4[1]))
			$f1_setter_state = 0
	EndSwitch
EndFunc   ;==>Set1


Func Pause()
	$pause = Not $pause
EndFunc   ;==>Pause

Func Terminate()
	$exit = True
EndFunc   ;==>Terminate


While Not $exit
	If Not $pause Then
		If $b1set Then
			$now = TimerInit()
			$timediff = TimerDiff($lastused1)
			If $timediff > $i1cd Then
				ControlSend($WinID1, "", "", $Key1)
				$lastused1 = TimerInit();
			EndIf
		EndIf

		If $b2set Then
			$now = TimerInit()
			$timediff = TimerDiff($lastused2)
			If $timediff > $i2cd Then
				ControlSend($WinID2, "", "", $Key2)
				$lastused2 = TimerInit();
			EndIf
		EndIf

		If $b3set Then
			$now = TimerInit()
			$timediff = TimerDiff($lastused3)
			If $timediff > $i3cd Then
				ControlSend($WinID3, "", "", $Key3)
				$lastused3 = TimerInit();
			EndIf
		EndIf

		If $b4set Then
			$now = TimerInit()
			$timediff = TimerDiff($lastused4)
			If $timediff > $i4cd Then
				ControlSend($WinID4, "", "", $Key4)
				Sleep($pausezwischenskillundclick)
				MouseClick("left", $mousePosition[0], $mousePosition[1])
				$lastused4 = TimerInit();
			EndIf
		EndIf
	EndIf
WEnd


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
