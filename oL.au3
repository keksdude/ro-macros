#include<array.au3>
;#include<PixelCheckSumFindAll.au3>
#Include<GUIConstants.au3>
#include<misc.au3>
#include<string.au3>
#include<A3LScreenCap.au3>
#include<IE.au3>

Opt("PixelCoordMode", 0);1=absolute & Default, 0=relative, 2=client area   ;Set CoOrds relative to Window not screen
Opt("MouseCoordMode", 0)

HotKeySet("`","_Go")
HotKeySet("~","_record")
HotKeySet('{esc}', '_Exit')

Local $msg = "Press Shift+tilde to Record "&@LF&"Press tilde to Find "&@LF&"info saved in NoMia.ini"
Local $xy,$currentpixel,$FileBMP = ".\Render.bmp",$IniFile = ".\NoMIA.ini"

_initialize($IniFile)

While 1
    $xy = MouseGetPos()
    $currentpixel = PixelGetColor($xy[0],$xy[1])
    ToolTip("Pixel color = " & $currentpixel & @LF & $msg)
    Sleep(100)
WEnd

Func _Go()
    $pixel = Int(IniRead($IniFile,"Rec1","PixelColor","-1"))
    $chksum = Int(IniRead($IniFile,"Rec1","PixelCheckSum","-1"))
    $WinLoc = WinGetPos("")
    _ScreenCap_Capture($FileBMP, $WinLoc[0], $WinLoc[1],$WinLoc[0]+$WinLoc[2],$WinLoc[1]+$WinLoc[3])        ;Create Image
    _RenderImg($FileBMP, $WinLoc[0], $WinLoc[1])                                                            ;Render Image
    $WinLoc = WinGetPos(" Render VD")
    $Array = _PixelCheckSumFindAll( $pixel, $chksum, 5, 5, 5, 5, 0, 0, $WinLoc[2], $WinLoc[3])              ;Find in Image
    GUISetState(@SW_HIDE)
    For $i = 1 to $Array[0][0]                                                                              ;Demonstrate Found locations
        MouseMove($Array[$i][0],$Array[$i][1], 10)
        MouseClick("Left")
    Next
    _ArrayDisplay($Array)
EndFunc

Func _record()
    IniWrite($IniFile,"Rec1","PixelColor",$currentpixel)
    Local $chksum = PixelChecksum($xy[0]-5, $xy[1]-5, $xy[0]+5, $xy[1]+5)
    IniWrite($IniFile,"Rec1","PixelCheckSum",$chksum)
    ToolTip('          '&@CRLF&'  SAVED  '&@CRLF&'          ')
    Sleep(500)
EndFunc

Func _Exit()
    ToolTip('          '&@CRLF&'  EXITING  '&@CRLF&'          ')
    Sleep(500)
    Exit
EndFunc

Func _initialize($IniFile)
    ;For $i = 0 to 9
        $val01 = IniRead($IniFile, "Rec1","PixelColor", -1)
        $val02 = IniRead($IniFile, "Rec1","PixelCheckSum", -1)
        $val03 = IniRead($IniFile, "Rec1","Left_SerchArea", -1)
        $val04 = IniRead($IniFile, "Rec1","Top_SerchArea", -1)
        $val05 = IniRead($IniFile, "Rec1","Right_SerchArea", -1)
        $val06 = IniRead($IniFile, "Rec1","Bottom_SerchArea", -1)
        If $val01 = -1 then IniWrite($IniFile, "Rec1","PixelColor", "0")
        If $val02 = -1 then IniWrite($IniFile, "Rec1","PixelCheckSum", "0")
        If $val03 = -1 then IniWrite($IniFile, "Rec1","Left_SerchArea", "0")
        If $val04 = -1 then IniWrite($IniFile, "Rec1","Top_SerchArea", "0")
        If $val05 = -1 then IniWrite($IniFile, "Rec1","Right_SerchArea", "100")
        If $val06 = -1 then IniWrite($IniFile, "Rec1","Bottom_SerchArea", "100")
    ;Next
EndFunc

Func _RenderImg($FileBMP, $x, $y)
    $size = _ImageGetSize($FileBMP) ; 0 = width, 1 = height
    $Form1 = GUICreate(" Render VD", $size[0], $size[1], $x, $y, $WS_POPUP)
    GUICtrlCreatePic($FileBMP,0,0,$size[0],$size[1])
    GUISetState(@SW_SHOW)
EndFunc

;===============================================================================
; Function Name:    _PixelCheckSumFindAll
; Description:      Finds all instances of Checksum within a given area and returns array with Total and all locations X and Y.
; Parameters:       $Pixel          Colour value of pixel to find (in decimal or hex).
;                   $chksum         Previously generated checksum value of the region per(PixelChecksum)
;                   $CS_l           left coordinate of rectangle. (amount to subtract)
;                   $CS_t           Top coordinate of rectangle. (amount to subtract)
;                   $CS_r           Right coordinate of rectangle. (amount to add)
;                   $CS_b           Bottom coordinate of rectangle. (amount to add)
;                   $SB_l           left coordinate of total area to search. Default is 0 (far left side of screen)
;                   $SB_t           top coordinate of total area to search. Default is 0 (top most Side of screen)
;                   $SB_r           Right coordinate of total area to search. Default is @DesktopWidth (Far Right side of screen)
;                   $SB_b           Bottom coordinate of total area to search. Default is @DesktopHeight (Bottom most side of screen)
; Syntax:           _PixelCheckSumFindAll($pixel, $chksum, $CS_l, $CS_t, $CS_r, $CS_b[, $SB_l, $SB_t, $SB_r, $SB_b])
; Author(s):        ofLight
; Returns:          $Array[0][0] = 0 on failure, $Array on success
;===============================================================================
Func _PixelCheckSumFindAll($pixel,$chksum,$CS_l,$CS_t,$CS_r,$CS_b,$SB_l=0,$SB_t=0,$SB_r=@DesktopWidth,$SB_b=@DesktopHeight)
    $SB_b_Max = $SB_b
    $SB_l_Max = $SB_l
    Dim $Array[2][2]
    $Array[0][0] = "0"
    $Count = "0"
    While 1
        $xy = PixelSearch($SB_l,$SB_t,$SB_r,$SB_b,$pixel, 0)
        If @error And $SB_b = $SB_b_Max Then
            SetError(1)
            Return $Array
        ElseIf @error Then
            $SB_t = $SB_b + 1
            $SB_b = $SB_b_Max
            $SB_l = $SB_l_Max
        ElseIf $chksum = PixelCheckSum($xy[0]-$CS_l, $xy[1]-$CS_t, $xy[0]+$CS_r, $xy[1]+$CS_B) Then
            $Count = $Count+1
            $Array[0][0] = $Count
            ReDim $Array[$Count+1][2]
            $Array[$Count][0] = $xy[0]
            $Array[$Count][1] = $xy[1]
            $SB_t = $xy[1]
            $SB_b = $SB_t
            $SB_l = $xy[0] + 1
        Else
            $SB_t = $xy[1]
            $SB_b = $SB_t
            $SB_l = $xy[0] + 1
        EndIf
    WEnd
EndFunc

;==========================   Render Image Specific   ==========================
Func _GUICtrlCreateGIF($gif, $x = 0, $y = 0, $border = 0)
    Local $oIE, $GUIActiveX
    Local $a_sizes = _ImageGetSize($gif) ; 0 = width, 1 = height
    $oIE = ObjCreate("Shell.Explorer.2")
    $GUIActiveX = GUICtrlCreateObj($oIE, $x, $y, $a_sizes[0], $a_sizes[1])
    $oIE.navigate ("about:blank")
    While _IEPropertyGet($oIE, "busy")
        Sleep(100)
    WEnd
    $oIE.document.body.background = $gif
    $oIE.document.body.scroll = "no"
    If $border = 0 Then $oIE.document.body.style.border = "0px"
    Return $oIE
EndFunc

Func _ImageGetSize($sFile)
    Local $sHeader = _FileReadAtOffsetHEX($sFile, 1, 24); Get header bytes
    Local $asIdent = StringSplit("FFD8 424D 89504E470D0A1A 4749463839 4749463837 4949 4D4D", " ")
    Local $anSize = ""
    For $i = 1 To $asIdent[0]
        If StringInStr($sHeader, $asIdent[$i]) = 1 Then
            Select
                Case $i = 1; JPEG
                    $anSize = _ImageGetSizeJPG($sFile)
                    ExitLoop
                Case $i = 2; BMP
                    $anSize = _ImageGetSizeSimple($sHeader, 19, 23, 0)
                    ExitLoop
            EndSelect
        EndIf
    Next
    If Not IsArray($anSize) Then SetError(1)
    Return ($anSize)
EndFunc

Func _ImageGetSizeSimple($sHeader, $nXoff, $nYoff, $nByteOrder)
    Local $anSize[2]
    $anSize[0] = _Dec(StringMid($sHeader, $nXoff * 2 - 1, 4), $nByteOrder)
    $anSize[1] = _Dec(StringMid($sHeader, $nYoff * 2 - 1, 4), $nByteOrder)
    Return ($anSize)
EndFunc

Func _FileReadAtOffsetHEX($sFile, $nOffset, $nBytes)
    Local $hFile = FileOpen($sFile, 0)
    Local $sTempStr = ""
    FileRead($hFile, $nOffset - 1)
    For $i = $nOffset To $nOffset + $nBytes - 1
        $sTempStr = $sTempStr & Hex(Asc(FileRead($hFile, 1)), 2)
    Next
    FileClose($hFile)
    Return ($sTempStr)
EndFunc

Func _Dec($sHexStr, $nByteOrder)
    If $nByteOrder Then Return (Dec($sHexStr))
    Local $sTempStr = ""
    While StringLen($sHexStr) > 0
        $sTempStr = $sTempStr & StringRight($sHexStr, 2)
        $sHexStr = StringTrimRight($sHexStr, 2)
    WEnd
    Return (Dec($sTempStr))
EndFunc

Func _ImageGetSizeJPG($sFile)
    Local $anSize[2], $sData, $sSeg, $nFileSize, $nPos = 3
    $nFileSize = FileGetSize($sFile)
    While $nPos < $nFileSize
        $sData = _FileReadAtOffsetHEX($sFile, $nPos, 4)
        If StringLeft($sData, 2) = "FF" Then; Valid segment start
            If StringInStr("C0 C2 CA C1 C3 C5 C6 C7 C9 CB CD CE CF", StringMid($sData, 3, 2)) Then; Segment with size data
                $sSeg = _FileReadAtOffsetHEX($sFile, $nPos + 5, 4)
                $anSize[1] = Dec(StringLeft($sSeg, 4))
                $anSize[0] = Dec(StringRight($sSeg, 4))
                Return ($anSize)
            Else
                $nPos = $nPos + Dec(StringRight($sData, 4)) + 2
            EndIf
        Else
            ExitLoop
        EndIf
    WEnd
    Return ("")
EndFunc