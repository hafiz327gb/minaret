Attribute VB_Name = "Module3"
Option Explicit
Type tm
    tm_sec As Integer
    tm_min As Integer
    tm_hour As Integer
    tm_mday As Integer
    tm_mon As Integer
    tm_year As Integer
    tm_wday As Integer
    tm_yday As Integer
    tm_isdst As Integer
End Type
Type locInfo
    name As String * 29
    namelen As String * 1
    latd As String * 1
    latm As String * 1
    latIsS As String * 1
    longd As String * 1
    longm As String * 1
    longIsW As String * 1
    zoneH As String * 1
    zoneM As String * 1
    zoneIsM As String * 1
    hasDayLt As String * 1
    DSTStartMonth As String * 1
    DSTStartDate As String * 1
    DSTStartNum As String * 1
    DSTStartDOW As String * 1
    DSTFinMonth As String * 1
    DSTFinDate As String * 1
    DSTFinNum As String * 1
    DSTEndDOW As String * 1
End Type
'Type fullInfo
    'site As locInfo
    'asrHanafi As String * 1
    'fajrByInterval As String * 1
    'ishaByInterval As String * 1
    'fajrInterval As String * 1
    'fajrDepr As String * 1
    'ishaInterval As String * 1
    'ishaDepr As String * 1
'End Type

Global Const PI As Double = 3.14159265358979
Global Const HalfPI As Double = 1.5707963267949
Global Const TWOPI As Double = 6.28318530717959
Global Const PI4 As Double = 0.785398163397448
Global Const DPR As Double = 57.2957795130823          ' degree per radian (180/pi) */
Global Const RPD As Double = 1.74532925199433E-02      ' radians per degree (pi/180) */
Global Const HPR As Double = 3.81971863420549          ' hours per radian (12/pi) */
Global Const BLANK = 32 'Asc(" ")
Global Const ZERO = 48 'Asc("0")
Global Const CRIT_AGE As Double = 1.08        '0.25 + Moon's age to start a new month
Global Const LOCINFO_LEN% = 48 'w/o DST info was 40
Global Const FULLINFO_LEN% = 47
Global Const YEARPERP% = 2022 ' was 1994
Global Const LAT_D% = 0
Global Const LAT_M% = 1
Global Const LONG_D% = 2
Global Const LONG_M% = 3
Global Const IS_LAT_S% = 4
Global Const IS_LONG_W% = 5
Global Const ZONE_H% = 6
Global Const ZONE_M% = 7
Global Const IS_ZONE_M% = 8
Global Const HAS_DAYLT% = 9
Global Const ASR_HANAFI% = 0
Global Const FAJR_BY_DEPR% = 1
Global Const ISHA_BY_DEPR% = 2
Global Const FAJR_INTERVAL% = 3
Global Const FAJR_DEPR% = 4
Global Const ISHA_INTERVAL% = 5
Global Const ISHA_DEPR% = 6
Global Const MAX_LOC_CNT% = 900

' Constants related to HTML Help
Global Const HH_DISPLAY_TOPIC = &H0
Global Const HH_DISPLAY_TOC = &H1
Global Const HH_DISPLAY_INDEX = &H2
Global Const HH_DISPLAY_SEARCH = &H3
Global Const HH_HELP_CONTEXT = &HF  ' Display mapped numeric value in
                                    ' dwData.
Declare Function HtmlHelp Lib "hhctrl.ocx" Alias "HtmlHelpA" ( _
         ByVal hwndCaller As Long, ByVal pszFile As String, ByVal _
         uCommand As Long, ByVal dwData As Long) As Long

Global helpfile As String
Global gazetteer As String
Global place(0 To MAX_LOC_CNT - 1) As locInfo
Global locCnt As Integer
Global locHole(0 To 99) As Integer
Global nLocHoles As Integer
Global gztDirty As Integer
Global setting As locInfo
'Global pname As String * 29
Global pname As String
Global namelen As Integer
Global latd As Integer
Global latm As Integer
Global latsgn As Integer
Global longd As Integer
Global longm As Integer
Global longsgn As Integer
Global zonesgn As Integer
Global zoneH As Integer
Global zoneM As Integer
Global hasDayLt As Integer
Global asrHanafi As Integer
Global fajrByDepr As Integer
Global ishaByDepr As Integer
Global fajrInterval As Integer
Global fajrDepr As Integer
Global ishaInterval As Integer
Global ishaDepr As Integer
Global addHijriDate As Integer
Global addQiblaTime As Integer
Global AHYear As Integer
Global AHMonth As Integer
Global AHday As Integer
Global ADYear As Integer
Global ADMonth As Integer
Global ADday As Integer
Global ADhour As Integer
Global ADminute As Integer
Global ampm As Integer
Global dayOfWeek As Integer
Global leap As Integer
Global begin1DayLight As Integer
Global end1DayLight As Integer
Global begin2DayLight As Integer
Global end2DayLight As Integer
Global DSTStartMonth As Integer
Global DSTStartDate As Integer
Global DSTStartNum As Integer
Global DSTStartDOW As Integer
Global DSTFinMonth As Integer
Global DSTFinDate As Integer
Global DSTFinNum As Integer
Global DSTEndDOW As Integer  'DSTFinDOW not accepted by VB4!
Global latitude As Double
Global longitude As Double
Global timeZone As Double
Global direc As Double
Global ndmnth(0 To 11) As Integer
Global ndmnthcum(0 To 11) As Integer
Global weekdayName(1 To 7) As String * 9
Global monthName(1 To 12) As String
Global monthLbl(1 To 12) As String
Global hijriMonthName(1 To 12) As String
Global tim(0 To 365, 0 To 7) As Single
'Global sch As form
Global LF As String * 1
Global NL As String * 2
Global FORMFEED As String * 2
Global BLANKNAME As String * 29
Global LinesPerPage As Integer
Global schTxt As TextBox
Global msg As String
Global doingQib As Integer
'Global Const gazetteer As String = App.Path & "\gazette.dta"
'Declare Function GetTM Lib "d:\test\vb\minaret\minardll.dll" (aTM As Any) As Integer
'Declare Function GetTickCount Lib "User" () As Long
'Declare Sub SetGeog Lib "d:\test\vb\minaret\mindll.dll" (setting As locInfo)
'Declare Sub SetFiqhArg Lib "d:\test\vb\minaret\mindll.dll" (ByVal arg1 As Integer, ByVal val1 As Integer)
'Declare Sub QibDirec Lib "d:\test\vb\minaret\mindll.dll" (qibd As Integer, qibm As Integer, qibsgn As Integer)
'Declare Sub X2H Lib "d:\test\vb\minaret\mindll.dll" (ByVal yx As Integer, ByVal mx As Integer, ByVal dx As Integer, yh As Integer, mh As Integer, dh As Integer, dOW As Integer)
'Declare Sub H2X Lib "d:\test\vb\minaret\mindll.dll" (ByVal yh As Integer, ByVal mh As Integer, ByVal dh As Integer, yx As Integer, mx As Integer, dx As Integer, dOW As Integer)
'Declare Sub daySchedule Lib "d:\test\vb\minaret\mindll.dll" (ByVal aDay As Integer, ByVal aMonth As Integer, ByVal aYear As Integer, start As Integer, dOWeek As Integer, tim As Any)
'Declare Sub monthSchedule Lib "d:\test\vb\minaret\mindll.dll" (ByVal aMonth As Integer, ByVal aYear As Integer, start As Integer, finish As Integer, tim As Any)
'Declare Sub yearSchedule Lib "d:\test\vb\minaret\mindll.dll" (ByVal aYear As Integer, start As Integer, finish As Integer, tim As Any)
'Declare Sub StartNewMoon Lib "d:\test\vb\minaret\mindll.dll" (ByVal yh As Integer, ByVal mh As Integer, greenwich As Integer, yx As Integer, mx As Integer, dx As Integer, hx As Integer, minx As Integer)
'Declare Function Age Lib "d:\test\vb\minaret\mindll.dll" (ByVal aYear As Integer, ByVal aMonth As Integer, ByVal aDay As Integer, ByVal aHour As Integer, ByVal aMinute As Integer) As Double

Function BinSearch(ByVal s As String) As Integer
    Dim top As Integer
    Dim bottom As Integer
    Dim i As Integer
    Dim s1 As String

    top = 0
    bottom = frmGaz.cboGaz.ListCount
    Do Until top > bottom
        i = (top + bottom) \ 2
        s1 = RTrim(frmGaz.cboGaz.List(i))
        If s = s1 Then
            BinSearch = i
            Exit Function
        ElseIf s < s1 Then
            bottom = i - 1
        Else
            top = i + 1
        End If
    Loop
    BinSearch = -1
End Function

Sub GetGztData()
' Read geog data for setting (current location) and
'   place (locs in gazetteer)
    Dim i As Integer
    Dim c As String * 1
    
    ' data for current location
    Get #1, 1, setting
    ' option data for curr loc
    Get #1, , c
    asrHanafi = Asc(c)
    Get #1, , c
    fajrByDepr = Asc(c)
    Get #1, , c
    ishaByDepr = Asc(c)
    Get #1, , c
    fajrInterval = Asc(c)
    Get #1, , c
    fajrDepr = Asc(c)
    Get #1, , c
    ishaInterval = Asc(c)
    Get #1, , c
    ishaDepr = Asc(c)
    ' count of locations in gazetter
    Get #1, , locCnt
    ' skip over 39 pad bytes Chr(255)
    For i = 0 To 38
        Get #1, , c
    Next i
    ' location data from gazetteer
    For i = 0 To locCnt
        Get #1, , place(i)
    Next i
End Sub

Sub InitGazette()
    Dim i As Integer

    frmGaz.cboGaz.Clear
    'Fill combo box
    For i = 0 To locCnt
        frmGaz.cboGaz.AddItem RTrim(place(i).name)
        frmGaz.cboGaz.ItemData(frmGaz.cboGaz.NewIndex) = i
    Next i
    RecallCurrentLoc
End Sub

Function IsLeap(ByVal yr As Integer) As Integer
    If yr Mod 4 <> 0 Or yr Mod 100 = 0 And yr Mod 400 <> 0 Then
        IsLeap = 0
    Else
        IsLeap = 1
    End If
End Function

Sub MinaretInit()
    Dim i As Integer
    For i = 0 To 11
        ndmnth(i) = 31 - i Mod 2 + (i \ 7) * ((i Mod 2) * 2 - 1)
    Next i
    ndmnth(1) = 28
    ndmnthcum(0) = 0
    For i = 1 To 11
        ndmnthcum(i) = ndmnthcum(i - 1) + ndmnth(i - 1)
    Next i
    weekdayName(1) = "Sunday"
    weekdayName(2) = "Monday"
    weekdayName(3) = "Tuesday"
    weekdayName(4) = "Wednesday"
    weekdayName(5) = "Thursday"
    weekdayName(6) = "Friday"
    weekdayName(7) = "Saturday"
    monthName(1) = "January"
    monthName(2) = "February"
    monthName(3) = "March"
    monthName(4) = "April"
    monthName(5) = "May"
    monthName(6) = "June"
    monthName(7) = "July"
    monthName(8) = "August"
    monthName(9) = "September"
    monthName(10) = "October"
    monthName(11) = "November"
    monthName(12) = "December"
    monthLbl(1) = "J A N U A R Y"
    monthLbl(2) = "F E B R U A R Y"
    monthLbl(3) = "M A R C H"
    monthLbl(4) = "A P R I L"
    monthLbl(5) = "M A Y"
    monthLbl(6) = "J U N E"
    monthLbl(7) = "J U L Y"
    monthLbl(8) = "A U G U S T"
    monthLbl(9) = "S E P T E M B E R"
    monthLbl(10) = "O C T O B E R"
    monthLbl(11) = "N O V E M B E R"
    monthLbl(12) = "D E C E M B E R"
    hijriMonthName(1) = "Muharram"
    hijriMonthName(2) = "Safar"
    hijriMonthName(3) = "Rabi I"
    hijriMonthName(4) = "Rabi II"
    hijriMonthName(5) = "Jumada I"
    hijriMonthName(6) = "Jumada II"
    hijriMonthName(7) = "Rajab"
    hijriMonthName(8) = "Sha`ban"
    hijriMonthName(9) = "Ramadan"
    hijriMonthName(10) = "Shawwal"
    hijriMonthName(11) = "Zul Qi`da"
    hijriMonthName(12) = "Zul Hijja"
    LF = Chr(10) ' Linefeed
    NL = Chr(13) & Chr(10) 'Carriage Return & Linefeed
    FORMFEED = Chr(12)
    BLANKNAME = "                             " '29 spaces
    gazetteer = App.Path & "\gazette.dta"
    helpfile = App.Path & "\minaret.chm"
    Open gazetteer For Binary Access Read As #1
    GetGztData
    Close #1
    InitGazette
    SetCurLocInfo
    gztDirty = 0
    nLocHoles = 0
    addHijriDate = 0
    addQiblaTime = 0
    'DSTStartDate = -1
    'DSTStartNum = 1
    'DSTStartDOW = 2
    'DSTStartMonth = 4
    'DSTFinDate = -1
    'DSTFinNum = 0
    'DSTEndDOW = 2
    'DSTFinMonth = 10
    frmWelcome.Show  'non-modal
End Sub

Sub PutGztData()
    Dim i As Integer
    Dim c As String * 1
    Dim lastListIndex As Integer

    ' data for current location
    Put #2, 1, setting
    ' options for curr loc
    c = Chr(asrHanafi)
    Put #2, , c
    c = Chr(fajrByDepr)
    Put #2, , c
    c = Chr(ishaByDepr)
    Put #2, , c
    c = Chr(fajrInterval)
    Put #2, , c
    c = Chr(fajrDepr)
    Put #2, , c
    c = Chr(ishaInterval)
    Put #2, , c
    c = Chr(ishaDepr)
    Put #2, , c
    'Put #2, , locCnt
    'For i = 0 To locCnt
        'Put #2, , place(i)
    'Next i
    ' write location count
    lastListIndex = frmGaz.cboGaz.ListCount - 1
    Put #2, , lastListIndex
    ' write 39 pad bytes
    c = Chr(255)
    For i = 0 To 38
        Put #2, , c
    Next i
    ' write loc data to gazetteer
    For i = 0 To lastListIndex
        Put #2, , place(frmGaz.cboGaz.ItemData(i))
    Next i
End Sub

Function RangeCheck(ByRef cntl As Control, ByVal minval As Integer, ByVal maxval As Integer) As Integer
    Dim i As Integer
    i = Val(cntl.Text)
    If (i < minval Or i > maxval) Then
        cntl.SetFocus
        cntl.SelStart = 0
        cntl.SelLength = 100 'larger than textlen
        Beep
        RangeCheck = -1
    Else
        RangeCheck = i
    End If
End Function

Sub RecallCurrentLoc()
    Dim i As Integer
    'Fill current loc info
    pname = RTrim(setting.name)
    frmGaz.txtCurLoc.Text = pname
    frmGaz.txtName.Text = pname
    frmGaz.txtLatDeg.Text = Asc(setting.latd)
    frmGaz.txtLatMin.Text = Asc(setting.latm)
    If Asc(setting.latIsS) <> 0 Then
        frmGaz.optS.Value = True
    Else
        frmGaz.optN.Value = True
    End If
    frmGaz.txtLongDeg.Text = Asc(setting.longd)
    frmGaz.txtLongMin.Text = Asc(setting.longm)
    If Asc(setting.longIsW) <> 0 Then
        frmGaz.optW.Value = True
    Else
        frmGaz.optE.Value = True
    End If
    If Asc(setting.zoneIsM) <> 0 Then
        frmGaz.optNeg.Value = True
    Else
        frmGaz.optPos.Value = True
    End If
    frmGaz.txtHr.Text = Asc(setting.zoneH)
    frmGaz.txtMin.Text = Asc(setting.zoneM)
    frmGaz.chkDST.Value = Asc(setting.hasDayLt)
    DSTStartMonth = Asc(setting.DSTStartMonth)
    DSTStartDate = Asc(setting.DSTStartDate)
    DSTStartNum = Asc(setting.DSTStartNum)
    DSTStartDOW = Asc(setting.DSTStartDOW)
    DSTFinMonth = Asc(setting.DSTFinMonth)
    DSTFinDate = Asc(setting.DSTFinDate)
    DSTFinNum = Asc(setting.DSTFinNum)
    DSTEndDOW = Asc(setting.DSTEndDOW)
    i = BinSearch(pname)
    If i >= 0 Then
        frmGaz.cboGaz.ListIndex = i
    End If
End Sub

Sub SetCurLocInfo()
    latd = Asc(setting.latd)
    latm = Asc(setting.latm)
    latsgn = Asc(setting.latIsS)
    longd = Asc(setting.longd)
    longm = Asc(setting.longm)
    longsgn = Asc(setting.longIsW)
    zoneH = Asc(setting.zoneH)
    zoneM = Asc(setting.zoneM)
    zonesgn = Asc(setting.zoneIsM)
    hasDayLt = Asc(setting.hasDayLt)
    DSTStartMonth = Asc(setting.DSTStartMonth)
    DSTStartDate = Asc(setting.DSTStartDate)
    DSTStartNum = Asc(setting.DSTStartNum)
    DSTStartDOW = Asc(setting.DSTStartDOW)
    DSTFinMonth = Asc(setting.DSTFinMonth)
    DSTFinDate = Asc(setting.DSTFinDate)
    DSTFinNum = Asc(setting.DSTFinNum)
    DSTEndDOW = Asc(setting.DSTEndDOW)
    latitude = deg2rad(dm2deg(latd, latm))
    If latsgn <> 0 Then
        latitude = -latitude
    End If
    longitude = deg2rad(dm2deg(longd, longm))
    If longsgn <> 0 Then
        longitude = -longitude
    End If
    timeZone = zoneH + zoneM / 60#
    If zonesgn <> 0 Then
        timeZone = -timeZone
    End If
    direc = qibla()
End Sub


Public Function EmptyFieldCheck(ByRef cntl As Control) As Integer
    If StrComp(Trim(cntl.Text), "") = 0 Then
        cntl.SetFocus
        cntl.SelStart = 0
        cntl.SelLength = 100 'larger than textlen
        Beep
        EmptyFieldCheck = True
    Else
        EmptyFieldCheck = False
    End If
End Function
