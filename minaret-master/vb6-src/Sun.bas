Attribute VB_Name = "Module5"
Option Explicit
'static pascal void drawQibla (WindowPtr windPtr, short itemNo)
' compute qibla Diagram for one day. */
'void qibDiagram (void)
'static pascal void drawShadow (WindowPtr windPtr, short itemNo)
'void monthChart (void)
'void yearChart (void)
Dim time0(0 To 5) As Double, coalt(0 To 5) As Double
Dim cosobl As Double
Dim sinobl As Double
Dim dperigee As Double
Dim perigee0 As Double
Dim dmlong As Double
Dim mlong0 As Double
Dim c1 As Double
Dim c2 As Double
Dim delsid As Double
Dim sidtm0 As Double

Function acos(ByVal x As Double) As Double
    'If Abs(x) > 1# Then
        'acos = 0#
    'Else
    If x = -1 Then
        acos = PI
        Exit Function
    Else
        acos = 2 * Atn(Sqr((1 - x) / (1 + x)))
    End If
End Function

Function asin(ByVal x As Double) As Double
    Dim y As Double
    y = Abs(x)
    If y = 1 Then
        asin = HalfPI * x
        Exit Function
    End If
    If y > 0.5 Then
        y = 1 - y
        y = 2 * y - y * y
    Else
        y = 1 - y * y
    End If
    asin = Atn(x / Sqr(y))
End Function

Function atan2(ByVal y As Double, ByVal x As Double) As Double
    Dim z As Double
    If x = 0 Then
        If y = 0 Then
            atan2 = 0
        ElseIf y < 0 Then
            atan2 = -HalfPI
        Else
            atan2 = HalfPI
        End If
        Exit Function
    End If
    z = Atn(y / x)
    If x < 0 Then
        If y < 0 Then
            z = z - PI
        Else
            z = z + PI
        End If
    End If
    atan2 = z
End Function

Sub compute(ByVal aYear As Integer, ByVal first As Integer, ByVal last As Integer, ByRef tim() As Single)
'   compute times for range of days first..last-1.
'   returns 0 if computation was interrupted by pressing CMD-period.
'   returns 1 if computation ended normally.
    Dim coaltn As Double ' time0(0 To 5) As Double, coalt(0 To 5) As Double
    Dim t As Double
    Dim i As Integer
    Dim k As Integer
    Dim l As Integer
    Dim y As Integer
    Const am As Integer = 1
    Const pm As Integer = 0
    
'  0 for year indicates that a perpetual schedule is desired. use 1990 */
    If (aYear = 0) Then
        y = YEARPERP
    Else
        y = aYear
    End If
    computeConstants y
'  approximate times of fajr, shuruq, asr, maghrib, isha
    time0(0) = 4#
    time0(1) = 6#
    time0(3) = 15#
    time0(4) = 18#
    time0(5) = 20#
'  coaltitudes of sun at fajr, shuruq, maghrib, isha */
    coalt(0) = deg2rad(CDbl(90 + fajrDepr))
    coalt(1) = deg2rad(90.83)
    coalt(4) = coalt(1)
    coalt(5) = deg2rad(CDbl(90 + ishaDepr))
'  get approximate times for the first day specified. */
'  later on, each day's times are used as approximate times */
'  for next day */
    t = noontime(first, coaltn)
    coalt(3) = Atn(1 + asrHanafi + Tan(coaltn))
    t = tempus(first, coalt(1), time0(1), am)
    If t < 24# Then
        time0(1) = t
    Else
        time0(1) = 5#
    End If
    t = tempus(first, coalt(3), time0(3), pm)
    If t < 24# Then
        time0(3) = t
    Else
        time0(1) = 15#
    End If
    t = tempus(first, coalt(4), time0(4), pm)
    If t < 24# Then
        time0(1) = t
    Else
        time0(1) = 21#
    End If
    If fajrByDepr <> 0 Then
        t = tempus(first, coalt(0), time0(0), am)
        If t < 24# Then
            time0(0) = t
        Else
            time0(0) = 1#
        End If
    Else
        time0(0) = time0(1) - fajrInterval / 60#
    End If
    If (ishaByDepr <> 0) Then
        t = tempus(first, coalt(5), time0(5), pm)
        If t < 24# Then
            time0(5) = t
        Else
            time0(5) = 23#
        End If
    Else
        time0(5) = time0(4) + ishaInterval / 60#
    End If
    'i = 1
    For l = first To last - 1
    'if (showProgress) putDlgInt(progressDialog, DOING, i);*/
    '  for perpetual calendar, february 29 and march 1 have same times */
        k = l
        If (l > 59 And aYear = 0) Then
            k = l - 1
        End If
        tim(l, 2) = noontime(k + 1, coaltn)
        coalt(3) = Atn(1 + asrHanafi + Tan(coaltn))
        t = tempus(k + 1, coalt(1), time0(1), am)
        tim(l, 1) = t
        If t < 24# Then
            time0(1) = t
        Else
            time0(1) = 5#
        End If
        t = tempus(k + 1, coalt(3), time0(3), pm)
        tim(l, 3) = t
        If t < 24# Then
            time0(3) = t
        Else
            time0(3) = 15#
        End If
        t = tempus(k + 1, coalt(4), time0(4), pm)
        tim(l, 4) = t
        If t < 24# Then
            time0(4) = t
        Else
            time0(4) = 21#
        End If
        If (fajrByDepr <> 0) Then
            t = tempus(k + 1, coalt(0), time0(0), am)
            tim(l, 0) = t
            If t < 24# Then
                time0(0) = t
            Else
                time0(0) = 1#
            End If
        Else
            time0(0) = time0(1) - fajrInterval / 60#
            tim(l, 0) = time0(0)
        End If
        If (ishaByDepr <> 0) Then
            t = tempus(k + 1, coalt(5), time0(5), pm)
            tim(l, 5) = t
            If t < 24# Then
                time0(5) = t
            Else
                time0(5) = 23#
            End If
        Else
            time0(5) = time0(4) + ishaInterval / 60#
            tim(l, 5) = time0(5)
        End If
        'i = i + 1
    Next l
'  correct for daylight saving time */
    If (end1DayLight <> 0) Then
        For i = begin1DayLight - 1 To end1DayLight - 1
            For k = 0 To 5
               tim(i, k) = tim(i, k) + 1#
            Next k
        Next i
    End If
    If (end2DayLight <> 0) Then
        For i = begin2DayLight - 1 To end2DayLight - 1
            For k = 0 To 5
               tim(i, k) = tim(i, k) + 1#
            Next k
        Next i
    End If
End Sub

Sub computeConstants(ByVal yr As Integer)
'
' Computes astro constants for Jan 0 of given year

'  t = time from 12 hr(noon), Jan 1, 2000 to 0 hr, Jan 0 of year */
'           measured in julian centuries (units of 36525 days) */
'  obl = obliquity of ecliptic */
'  eccy = earth's eccentricity */
'  dmlong, dperigee, delsid = daily motion (change) in */
'             sun's mean longitude, longitude of sun's perigee, sidereal time */
'  mlong0, perigee0, sidtm0 = Values (at 0h, Jan 0 of year) of: */
'       sun's mean longitude, longitude of sun's perigee, sidereal time, */
'              all at 0 hr, jan 0 of year year */
'  c1, c2 = coefficients in equation of center */

    Dim t As Double
    Dim obl As Double
    Dim eccy As Double
    Dim aa As Double
    Dim bb As Double
    Dim cc As Double
    t = (((yr - 1) \ 400 - (yr - 1) \ 100 + (yr - 1) \ 4) + 365# * yr - 730485.5) / 36525#
    obl = deg2rad(dms2deg(23&, 26, 21.448) - dms2deg(0&, 0, 46.815) * t)
    cosobl = Cos(obl)
    sinobl = Sin(obl)
    eccy = 0.016708617 - 0.000042037 * t - 0.0000001236 * t * t
    dmlong = deg2rad(36000.7698231 / 36525#)
    mlong0 = deg2rad(fmod(280.466449 - 0.00030368 * t * t + fmod(36000.7698231 * t, 360#), 360#))
    dperigee = deg2rad(1.7195269 / 36525#)
    perigee0 = deg2rad(fmod(282.937348 + 1.7195269 * t + 0.00045962 * t * t, 360#))
    delsid = hms2h(2400, 3, 4.812866) / 36525#
    sidtm0 = fmod(hms2h(6, 41, 50.54841) + fmod(hms2h(2400, 3, 4.812866) * t, 24#), 24#)
    c1 = eccy * (2 - eccy * eccy / 4)
    c2 = 5 * eccy * eccy / 4
End Sub

Sub computeq(ByVal aYear As Integer, ByVal first As Integer, ByVal last As Integer, ByRef tim() As Single)
'   compute times for range of days first..last-1.
'   returns 0 if computation was interrupted by pressing CMD-period.
'   returns 1 if computation ended normally.
    Dim t As Double
    Dim i As Integer
    Dim j As Integer
    Dim k As Integer
    Dim l As Integer
    Dim y As Integer
    
'  0 for year indicates that a perpetual schedule is desired. use 1990 */
    If (aYear = 0) Then
        y = YEARPERP
    Else
        y = aYear
    End If
    computeConstants y
    For l = first To last - 1
    'if (showProgress) putDlgInt(progressDialog, DOING, i);*/
    '  for perpetual calendar, february 29 and march 1 have same times */
        k = l
        If (l > 59 And aYear = 0) Then
            k = l - 1
        End If
        For j = 0 To 7
            tim(l, j) = tshad(k + 1, direc - PI4 * j)
        Next j
    Next l
'  correct for daylight saving time */
    If (end1DayLight <> 0) Then
        For i = begin1DayLight - 1 To end1DayLight - 1
            For k = 0 To 7
               tim(i, k) = tim(i, k) + 1#
            Next k
        Next i
    End If
    If (end2DayLight <> 0) Then
        For i = begin2DayLight - 1 To end2DayLight - 1
            For k = 0 To 7
               tim(i, k) = tim(i, k) + 1#
            Next k
        Next i
    End If
End Sub

Sub computeq1(ByVal aYear As Integer, ByVal first As Integer, ByVal last As Integer, ByRef tim() As Single)
'   compute qibla times for range of days first..last-1,
'   when the shadow is collinear with the qibla.
''   returns 0 if computation was interrupted by pressing CMD-period.
''   returns 1 if computation ended normally.
    Dim t As Double
    Dim i As Integer
    Dim j As Integer
    Dim k As Integer
    Dim l As Integer
    Dim y As Integer
    
'  0 for year indicates that a perpetual schedule is desired. use 1990 */
    If (aYear = 0) Then
        y = YEARPERP
    Else
        y = aYear
    End If
    computeConstants y
    For l = first To last - 1
    'if (showProgress) putDlgInt(progressDialog, DOING, i);*/
    '  for perpetual calendar, february 29 and march 1 have same times */
        k = l
        If (l > 59 And aYear = 0) Then
            k = l - 1
        End If
        tim(l, 6) = tshad(k + 1, direc)
        tim(l, 7) = tshad(k + 1, direc - PI) 'HalfPI)
    Next l
'  correct for daylight saving time */
    If (end1DayLight <> 0) Then
        For i = begin1DayLight - 1 To end1DayLight - 1
            tim(i, 6) = tim(i, 6) + 1#
            tim(i, 7) = tim(i, 7) + 1#
        Next i
    End If
    If (end2DayLight <> 0) Then
        For i = begin2DayLight - 1 To end2DayLight - 1
            tim(i, 6) = tim(i, 6) + 1#
            tim(i, 7) = tim(i, 7) + 1#
        Next i
    End If
End Sub

Sub daySchedule(ByVal aDay As Integer, ByVal aMonth As Integer, ByVal aYear As Integer, ByRef start As Integer, ByRef dow As Integer, ByRef tim() As Single)
' compute schedule for one day.
'  get date from system, if today = 1;
'  via a dialog, if today = 0;
    '  find beginning and ending days for daylight saving time */
    Call daylit(aYear, leap, hasDayLt, begin1DayLight, end1DayLight, begin2DayLight, end2DayLight)
    ndmnth(1) = 28 + leap
    'month= month-1
    start = aDay - 1 + ndmnthcum(aMonth - 1)
    If aMonth > 2 Then
        start = start + leap
    End If
    dow = (((aYear Mod 400) \ 100) * 124 + aYear Mod 100 + (aYear Mod 100) \ 4 - leap + start + 7) Mod 7 + 1
    Call compute(aYear, start, start + 1, tim())
End Sub

Sub display(ByVal aYear As Integer, ByVal first As Integer, ByVal last As Integer, ByVal startdate As Integer)
' print times for range of days first..last-1 */
    Dim AHY As Integer
    Dim AHM As Integer
    Dim AHD As Integer
    Dim ajD As Double
    Dim s As String
    Dim i As Integer
    Dim j As Integer
    Dim l As Integer

    If addHijriDate <> 0 Then
        Call augJulDay(aYear, 1, first, 0, 0, ajD)
    End If
    i = startdate
    msg = ""
    For l = first To last - 1
        msg = msg & "     " & NumToStr(i, 2, BLANK)
        If addHijriDate <> 0 Then
            ajD = ajD + 1
            Call augJD2H(ajD, AHY, AHM, AHD)
            msg = msg & "  " & NumToStr(AHM, 2, ZERO) & "/" & NumToStr(AHD, 2, ZERO) '& " "
        End If
        For j = 0 To 5
            If (j = 2) Then
                msg = msg & " "
            End If
            msg = msg & " " & TimeTo12hr(tim(l, j), 0)
        Next j
        If addQiblaTime <> 0 Then
            ' tim(l,6), tim(l,7) have time for shadow collinear with qibla, opposite
            ' if tim(l,6) not available, print tim(l,7)
            If tim(l, 6) < 0 Or tim(l, 6) > 24# Then
                s = TimeTo12hr(tim(l, 7), 1)
            Else
                s = TimeTo12hr(tim(l, 6), 1)
            End If
            msg = msg & " " & Left(s, 5) & Right(s, 2)
        End If
        msg = msg & NL
        i = i + 1
    Next l
    schTxt.SelText = msg
End Sub

Sub displayAH(ByVal aYear As Integer, ByVal aMonth As Integer, ByVal first As Integer, ByVal last As Integer, ByVal startdate As Integer)
' print times for range of days first..last-1 */
    Dim aHour As Integer, aMinute As Integer
    Dim ADY As Integer
    Dim ADM As Integer
    Dim ADD As Integer
    Dim dow As Integer
    Dim ajD As Double
    Dim s As String
    'Dim t As Double
    Dim i As Integer
    Dim j As Integer
    Dim l As Integer

    Call augJulDay(aYear, 1, first + 1, 0, 0, ajD)
    i = startdate
    msg = ""
    For l = first To last - 1
        msg = msg & "     " & NumToStr(i, 2, BLANK)
        'ajD = ajD + 1
        Call caldat(ajD, ADY, ADM, ADD, aHour, aMinute, dow)
        msg = msg & "  " & NumToStr(ADM, 2, ZERO) & "/" & NumToStr(ADD, 2, ZERO) '& " "
        For j = 0 To 5
            If (j = 2) Then
                msg = msg & " "
            End If
            msg = msg & " " & TimeTo12hr(tim(l, j), 0)
        Next j
        msg = msg & NL
        i = i + 1
        ajD = ajD + 1
    Next l
    schTxt.SelText = msg
End Sub

Sub displayQ(ByVal first As Integer, ByVal last As Integer, ByVal startdate As Integer)
' print times for range of days first..last-1 */
    Dim aHour As Integer
    Dim aMinute As Integer
    'Dim t As Double
    Dim i As Integer
    Dim j As Integer
    Dim l As Integer

    i = startdate
    msg = ""
    For l = first To last - 1
        msg = msg & "  " & NumToStr(i, 2, BLANK)
        For j = 0 To 7
            't = tim(l, j)
            'If (t > 360#) Then
                'msg = msg & "    *  "
            'Else
'  time conversion to a.m. and p.m. hours and rounded minutes */
                'aHour = Fix(t)
                'aMinute = Fix(60# * (t - aHour) + .5)
                'If (aMinute >= 60) Then
                    'aMinute = 0
                    'aHour = aHour + 1
                'End If
                'msg = msg & "  " & NumToStr(aHour, 2, BLANK) & ":" & NumToStr(aMinute, 2, ZERO)
            'End If
            msg = msg & "  " & TimeTo24hr(tim(l, j))
        Next j
        msg = msg & NL
        i = i + 1
    Next l
    schTxt.SelText = msg
End Sub

Sub DrawShadow()
    Dim x1 As Integer
    Dim X2 As Integer
    Dim y1 As Integer
    Dim Y2 As Integer
    Dim radius As Integer
    Dim wid As Integer
    Dim theta As Double
    Dim t As Double
    Dim start As Integer
    Dim j As Integer

    Call daylit(ADYear, leap, hasDayLt, begin1DayLight, end1DayLight, begin2DayLight, end2DayLight)
    ndmnth(1) = 28 + leap
    start = ADday - 1 + ndmnthcum(ADMonth - 1)
    If ADMonth > 2 Then
        start = start + leap
    End If
    Call computeq(ADYear, start, start + 1, tim())
    x1 = 5652 '5646
    y1 = 2892 '2046
    radius = 1386
    'direc = qibla()
    theta = direc + PI4
    For j = 0 To 7
        theta = theta - PI4
        X2 = x1 + round(radius * Sin(theta))
        Y2 = y1 - round(radius * Cos(theta))
        frmDiag.linShad(j).X2 = X2
        frmDiag.linShad(j).Y2 = Y2
        t = tim(start, j)
        If (t > 360#) Then
            frmDiag.lblShad(j).Caption = " "
        Else
            frmDiag.lblShad(j).Caption = TimeTo12hr(t, 1)
            'wid = frmDiag.lblShad(j).Width
            If X2 < x1 Then
                X2 = X2 - 1110  'frmDiag.lblShad(j).Width is 1100
            End If
            If Y2 < y1 Then
                Y2 = Y2 - 262 'height(lbl) is 252
            End If
            frmDiag.lblShad(j).Left = X2
            frmDiag.lblShad(j).top = Y2
        End If
    Next j
    X2 = x1 + round(radius * Sin(direc)) ' * .95
    Y2 = y1 - round(radius * Cos(direc)) ' * .95
    If X2 > x1 Then
        X2 = X2 - 252  'lblQ.Width is 372
    End If
    If Y2 > y1 Then
        Y2 = Y2 - 252  'lblQ.height is 372
    End If
    frmDiag.lblQ.Left = X2
    frmDiag.lblQ.top = Y2
    dayOfWeek = (((ADYear Mod 400) \ 100) * 124 + ADYear Mod 100 + (ADYear Mod 100) \ 4 - leap + start + 7) Mod 7 + 1
    frmDiag.lblDOW = weekdayName(dayOfWeek)
    frmDiag.Show
End Sub

Sub headr(ByVal aMonth As Integer, ByVal aYear As Integer, ByVal hasDayLt As Integer)
'  print header for monthly section ADMonth in schedule */
'  hasDayLt = 1 if daylight saving adjustment done, 0 otherwise */

    Dim i As Integer
    Dim AHY As Integer
    Dim AHM As Integer
    Dim AHD As Integer
    Dim dow As Integer
    
    Call X2H(aYear, aMonth, 1, AHY, AHM, AHD, dow)
    msg = "                 "   ' 17 spaces */
    If addHijriDate <> 0 Then
        msg = msg & "    "
    End If
    If addQiblaTime <> 0 Then
        msg = msg & "    "
    End If
    msg = msg & monthLbl(aMonth) & NL
    If addHijriDate <> 0 Then
        msg = msg & "    "
    End If
    If addQiblaTime <> 0 Then
        msg = msg & "    "
    End If
    If aMonth = 4 And aYear = 0 And hasDayLt <> 0 Then
        msg = msg & "(Before first Sunday, subtract an hour from all times)" & NL
    End If
    If (aMonth = 10 And aYear = 0 And hasDayLt <> 0) Then
        msg = msg & "(After last Saturday, subtract an hour from all times)" & NL
    End If
    'Select Case ADMonth
    'Case 1
        'msg = msg & "J A N U A R Y" & NL
    'Case 2
        'msg = msg & "F E B R U A R Y" & NL
    'Case 3
        'msg = msg & "M A R C H" & NL
    'Case 4
        'msg = msg & "A P R I L" & NL
        'If (aYear = 0 & hasDayLt <> 0) Then
            'msg = msg & "(Before first Sunday, subtract an hour from all times)" & NL
        'End If
    'Case 5
        'msg = msg & "M A Y" & NL
    'Case 6
        'msg = msg & "J U N E" & NL
    'Case 7
        'msg = msg & "J U L Y" & NL
    'Case 8
        'msg = msg & "A U G U S T" & NL
    'Case 9
        'msg = msg & "S E P T E M B E R" & NL
    'Case 10
        'msg = msg & "O C T O B E R" & NL
        'If (aYear = 0 & hasDayLt <> 0) Then
            'msg = msg & "(After last Saturday, subtract an hour from all times)" & NL
        'End If
    'Case 11
        'msg = msg & "N O V E M B E R" & NL
    'Case 12
        'msg = msg & "D E C E M B E R" & NL
    'End Select
    'schTxt.SelText = msg
    msg = msg & NL & "    ----------------------------------------"
    If addHijriDate <> 0 Then
        msg = msg & "-------"
    End If
    If addQiblaTime <> 0 Then
        msg = msg & "--------"
    End If
    msg = msg & NL & "    "
    If addHijriDate <> 0 Then
        msg = msg & "     " & NumToStr(AHY, 4, BLANK) & "H"
    Else
        msg = msg & "   "
    End If
    msg = msg & "  Fajr Shuruq  Zuhr  Asr Maghrib Isha"
    If addQiblaTime <> 0 Then
        msg = msg & "  Shadow"
    End If
    msg = msg & NL & "    Date"
    If addHijriDate <> 0 Then
        msg = msg & "  M/D  "
    End If
    msg = msg & " Dawn Snrise Noon Afnoon Snset Night"
    If addQiblaTime <> 0 Then
        msg = msg & " ToQibla"
    End If
    msg = msg & NL & "    ----------------------------------------"
    If addHijriDate <> 0 Then
        msg = msg & "-------"
    End If
    If addQiblaTime <> 0 Then
        msg = msg & "--------"
    End If
    msg = msg & NL
    schTxt.SelText = msg
End Sub

Sub headrAH(ByVal aMonth As Integer, ByVal aYear As Integer)
'  print header for monthly section n in schedule */
'  hasDayLt = 1 if daylight saving adjustment done, 0 otherwise */

    Dim i As Integer
    Dim ADY As Integer
    Dim ADM As Integer
    Dim ADD As Integer
    Dim dow As Integer
    
    Call H2X(aYear, aMonth, 1, ADY, ADM, ADD, dow)
    msg = "                   "   ' 19 spaces */
    msg = msg & hijriMonthName(aMonth) & " " & aYear & NL
    msg = msg & NL & "    -----------------------------------------------"
    msg = msg & NL & "    "
    msg = msg & "    " & NumToStr(ADY, 4, BLANK) & "AD"
    msg = msg & "  Fajr Shuruq  Zuhr  Asr Maghrib Isha"
    msg = msg & NL & "    Date"
    msg = msg & "  M/D  "
    msg = msg & " Dawn Snrise Noon Afnoon Snset Night"
    msg = msg & NL & "    -----------------------------------------------"
    msg = msg & NL
    schTxt.SelText = msg
End Sub

Sub headrQ(ByVal n As Integer, ByVal aYear As Integer, ByVal hasDayLt As Integer)
'  print header for monthly section n in schedule */
'  hasDayLt = 1 if daylight saving adjustment done, 0 otherwise */

    Dim i As Integer

    msg = "                       "   ' 23 spaces
    Select Case n
    Case 1
        msg = msg & "  "
    Case 2
        msg = msg & " "
    Case 3
        msg = msg & "    "
    Case 4
        msg = msg & "    "
    Case 5
        msg = msg & "      "
    Case 6
        msg = msg & "     "
    Case 7
        msg = msg & "     "
    Case 8
        msg = msg & "   "
    'Case 9
        'msg = msg
    Case 10
        msg = msg & "  "
    Case 11
        msg = msg & " "
    Case 12
        msg = msg & " "
    Case Else
    End Select
    msg = msg & monthLbl(n) & NL
    If (n = 4 And aYear = 0 And hasDayLt <> 0) Then
        msg = msg & "(Before first Sunday, subtract an hour from all times)" & NL
    End If
    If (n = 10 And aYear = 0 And hasDayLt <> 0) Then
        msg = msg & "(After last Saturday, subtract an hour from all times)" & NL
    End If
    'schTxt.SelText = msg
    msg = msg & NL & "  -----------------------------------------------------------" & NL  '60(-)
    msg = msg & "        Angle (degrees) clockwise from shadow to Qibla" & NL
    msg = msg & "  Day   0      45     90    135    180    225    270    315" & NL
    msg = msg & "  -----------------------------------------------------------" & NL  '60(-)
    schTxt.SelText = msg
End Sub

Sub hijriMonthSchedule(ByVal aMonth As Integer, ByVal aYear As Integer, ByRef start As Integer, ByRef finish As Integer, ByRef tim() As Single)
    Dim ADY As Integer
    Dim ADM As Integer
    Dim ADD As Integer
    Dim dow As Integer
    Dim ADYearLength As Integer
' find beginning and ending days for daylight saving time */
    Call H2X(aYear, aMonth, 1, ADY, ADM, ADD, dow)
    Call daylit(ADY, leap, hasDayLt, begin1DayLight, end1DayLight, begin2DayLight, end2DayLight)
    ADYearLength = 365 + leap
    ndmnth(1) = 28 + leap
    start = ndmnthcum(ADM - 1) + ADD - 1
    If ADM > 2 Then
        start = start + leap
    End If
    finish = start + DaysInMonth(aYear, aMonth)
    FileNew
    Call titleAH(pname, aMonth, aYear, direc)
    Call headrAH(aMonth, aYear)
    If finish <= ADYearLength Then
        Call compute(ADY, start, finish, tim())
        Call displayAH(aYear, aMonth, start, finish, 1)
    Else
        Call compute(ADY, start, ADYearLength, tim())
        Call displayAH(aYear, aMonth, start, ADYearLength, 1)
        Call compute(ADY + 1, 0, finish - ADYearLength, tim())
        Call displayAH(aYear, aMonth, 0, finish - ADYearLength, ADYearLength - start + 1)
    End If
    schTxt.SelStart = 0
    schTxt.SelLength = 0
End Sub

Sub monthChart(ByVal aMonth As Integer, ByVal aYear As Integer, ByRef start As Integer, ByRef finish As Integer, ByRef tim() As Single)
' find beginning and ending days for daylight saving time */
    Call daylit(aYear, leap, hasDayLt, begin1DayLight, end1DayLight, begin2DayLight, end2DayLight)
    ndmnth(1) = 28 + leap
    start = ndmnthcum(aMonth - 1)
    If aMonth > 2 Then
        start = start + leap
    End If
    finish = start + ndmnth(aMonth - 1)
    Call computeq(aYear, start, finish, tim())
    FileNew
    Call titleQ(pname, aYear, direc)
    Call headrQ(aMonth, aYear, hasDayLt)
    Call displayQ(start, finish, 1)
    schTxt.SelStart = 0
    schTxt.SelLength = 0
End Sub

Sub monthSchedule(ByVal aMonth As Integer, ByVal aYear As Integer, ByRef start As Integer, ByRef finish As Integer, ByRef tim() As Single)
' find beginning and ending days for daylight saving time */
    Call daylit(aYear, leap, hasDayLt, begin1DayLight, end1DayLight, begin2DayLight, end2DayLight)
    ndmnth(1) = 28 + leap
    start = ndmnthcum(aMonth - 1)
    If aMonth > 2 Then
        start = start + leap
    End If
    finish = start + ndmnth(aMonth - 1)
    Call compute(aYear, start, finish, tim())
    If addQiblaTime <> 0 Then
        Call computeq1(aYear, start, finish, tim())
    End If
    FileNew
    Call title(pname, aYear, direc)
    'title trimName, aYear, direc
    Call headr(aMonth, aYear, hasDayLt)
    Call display(aYear, start, finish, 1)
    schTxt.SelStart = 0
    schTxt.SelLength = 0
End Sub

Function noontime(ByVal nday As Integer, ByRef coaltn As Double) As Double
'  slong, mlong =  sun's true, mean longitude at noon */
'  perigee = longitude of sun's perigee */
'  ra = sun's right ascension, decl = sun's declination */
'  ha = sun's hour angle west */
'  locmt = local mean time of phenomenon */

    Dim t As Double
    Dim longh As Double
    Dim days As Double
    Dim mlong As Double
    Dim perigee As Double
    Dim anomaly As Double
    Dim slong As Double
    Dim sinslong As Double
    Dim ra As Double
    Dim decl As Double
    Dim locmt As Double
    Dim rslt As Double
    longh = longitude * HPR
    days = nday + (12# - longh) / 24#
    mlong = mlong0 + dmlong * days
    perigee = perigee0 + dperigee * days
    anomaly = mlong - perigee
    slong = mlong + c1 * Sin(anomaly) + c2 * Sin(anomaly * 2)
    sinslong = Sin(slong)
    ra = atan2(cosobl * sinslong, Cos(slong)) * HPR
    If (ra < 0#) Then
        ra = ra + 24#
    End If
    decl = asin(sinobl * sinslong)
    locmt = ra - delsid * days - sidtm0
    rslt = locmt - longh + timeZone
    If (rslt < 0#) Then
        rslt = rslt + 24#
    ElseIf (rslt > 24#) Then
        rslt = rslt - 24#
    End If
    coaltn = Abs(latitude - decl)
    noontime = rslt
End Function

Function NumToStr(ByVal n As Integer, ByVal wdth As Integer, ByVal padchar As Integer) As String
    Dim buf As String
    Dim lngth As Integer
    Dim i As Integer
    
    If n < 0 Then
        buf = "-"
        n = -n
    End If
    lngth = 0
    Do
        lngth = lngth + 1
        buf = Chr(48 + n Mod 10) & buf 'digit char
        n = n \ 10
    Loop While n > 0
    lngth = wdth - lngth
    For i = 1 To lngth
        buf = Chr(padchar) & buf
    Next i
    NumToStr = buf
End Function

Function qibla() As Double
' Returns the direction of qibla in radians.
' Eastward from north is positive.
    '  Makkah's latitude = 21d25m21s N, longitude = 39d49m34s E
    '  lat0, long0 are Makkah's latitude and longitude in radians */
    Const lat0 As Double = 0.3738932
    Const long0 As Double = 0.6950968
    Dim dflong As Double
    
    dflong = long0 - longitude
    qibla = atan2(Sin(dflong), Cos(latitude) * Tan(lat0) - Sin(latitude) * Cos(dflong))
End Function

Function solncheck(ByVal sdcl As Double, ByVal slat As Double, ByVal clat As Double, ByVal cosaz As Double, ByVal coalt As Double) As Double
    solncheck = Abs(slat * Cos(coalt) + clat * Sin(coalt) * cosaz - sdcl)
End Function

Function tempus(ByVal nday As Integer, ByVal coalt As Double, ByVal time0 As Double, ByVal am As Integer) As Double
' Returns time on day no. nday of year when sun's coaltitude is coalt.
' If no such time, then returns a large number.
'    time0 is approximate time of phenomenon.
'    am should be 1 if the phenomenon is before noon, 0 otherwise.

'  slong, mlong =  sun's true, mlong longitude */
'  perigee = longitude of sun's perigee */
'  ra = sun's right ascension, sindcl = sin(sun's declination) */
'  ha = sun's hour angle west */
'  locmt = local mean time of phenomenon */

    Dim t As Double
    Dim longh As Double
    Dim days As Double
    Dim mlong As Double
    Dim perigee As Double
    Dim anomaly As Double
    Dim slong As Double
    Dim sinslong As Double
    Dim ra As Double
    Dim sindcl As Double
    Dim cosha As Double
    Dim ha As Double
    Dim locmt As Double
    Dim rslt As Double
    longh = longitude * HPR
    days = nday + (time0 - longh) / 24#
    mlong = mlong0 + dmlong * days
    perigee = perigee0 + dperigee * days
    anomaly = mlong - perigee
    slong = mlong + c1 * Sin(anomaly) + c2 * Sin(anomaly * 2)
    sinslong = Sin(slong)
    ra = atan2(cosobl * sinslong, Cos(slong)) * HPR
    If (ra < 0#) Then
        ra = ra + 24#
    End If
    sindcl = sinobl * sinslong
    cosha = (Cos(coalt) - sindcl * Sin(latitude)) / (Sqr(1# - sindcl * sindcl) * Cos(latitude))
    '  if cos(ha)>1, then time cannot be evaluated */
    If (Abs(cosha) > 1#) Then
        tempus = 10000000#
        Exit Function
    End If
    ha = acos(cosha) * HPR
    If (am <> 0) Then
        ha = 24# - ha
    End If
    locmt = ha + ra - delsid * days - sidtm0
    rslt = locmt - longh + timeZone
    If (rslt < 0#) Then
        rslt = rslt + 24#
    ElseIf (rslt > 24#) Then
        rslt = rslt - 24#
    End If
    tempus = rslt
End Function

Function TimeTo12hr(ByVal t As Double, ByVal ampm As Integer) As String
    Dim h As Integer
    Dim m As Integer
    Dim pm As Integer

    If t < 0 Or t > 360# Then
        TimeTo12hr = "  *  "
    Else
        h = Fix(t)
        m = Fix((t - h) * 60# + 0.5)
        If (m >= 60) Then
            m = 0
            h = h + 1
        End If
        pm = 0
        If h >= 12 Then
            pm = 1
        End If
        If h > 12 Then
            h = h - 12
        End If
        If ampm = 0 Then
            TimeTo12hr = NumToStr(h, 2, BLANK) & ":" & NumToStr(m, 2, ZERO)
        ElseIf pm = 0 Then
            TimeTo12hr = NumToStr(h, 2, BLANK) & ":" & NumToStr(m, 2, ZERO) & " AM"
        Else
            TimeTo12hr = NumToStr(h, 2, BLANK) & ":" & NumToStr(m, 2, ZERO) & " PM"
        End If
    End If
End Function

Function TimeTo24hr(ByVal t As Double) As String
    Dim h As Integer
    Dim m As Integer

    If t < 0 Or t >= 24# Then
        TimeTo24hr = "  *  "
    Else
        h = Fix(t)
        m = Fix((t - h) * 60# + 0.5)
        If (m >= 60) Then
            m = 0
            h = h + 1
        End If
        TimeTo24hr = NumToStr(h, 2, BLANK) & ":" & NumToStr(m, 2, ZERO)
    End If
End Function

Sub title(ByRef aName As String, ByVal aYear As Integer, ByVal direc As Double)
'  print title for schedule */
'  direc = direction of qibla, eastward from north is positive */
    Dim stdabs As Double
    Dim absqib As Double
    Dim qibd As Integer
    Dim qibm As Integer
    Dim sgnlat As String * 1
    Dim sgnlng As String * 1
    Dim sgnstd As String * 1
    Dim sgnqib As String * 1

    If latitude < 0 Then
        sgnlat = "S" 'Dir(3)
    Else
        sgnlat = "N" 'Dir(2)
    End If
    If longitude < 0 Then
        sgnlng = "W" 'Dir(0)
    Else
        sgnlng = "E" 'Dir(1)
    End If
    stdabs = Abs(timeZone)
    If timeZone < 0 Then
        sgnstd = "-"
    Else
        sgnstd = "+"
    End If
    absqib = Abs(direc * DPR)
    qibd = Fix(absqib)
    qibm = Fix(60# * (absqib - qibd) + 0.5)
    If (qibm >= 60) Then
        qibm = 0
        qibd = qibd + 1
    End If
    If direc < 0 Then
        sgnqib = "W" 'Dir(0)
    Else
        sgnqib = "E" 'Dir(1)
    End If
    msg = NL
    If addHijriDate <> 0 Then
        msg = msg & "    "
    End If
    If addQiblaTime <> 0 Then
        msg = msg & "    "
    End If
    If (aYear <> 0) Then
        msg = msg & " " & NumToStr(aYear, 4, BLANK) & " A.D.  Prayer Schedule for " & aName & NL & NL
    Else
        msg = msg & " Perpetual Prayer Schedule for " & aName & NL & NL
    End If
    If addHijriDate <> 0 Then
        msg = msg & "    "
    End If
    If addQiblaTime <> 0 Then
        msg = msg & "    "
    End If
    msg = msg & "   Latitude ="
    msg = msg & NumToStr(latd, 3, BLANK) & Chr(176)
    msg = msg & NumToStr(latm, 2, ZERO) & "' " & sgnlat
    msg = msg & "   Longitude = "
    msg = msg & NumToStr(longd, 3, BLANK) & Chr(176)
    msg = msg & NumToStr(longm, 2, ZERO) & "' " & sgnlng & NL
    If addHijriDate <> 0 Then
        msg = msg & "    "
    End If
    If addQiblaTime <> 0 Then
        msg = msg & "    "
    End If
    msg = msg & " Time = GMT "
    msg = msg & sgnstd & NumToStr(zoneH, 2, BLANK) & "h"
    If (zoneM <> 0) Then
        msg = msg & NumToStr(zoneM, 3, BLANK) & "m"
    End If
    msg = msg & "    Qibla = "
    msg = msg & NumToStr(qibd, 3, BLANK) & Chr(176)
    msg = msg & NumToStr(qibm, 2, ZERO) & "' " & sgnqib & " (From N)" & NL & NL
    schTxt.SelText = msg
End Sub

Sub titleAH(ByRef aName As String, ByVal aYear As Integer, ByVal aMonth As Integer, ByVal direc As Double)
'  print title for schedule */
'  direc = direction of qibla, eastward from north is positive */
'  print title for schedule */
'  direc = direction of qibla, eastward from north is positive */
    Dim stdabs As Double
    Dim absqib As Double
    Dim qibd As Integer
    Dim qibm As Integer
    Dim sgnlat As String * 1
    Dim sgnlng As String * 1
    Dim sgnstd As String * 1
    Dim sgnqib As String * 1

    If latitude < 0 Then
        sgnlat = "S" 'Dir(3)
    Else
        sgnlat = "N" 'Dir(2)
    End If
    If longitude < 0 Then
        sgnlng = "W" 'Dir(0)
    Else
        sgnlng = "E" 'Dir(1)
    End If
    stdabs = Abs(timeZone)
    If timeZone < 0 Then
        sgnstd = "-"
    Else
        sgnstd = "+"
    End If
    absqib = Abs(direc * DPR)
    qibd = Fix(absqib)
    qibm = Fix(60# * (absqib - qibd) + 0.5)
    If (qibm >= 60) Then
        qibm = 0
        qibd = qibd + 1
    End If
    If direc < 0 Then
        sgnqib = "W" 'Dir(0)
    Else
        sgnqib = "E" 'Dir(1)
    End If
    msg = "          "
    msg = msg & "Prayer Schedule for " & aName & NL & NL
    msg = msg & "       Latitude ="
    msg = msg & NumToStr(latd, 3, BLANK) & Chr(176)
    msg = msg & NumToStr(latm, 2, ZERO) & "' " & sgnlat
    msg = msg & "   Longitude = "
    msg = msg & NumToStr(longd, 3, BLANK) & Chr(176)
    msg = msg & NumToStr(longm, 2, ZERO) & "' " & sgnlng & NL
    msg = msg & "     Time = GMT "
    msg = msg & sgnstd & NumToStr(zoneH, 2, BLANK) & "h"
    If (zoneM <> 0) Then
        msg = msg & NumToStr(zoneM, 3, BLANK) & "m"
    End If
    msg = msg & "    Qibla = "
    msg = msg & NumToStr(qibd, 3, BLANK) & Chr(176)
    msg = msg & NumToStr(qibm, 2, ZERO) & "' " & sgnqib & " (From N)" & NL & NL
    schTxt.SelText = msg
End Sub

Sub titleQ(ByRef aName As String, ByVal aYear As Integer, ByVal direc As Double)
'  print title for schedule */
'  direc = direction of qibla, eastward from north is positive */
    Dim stdabs As Double
    Dim absqib As Double
    Dim qibd As Integer
    Dim qibm As Integer
    Dim sgnlat As String * 1
    Dim sgnlng As String * 1
    Dim sgnstd As String * 1
    Dim sgnqib As String * 1

    If latitude < 0 Then
        sgnlat = "S" 'Dir(3)
    Else
        sgnlat = "N" 'Dir(2)
    End If
    If longitude < 0 Then
        sgnlng = "W" 'Dir(0)
    Else
        sgnlng = "E" 'Dir(1)
    End If
    stdabs = Abs(timeZone)
    If timeZone < 0 Then
        sgnstd = "-"
    Else
        sgnstd = "+"
    End If
    absqib = Abs(direc * DPR)
    qibd = Fix(absqib)
    qibm = Fix(60# * (absqib - qibd) + 0.5)
    If (qibm >= 60) Then
        qibm = 0
        qibd = qibd + 1
    End If
    If direc < 0 Then
        sgnqib = "W" 'Dir(0)
    Else
        sgnqib = "E" 'Dir(1)
    End If
    If (aYear <> 0) Then
        msg = NL & "        " & NumToStr(aYear, 4, BLANK) & " A.D.  Qibla Indicator for " & aName & NL & NL
    Else
        msg = NL & "      Perpetual Qibla Indicator for " & aName & NL & NL
    End If
    msg = msg & "         Latitude ="
    msg = msg & NumToStr(latd, 3, BLANK) & Chr(176)
    msg = msg & NumToStr(latm, 2, ZERO) & "' " & sgnlat
    msg = msg & "    Longitude = "
    msg = msg & NumToStr(longd, 3, BLANK) & Chr(176)
    msg = msg & NumToStr(longm, 2, ZERO) & "' " & sgnlng & NL
    msg = msg & "     Zone Time = GMT "
    msg = msg & sgnstd & NumToStr(zoneH, 2, BLANK) & "h"
    If (zoneM <> 0) Then
        msg = msg & NumToStr(zoneM, 3, BLANK) & "m"
    End If
    msg = msg & "    Qibla = "
    msg = msg & NumToStr(qibd, 3, BLANK) & Chr(176)
    msg = msg & NumToStr(qibm, 2, ZERO) & "' " & sgnqib & " (From N)" & NL & NL
    msg = msg & "Time when Qibla is at given angle to shadow of vertical object" & NL
    msg = msg & "            (* indicates no such time on that day)" & NL & NL
    schTxt.SelText = msg
End Sub

Function tshad(ByVal nday As Integer, ByVal bearing As Double) As Double
'  returns time on day no. nday of year when the shadow of */
'  a vertical object has a given bearing clockwise to North. */
'  if no such time, then returns a large number. */
'  slong =  true longitude */
'  ra = sun's right ascension, sindcl = sin(sun's declination) */
'  ha = sun's hour angle west */
'  locmt = local mean time of phenomenon */

    Dim longh As Double
    Dim days As Double
    Dim mlong As Double
    Dim perigee As Double
    Dim anomaly As Double
    Dim slong As Double
    Dim sinslong As Double
    Dim ra As Double
    Dim sindcl As Double
    Dim cosha As Double
    Dim ha As Double
    Dim locmt As Double
    Dim azimuth As Double
    Dim sinlat As Double
    Dim time0 As Double
    Dim coalt1 As Double
    Dim coalt2 As Double
    Dim coalt As Double
    Dim rslt As Double
    Dim sinaz As Double
    Dim cosaz As Double
    Dim cosdcl As Double
    Dim coslat As Double
    Dim sinq As Double
    Dim cosq As Double
    Dim denom As Double
    Dim maxcoalt As Double
    Dim q1 As Double
    Dim q2 As Double
    Dim decl As Double
'   tshad = 1.0e7
'  First make sun's azimuth between 0 and 360 degrees, then */
'  between -180 and +180.  If azimuth is positive, time is AM, else PM. */
'  Approximate times are 8 AM and 4 PM. */
'  Coalt is 90.83deg for sunrise/set. Allow upto 80deg for shadow observation
    maxcoalt = 80# * RPD
    azimuth = fmod(bearing + TWOPI + PI, TWOPI)
    time0 = 8#
    If (azimuth >= PI) Then
        azimuth = TWOPI - azimuth
        time0 = 16#
    End If
    longh = longitude * HPR
    days = nday + (time0 - longh) / 24#
    mlong = mlong0 + dmlong * days
    perigee = perigee0 + dperigee * days
    anomaly = mlong - perigee
    slong = mlong + c1 * Sin(anomaly) + c2 * Sin(anomaly * 2)
    sinslong = Sin(slong)
    ra = atan2(cosobl * sinslong, Cos(slong)) * HPR
    If (ra < 0#) Then
        ra = ra + 24#
    End If
    sindcl = sinobl * sinslong
    ' -90 < decl < 90, so cosdcl nonnegative
    cosdcl = Sqr(1 - sindcl * sindcl)
    sinlat = Sin(latitude)
    ' -90 < latitude < 90, so coslat nonnegative
    coslat = Sqr(1 - sinlat * sinlat)
    decl = asin(sindcl)
    sinaz = Sin(azimuth)
    cosaz = Cos(azimuth)
    sinq = sinaz * coslat / cosdcl  ' always nonnegative
    If sinq > 1# Then   'sin of sph angle always > 0
        tshad = 1000#
        Exit Function
    End If
'  Get possibly two values of coalt.  Select the larger one so */
'  that we have coalt <= 90.83 (i.e. sun above horizon). */
    q1 = asin(sinq)
    q2 = PI - q1
    cosq = Cos(q1)
    denom = 1 - coslat * coslat * sinaz * sinaz
    If (decl > latitude And q1 <= azimuth Or decl = latitude And q1 <> azimuth Or decl < latitude And q1 >= azimuth) Then
        coalt1 = 1000#
    Else
        coalt1 = acos((sindcl * sinlat - cosdcl * coslat * cosaz * cosq) / denom)
    End If
    'q2 = PI - q1
    If (decl > latitude And q2 <= azimuth Or decl = latitude And q2 <> azimuth Or decl < latitude And q2 >= azimuth) Then
        coalt2 = 1000#
    Else
        'for q2 = PI-q1, cos(q2) = -cos(q1)
        coalt2 = acos((sindcl * sinlat + cosdcl * coslat * cosaz * cosq) / denom)
    End If
    'temp = solncheck(sindcl, sinlat, coslat, cosaz, coalt1)
    'If (temp > .1) Then  'solution not acceptable
        'coalt1 = 1000#
    'End If
    'temp = solncheck(sindcl, sinlat, coslat, cosaz, coalt2)
    'If (temp > .1) Then  'solution not acceptable
        'coalt2 = 1000#
    'End If
    'Check if there exists an admissible value of coalt
    If (coalt1 > maxcoalt And coalt2 > maxcoalt) Then
        tshad = 1000#
        Exit Function
    End If
    'At least one of coalt1 and coalt2 is admissible
    'choose coalt to be the larger of the admissible values
    If coalt2 > maxcoalt Then
        coalt = coalt1
    ElseIf coalt1 > maxcoalt Then
        coalt = coalt2
    ElseIf coalt1 > coalt2 Then
        coalt = coalt1
    Else
        coalt = coalt2
    End If
    'temp = solncheck(sindcl, sinlat, coslat, cosaz, coalt)
    'If (temp > .1) Then  'solution not acceptable
        'Exit Function
    'End If
    cosha = (Cos(coalt) - sindcl * sinlat) / (cosdcl * coslat)
'  if cos(ha)>1, then time cannot be evaluated */
    If (Abs(cosha) > 1#) Then
        tshad = 1000#
        Exit Function
    End If
    ha = acos(cosha) * HPR
    If (time0 < 12#) Then
        ha = 24# - ha
    End If
    locmt = ha + ra - delsid * days - sidtm0
    rslt = locmt - longh + timeZone
    If (rslt < 0#) Then
        rslt = rslt + 24#
    ElseIf (rslt > 24#) Then
        rslt = rslt - 24#
    End If
    tshad = rslt
End Function

Sub yearChart(ByVal aYear As Integer, ByRef start As Integer, ByRef finish As Integer, ByRef tim() As Single)
'  find beginning and ending days for daylight saving time */
    Dim i As Integer
    Call daylit(aYear, leap, hasDayLt, begin1DayLight, end1DayLight, begin2DayLight, end2DayLight)
    ndmnth(1) = 28 + leap
'  schedule making
    Call computeq(aYear, 0, 365 + leap, tim())
    FileNew
    start = 0
    For i = 1 To 12
        If (i <> 1) Then
            schTxt.SelText = FORMFEED
        End If
        Call titleQ(pname, aYear, direc)
        Call headrQ(i, aYear, hasDayLt)
        finish = start + ndmnth(i - 1)
        Call displayQ(start, finish, 1)
        start = finish
    Next i
    schTxt.SelStart = 0
    schTxt.SelLength = 0
End Sub

Sub yearSchedule(ByVal aYear As Integer, ByRef start As Integer, ByRef finish As Integer, ByRef tim() As Single)
'  find beginning and ending days for daylight saving time */
    Dim i As Integer
    Dim oldAddHijriDate  As Integer

    If aYear = 0 Then 'perpetual schedule
        oldAddHijriDate = addHijriDate
        addHijriDate = 0
    End If
    Call daylit(aYear, leap, hasDayLt, begin1DayLight, end1DayLight, begin2DayLight, end2DayLight)
    ndmnth(1) = 28 + leap
'  schedule making
    Call compute(aYear, 0, 365 + leap, tim())
    If addQiblaTime <> 0 Then
        Call computeq1(aYear, 0, 365 + leap, tim())
    End If
    FileNew
    start = 0
    For i = 1 To 12
        If (i <> 1) Then
            schTxt.SelText = FORMFEED
        End If
        Call title(pname, aYear, direc)
        Call headr(i, aYear, hasDayLt)
        finish = start + ndmnth(i - 1)
        Call display(aYear, start, finish, 1)
        start = finish
    Next i
    schTxt.SelStart = 0
    schTxt.SelLength = 0
    If aYear = 0 Then 'perpetual schedule
        addHijriDate = oldAddHijriDate
    End If
End Sub

