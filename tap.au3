; Script Start - Add your code below here
#include <GUIConstants.au3>
;~ Global Const $WS_POPUP                = 0x80000000
;~ Global Const $WS_EX_TOOLWINDOW            = 0x00000080
;~ Global Const $WS_EX_TOPMOST                = 0x00000008

#include <MemoryCustom.au3>
#include <Misc.au3>
#include <MsgBoxConstants.au3>
#include <AutoItConstants.au3>
#include <Date.au3>
#include <WinAPIFiles.au3>
#include <GUIConstantsEx.au3>
#include <GuiEdit.au3>
#include <ScrollBarsConstants.au3>
#include <Math.au3>

Local $hDLL = DllOpen("user32.dll")

Global $key_exit = IniRead ( "tap.ini", "macrokeys", "keyexit", "" )
Global $key_pause = IniRead ( "tap.ini", "macrokeys", "keypause", "" )

Global $key_setclient = IniRead ( "tap.ini", "client", "keynewclient", "" )
Global $key_songswitch = IniRead ( "tap.ini", "macrokeys", "skillkey", "" )

Global $ms_guiupdate = 2000
Global $ms_whilepause = 200
Global $ms_lastguiupdate = 0

HotKeySet($key_songswitch, "SwitchSongs")

HotKeySet($key_exit, "Terminate")
HotKeySet($key_pause, "Pause")

HotKeySet($key_setclient, "Set0")

HotKeySet("^"&$key_setclient, "Unset0")


Global $sendencore = IniRead ( "tap.ini", "client", "sendencore", "" )
Global $sendsong = IniRead ( "tap.ini", "client", "sendsong", "" )
Global $sendweapon = IniRead ( "tap.ini", "client", "sendweapon", "" )
;===========================================================
Global $counter = 0

Global $set[10]

Global $windId[10]

;===========================================================

$exit = False
$pause = True

Global $pause = True
Opt("PixelCoordMode", 0) ;1=absolute, 0=relative, 2=client
Opt("MouseCoordMode", 0) ;1=absolute, 0=relative, 2=client
Opt("MouseClickDelay", 0)
Opt("SendKeyDelay", 0)
Opt("GUIOnEventMode", 1) ; Change to OnEvent mode

Local $hMainGUI = GUICreate("status", 220, 410,0,0)
GUISetOnEvent($GUI_EVENT_CLOSE, "CloseButton")
Local $editbox = GUICtrlCreateEdit("", 1, 5, 215, 400, $WS_VSCROLL)
UpdateTextBox()
GUISetState()

Func UnsetClient($client_no)
	$set[$client_no] = False
	UpdateTextBox()
EndFunc

Func InitClient($client_no)

	$set[$client_no] = True

	$windId[$client_no] = WinGetHandle("")

	UpdateTextBox()
EndFunc

Func Set0()
	If $counter <= 10 Then
		InitClient($counter)
		$counter = $counter + 1
	EndIf
EndFunc


Func Unset0()
	If $counter > 0 Then
		UnsetClient($counter-1)
		$counter = $counter - 1
	EndIf
EndFunc



Func UpdateTextBox()
	Local $text = ""
	if $pause Then
		$text = "PAUSED"
	Else
		$text = "RUNNING"
	EndIf

	For $client_no = 0 To 9 Step 1
		If $set[$client_no] Then
			$text = $text & @CRLF & @CRLF &  "client:" & $windId[$client_no]
		Else
			$text = $text & @CRLF & @CRLF & "client" & $client_no & " not set. press " & $key_setclient & " to set window."
		EndIf
	Next



	$iEnd = StringLen(GUICtrlRead($editbox))
	;_GUICtrlEdit_SetSel($editbox, $iEnd, $iEnd)
	;_GUICtrlEdit_Scroll($editbox, $SB_SCROLLCARET)
	GUICtrlSetData($editbox, $text)
	$ms_lastguiupdate = TimerInit()
EndFunc

Func SwitchSongs()
	If Not $pause Then
		$pause = true
		For $client_no = 0 To 9 Step 1
			If $set[$client_no] Then
				ControlSend($windId[$client_no], "", "", $sendencore)
				ControlSend($windId[$client_no], "", "", $sendsong)
			EndIf
		Next

		For $client_no = 0 To 9 Step 1
			If $set[$client_no] Then
				ControlSend($windId[$client_no], "", "", $sendweapon)
			EndIf
		Next

		$pause = false
	Else
		HotKeySet($key_songswitch)
		Send($key_songswitch)
		HotKeySet($key_songswitch, "SwitchSongs")
	EndIf
EndFunc

Func Pause()
	$pause = Not $pause
	UpdateTextBox()
EndFunc   ;==>Pause

Func Terminate()
	GUIDelete($hMainGUI)
	$exit = True
EndFunc   ;==>Terminate



While Not $exit
	If Not $pause And Not _IsPressed ("A0",$hDLL) And Not _IsPressed ("A1",$hDLL) And Not _IsPressed ("A2",$hDLL) And Not _IsPressed ("A3",$hDLL) And Not _IsPressed ("A4",$hDLL) And Not _IsPressed ("A5",$hDLL)  Then
		Sleep($ms_whilepause)

	EndIf
	Sleep($ms_whilepause)
WEnd

Func CloseButton()
    $exit = true
EndFunc
