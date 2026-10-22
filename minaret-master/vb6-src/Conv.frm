VERSION 5.00
Begin VB.Form frmConv 
   Caption         =   "Date Conversion"
   ClientHeight    =   6348
   ClientLeft      =   1872
   ClientTop       =   2904
   ClientWidth     =   6972
   BeginProperty Font 
      Name            =   "Arial"
      Size            =   7.8
      Charset         =   178
      Weight          =   700
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   ForeColor       =   &H80000008&
   LinkTopic       =   "Form8"
   MaxButton       =   0   'False
   PaletteMode     =   1  'UseZOrder
   ScaleHeight     =   6348
   ScaleWidth      =   6972
   Begin VB.OptionButton optJul 
      Caption         =   "Julian"
      Height          =   252
      Left            =   1800
      TabIndex        =   2
      Top             =   5760
      Visible         =   0   'False
      Width           =   852
   End
   Begin VB.OptionButton optGreg 
      Caption         =   "Gregorian"
      Height          =   495
      Left            =   480
      TabIndex        =   19
      Top             =   5640
      Value           =   -1  'True
      Visible         =   0   'False
      Width           =   1215
   End
   Begin VB.CommandButton cmdClose 
      Caption         =   "Close"
      Default         =   -1  'True
      Height          =   372
      Left            =   2760
      TabIndex        =   27
      Top             =   5640
      Width           =   1452
   End
   Begin VB.CommandButton cmdH2A 
      Caption         =   "<<"
      Height          =   372
      Left            =   3120
      TabIndex        =   26
      Top             =   3240
      Width           =   732
   End
   Begin VB.CommandButton cmdA2H 
      Caption         =   ">>"
      Height          =   372
      Left            =   3120
      TabIndex        =   25
      Top             =   2400
      Width           =   732
   End
   Begin VB.TextBox txtAHyear 
      Height          =   288
      Left            =   5760
      TabIndex        =   22
      Top             =   3600
      Width           =   732
   End
   Begin VB.TextBox txtAHday 
      Height          =   288
      Left            =   5760
      TabIndex        =   20
      Top             =   2160
      Width           =   492
   End
   Begin VB.Frame Frame2 
      Caption         =   "Hijri"
      Height          =   4812
      Left            =   4200
      TabIndex        =   1
      Top             =   600
      Width           =   2532
      Begin VB.OptionButton optMonthH 
         Caption         =   "Zul Hijja"
         Height          =   252
         Index           =   11
         Left            =   120
         TabIndex        =   18
         Top             =   4320
         Width           =   1332
      End
      Begin VB.OptionButton optMonthH 
         Caption         =   "Zul Qi`da"
         Height          =   252
         Index           =   10
         Left            =   120
         TabIndex        =   17
         Top             =   3960
         Width           =   1332
      End
      Begin VB.OptionButton optMonthH 
         Caption         =   "Shawwal"
         Height          =   252
         Index           =   9
         Left            =   120
         TabIndex        =   16
         Top             =   3600
         Width           =   1332
      End
      Begin VB.OptionButton optMonthH 
         Caption         =   "Ramadan"
         Height          =   252
         Index           =   8
         Left            =   120
         TabIndex        =   15
         Top             =   3240
         Width           =   1332
      End
      Begin VB.OptionButton optMonthH 
         Caption         =   "Sha`ban"
         Height          =   252
         Index           =   7
         Left            =   120
         TabIndex        =   14
         Top             =   2880
         Width           =   1212
      End
      Begin VB.OptionButton optMonthH 
         Caption         =   "Rajab"
         Height          =   252
         Index           =   6
         Left            =   120
         TabIndex        =   13
         Top             =   2520
         Width           =   972
      End
      Begin VB.OptionButton optMonthH 
         Caption         =   "Jumada II"
         Height          =   252
         Index           =   5
         Left            =   120
         TabIndex        =   12
         Top             =   2160
         Width           =   1212
      End
      Begin VB.OptionButton optMonthH 
         Caption         =   "Jumada I"
         Height          =   252
         Index           =   4
         Left            =   120
         TabIndex        =   11
         Top             =   1800
         Width           =   1212
      End
      Begin VB.OptionButton optMonthH 
         Caption         =   "Rabi II"
         Height          =   252
         Index           =   3
         Left            =   120
         TabIndex        =   10
         Top             =   1440
         Width           =   972
      End
      Begin VB.OptionButton optMonthH 
         Caption         =   "Rabi I"
         Height          =   252
         Index           =   2
         Left            =   120
         TabIndex        =   9
         Top             =   1080
         Width           =   972
      End
      Begin VB.OptionButton optMonthH 
         Caption         =   "Safar"
         Height          =   252
         Index           =   1
         Left            =   120
         TabIndex        =   8
         Top             =   720
         Width           =   972
      End
      Begin VB.OptionButton optMonthH 
         Caption         =   "Muharram"
         Height          =   252
         Index           =   0
         Left            =   120
         TabIndex        =   7
         Top             =   360
         Value           =   -1  'True
         Width           =   1332
      End
      Begin VB.Label Label4 
         BackStyle       =   0  'Transparent
         Caption         =   "Year"
         Height          =   252
         Left            =   1560
         TabIndex        =   24
         Top             =   2760
         Width           =   732
      End
      Begin VB.Label Label1 
         BackStyle       =   0  'Transparent
         Caption         =   "Day"
         Height          =   252
         Left            =   1560
         TabIndex        =   23
         Top             =   1320
         Width           =   492
      End
   End
   Begin VB.Frame Frame1 
      Caption         =   "AD"
      Height          =   4812
      Left            =   240
      TabIndex        =   0
      Top             =   600
      Width           =   2532
      Begin VB.OptionButton optMonthA 
         Caption         =   "January"
         Height          =   252
         Index           =   0
         Left            =   120
         TabIndex        =   39
         Top             =   480
         Value           =   -1  'True
         Width           =   1570
      End
      Begin VB.OptionButton optMonthA 
         Caption         =   "February"
         Height          =   252
         Index           =   1
         Left            =   120
         TabIndex        =   38
         Top             =   840
         Width           =   1570
      End
      Begin VB.OptionButton optMonthA 
         Caption         =   "March"
         Height          =   252
         Index           =   2
         Left            =   120
         TabIndex        =   37
         Top             =   1200
         Width           =   972
      End
      Begin VB.OptionButton optMonthA 
         Caption         =   "April"
         Height          =   252
         Index           =   3
         Left            =   120
         TabIndex        =   36
         Top             =   1560
         Width           =   972
      End
      Begin VB.OptionButton optMonthA 
         Caption         =   "May"
         Height          =   252
         Index           =   4
         Left            =   120
         TabIndex        =   35
         Top             =   1920
         Width           =   972
      End
      Begin VB.OptionButton optMonthA 
         Caption         =   "June"
         Height          =   252
         Index           =   5
         Left            =   120
         TabIndex        =   34
         Top             =   2280
         Width           =   972
      End
      Begin VB.OptionButton optMonthA 
         Caption         =   "July"
         Height          =   252
         Index           =   6
         Left            =   120
         TabIndex        =   33
         Top             =   2640
         Width           =   972
      End
      Begin VB.OptionButton optMonthA 
         Caption         =   "August"
         Height          =   252
         Index           =   7
         Left            =   120
         TabIndex        =   32
         Top             =   3000
         Width           =   1212
      End
      Begin VB.OptionButton optMonthA 
         Caption         =   "September"
         Height          =   252
         Index           =   8
         Left            =   120
         TabIndex        =   31
         Top             =   3360
         Width           =   1570
      End
      Begin VB.OptionButton optMonthA 
         Caption         =   "October"
         Height          =   252
         Index           =   9
         Left            =   120
         TabIndex        =   30
         Top             =   3720
         Width           =   1570
      End
      Begin VB.OptionButton optMonthA 
         Caption         =   "November"
         Height          =   252
         Index           =   10
         Left            =   120
         TabIndex        =   29
         Top             =   4080
         Width           =   1570
      End
      Begin VB.OptionButton optMonthA 
         Caption         =   "December"
         Height          =   252
         Index           =   11
         Left            =   120
         TabIndex        =   28
         Top             =   4440
         Width           =   1570
      End
      Begin VB.TextBox txtADyear 
         Height          =   288
         Left            =   1560
         TabIndex        =   6
         Top             =   2880
         Width           =   732
      End
      Begin VB.TextBox txtADday 
         Height          =   288
         Left            =   1560
         TabIndex        =   4
         Top             =   1560
         Width           =   492
      End
      Begin VB.Label lblDOW 
         Alignment       =   1  'Right Justify
         BackStyle       =   0  'Transparent
         Caption         =   "Wednesday"
         Height          =   252
         Left            =   840
         TabIndex        =   21
         Top             =   240
         Width           =   1572
      End
      Begin VB.Label Label3 
         BackStyle       =   0  'Transparent
         Caption         =   "Year"
         Height          =   252
         Left            =   1560
         TabIndex        =   5
         Top             =   2640
         Width           =   612
      End
      Begin VB.Label Label2 
         BackStyle       =   0  'Transparent
         Caption         =   "Day"
         Height          =   252
         Left            =   1560
         TabIndex        =   3
         Top             =   1320
         Width           =   612
      End
   End
   Begin VB.Label lblLoc 
      Alignment       =   2  'Center
      BackStyle       =   0  'Transparent
      Caption         =   "Vancouver, British Columbia"
      Height          =   372
      Left            =   240
      TabIndex        =   40
      Top             =   240
      Width           =   6492
   End
End
Attribute VB_Name = "frmConv"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub cmdA2H_Click()
    Dim i As Integer
    Dim j As Integer
    For i = 0 To 11
        If optMonthA(i).Value Then
            ADMonth = i + 1
            Exit For
        End If
    Next i
    i = RangeCheck(txtADyear, 622, 4503)
    If i <= 0 Then
        Exit Sub
    End If
    ADYear = i
    If ADMonth = 2 Then
        j = 28 + IsLeap(ADYear)
    Else
        j = ndmnth(ADMonth - 1)
    End If
    i = RangeCheck(txtADday, 1, j)
    If i <= 0 Then
        Exit Sub
    End If
    If ADYear = 1582 And ADMonth = 10 And i > 4 And i < 15 Then
        Beep
        txtADday.SetFocus
        txtADday.SelStart = 0
        txtADday.SelLength = 100 'larger than textlen
        Exit Sub
    End If
    ADday = i
    Call X2H(ADYear, ADMonth, ADday, AHYear, AHMonth, AHday, dayOfWeek)
    optMonthH(AHMonth - 1).Value = True
    txtAHyear.Text = AHYear
    txtAHday.Text = AHday
    lblDOW.Caption = weekdayName(dayOfWeek)
End Sub

Private Sub cmdClose_Click()
    Hide
End Sub

Private Sub cmdH2A_Click()
    Dim i As Integer
    Dim j As Integer
    For i = 0 To 11
        If optMonthH(i).Value Then
            AHMonth = i + 1
            Exit For
        End If
    Next i
    i = RangeCheck(txtAHyear, 1, 4000)
    If i <= 0 Then
        Exit Sub
    End If
    AHYear = i
    i = RangeCheck(txtAHday, 1, 30)
    If i <= 0 Then
        Exit Sub
    End If
    AHday = i
    Call H2X(AHYear, AHMonth, AHday, ADYear, ADMonth, ADday, dayOfWeek)
    optMonthA(ADMonth - 1).Value = True
    txtADyear.Text = ADYear
    txtADday.Text = ADday
    'lblDOW.Caption = Format(n, "dddd")
    lblDOW.Caption = weekdayName(dayOfWeek)
End Sub

Private Sub Form_Load()
    top = (Screen.Height - Height) / 2
    Left = (Screen.Width - Width) / 2
End Sub


