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

Local $hDLL = DllOpen("user32.dll")

Global $key_exit = IniRead ( "config.ini", "macrokeys", "keyexit", "" )
Global $key_pause = IniRead ( "config.ini", "macrokeys", "keypause", "" )
Global $key_setwindow = IniRead ( "config.ini", "macrokeys", "keysetwindow", "" )

HotKeySet($key_exit, "Terminate")
HotKeySet($key_pause, "Pause")
HotKeySet($key_setwindow, "Init")

HotKeySet("{PGUP}", "Morecd")
HotKeySet("{PGDN}", "Lesscd")


Global $b_do_hp = Int(IniRead ( "config.ini", "autopot", "hp", "-1" ))
Global $key_hp = IniRead ( "config.ini", "keys", "hpkey", "0" )
Global $i_hp_percent = Int(IniRead ( "config.ini", "autopot", "hppercent", "0" ))

Global $b_do_sp = Int(IniRead ( "config.ini", "autopot", "sp", "-1" ))
Global $key_sp = IniRead ( "config.ini", "keys", "spkey", "0" )
Global $i_sp_percent = Int(IniRead ( "config.ini", "autopot", "sppercent", "0" ))

Global $key_panacea = IniRead ( "config.ini", "keys", "panacea", "0" )
Global $b_do_silence = Int(IniRead ( "config.ini", "autopot", "silence", "-1" ))
Global $b_do_consufion = Int(IniRead ( "config.ini", "autopot", "confusion", "-1" ))

Global $b_do_skill = Int(IniRead ( "config.ini", "autopot", "skillspam", "-1" ))
Global $key_skill = IniRead ( "config.ini", "keys", "skillonspacekey", "0" )

Global $ms_skilldelay = Int(IniRead ( "config.ini", "times", "skilldelay", "-1" ))
Global $ms_pingtollerance = Int(IniRead ( "config.ini", "times", "pingtollerance", "-1" ))
Global $ms_potdelay = Int(IniRead ( "config.ini", "times", "potdelay", "-1" ))

;Variables to calc time differences
Global $lastusedskill
Global $lastusedpot

Global $b_silenced = false
Global $hp
Global $max_hp

Global $WindId = 0
Global $ProcessID = 0
Global $ProcessInformation
Global $buffstart = 0x00CA2590
Global $buffend = 0x00CA271F

Global $int_confusion_id = 886
Global $int_silcence_id = 885

Global $bla = 1

$exit = False
$pause = True

Global $pause = True
Opt("PixelCoordMode", 0) ;1=absolute, 0=relative, 2=client
Opt("MouseCoordMode", 0) ;1=absolute, 0=relative, 2=client
Opt("MouseClickDelay", 0)
Opt("SendKeyDelay", 0)
Opt("GUIOnEventMode", 1) ; Change to OnEvent mode

Local $hMainGUI = GUICreate("status", 220, 250,0,0)
GUISetOnEvent($GUI_EVENT_CLOSE, "CloseButton")
Local $editbox = GUICtrlCreateEdit("set window with " & $key_setwindow, 10, 10, 200, 200, $WS_VSCROLL)
;BitOr($GUI_SS_DEFAULT_EDIT, $ES_AUTOVSCROLL) + BitOr($WS_HSCROLL, 0) + BitOr($WS_VSCROLL, 1

Global $hwnd

Global $iEnd
Global $text
GUISetState()

$text =  @CRLF & "pause: " & $pause
$iEnd = StringLen(GUICtrlRead($editbox))
_GUICtrlEdit_SetSel($editbox, $iEnd, $iEnd)
_GUICtrlEdit_Scroll($editbox, $SB_SCROLLCARET)
GUICtrlSetData($editbox, $text, 1)

Func Morecd()
	$ms_skilldelay = $ms_skilldelay + 10
	AddText("next skilldelay " & Int($ms_skilldelay))
EndFunc

Func Lesscd()
	$ms_skilldelay = $ms_skilldelay - 10
	AddText("next skilldelay " & Int($ms_skilldelay))
EndFunc

Func Init()
	GUICtrlDelete($editbox)
	$editbox= 	GUICtrlCreateEdit("set window with " & $key_setwindow, 10, 10, 200, 200, $WS_VSCROLL)
	If $ProcessInformation <> 0 Then
		_MemoryClose($ProcessInformation)
	EndIf
	$ProcessID = WinGetProcess("")
	$WindId = WinGetHandle("")
	$ProcessInformation = _MemoryOpen($ProcessID)

	$text =  @CRLF & "window set, winid: " & $WindId & ", processid: " & $ProcessID
	$iEnd = StringLen(GUICtrlRead($editbox))
	_GUICtrlEdit_SetSel($editbox, $iEnd, $iEnd)
	_GUICtrlEdit_Scroll($editbox, $SB_SCROLLCARET)
	GUICtrlSetData($editbox, $text, 1)
	GetStats()
EndFunc   ;==>Init

Func GetStats()
	$iclass = _MemoryRead(0xC9FC64, $ProcessInformation)
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

	$blvl = _MemoryRead(0xC9FC6C, $ProcessInformation)
	$jlvl = _MemoryRead(0xC9FC78, $ProcessInformation)
	AddText($stringclass & " lvl" & $blvl & "/" & $jlvl)

	$str = _MemoryRead(0xC9FCA4, $ProcessInformation) + _MemoryRead(0xC9FC8C, $ProcessInformation)
	$agi = _MemoryRead(0xC9FCA8, $ProcessInformation) + _MemoryRead(0xC9FC90, $ProcessInformation)
	$vit = _MemoryRead(0xC9FCAC, $ProcessInformation) + _MemoryRead(0xC9FC94, $ProcessInformation)
	$int = _MemoryRead(0xC9FCB0, $ProcessInformation) + _MemoryRead(0xC9FC98, $ProcessInformation)
	$dex = _MemoryRead(0xC9FCB4, $ProcessInformation) + _MemoryRead(0xC9FC9C, $ProcessInformation)
	$luk = _MemoryRead(0xC9FCB8, $ProcessInformation) + _MemoryRead(0xC9FCA0, $ProcessInformation)
	AddText("stats")
	AddText($str & "str "& $agi & "agi "& $vit & "vit ")
	AddText($int & "int "& $dex & "dex "& $luk & "luk ")

	$fancyaspdmemoryvalue = _MemoryRead(0xC9FCD4, $ProcessInformation)
	AddText("aspd " & (200 - ($fancyaspdmemoryvalue/10)))
EndFunc

Func Pause()
	$pause = Not $pause
	$text = @CRLF&"pause: " & $pause
	$iEnd = StringLen(GUICtrlRead($editbox))
	_GUICtrlEdit_SetSel($editbox, $iEnd, $iEnd)
	_GUICtrlEdit_Scroll($editbox, $SB_SCROLLCARET)
	GUICtrlSetData($editbox, $text, 1)
EndFunc   ;==>Pause

Func AddText($linetext)
	$text = @CRLF&$linetext
	$iEnd = StringLen(GUICtrlRead($editbox))
	_GUICtrlEdit_SetSel($editbox, $iEnd, $iEnd)
	_GUICtrlEdit_Scroll($editbox, $SB_SCROLLCARET)
	GUICtrlSetData($editbox, $text, 1)
EndFunc

Func Terminate()
	GUIDelete($hwnd)
	$exit = True
EndFunc   ;==>Terminate


While Not $exit
	If Not $pause And $WindId <> 0 And Not _IsPressed ("A0",$hDLL) And Not _IsPressed ("A1",$hDLL) And Not _IsPressed ("A2",$hDLL) And Not _IsPressed ("A3",$hDLL) And Not _IsPressed ("A4",$hDLL) And Not _IsPressed ("A5",$hDLL)  Then

			$dowhile = true
			$text = ""
			$currentram = $buffstart
			$do_panacea = False
			$do_hppot = False
			$do_sppot = false

			If $b_do_silence = 1 Or $b_do_consufion = 1 Then
				While $dowhile
					$dec_bufframvalue = _MemoryRead($currentram, $ProcessInformation)
					If $b_do_silence = 1 And $dec_bufframvalue = $int_silcence_id Then
						$do_panacea = True
					EndIf

					If $b_do_silence = 1 And $dec_bufframvalue = $int_confusion_id Then
						$do_panacea = True
					EndIf

					If $dec_bufframvalue < 4294967295 Then
						$text = $text & $hp & ", "
					Else
						$dowhile = False
					EndIf

					$currentram = $currentram + 0x00000004
					If $currentram >= $buffend  Then
						$dowhile = False
					EndIf
				WEnd
			EndIf

			If $b_do_hp = 1 Then
				$max_hp = _MemoryRead(0xCA2118, $ProcessInformation)
				$hp = _MemoryRead(0xCA2114, $ProcessInformation)
				Local $procenthp = $hp / $max_hp
				If ($procenthp) < ($i_hp_percent/100) And $hp > 0 Then
					$do_hppot = true
				EndIf
			EndIf

			If $b_do_sp = 1 Then
				$hp = _MemoryRead(0xCA2114, $ProcessInformation)
				$max_sp = _MemoryRead(0xCA2120, $ProcessInformation)
				$sp = _MemoryRead(0xCA211C, $ProcessInformation)
				Local $procentsp = $sp / $max_sp
				If ($procentsp) < ($i_sp_percent/100)  And $hp > 0 Then
					$do_sppot = True
				EndIf
			EndIf


			;$rgn = CreateTextRgn($hwnd, $text, 20, "Arial", 500)
			;SetWindowRgn($hwnd, $rgn)
			;GUISetState()

			$now = TimerInit()
			$timediff = TimerDiff($lastusedskill)

			if $b_do_skill = 2 And _IsPressed (20,$hDLL) And $timediff > ($ms_skilldelay + $ms_pingtollerance) Then
				Send($key_skill)
				Sleep(5)
				$aPos = MouseGetPos()
				MouseClick("left", $aPos[0], $aPos[1]+$bla)
				$bla=$bla*(-1)
				$lastusedskill = TimerInit()
				AddText("used skill ms " & Int($timediff))
			ElseIf $b_do_skill = 1 And _IsPressed (20,$hDLL) And $timediff > ($ms_skilldelay + $ms_pingtollerance)  Then
				Send($key_skill)
				$lastusedskill = TimerInit()
				AddText("used skill ms " & Int($timediff))
			EndIf

			$now = TimerInit()
			$timediff = TimerDiff($lastusedpot)
			If $timediff > $ms_potdelay Then
				If $do_hppot Then
					ControlSend($WindId, "", "", $key_hp)
					$lastusedpot = TimerInit()
					AddText("used hppot ms " & $timediff)
				ElseIf $do_panacea Then
					ControlSend($WindId, "", "", $key_panacea)
					$lastusedpot = TimerInit()
					AddText("used panacea ms " & $timediff)
				ElseIf $do_sppot Then
					ControlSend($WindId, "", "", $key_sp)
					$lastusedpot = TimerInit()
					AddText("used sppot ms " & $timediff)
				EndIf
			EndIf
	EndIf
WEnd
If $ProcessInformation <> 0 Then
	_MemoryClose($ProcessInformation)
EndIf

Func CloseButton()
    $exit = true
EndFunc
