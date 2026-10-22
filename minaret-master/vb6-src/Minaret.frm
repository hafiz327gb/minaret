VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Begin VB.MDIForm frmMinaret 
   BackColor       =   &H8000000C&
   Caption         =   "MINARET"
   ClientHeight    =   6444
   ClientLeft      =   1056
   ClientTop       =   2304
   ClientWidth     =   10824
   Icon            =   "Minaret.frx":0000
   LinkTopic       =   "MDIForm1"
   Begin MSComDlg.CommonDialog CMDialog1 
      Left            =   6720
      Top             =   120
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.Menu mnuFil 
      Caption         =   "&File"
      Begin VB.Menu mnuFilNew 
         Caption         =   "&New"
         Shortcut        =   ^N
      End
      Begin VB.Menu mnuFilOpen 
         Caption         =   "&Open..."
         Shortcut        =   ^O
      End
      Begin VB.Menu mnuSep1 
         Caption         =   "-"
      End
      Begin VB.Menu mnuFilExit 
         Caption         =   "E&xit"
      End
   End
   Begin VB.Menu mnuOpt 
      Caption         =   "&Options"
      Begin VB.Menu mnuOptFajr 
         Caption         =   "&Fajr determination method..."
      End
      Begin VB.Menu mnuOptIsha 
         Caption         =   "&Isha determination method..."
      End
      Begin VB.Menu mnuOptAsr 
         Caption         =   "&Asr fiqha preference..."
      End
      Begin VB.Menu mnuOptDisp 
         Caption         =   "&Additional info on non-perpetual schedules..."
      End
   End
   Begin VB.Menu mnuPla 
      Caption         =   "&Location"
      Begin VB.Menu mnuPlaOpen 
         Caption         =   "&Open gazetteer"
      End
      Begin VB.Menu mnuPlaSize 
         Caption         =   "Gazetteer &size"
      End
      Begin VB.Menu mnuPlaRestore 
         Caption         =   "Restore &factory-set gazetteer"
      End
      Begin VB.Menu mnuPlaRead 
         Caption         =   "&Read gazetteer file..."
         Visible         =   0   'False
      End
      Begin VB.Menu mnuPlaWrite 
         Caption         =   "&Write gazetteer file..."
         Visible         =   0   'False
      End
   End
   Begin VB.Menu mnuPra 
      Caption         =   "&Prayer"
      Begin VB.Menu mnuPraDay 
         Caption         =   "Prayer hours for a &day..."
      End
      Begin VB.Menu mnuPraMonth 
         Caption         =   "Prayer schedule for a &month..."
      End
      Begin VB.Menu mnuPraYear 
         Caption         =   "Prayer schedule for a &year..."
      End
      Begin VB.Menu mnuPraHij 
         Caption         =   "Prayer schedule for a &Hijri month..."
      End
   End
   Begin VB.Menu mnuQib 
      Caption         =   "&Qibla"
      Begin VB.Menu mnuQibAngle 
         Caption         =   "&Angle from north"
      End
      Begin VB.Menu mnuQibDay 
         Caption         =   "Shadow Diagram for a &day..."
      End
      Begin VB.Menu mnuQibMonth 
         Caption         =   "Shadow chart for a &month..."
      End
      Begin VB.Menu mnuQibYear 
         Caption         =   "Shadow chart for a &year..."
      End
   End
   Begin VB.Menu mnuCal 
      Caption         =   "&Calendar"
      Begin VB.Menu mnuCalConv 
         Caption         =   "&Date conversion..."
      End
      Begin VB.Menu mnuCalNew 
         Caption         =   "&New moon phase..."
      End
      Begin VB.Menu mnuCalAge 
         Caption         =   "&Moon's age..."
      End
   End
   Begin VB.Menu mnuHel 
      Caption         =   "&Help"
      Begin VB.Menu mnuHelCont 
         Caption         =   "&Contents"
         Shortcut        =   {F1}
      End
      Begin VB.Menu mnuHelIndex 
         Caption         =   "&Search Index for Help On..."
      End
      Begin VB.Menu mnuSep2 
         Caption         =   "-"
      End
      Begin VB.Menu mnuHelAbout 
         Caption         =   "&About..."
      End
   End
End
Attribute VB_Name = "frmMinaret"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Option Explicit

Private Sub MDIForm_Load()
    ' Application starts here (Load event of Startup form).
    Show
    ' Always set working directory to directory containing the application.
    ChDir App.Path
    
    'Initialize document form arrays, and show first document.
    ReDim Document(0)
    ReDim FState(0)
    ''Document(1).Tag = 1
    ''FState(1).Dirty = False
    ''Document(1).Show
    MinaretInit
End Sub

Private Sub MDIForm_QueryUnload(Cancel As Integer, UnloadMode As Integer)
    'in case of control box close command, just hide
    ' the gazetter, so combo box need not be refilled
    If UnloadMode = 0 Then
        If gztDirty <> 0 Then
            Cancel = True
            frmGztSave.Show 1 'modal
        End If
    End If
End Sub

Private Sub MDIForm_Unload(Cancel As Integer)
    ' If the Unload was not canceled (in the QueryUnload events for the Notepad forms)
    ' there will be no document windows left, so go ahead and end the application.

    If Not AnyPadsLeft() Then
        End
    End If

End Sub

Private Sub mnuCalAge_Click()
    Dim n As Date
    Dim h As Integer
    Dim x As Double
    Dim y As Double
    n = Now
    ADYear = Year(n)
    ADMonth = Month(n)
    ADday = Day(n)
    ADhour = Hour(n)
    ADminute = Minute(n)
    frmAge.optMonth(ADMonth - 1).Value = True
    frmAge.txtYear.Text = ADYear
    frmAge.txtDay.Text = ADday
    If ADhour > 12 Then
        frmAge.optAM(1).Value = True
        h = ADhour - 12
    Else
        frmAge.optAM(0).Value = True
        h = ADhour
    End If
    frmAge.txtHour.Text = h
    frmAge.txtMin.Text = ADminute
    x = Age(ADYear, ADMonth, ADday, ADhour, ADminute, dayOfWeek)
    y = Fix(x)
    frmAge.lblDays.Caption = y
    frmAge.lblHours.Caption = Format((x - y) * 24#, "#0.0")
    frmAge.lblDOW.Caption = weekdayName(dayOfWeek)
    frmAge.lblLoc = pname
    frmAge.Show
End Sub

Private Sub mnuCalConv_Click()
    Dim n As Date
    n = Now
    ADYear = Year(n)
    ADMonth = Month(n)
    ADday = Day(n)
    frmConv.optMonthA(ADMonth - 1).Value = True
    frmConv.txtADyear.Text = ADYear
    frmConv.txtADday.Text = ADday
    Call X2H(ADYear, ADMonth, ADday, AHYear, AHMonth, AHday, dayOfWeek)
    frmConv.optMonthH(AHMonth - 1).Value = True
    frmConv.txtAHyear.Text = AHYear
    frmConv.txtAHday.Text = AHday
    frmConv.lblDOW.Caption = weekdayName(dayOfWeek)
    frmConv.lblLoc = pname
    frmConv.Show
End Sub

Private Sub mnuCalNew_Click()
    Dim n As Date
    Dim s As String * 2
    n = Now
    ADYear = Year(n)
    ADMonth = Month(n)
    ADday = Day(n)
    'frmConv.lblDOW.Caption = Format$(n, "dddd")
    Call X2H(ADYear, ADMonth, ADday, AHYear, AHMonth, AHday, dayOfWeek)
    frmNewMoon.optMonth(AHMonth - 1).Value = True
    frmNewMoon.txtYear.Text = AHYear
    ' greenwich time (3rd arg=1)
    Call StartNewMoon(AHYear, AHMonth, 1, ADYear, ADMonth, ADday, ADhour, ADminute)
    frmNewMoon.lblGMT.Caption = monthName(ADMonth) & " " & ADday & ", " & ADYear & ", " & NumToStr(ADhour, 2, ZERO) & ":" & NumToStr(ADminute, 2, ZERO) & " GMT"
    ' local time (3rd arg=0)
    Call StartNewMoon(AHYear, AHMonth, 0, ADYear, ADMonth, ADday, ADhour, ADminute)
    If ADhour > 12 Then
        ADhour = ADhour - 12
        s = " P"
    Else
        s = " A"
    End If
    frmNewMoon.lblZT.Caption = monthName(ADMonth) & " " & NumToStr(ADday, 2, BLANK) & ", " & NumToStr(ADYear, 4, BLANK) & ", " & NumToStr(ADhour, 2, ZERO) & ":" & NumToStr(ADminute, 2, ZERO) & s & "M Zone Time"
    frmNewMoon.lblLoc = pname
    frmNewMoon.Show
End Sub

Private Sub mnuFilExit_Click()
    If gztDirty <> 0 Then
        frmGztSave.Show 1 'modal
    Else
        End
    End If
End Sub

Private Sub mnuFilNew_Click()
    FileNew
End Sub

Private Sub mnuFilOpen_Click()
    Dim OpenFileName As String

    OpenFileName = GetFileName(1)
    If OpenFileName <> "" Then OpenFile (OpenFileName)
End Sub

Private Sub mnuHelAbout_Click()
    frmAbout.Show 1 'modal
End Sub

'Private Sub mnuHlpCont_Click()
    'CMDialog1.HelpFile = "minaret.chm"
    'CMDialog1.HelpCommand = &H3 'HELP_CONTENTS
    'CMDialog1.Action = 6 'Execute WinHelp
      'hWnd is a Long defined elsewhere to be the window handle
      'that will be the parent to the help window.
    'Dim hwndHelp As Long
    'The return value is the window handle of the created help window.
    'hwndHelp = HtmlHelp(hWnd, "minaret.chm", HH_DISPLAY_TOPIC, 0)

'End Sub

Private Sub mnuHelCont_Click()
    Dim hwndHelp As Long
    'The return value is the window handle of the created help window.
    hwndHelp = HtmlHelp(hWnd, helpfile, HH_DISPLAY_TOC, 0&)
End Sub


'Private Sub mnuHelSearch_Click()
    'Dim hwndHelp As Long
    'The return value is the window handle of the created help window.
    'hwndHelp = HtmlHelp(hWnd, helpfile, HH_DISPLAY_SEARCH, 0&)
'End Sub


Private Sub mnuHelIndex_Click()
    Dim hwndHelp As Long
    'The return value is the window handle of the created help window.
    hwndHelp = HtmlHelp(hWnd, helpfile, HH_DISPLAY_INDEX, 0&)
End Sub

Private Sub mnuOptAsr_Click()
    If asrHanafi <> 0 Then
        frmAsr.opt(1).Value = True
    Else
        frmAsr.opt(0).Value = True
    End If
    frmAsr.Show 1
End Sub

Private Sub mnuOptDisp_Click()
    frmDispOpt.chkHijriDate.Value = addHijriDate
    frmDispOpt.chkQiblaTime.Value = addQiblaTime
    frmDispOpt.Show 1
End Sub

Sub mnuOptDST_Click()
End Sub

Private Sub mnuOptFajr_Click()
    If fajrByDepr <> 0 Then
        frmFajr.optDepr.Value = True
    Else
        frmFajr.optInterval.Value = True
    End If
    frmFajr.txtInterval.Text = fajrInterval
    frmFajr.txtDepr.Text = fajrDepr
    'Show
    frmFajr.Show 1 'modal
End Sub

Private Sub mnuOptIsha_Click()
    If ishaByDepr <> 0 Then
        frmIsha.optDepr.Value = True
    Else
        frmIsha.optInterval.Value = True
    End If
    frmIsha.txtInterval.Text = ishaInterval
    frmIsha.txtDepr.Text = ishaDepr
    'Show
    frmIsha.Show 1 'modal
End Sub

Private Sub mnuPlaOpen_Click()
    'InitGazette
    frmGaz.Show
End Sub

Private Sub mnuPlaRead_Click()
    Dim Filename As String

    ' GetFilename(1) for open mode filename
    Filename = GetFileName(1)
    If Filename = "" Then
        Exit Sub
    End If
    Open Filename For Binary As #1
    GetGztData
    Close #1
    InitGazette
    SetCurLocInfo
    gztDirty = 0
    nLocHoles = 0
End Sub

Private Sub mnuPlaRestore_Click()
    frmRestore.Show 1 'modal
End Sub

Private Sub mnuPlaSize_Click()
    frmSize.txtSize.Caption = frmGaz.cboGaz.ListCount
    frmSize.Label1.Caption = "entries at present.  (At most " & MAX_LOC_CNT & " allowed.)"
    frmSize.Show 1 'modal
End Sub

Private Sub mnuPlaWrite_Click()
    Dim Filename As String

    'GetFileName(2) for SaveAs dialog
    Filename = GetFileName(2)
    If Filename = "" Then
        Exit Sub
    End If
    Open Filename For Binary As #2
    PutGztData
    Close #2
End Sub

Private Sub mnuPraDay_Click()
    Dim n As Date
    Dim nday As Integer
    Dim h As Integer
    Dim m As Integer
    Dim pm As Integer
    Dim i As Integer
    n = Now
    ADYear = Year(n)
    ADMonth = Month(n)
    ADday = Day(n)
    frmDay.optMonth(ADMonth - 1).Value = True
    frmDay.txtYear.Text = ADYear
    frmDay.txtDay.Text = ADday
    Call daySchedule(ADday, ADMonth, ADYear, nday, dayOfWeek, tim())
    For i = 0 To 5
        frmDay.lblTime(i).Caption = TimeTo12hr(tim(nday, i), 0)
    Next i
    frmDay.lblDOW.Caption = weekdayName(dayOfWeek)
    frmDay.lblLoc = pname
    frmDay.Show
End Sub

Private Sub mnuPraHij_Click()
    Dim n As Date
    n = Now
    ADYear = Year(n)
    ADMonth = Month(n)
    ADday = Day(n)
    'frmConv.lblDOW.Caption = Format$(n, "dddd")
    Call X2H(ADYear, ADMonth, ADday, AHYear, AHMonth, AHday, dayOfWeek)
    frmHijMonth.optMonth(AHMonth - 1).Value = True
    frmHijMonth.txtYear.Text = AHYear
    frmHijMonth.Show '1 'modal (nomodal, removed by OK proc)
End Sub

Private Sub mnuPraMonth_Click()
    Dim n As Date
    n = Now
    ADYear = Year(n)
    ADMonth = Month(n)
    frmMonth.optMonth(ADMonth - 1).Value = True
    frmMonth.txtYear.Text = ADYear
    frmMonth.Show '1 'modal (nonmodal, remoded by OK proc)
    doingQib = 0
End Sub

Private Sub mnuPraYear_Click()
    Dim n As Date
    n = Now
    ADYear = Year(n)
    frmYear.txtYear.Text = ADYear
    frmYear.Show '1 'modal (Nonmodal, removed by OK proc)
    doingQib = 0
End Sub

Private Sub mnuQibAngle_Click()
    Dim qibd As Integer
    Dim qibm As Integer
    Dim qibsgn As Integer
    Dim msg As String
    Dim x1 As Integer
    Dim X2 As Integer
    Dim y1 As Integer
    Dim Y2 As Integer
    Dim radius As Integer
    Dim wid As Integer
    Dim absqib As Double
    
    'direc = qibla()
    'If direc > 0 Then
       'qibsgn = 1
    'Else
       'qibsgn = 0
    'End If
'  direc = direction of qibla, eastward from north is positive */
    absqib = Abs(direc * DPR)
    qibd = Fix(absqib)
    qibm = round(60# * (absqib - qibd))
    If (qibm >= 60) Then
        qibm = qibm - 60
        qibd = qibd + 1
    End If
    'msg = "Qibla:" & qibd & "deg, " & qibm & "min"
    msg = NumToStr(qibd, 3, BLANK) & Chr(176) & " " & NumToStr(qibm, 2, ZERO) & "'  "
    If direc > 0 Then
        msg = msg & "east"
    Else
        msg = msg & "west"
    End If
    frmAngle.lblAngle = msg
    x1 = 5400
    y1 = 1920
    radius = 1380  ' actually 1320
    X2 = x1 + round(radius * Sin(direc))
    Y2 = y1 - round(radius * Cos(direc))
    frmAngle.linQ.X2 = X2
    frmAngle.linQ.Y2 = Y2
    wid = 380  'TextWidth("Q")=372
    If X2 < x1 Then
        X2 = X2 - wid
    End If
    If Y2 < y1 Then
        Y2 = Y2 - wid
    End If
    frmAngle.lblQ.Left = X2
    frmAngle.lblQ.top = Y2
    frmAngle.lblLoc = pname
    frmAngle.Show 1 'modal
End Sub

Private Sub mnuQibDay_Click()
    Dim n As Date
    n = Now
    ADYear = Year(n)
    ADMonth = Month(n)
    ADday = Day(n)
    frmDiag.optMonth(ADMonth - 1).Value = True
    frmDiag.txtYear.Text = ADYear
    frmDiag.txtDay.Text = ADday
    'daylit aYear, leap, hasDayLt, beginDayLight, endDayLight
    'ndmnth(1) = 28 + leap
    'start = aDay - 1 + ndmnthcum(aMonth - 1)
    'If aMonth > 2 Then
        'start = start + leap
    'End If
    'dow = (((aYear Mod 400) \ 100) * 124 + aYear Mod 100 + (aYear Mod 100) \ 4 - leap + start + 7) Mod 7 + 1
    'computeq aYear, start, start + 1, tim()
    frmDiag.lblLoc = pname
    DrawShadow
End Sub

Private Sub mnuQibMonth_Click()
    Dim n As Date
    n = Now
    ADYear = Year(n)
    ADMonth = Month(n)
    frmMonth.optMonth(ADMonth - 1).Value = True
    frmMonth.txtYear.Text = ADYear
    frmMonth.Show '1 'modal (nonmodal, removed by OK proc)
    doingQib = 1
End Sub

Private Sub mnuQibYear_Click()
    Dim n As Date
    n = Now
    ADYear = Year(n)
    frmYear.txtYear.Text = ADYear
    frmYear.Show '1 'modal (nonmodal, removed by OK proc)
    doingQib = 1
End Sub

Private Sub Picture1_Click()

End Sub


