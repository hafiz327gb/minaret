Attribute VB_Name = "Module4"
Option Explicit

Function Age(ByVal aYear As Integer, ByVal aMonth As Integer, ByVal aDay As Integer, ByVal aHour As Integer, ByVal aMinute As Integer, ByRef dow As Integer) As Double
    Dim augJD As Double
    Dim augJD0 As Double
    Dim lunation As Long
    Dim leap As Integer
    Dim begin1DL As Integer
    Dim end1DL As Integer
    Dim begin2DL As Integer
    Dim end2DL As Integer
    Dim ndays0 As Integer
    
    Call daylit(aYear, leap, hasDayLt, begin1DL, end1DL, begin2DL, end2DL)
    ndays0 = (275 * aMonth) \ 9 + aDay - 30 - ((aMonth + 9) \ 12) * (2 - leap)
    If (begin1DL <= ndays0 And ndays0 <= end1DL Or begin2DL <= ndays0 And ndays0 <= end2DL) Then
        aHour = aHour - 1
    End If
    Call augJulDay(aYear, aMonth, aDay, aHour, aMinute, augJD)
    dow = (1 + Fix(augJD)) Mod 7 + 1
    augJD = augJD - timeZone / 24# ' augJD at Greenwich */
    lunation = Fix((augJD - 2451545.5) * 0.033863107) ' 12.3685/365.25 */
    newmoon lunation, augJD0
    Do While (augJD - augJD0 <= -1#)
        lunation = lunation - 1
        newmoon lunation, augJD0
    Loop
    Age = augJD - augJD0
End Function

Sub augJD2H(ByVal ajD As Double, ByRef yh As Integer, ByRef mh As Integer, ByRef dh As Integer)
    Dim augJD As Double
    Dim augJD0 As Double
    Dim lunation As Long
    Dim n As Long
    
    'augJulDay yx, mx, dx, 0, 0, augJD
    augJD = ajD - timeZone / 24# ' augJD at Greenwich
    'lunation = CLng((augJD - 2451545.5) * .033863107) ' 12.3628/365.25
    lunation = Fix((augJD - 2451545.5) * 0.033863107) ' 12.3628/365.25
    Call newmoon(lunation, augJD0)
    Do While (augJD - augJD0 - CRIT_AGE < 0)
        lunation = lunation - 1
        newmoon lunation, augJD0
    Loop
    'dh = Fix(augJD - augJD0 + .25) ' ceil(augJD-augJD0-0.75) */
    dh = Fix(augJD - augJD0 - CRIT_AGE + 0.99) ' ceil(augJD-augJD0-CRIT_AGE) */
    n = 17049& + lunation
    yh = n \ 12
    mh = n Mod 12 + 1 ' *dh = augJD-augJD0;*/
End Sub

Sub augJulDay(ByVal aYear As Integer, ByVal aMonth As Integer, ByVal aDay As Integer, ByVal aHour As Integer, ByVal aMinute As Integer, ByRef augJD As Double)
    Dim y As Integer
    Dim m As Integer
    Dim a As Integer
    Dim b As Integer
    If (aMonth > 2) Then
        y = aYear
        m = aMonth + 1
    Else
        y = aYear - 1
        m = aMonth + 13
    End If
    augJD = (365& * y + y \ 4 + 30 * m + 3 * m \ 5 + aDay) + (aHour * 60 + aMinute) / 1440# + 1720995#
    If (y > 1583 Or (y = 1582 And ((m > 11) Or (m = 11 And aDay >= 15)))) Then
        a = y \ 100
        b = 2 - a + a \ 4
        augJD = augJD + b
    End If
End Sub

Sub caldat(ByVal augJD As Double, ByRef aYear As Integer, ByRef aMonth As Integer, ByRef aDay As Integer, ByRef aHour As Integer, ByRef aMinute As Integer, ByRef dow As Integer)
    Dim d As Long
    Dim c As Long
    Dim b As Long
    Dim a As Long
    Dim intJD As Long
    Dim e As Integer
    Dim alpha As Integer
    Dim frac As Double
    intJD = Fix(augJD)
    frac = augJD - intJD
    dow = (1 + intJD) Mod 7 + 1
    aHour = Fix(frac * 24#)
    aMinute = Fix((frac * 24# - aHour) * 60# + 0.5)
    If (aMinute >= 60) Then
        aMinute = aMinute - 60
        aHour = aHour + 1
    End If
    If (intJD >= 2299161) Then
        alpha = Fix(((intJD - 1867216) - 0.25) / 36524.25)
        a = intJD + 1 + alpha - alpha \ 4
    Else
        a = intJD
    End If
    b = a + 1524
    c = Fix(6680# + (b - 2439870 - 122.1) / 365.25)
    d = 365 * c + c \ 4
    e = Fix((b - d) / 30.6001)
    aDay = Fix(-30.6001 * e)
    aDay = aDay + b - d
    aMonth = e - 1
    If (aMonth > 12) Then
        aMonth = aMonth - 12
    End If
    aYear = c - 4715
    If (aMonth > 2) Then
        aYear = aYear - 1
    End If
    If (aYear <= 0) Then
        aYear = aYear - 1
    End If
End Sub

Sub daylit(ByVal aYear As Integer, ByRef leap As Integer, ByVal hasDayLt As Integer, ByRef begin1 As Integer, ByRef finish1 As Integer, ByRef begin2 As Integer, ByRef finish2 As Integer)
    Dim m4 As Integer
    Dim m1 As Integer
    Dim jan0 As Integer
    Dim napr1 As Integer
    Dim noct31 As Integer
    Dim apr1 As Integer
    Dim oct31 As Integer
    
    m4 = aYear Mod 400
    m1 = aYear Mod 100
    If aYear Mod 4 <> 0 Or m1 = 0 And m4 <> 0 Then
        leap = 0
    Else
        leap = 1
    End If
    begin2 = 367
    finish2 = 0
    If (hasDayLt = 0) Then
    ' No adjustment for Daylight Saving Time (year zero for perpetual) */
        begin1 = 367
        finish1 = 0
        Exit Sub
    End If
    If (aYear = 0) Then
    ' Daylight Saving Time in perpetual calendar. April 1 thru Oct 31 */
        begin1 = 92 ' April 1, 31+29+31+1 */
        finish1 = begin1 + 213 ' Oct 31, -1+30+31+30+31+31+30+31 */
        Exit Sub
    End If
    ' Non-zero year. for annual calendar */
    ' jan0, apr1, oct31 = day of week on those dates (fri=0, sat=1, sun=2, ...) */
    ' napr1, noct31 = Day no. in year on those dates */
    'If DSTStartDate < 0 Then
        begin1 = NamedDay(aYear, DSTStartMonth, DSTStartDate, DSTStartDOW, DSTStartNum)
    'Else
    'End If
    'If DSTFinDate < 0 Then
        finish1 = -1 + NamedDay(aYear, DSTFinMonth, DSTFinDate, DSTEndDOW, DSTFinNum)
    'Else
    'End If
    If (begin1 > finish1) Then
        begin2 = begin1
        begin1 = 1
        finish2 = 365 + leap
    End If
    'jan0 = ((m4 \ 100) * 124 + 1 + m1 + m1 \ 4 - leap) Mod 7
    'napr1 = 91 + leap ' 31+28+*leap+31+1 */
    'noct31 = 304 + leap ' 365+*leap-31-30 */
    'apr1 = (napr1 + jan0) Mod 7
    'oct31 = (noct31 + jan0) Mod 7
    'begin = napr1 + 2 - apr1
    'If (begin < napr1) Then
        'begin = begin + 7
    'End If
    'finish = noct31 + 2 - oct31
    'If (finish > noct31) Then
        'finish = finish - 7
    'End If
    'finish = finish - 1
End Sub

Function DaysInMonth(ByVal AHYear As Integer, ByVal AHMonth As Integer) As Integer
    Dim ADYear As Integer
    Dim ADMonth As Integer
    Dim ADDay0 As Integer
    Dim dow As Integer
    Dim ajD As Double
    Dim aJD1 As Double

    Call H2X(AHYear, AHMonth, 1, ADYear, ADMonth, ADday, dow)
    Call augJulDay(ADYear, ADMonth, ADday, 0, 0, ajD)
    AHMonth = AHMonth + 1
    If (AHMonth > 12) Then
        AHMonth = 1
        AHYear = AHYear + 1
    End If
    Call H2X(AHYear, AHMonth, 1, ADYear, ADMonth, ADday, dow)
    Call augJulDay(ADYear, ADMonth, ADday, 0, 0, aJD1)
    DaysInMonth = aJD1 - ajD ' - 1
End Function

' -------------------------------------------------------------------- */
'                  Misc. functions                                     */
' -------------------------------------------------------------------- */
Function deg2rad(ByVal degree As Double) As Double
    deg2rad = degree * RPD
End Function

Function dm2deg(ByVal degree As Integer, ByVal aMinute As Integer) As Double
        dm2deg = (CDbl(degree) + aMinute / 60#)
End Function

Function dms2deg(ByVal degree As Long, ByVal aMinute As Integer, ByVal sec As Double) As Double
        dms2deg = CDbl(degree) + aMinute / 60# + sec / 3600#
End Function

Function fmod(ByVal a As Double, ByVal b As Double) As Double
    Dim q As Long
    q = Fix(a / b)
    fmod = a - q * b
End Function

Sub H2X(ByVal yh As Integer, ByVal mh As Integer, ByVal dh As Integer, ByRef yx As Integer, ByRef mx As Integer, ByRef dx As Integer, ByRef dow As Integer)
    Dim lunation As Long
    Dim hr As Integer
    Dim mn As Integer
    Dim augJD As Double
    
    lunation = yh * 12& + mh - 17050&
    Call newmoon(lunation, augJD)
    'caldat(augJD+dh+1.0+timeZone/24.0, yx, mx, dx, &hr, &mn, dow)
        ' Assume that the crescent becomes visible after CRIT_AGE days
    Call caldat(augJD + dh + CRIT_AGE + timeZone / 24#, yx, mx, dx, hr, mn, dow)
End Sub

Function hms2h(ByVal aHour As Integer, ByVal aMinute As Integer, ByVal sec As Double) As Double
    hms2h = CDbl(aHour) + aMinute / 60# + sec / 3600#
End Function

Function NamedDay(ByVal aYear As Integer, ByVal aMonth As Integer, ByVal aDate As Integer, ByVal dow As Integer, ByVal num As Integer) As Integer
' returns serial day of year for such things as 4th of July
'   or 4th Thursday of November.
' aMonth is month, aDate is fixed date, dow is day of week, and num specifies which dow.
' num=0 means last dow of the month
' if aDate is nonpositive, dow is used; else adate is used.
' For dow, fri=0, sat=1, sun=2, ..., sat=6
    Dim m1 As Integer
    Dim m4 As Integer
    Dim leap As Integer
    Dim refDay As Integer
    Dim DOWRefDay As Integer
    Dim k As Integer

    m4 = aYear Mod 400
    m1 = aYear Mod 100
    If aYear Mod 4 <> 0 Or m1 = 0 And m4 <> 0 Then
        leap = 0
    Else
        leap = 1
    End If
    If aDate > 0 Then
        k = ndmnthcum(aMonth - 1) + aDate
        If aMonth > 2 Then
            k = k + leap
        End If
        NamedDay = k
        Exit Function
    End If
    If num > 0 Then
        'refDay to be the day of year on 1st of month
        refDay = ndmnthcum(aMonth - 1) + 1
    Else
        'num=0 means last specified dow of month
        'refDay to be the day of year at the end of month
        refDay = ndmnthcum(aMonth - 1) + ndmnth(aMonth - 1)
    End If
    If aMonth > 2 Then
        refDay = refDay + leap
    End If
    'get day of week on refDay (i.e. 1st or last day of month)
    DOWRefDay = (refDay + (m4 \ 100) * 124 + 1 + m1 + m1 \ 4 - leap) Mod 7
    k = refDay - DOWRefDay + dow
    'k is day of year on 1st or last dow of month.  But it may be off by a week
    If num > 0 Then
        If k < refDay Then
            k = k + 7
        End If
        ' k now is day of year on 1st dow of month
        ' add increment for num'th dow of month
        k = k + (num - 1) * 7
    Else 'num=0, for last dow of month
        If k > refDay Then
            k = k - 7
        End If
    End If
    NamedDay = k
End Function

' Finds the augmented Julian Date (JD+0.5) of the new moon  */
' at Greenwich, counting lunations from 12h, January 1, 2000 */
Sub newmoon(ByVal lunation As Long, ByRef augJD As Double)
    Dim t2 As Double
    Dim t As Double
    Dim eccy As Double
    Dim anomSun As Double
    Dim anomMoon As Double
    Dim latMoon As Double
    Dim longNode As Double
    Dim aS2 As Double
    'dim aS3 As Double
    Dim aM2 As Double
    Dim aM3 As Double
    Dim lM2 As Double

    t = lunation / 1236.85
    t2 = t * t
    eccy = 1 - 0.002516 * t - 0.0000074 * t2
    anomSun = RPD * fmod(2.5534 + 29.10535669 * lunation - (0.0000218 + 0.00000011 * t) * t2, 360#)
    aS2 = anomSun + anomSun
    'aS3 = aS2+anomSun
    anomMoon = RPD * fmod(201.5643 + 385.81693528 * lunation + (0.0107438 + 0.00001239 * t - 0.000000058 * t2) * t2, 360#)
    aM2 = anomMoon + anomMoon
    aM3 = aM2 + anomMoon
    latMoon = RPD * fmod(160.7108 + 390.67050274 * lunation - (0.0016341 + 0.00000227 * t - 0.000000011 * t2) * t2, 360#)
    lM2 = latMoon + latMoon
    longNode = RPD * fmod(124.7746 - 1.5637558 * lunation + (0.0020691 + 0.00000215 * t) * t2, 360#)
    augJD = 2451550.59765 + 29.530588853 * lunation + (0.00011337 - 0.00000015 * t + 0.00000000073 * t2) * t2
    augJD = augJD - 0.4072 * Sin(anomMoon) + 0.17241 * eccy * Sin(anomSun) + 0.01608 * Sin(aM2) + 0.01039 * Sin(lM2) + (0.00739 * Sin(anomMoon - anomSun) - 0.00514 * Sin(anomMoon + anomSun)) * eccy + 0.00208 * eccy * eccy * Sin(aS2) - 0.00111 * Sin(anomMoon - lM2) - 0.00057 * Sin(anomMoon + lM2) + (0.00056 * Sin(aM2 + anomSun) + 0.00042 * Sin(anomSun + lM2) + 0.00038 * Sin(anomSun - lM2) - 0.00024 * Sin(aM2 - anomSun)) * eccy - 0.00042 * Sin(aM3) - 0.00017 * Sin(longNode)
    augJD = augJD + 0.000325 * Sin(RPD * fmod(299.77 + 0.107408 * lunation - 0.009173 * t2, 360#)) + 0.000165 * Sin(RPD * fmod(251.88 + 0.0163218 * lunation, 360#)) + 0.000164 * Sin(RPD * fmod(251.83 + 26.651886 * lunation, 360#)) + 0.000126 * Sin(RPD * fmod(349.42 + 36.412478 * lunation, 360#)) + 0.00011 * Sin(RPD * fmod(84.66 + 18.206239 * lunation, 360#)) + 0.000062 * Sin(RPD * fmod(141.74 + 53.303771 * lunation, 360#)) + 0.00006 * Sin(RPD * fmod(207.14 + 2.453732 * lunation, 360#)) + 0.000056 * Sin(RPD * fmod(154.84 + 7.30686 * lunation, 360#))
End Sub

Function round(ByVal x As Double) As Integer
    If x < 0# Then
        round = Fix(x - 0.5)
    Else
        round = Fix(x + 0.5)
    End If
End Function

Sub StartNewMoon(ByVal yearH As Integer, ByVal monthH As Integer, ByVal greenwich As Integer, aYear As Integer, aMonth As Integer, aDay As Integer, aHour As Integer, aMinute As Integer)
    Dim lunation As Long
    Dim augJD As Double
    Dim leap As Integer
    Dim begin1DayLight As Integer
    Dim end1DayLight As Integer
    Dim begin2DayLight As Integer
    Dim end2DayLight As Integer
    Dim ndays0 As Integer
    Dim dow As Integer

    lunation = yearH * 12& + monthH - 17050&
    newmoon lunation, augJD
    If (greenwich <> 0) Then
        Call caldat(augJD, aYear, aMonth, aDay, aHour, aMinute, dow)
    Else
        Call caldat(augJD + timeZone / 24#, aYear, aMonth, aDay, aHour, aMinute, dow)
        Call daylit(aYear, leap, hasDayLt, begin1DayLight, end1DayLight, begin2DayLight, end2DayLight)
        ndays0 = (275 * aMonth) \ 9 + aDay - 30 - ((aMonth + 9) \ 12) * (2 - leap)
        ' Foll is unsatisfactory for boundary cases */
        If (begin1DayLight <= ndays0 And ndays0 <= end1DayLight Or begin2DayLight <= ndays0 And ndays0 <= end2DayLight) Then
            Call caldat(augJD + (timeZone + 1#) / 24#, aYear, aMonth, aDay, aHour, aMinute, dow)
        End If
    End If
End Sub

Function trunc(ByVal x As Double) As Integer
        'dim   i As Integer
    trunc = Fix(x)
End Function

Sub X2H(ByVal yx As Integer, ByVal mx As Integer, ByVal dx As Integer, ByRef yh As Integer, ByRef mh As Integer, ByRef dh As Integer, ByRef dow As Integer)
    Dim augJD As Double
    Dim augJD0 As Double
    Dim lunation As Long
    Dim n As Long
    
    Call augJulDay(yx, mx, dx, 0, 0, augJD)
    'dow = (1 + CLng(augJD)) Mod 7 + 1
    dow = (1 + Fix(augJD)) Mod 7 + 1
    augJD = augJD - timeZone / 24# ' augJD at Greenwich
    'lunation = CLng((augJD - 2451545.5) * .033863107) ' 12.3628/365.25
    lunation = Fix((augJD - 2451545.5) * 0.033863107) ' 12.3628/365.25
    Call newmoon(lunation, augJD0)
    Do While (augJD - augJD0 - CRIT_AGE < 0)  '(augJD - augJD0 - .75 < 0)
        lunation = lunation - 1
        Call newmoon(lunation, augJD0)
    Loop
    'dh = Fix(augJD - augJD0 + .25)' ceil(augJD-augJD0-0.75) */
    dh = Fix(augJD - augJD0 - CRIT_AGE + 0.99) ' ceil(augJD-augJD0-CRIT_AGE) */
    
    n = 17049& + lunation
    yh = n \ 12
    mh = n Mod 12 + 1 ' *dh = augJD-augJD0;*/
End Sub

