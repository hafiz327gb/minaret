VERSION 5.00
Begin VB.Form frmNewMoon 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "New Moon Phase"
   ClientHeight    =   5520
   ClientLeft      =   768
   ClientTop       =   2316
   ClientWidth     =   6768
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
   LinkTopic       =   "Form9"
   MaxButton       =   0   'False
   PaletteMode     =   1  'UseZOrder
   ScaleHeight     =   5520
   ScaleWidth      =   6768
   Begin VB.CommandButton cmdClose 
      Caption         =   "Close"
      Default         =   -1  'True
      Height          =   492
      Left            =   4680
      TabIndex        =   18
      Top             =   4200
      Width           =   1332
   End
   Begin VB.CommandButton cmdComp 
      Caption         =   "Recompute"
      Height          =   492
      Left            =   2400
      TabIndex        =   17
      Top             =   4200
      Width           =   1332
   End
   Begin VB.OptionButton optMonth 
      Caption         =   "Muharram"
      Height          =   252
      Index           =   0
      Left            =   360
      TabIndex        =   13
      Top             =   960
      Value           =   -1  'True
      Width           =   1572
   End
   Begin VB.OptionButton optMonth 
      Caption         =   "Safar"
      Height          =   252
      Index           =   1
      Left            =   360
      TabIndex        =   12
      Top             =   1320
      Width           =   1812
   End
   Begin VB.OptionButton optMonth 
      Caption         =   "Rabi I"
      Height          =   252
      Index           =   2
      Left            =   360
      TabIndex        =   11
      Top             =   1680
      Width           =   1692
   End
   Begin VB.OptionButton optMonth 
      Caption         =   "Rabi II"
      Height          =   252
      Index           =   3
      Left            =   360
      TabIndex        =   10
      Top             =   2040
      Width           =   1572
   End
   Begin VB.OptionButton optMonth 
      Caption         =   "Jumada I"
      Height          =   252
      Index           =   4
      Left            =   360
      TabIndex        =   9
      Top             =   2400
      Width           =   1692
   End
   Begin VB.OptionButton optMonth 
      Caption         =   "Jumada II"
      Height          =   252
      Index           =   5
      Left            =   360
      TabIndex        =   8
      Top             =   2760
      Width           =   1812
   End
   Begin VB.OptionButton optMonth 
      Caption         =   "Rajab"
      Height          =   252
      Index           =   6
      Left            =   360
      TabIndex        =   7
      Top             =   3120
      Width           =   972
   End
   Begin VB.OptionButton optMonth 
      Caption         =   "Sha`ban"
      Height          =   252
      Index           =   7
      Left            =   360
      TabIndex        =   6
      Top             =   3480
      Width           =   1932
   End
   Begin VB.OptionButton optMonth 
      Caption         =   "Ramadan"
      Height          =   252
      Index           =   8
      Left            =   360
      TabIndex        =   5
      Top             =   3840
      Width           =   1692
   End
   Begin VB.OptionButton optMonth 
      Caption         =   "Shawwal"
      Height          =   252
      Index           =   9
      Left            =   360
      TabIndex        =   4
      Top             =   4200
      Width           =   1692
   End
   Begin VB.OptionButton optMonth 
      Caption         =   "Zul Qi`da"
      Height          =   252
      Index           =   10
      Left            =   360
      TabIndex        =   3
      Top             =   4560
      Width           =   1692
   End
   Begin VB.OptionButton optMonth 
      Caption         =   "Zul Hijja"
      Height          =   252
      Index           =   11
      Left            =   360
      TabIndex        =   2
      Top             =   4920
      Width           =   1812
   End
   Begin VB.TextBox txtYear 
      Height          =   288
      Left            =   1080
      TabIndex        =   1
      Top             =   360
      Width           =   612
   End
   Begin VB.Label lblLoc 
      Alignment       =   2  'Center
      Caption         =   "Vancouver, British Columbia"
      Height          =   612
      Left            =   2040
      TabIndex        =   19
      Top             =   360
      Width           =   4212
   End
   Begin VB.Label lblZT 
      Caption         =   "December 31, 1994  04:28 AM Zone Time"
      Height          =   372
      Left            =   2400
      TabIndex        =   16
      Top             =   2160
      Width           =   4212
   End
   Begin VB.Label lblGMT 
      Caption         =   "December 31, 1994   08:24 GMT"
      Height          =   372
      Left            =   2400
      TabIndex        =   15
      Top             =   2760
      Width           =   4092
   End
   Begin VB.Label Label2 
      Caption         =   "Time of astronomical new moon phase to start this hijri month:"
      Height          =   492
      Left            =   2280
      TabIndex        =   14
      Top             =   1320
      Width           =   3612
   End
   Begin VB.Label Label1 
      Caption         =   "Year"
      Height          =   252
      Left            =   360
      TabIndex        =   0
      Top             =   360
      Width           =   612
   End
End
Attribute VB_Name = "frmNewMoon"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub cmdClose_Click()
    Hide
End Sub

Private Sub cmdComp_Click()
    'Dim greenwich As Integer
    Dim i As Integer
    Dim s As String * 2
    For i = 0 To 11
        If optMonth(i).Value Then
            AHMonth = i + 1
            Exit For
        End If
    Next i
    i = RangeCheck(txtYear, 1, 4000)
    If i <= 0 Then
        Exit Sub
    End If
    AHYear = i
    ' greenwich time (3rd arg=1)
    Call StartNewMoon(AHYear, AHMonth, 1, ADYear, ADMonth, ADday, ADhour, ADminute)
    lblGMT.Caption = monthName(ADMonth) & " " & ADday & ", " & ADYear & ", " & NumToStr(ADhour, 2, ZERO) & ":" & NumToStr(ADminute, 2, ZERO) & " GMT"
    ' local time (3rd arg=0)
    Call StartNewMoon(AHYear, AHMonth, 0, ADYear, ADMonth, ADday, ADhour, ADminute)
    If ADhour >= 12 Then
        s = " P"
    Else
        s = " A"
    End If
    If ADhour > 12 Then
        ADhour = ADhour - 12
    End If
    lblZT.Caption = monthName(ADMonth) & " " & NumToStr(ADday, 2, BLANK) & ", " & NumToStr(ADYear, 4, BLANK) & ", " & NumToStr(ADhour, 2, ZERO) & ":" & NumToStr(ADminute, 2, ZERO) & s & "M Zone Time"
End Sub

Private Sub Form_Load()
    top = (Screen.Height - Height) / 2
    Left = (Screen.Width - Width) / 2
End Sub


