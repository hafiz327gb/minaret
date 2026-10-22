VERSION 5.00
Begin VB.Form frmMonth 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Month"
   ClientHeight    =   3300
   ClientLeft      =   2016
   ClientTop       =   2676
   ClientWidth     =   4896
   ControlBox      =   0   'False
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
   LinkTopic       =   "Form7"
   MaxButton       =   0   'False
   PaletteMode     =   1  'UseZOrder
   ScaleHeight     =   3300
   ScaleWidth      =   4896
   ShowInTaskbar   =   0   'False
   Begin VB.OptionButton optMonth 
      Caption         =   "Jan"
      Height          =   252
      Index           =   0
      Left            =   480
      TabIndex        =   1
      Top             =   360
      Value           =   -1  'True
      Width           =   732
   End
   Begin VB.OptionButton optMonth 
      Caption         =   "Feb"
      Height          =   252
      Index           =   1
      Left            =   480
      TabIndex        =   2
      Top             =   840
      Width           =   732
   End
   Begin VB.OptionButton optMonth 
      Caption         =   "Mar"
      Height          =   252
      Index           =   2
      Left            =   480
      TabIndex        =   3
      Top             =   1320
      Width           =   732
   End
   Begin VB.OptionButton optMonth 
      Caption         =   "Apr"
      Height          =   252
      Index           =   3
      Left            =   480
      TabIndex        =   4
      Top             =   1800
      Width           =   732
   End
   Begin VB.OptionButton optMonth 
      Caption         =   "May"
      Height          =   252
      Index           =   4
      Left            =   1440
      TabIndex        =   5
      Top             =   360
      Width           =   732
   End
   Begin VB.OptionButton optMonth 
      Caption         =   "Jun"
      Height          =   252
      Index           =   5
      Left            =   1440
      TabIndex        =   6
      Top             =   840
      Width           =   732
   End
   Begin VB.OptionButton optMonth 
      Caption         =   "Jul"
      Height          =   252
      Index           =   6
      Left            =   1440
      TabIndex        =   7
      Top             =   1320
      Width           =   732
   End
   Begin VB.OptionButton optMonth 
      Caption         =   "Aug"
      Height          =   252
      Index           =   7
      Left            =   1440
      TabIndex        =   8
      Top             =   1800
      Width           =   732
   End
   Begin VB.OptionButton optMonth 
      Caption         =   "Sep"
      Height          =   252
      Index           =   8
      Left            =   2400
      TabIndex        =   9
      Top             =   360
      Width           =   732
   End
   Begin VB.OptionButton optMonth 
      Caption         =   "Oct"
      Height          =   252
      Index           =   9
      Left            =   2400
      TabIndex        =   10
      Top             =   840
      Width           =   732
   End
   Begin VB.OptionButton optMonth 
      Caption         =   "Nov"
      Height          =   252
      Index           =   10
      Left            =   2400
      TabIndex        =   11
      Top             =   1320
      Width           =   732
   End
   Begin VB.OptionButton optMonth 
      Caption         =   "Dec"
      Height          =   252
      Index           =   11
      Left            =   2400
      TabIndex        =   12
      Top             =   1800
      Width           =   732
   End
   Begin VB.TextBox txtYear 
      Height          =   288
      Left            =   3720
      TabIndex        =   13
      Top             =   1320
      Width           =   732
   End
   Begin VB.CommandButton cmdOK 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   492
      Left            =   840
      TabIndex        =   14
      Top             =   2400
      Width           =   1092
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "Cancel"
      Height          =   492
      Left            =   2880
      TabIndex        =   0
      Top             =   2400
      Width           =   1092
   End
   Begin VB.Label Label2 
      Caption         =   "Year"
      Height          =   252
      Left            =   3720
      TabIndex        =   15
      Top             =   960
      Width           =   732
   End
End
Attribute VB_Name = "frmMonth"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub cmdCancel_Click()
    Hide
End Sub

Private Sub cmdOK_Click()
    Dim i As Integer
    Dim start As Integer
    Dim finish As Integer
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
    Hide
    ADYear = i
    ' change mousepointer to an hourglass
    Screen.MousePointer = vbHourglass '11
    If doingQib <> 0 Then
        Call monthChart(ADMonth, ADYear, start, finish, tim())
    Else
        Call monthSchedule(ADMonth, ADYear, start, finish, tim())
    End If
    ' reset mousepointer
    Screen.MousePointer = 0
End Sub

Private Sub Form_Load()
    top = (Screen.Height - Height) / 2
    Left = (Screen.Width - Width) / 2
End Sub


