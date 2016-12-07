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

Global $key_exit = IniRead ( "multiclientmacro.ini", "macrokeys", "keyexit", "" )
Global $key_pause = IniRead ( "multiclientmacro.ini", "macrokeys", "keypause", "" )

Global $key_setclient[4] = ["","","",""]
$key_setclient[0] = IniRead ( "multiclientmacro.ini", "client0", "setkey", "" )
$key_setclient[1] = IniRead ( "multiclientmacro.ini", "client1", "setkey", "" )
$key_setclient[2] = IniRead ( "multiclientmacro.ini", "client2", "setkey", "" )
$key_setclient[3] = IniRead ( "multiclientmacro.ini", "client3", "setkey", "" )
Global $key_songswitch = IniRead ( "multiclientmacro.ini", "macrokeys", "songswitchkey", "" )

Global $ms_guiupdate = 2000
Global $ms_whilepause = 200
Global $ms_lastguiupdate = 0

HotKeySet($key_songswitch, "SwitchSongs")

HotKeySet($key_exit, "Terminate")
HotKeySet($key_pause, "Pause")

HotKeySet($key_setclient[0], "Set0")
HotKeySet($key_setclient[1], "Set1")
HotKeySet($key_setclient[2], "Set2")
HotKeySet($key_setclient[3], "Set3")

HotKeySet("^"&$key_setclient[0], "Unset0")
HotKeySet("^"&$key_setclient[1], "Unset1")
HotKeySet("^"&$key_setclient[2], "Unset2")
HotKeySet("^"&$key_setclient[3], "Unset3")

Global $ms_potdelay = Int(IniRead ( "multiclientmacro.ini", "times", "potdelay", "-1" ))

;===========================================================
Global $set[4] = [false,false,false,false]
Global $hp[4] = [0,0,0,0]
Global $max_hp[4] = [0,0,0,0]
Global $sp[4] = [0,0,0,0]
Global $max_sp[4] = [0,0,0,0]
Global $windId[4] = [0,0,0,0]
Global $processID[4] = [0,0,0,0]
Global $processInformation[4] = [0,0,0,0]
Global $sendkey[4]  = ["","","",""]
Global $lastusedsend[4] = [0,0,0,0]
Global $cd[4] = [0,0,0,0]
Global $enablesongswitch[4]  = [0,0,0,0]
Global $song1key[4]  = ["","","",""]
Global $song2key[4]  = ["","","",""]
Global $weaponkey[4]  = ["","","",""]
Global $autopot[4] = [0,0,0,0]
Global $hppercent[4] = [0,0,0,0]
Global $autopotkey[4]  = ["","","",""]


Global $autocure[4] = [0,0,0,0]
Global $confusion[4] = [0,0,0,0]
Global $silence[4] = [0,0,0,0]
Global $cureitemkey[4]  = ["","","",""]
Global $sendkeyaftercure[4] = [0,0,0,0]
Global $class[4]  = ["","","",""]
Global $blvl[4] = [0,0,0,0]
Global $jlvl[4] = [0,0,0,0]

Global $lastusedpot[4] = [0,0,0,0]
Global $lastusedcure[4] = [0,0,0,0]
Global $hppotsused[4] = [0,0,0,0]
Global $cureused[4] = [0,0,0,0]
;===========================================================

Global $buffstart = 0x00CA2590
Global $buffend = 0x00CA271F

Global $int_confusion_id = 886
Global $int_silcence_id = 885

Global $mouseoffset = 1

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

	$sendkey[$client_no] = IniRead ( "multiclientmacro.ini", "client" & $client_no, "sendkey", "" )
	$lastusedsend[$client_no] = 0
	$cd[$client_no] = Int(IniRead ( "multiclientmacro.ini", "client" & $client_no, "cd", "-1" ))

	$enablesongswitch[$client_no] = Int(IniRead ( "multiclientmacro.ini", "client" & $client_no, "enablesongswitch", "-1" ))
	$song1key[$client_no] = IniRead ( "multiclientmacro.ini", "client" & $client_no, "song1key", "" )
	$song2key[$client_no] = IniRead ( "multiclientmacro.ini", "client" & $client_no, "song2key", "" )
	$weaponkey[$client_no] = IniRead ( "multiclientmacro.ini", "client" & $client_no, "weaponkey", "" )

	$autopot[$client_no] = Int(IniRead ( "multiclientmacro.ini", "client" & $client_no, "autopot", "-1" ))
	$hppercent[$client_no] = Int(IniRead ( "multiclientmacro.ini", "client" & $client_no, "hppercent", "-1" ))
	$autopotkey[$client_no] = IniRead ( "multiclientmacro.ini", "client" & $client_no, "autopotkey", "" )

	$lastusedpot[$client_no] = 0
	$hppotsused[$client_no] = 0

	$autocure[$client_no] = IniRead ( "multiclientmacro.ini", "client" & $client_no, "autocure", "" )
	$confusion[$client_no] = Int(IniRead ( "multiclientmacro.ini", "client" & $client_no, "confusion", "-1" ))
	$silence[$client_no] = Int(IniRead ( "multiclientmacro.ini", "client" & $client_no, "silence", "-1" ))

	$cureitemkey[$client_no] = IniRead ( "multiclientmacro.ini", "client" & $client_no, "cureitemkey", "" )
	$sendkeyaftercure[$client_no] = Int(IniRead ( "multiclientmacro.ini", "client" & $client_no, "sendkeyaftercure", "-1" ))

	$lastusedcure[$client_no] = 0
	$cureused[$client_no] = 0

	If $processInformation[$client_no] <> 0 Then
		$class[$client_no] = GetClass($processInformation[$client_no])
		$blvl[$client_no] = _MemoryRead(0xC9FC6C, $processInformation[$client_no])
		$jlvl[$client_no] = _MemoryRead(0xC9FC78, $processInformation[$client_no])
		$hp[$client_no] = _MemoryRead(0x9A1088, $processInformation[$client_no])
		$max_hp[$client_no] = _MemoryRead(0x9A108C, $processInformation[$client_no])
		$sp[$client_no] = _MemoryRead(0x9A1090, $processInformation[$client_no])
		$max_sp[$client_no] = _MemoryRead(0x9A1094, $processInformation[$client_no])
	EndIf
	UpdateTextBox()
EndFunc

Func Set0()
	InitClient(0)
EndFunc

Func Set1()
	InitClient(1)
EndFunc

Func Set2()
	InitClient(2)
EndFunc

Func Set3()
	InitClient(3)
EndFunc

Func Unset0()
	UnsetClient(0)
EndFunc

Func Unset1()
	UnsetClient(1)
EndFunc

Func Unset2()
	UnsetClient(2)
EndFunc

Func Unset3()
	UnsetClient(3)
EndFunc

Func UpdateTextBox()
	Local $text = ""
	if $pause Then
		$text = "PAUSED"
	Else
		$text = "RUNNING"
	EndIf

	For $client_no = 0 To 3 Step 1
		If $set[$client_no] Then
			$text = $text & @CRLF & @CRLF &  "client" & $client_no & " " & $class[$client_no] & "(" & $blvl[$client_no] & "/" & $jlvl[$client_no] & ")"
			$text = $text & @CRLF & "hp " & $hp[$client_no] & "/" & $max_hp[$client_no] & " sp " & $sp[$client_no] & "/" & $max_sp[$client_no]

			If $autopot[$client_no] = 1 Then
				$timediff = TimerDiff($lastusedpot[$client_no])
				$text = $text & @CRLF & "autopot on " & $hppercent[$client_no] & "% " & Int($timediff) & "ms (" & $hppotsused[$client_no] & "x)"
			EndIf

			If $autocure[$client_no] = 1 Then
				$timediff = TimerDiff($lastusedcure[$client_no])
				$text = $text & @CRLF & "autocure on " & Int($timediff) & "ms (" & $cureused[$client_no] & "x)"
			EndIf

			If $enablesongswitch[$client_no] = 1 Then
				$text = $text & @CRLF & "songswitch on "& $key_songswitch &" doing: " & $weaponkey[$client_no] & $song2key[$client_no] & $weaponkey[$client_no] & $song1key[$client_no]
			EndIf
		Else
			$text = $text & @CRLF & @CRLF & "client" & $client_no & " not set. press " & $key_setclient[$client_no] & " to set window."
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

		For $client_no = 0 To 3 Step 1
			If $set[$client_no] Then
				Sleep(100)
				ControlSend($windId[$client_no], "", "", $weaponkey[$client_no])
				Sleep(500)
				ControlSend($windId[$client_no], "", "", "r")
				Sleep(100)
				ControlSend($windId[$client_no], "", "", $weaponkey[$client_no])
				Sleep(500)
				ControlSend($windId[$client_no], "", "", "t")
				Sleep(100)
				ControlSend($windId[$client_no], "", "", $weaponkey[$client_no])
				Sleep(500)
				ControlSend($windId[$client_no], "", "", "z")
				Sleep(100)
				ControlSend($windId[$client_no], "", "", $weaponkey[$client_no])
				Sleep(500)
				ControlSend($windId[$client_no], "", "", "u")
				Sleep(100)
				ControlSend($windId[$client_no], "", "", $weaponkey[$client_no])
				Sleep(500)
				ControlSend($windId[$client_no], "", "", "e")
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
		For $client_no = 0 To 3 Step 1
			If $set[$client_no] Then

				$dowhile = true
				$currentram = $buffstart
				$do_panacea = False
				$do_hppot = False
				$do_sppot = false
				$do_ygg = false

				If $silence[$client_no] = 1 Or $confusion[$client_no] = 1 Then
					While $dowhile
						$dec_bufframvalue = _MemoryRead($currentram, $processInformation[$client_no])
						If $dec_bufframvalue = $int_silcence_id Or $dec_bufframvalue = $int_confusion_id Then
							$do_panacea = True
							$do_while = False
						EndIf

						If $dec_bufframvalue >= 4294967295 Then
							$dowhile = False
						EndIf

						$currentram = $currentram + 0x00000004
						If $currentram >= $buffend  Then
							$dowhile = False
						EndIf
					WEnd
				EndIf

				If $autopot[$client_no] = 1 Then
					$max_hp[$client_no] = _MemoryRead(0xCA2118, $processInformation[$client_no])
					$hp[$client_no] = _MemoryRead(0xCA2114, $processInformation[$client_no])
					Local $procenthp = $hp[$client_no] / $max_hp[$client_no]
					If $procenthp < ($hppercent[$client_no]/100) And $hp[$client_no] > 0 Then
						$do_hppot = true
					EndIf
				Else
					$max_hp[$client_no] = _MemoryRead(0xCA2118, $processInformation[$client_no])
					$hp[$client_no] = _MemoryRead(0xCA2114, $processInformation[$client_no])
				EndIf

				$sp[$client_no] = _MemoryRead(0xCA211C, $processInformation[$client_no])
				$max_sp[$client_no] = _MemoryRead(0xCA2120, $processInformation[$client_no])

				$now = TimerInit()
				$timediff = TimerDiff($lastusedsend[$client_no])
				If $timediff > $cd[$client_no] Then
					$lastusedsend[$client_no] = TimerInit()
					ControlSend($windId[$client_no], "", "", $sendkey[$client_no])
				EndIf

				$now = TimerInit()
				$timediff1 = TimerDiff($lastusedpot[$client_no])
				$timediff2 = TimerDiff($lastusedcure[$client_no])
				If $timediff1 > $ms_potdelay  And  $timediff2 > $ms_potdelay Then
					If $do_panacea Then
						$lastusedcure = TimerInit()
						ControlSend($windId[$client_no], "", "", $cureitemkey[$client_no])
						$cureused[$client_no]+= 1
						If $sendkeyaftercure[$client_no] = 1 Then
							$lastusedsend[$client_no] = TimerInit()
							ControlSend($windId[$client_no], "", "", $sendkey[$client_no])
						EndIf

					ElseIf $do_hppot Then
						$lastusedpot = TimerInit()
						ControlSend($windId[$client_no], "", "", $autopotkey[$client_no])
						$hppotsused[$client_no]+= 1
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
