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

Global $key_exit = IniRead ( "reflect.ini", "macrokeys", "keyexit", "" )
Global $key_pause = IniRead ( "reflect.ini", "macrokeys", "keypause", "" )

Global $key_setclient = IniRead ( "reflect.ini", "client", "keynewclient", "" )
Global $key_songswitch = IniRead ( "reflect.ini", "macrokeys", "skillkey", "" )

Global $ms_guiupdate = 2000
Global $ms_whilepause = 200
Global $ms_lastguiupdate = 0

HotKeySet($key_songswitch, "SwitchSongs")

HotKeySet($key_exit, "Terminate")
HotKeySet($key_pause, "Pause")

HotKeySet($key_setclient, "Set0")

HotKeySet("^"&$key_setclient, "Unset0")

Global $ms_potdelay = Int(IniRead ( "reflect.ini", "macrokeys", "potdelay", "-1" ))

Global $sendkey = IniRead ( "reflect.ini", "client", "sendkey", "" )
Global $autopot = Int(IniRead ( "reflect.ini", "client", "autopot", "-1" ))
Global $minsp = Int(IniRead ( "reflect.ini", "client", "minsp", "-1" ))
Global $autopotkey = IniRead ( "reflect.ini", "client", "autopotkey", "" )
;===========================================================
Global $counter = 0

Global $set[5]
Global $sp[5] = [0,0,0,0,0]
Global $hp[5] = [0,0,0,0,0]
Global $max_sp[5] = [0,0,0,0,0]
Global $max_hp[5] = [0,0,0,0,0]
Global $windId[5] = [0,0,0,0,0]
Global $processID[5] = [0,0,0,0,0]
Global $processInformation[5] = [0,0,0,0,0]

Global $class[5]  = ["","","","",""]
Global $blvl[5] = [0,0,0,0,0]
Global $jlvl[5] = [0,0,0,0,0]

Global $lastusedpot[5] = [0,0,0,0,0]
Global $sppotsused[5] = [0,0,0,0,0]
;===========================================================

$exit = False
$pause = True

Global $pause = True
Opt("PixelCoordMode", 0) ;1=absolute, 0=relative, 2=client
Opt("MouseCoordMode", 0) ;1=absolute, 0=relative, 2=client
Opt("MouseClickDelay", 0)
Opt("SendKeyDelay", 0)
Opt("GUIOnEventMode", 1) ; Change to OnEvent mode

Local $hMainGUI = GUICreate("status", 220, 450,0,0)
GUISetOnEvent($GUI_EVENT_CLOSE, "CloseButton")
Local $editbox = GUICtrlCreateEdit("", 1, 10, 215, 400, $WS_VSCROLL)
UpdateTextBox()
GUISetState()

Func UnsetClient($client_no)
	$set[$client_no] = False
	If $processInformation[$client_no] <> 0 Then
		_MemoryClose($processInformation[$client_no])
	EndIf
	UpdateTextBox()
EndFunc

Func InitClient($client_no)
	If $processInformation[$client_no] <> 0 Then
		_MemoryClose($processInformation[$client_no])
	EndIf

	$set[$client_no] = True

	$windId[$client_no] = WinGetHandle("")
	$processID[$client_no] =  WinGetProcess("")
	$processInformation[$client_no] = _MemoryOpen($processID[$client_no])


	$lastusedpot[$client_no] = 0
	$sppotsused[$client_no] = 0

	If $processInformation[$client_no] <> 0 Then
		$class[$client_no] = GetClass($processInformation[$client_no])
		$blvl[$client_no] = _MemoryRead(0xC9FC6C, $processInformation[$client_no])
		$jlvl[$client_no] = _MemoryRead(0xC9FC78, $processInformation[$client_no])
		$hp[$client_no] = _MemoryRead(0xCA2114, $processInformation[$client_no])
		$max_hp[$client_no] = _MemoryRead(0xCA2118, $processInformation[$client_no])
		$sp[$client_no] = _MemoryRead(0xCA211C, $processInformation[$client_no])
		$max_sp[$client_no] = _MemoryRead(0xCA2120, $processInformation[$client_no])
	EndIf
	UpdateTextBox()
EndFunc

Func Set0()
	If $counter <= 5 Then
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

	For $client_no = 0 To 4 Step 1
		If $set[$client_no] Then
			$text = $text & @CRLF & @CRLF &  "client" & $client_no & " " & $class[$client_no] & "(" & $blvl[$client_no] & "/" & $jlvl[$client_no] & ")"
			$text = $text & @CRLF & "hp " & $hp[$client_no] & "/" & $max_hp[$client_no] & " sp " & $sp[$client_no] & "/" & $max_sp[$client_no]

			If $autopot = 1 Then
				$timediff = TimerDiff($lastusedpot[$client_no])
				$text = $text & @CRLF & "autopot on " & $minsp & "sp " & Int($timediff) & "ms (" & $sppotsused[$client_no] & "x)"
			EndIf
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
		For $client_no = 0 To 4 Step 1
			If $set[$client_no] Then
				ControlSend($windId[$client_no], "", "", $sendkey)
			EndIf
		Next

		$pause = false
	Else
		HotKeySet($key_songswitch)
		Send($key_songswitch)
		HotKeySet($key_songswitch, "SwitchSongs")
	EndIf
EndFunc

Func GetClass($local_process_info)
	$iclass = _MemoryRead(0xC9FC64, $local_process_info)
	$stringclass = ""
	Switch $iclass
		Case 4008
			$stringclass = "lk"
		Case 4009
			$stringclass = "hp"
		Case 4010
			$stringclass = "hw"
		Case 4011
			$stringclass = "ws"
		Case 4012
			$stringclass = "snip"
		Case 4013
			$stringclass = "assax"
		Case 4015
			$stringclass = "paly"
		Case 4016
			$stringclass = "champ"
		Case 4017
			$stringclass = "prof"
		Case 4018
			$stringclass = "stalker"
		Case 4019
			$stringclass = "crea"
		Case 4020
			$stringclass = "clown"
		Case 4021
			$stringclass = "gypsy"
		Case 14
			$stringclass = "crusi"
		Case 4049
			$stringclass = "sl"
		Case Else
			$stringclass = "class not found"
	EndSwitch
	Return $stringclass
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
		For $client_no = 0 To 4 Step 1
			If $set[$client_no] Then

				$dowhile = true
				$do_sppot = false

				$sp[$client_no] = _MemoryRead(0xCA211C, $processInformation[$client_no])
				$max_sp[$client_no] = _MemoryRead(0xCA2120, $processInformation[$client_no])
				$hp[$client_no] = _MemoryRead(0xCA2114, $processInformation[$client_no])
				$max_hp[$client_no] = _MemoryRead(0xCA2118, $processInformation[$client_no])

				If $autopot = 1 Then
					If $sp[$client_no] < $minsp And $hp[$client_no] > 0 Then
						$do_sppot = true
					EndIf
				EndIf

				$now = TimerInit()
				$timediff1 = TimerDiff($lastusedpot[$client_no])
				If $timediff1 > $ms_potdelay  Then
					If $do_sppot Then
						$lastusedpot[$client_no] = TimerInit()
						ControlSend($windId[$client_no], "", "", $autopotkey)
						$sppotsused[$client_no]+= 1
					EndIf
				EndIf
			EndIf
		Next
	EndIf

	$now = TimerInit()
	$timediff = TimerDiff($ms_lastguiupdate)
	If $timediff > $ms_guiupdate Then
		UpdateTextBox()
	EndIf

	Sleep($ms_whilepause)
WEnd
If $ProcessInformation <> 0 Then
	_MemoryClose($ProcessInformation)
EndIf

Func CloseButton()
    $exit = true
EndFunc
