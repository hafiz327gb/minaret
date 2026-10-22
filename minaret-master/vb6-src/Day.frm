VERSION 5.00
Begin VB.Form frmDay 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Prayer Hours for a Day"
   ClientHeight    =   5544
   ClientLeft      =   1620
   ClientTop       =   2136
   ClientWidth     =   7392
   BeginProperty Font 
      Name            =   "Arial"
      Size            =   8.4
      Charset         =   178
      Weight          =   700
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   ForeColor       =   &H80000008&
   LinkTopic       =   "Form2"
   PaletteMode     =   1  'UseZOrder
   ScaleHeight     =   5544
   ScaleWidth      =   7392
   Begin VB.CommandButton cmdClose 
      Caption         =   "Close"
      Height          =   492
      Left            =   5520
      TabIndex        =   15
      Top             =   4200
      Width           =   1092
   End
   Begin VB.CommandButton cmdCompute 
      Caption         =   "Recompute"
      Height          =   492
      Left            =   3600
      TabIndex        =   14
      Top             =   4200
      Width           =   1212
   End
   Begin VB.Frame Frame 
      Caption         =   "Prayer hours"
      Height          =   3372
      Index           =   1
      Left            =   3480
      TabIndex        =   32
      Top             =   240
      Width           =   3492
      Begin VB.Label lblLoc 
         Alignment       =   2  'Center
         BackStyle       =   0  'Transparent
         Caption         =   "Vancouver, British Columbia"
         Height          =   372
         Left            =   240
         TabIndex        =   27
         Top             =   360
         Width           =   3012
      End
      Begin VB.Label lblTime 
         BorderStyle     =   1  'Fixed Single
         Height          =   252
         Index           =   5
         Left            =   2280
         TabIndex        =   31
         Top             =   2880
         Width           =   972
      End
      Begin VB.Label lblTime 
         BorderStyle     =   1  'Fixed Single
         Height          =   252
         Index           =   4
         Left            =   2280
         TabIndex        =   16
         Top             =   2520
         Width           =   972
      End
      Begin VB.Label lblTime 
         BorderStyle     =   1  'Fixed Single
         Height          =   252
         Index           =   3
         Left            =   2280
         TabIndex        =   17
         Top             =   2160
         Width           =   972
      End
      Begin VB.Label lblTime 
         BorderStyle     =   1  'Fixed Single
         Height          =   252
         Index           =   2
         Left            =   2280
         TabIndex        =   18
         Top             =   1800
         Width           =   972
      End
      Begin VB.Label lblTime 
         BorderStyle     =   1  'Fixed Single
         Height          =   252
         Index           =   1
         Left            =   2280
         TabIndex        =   19
         Top             =   1440
         Width           =   972
      End
      Begin VB.Label lblTime 
         BorderStyle     =   1  'Fixed Single
         Height          =   252
         Index           =   0
         Left            =   2280
         TabIndex        =   20
         Top             =   1080
         Width           =   972
      End
      Begin VB.Label Label3 
         Caption         =   "`isha (night)"
         Height          =   252
         Index           =   5
         Left            =   240
         TabIndex        =   21
         Top             =   2880
         Width           =   1812
      End
      Begin VB.Label Label3 
         Caption         =   "maghrib (sunset)"
         Height          =   252
         Index           =   4
         Left            =   240
         TabIndex        =   22
         Top             =   2520
         Width           =   1812
      End
      Begin VB.Label Label3 
         Caption         =   "`asr (afternoon)"
         Height          =   252
         Index           =   3
         Left            =   240
         TabIndex        =   23
         Top             =   2160
         Width           =   1812
      End
      Begin VB.Label Label3 
         Caption         =   "zuhr (noon)"
         Height          =   252
         Index           =   2
         Left            =   240
         TabIndex        =   24
         Top             =   1800
         Width           =   1812
      End
      Begin VB.Label Label3 
         Caption         =   "shuruq (sunrise)"
         Height          =   252
         Index           =   1
         Left            =   240
         TabIndex        =   25
         Top             =   1440
         Width           =   1812
      End
      Begin VB.Label Label3 
         Caption         =   "fajr (dawn)"
         Height          =   252
         Index           =   0
         Left            =   240
         TabIndex        =   26
         Top             =   1080
         Width           =   1812
      End
   End
   Begin VB.Frame Frame 
      Caption         =   "Date"
      Height          =   5052
      Index           =   0
      Left            =   360
      TabIndex        =   28
      Top             =   240
      Width           =   2772
      Begin VB.TextBox txtDay 
         Height          =   288
         Left            =   1560
         TabIndex        =   12
         Top             =   1560
         Width           =   492
      End
      Begin VB.TextBox txtYear 
         Height          =   288
         Left            =   1560
         TabIndex        =   13
         Top             =   2880
         Width           =   732
      End
      Begin VB.OptionButton optMonth 
         Caption         =   "December"
         Height          =   252
         Index           =   11
         Left            =   120
         TabIndex        =   11
         Top             =   4560
         Width           =   1452
      End
      Begin VB.OptionButton optMonth 
         Caption         =   "November"
         Height          =   252
         Index           =   10
         Left            =   120
         TabIndex        =   10
         Top             =   4200
         Width           =   1452
      End
      Begin VB.OptionButton optMonth 
         Caption         =   "October"
         Height          =   252
         Index           =   9
         Left            =   120
         TabIndex        =   9
         Top             =   3840
         Width           =   1212
      End
      Begin VB.OptionButton optMonth 
         Caption         =   "September"
         Height          =   252
         Index           =   8
         Left            =   120
         TabIndex        =   8
         Top             =   3480
         Width           =   1572
      End
      Begin VB.OptionButton optMonth 
         Caption         =   "August"
         Height          =   252
         Index           =   7
         Left            =   120
         TabIndex        =   7
         Top             =   3120
         Width           =   972
      End
      Begin VB.OptionButton optMonth 
         Caption         =   "July"
         Height          =   252
         Index           =   6
         Left            =   120
         TabIndex        =   6
         Top             =   2760
         Width           =   972
      End
      Begin VB.OptionButton optMonth 
         Caption         =   "June"
         Height          =   252
         Index           =   5
         Left            =   120
         TabIndex        =   5
         Top             =   2400
         Width           =   972
      End
      Begin VB.OptionButton optMonth 
         Caption         =   "May"
         Height          =   252
         Index           =   4
         Left            =   120
         TabIndex        =   4
         Top             =   2040
         Width           =   972
      End
      Begin VB.OptionButton optMonth 
         Caption         =   "April"
         Height          =   252
         Index           =   3
         Left            =   120
         TabIndex        =   3
         Top             =   1680
         Width           =   972
      End
      Begin VB.OptionButton optMonth 
         Caption         =   "March"
         Height          =   252
         Index           =   2
         Left            =   120
         TabIndex        =   2
         Top             =   1320
         Width           =   972
      End
      Begin VB.OptionButton optMonth 
         Caption         =   "February"
         Height          =   252
         Index           =   1
         Left            =   120
         TabIndex        =   1
         Top             =   960
         Width           =   1332
      End
      Begin VB.OptionButton optMonth 
         Caption         =   "January"
         Height          =   252
         Index           =   0
         Left            =   120
         TabIndex        =   0
         Top             =   600
         Value           =   -1  'True
         Width           =   1332
      End
      Begin VB.Label lblDOW 
         Alignment       =   1  'Right Justify
         BackStyle       =   0  'Transparent
         Caption         =   "Wednesday"
         Height          =   252
         Left            =   1080
         TabIndex        =   33
         Top             =   240
         Width           =   1452
      End
      Begin VB.Label Label1 
         BackStyle       =   0  'Transparent
         Caption         =   "Day"
         Height          =   252
         Index           =   0
         Left            =   1560
         TabIndex        =   30
         Top             =   1320
         Width           =   612
      End
      Begin VB.Label Label1 
         BackStyle       =   0  'Transparent
         Caption         =   "Year"
         Height          =   252
         Index           =   1
         Left            =   1560
         TabIndex        =   29
         Top             =   2640
         Width           =   612
      End
   End
End
Attribute VB_Name = "frmDay"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub cmdClose_Click()
    Hide
End Sub

Private Sub cmdCompute_Click()
    Dim i As Integer
    Dim j As Integer
    Dim nday As Integer
    Dim h As Integer
    Dim m As Integer
    Dim pm As Integer
    For i = 0 To 11
        If optMonth(i).Value Then
            ADMonth = i + 1
            Exit For
        End If
    Next i
    i = RangeCheck(txtYear, 1901, 2200)
    If i <= 0 Then
        Exit Sub
    End If
    ADYear = i
    If ADMonth = 2 Then
        j = 28 + IsLeap(ADYear)
    Else
        j = ndmnth(ADMonth - 1)
    End If
    i = RangeCheck(txtDay, 1, j)
    If i <= 0 Then
        Exit Sub
    End If
    ADday = i
    Call daySchedule(ADday, ADMonth, ADYear, nday, dayOfWeek, tim())
    For i = 0 To 5
        't2hhmm tim(nday, i), h, m, pm
        'lblTime(i).Caption = NumToStr(h, 2, BLANK) & ":" & NumToStr(m, 2, ZERO)
        frmDay.lblTime(i).Caption = TimeTo12hr(tim(nday, i), 0)
    Next i
    lblDOW.Caption = weekdayName(dayOfWeek)
    'lblLoc = pname  'no need to change
End Sub

Private Sub Form_Load()
    top = (Screen.Height - Height) / 2
    Left = (Screen.Width - Width) / 2
End Sub


