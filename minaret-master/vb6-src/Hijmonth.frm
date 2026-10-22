VERSION 5.00
Begin VB.Form frmHijMonth 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Month"
   ClientHeight    =   3276
   ClientLeft      =   1956
   ClientTop       =   2952
   ClientWidth     =   4920
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
   LinkTopic       =   "Form1"
   PaletteMode     =   1  'UseZOrder
   ScaleHeight     =   3276
   ScaleWidth      =   4920
   ShowInTaskbar   =   0   'False
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "Cancel"
      Height          =   492
      Left            =   2880
      TabIndex        =   14
      Top             =   2400
      Width           =   1092
   End
   Begin VB.CommandButton cmdOK 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   492
      Left            =   840
      TabIndex        =   13
      Top             =   2400
      Width           =   1092
   End
   Begin VB.TextBox txtYear 
      Height          =   288
      Left            =   3720
      TabIndex        =   12
      Top             =   1320
      Width           =   732
   End
   Begin VB.OptionButton optMonth 
      Caption         =   "Zhj"
      Height          =   252
      Index           =   11
      Left            =   2400
      TabIndex        =   11
      Top             =   1800
      Width           =   852
   End
   Begin VB.OptionButton optMonth 
      Caption         =   "Zqd"
      Height          =   252
      Index           =   10
      Left            =   2400
      TabIndex        =   10
      Top             =   1320
      Width           =   852
   End
   Begin VB.OptionButton optMonth 
      Caption         =   "Shw"
      Height          =   252
      Index           =   9
      Left            =   2400
      TabIndex        =   9
      Top             =   840
      Width           =   852
   End
   Begin VB.OptionButton optMonth 
      Caption         =   "Rmd"
      Height          =   252
      Index           =   8
      Left            =   2400
      TabIndex        =   8
      Top             =   360
      Width           =   972
   End
   Begin VB.OptionButton optMonth 
      Caption         =   "Shb"
      Height          =   252
      Index           =   7
      Left            =   1440
      TabIndex        =   7
      Top             =   1800
      Width           =   852
   End
   Begin VB.OptionButton optMonth 
      Caption         =   "Rjb"
      Height          =   252
      Index           =   6
      Left            =   1440
      TabIndex        =   6
      Top             =   1320
      Width           =   852
   End
   Begin VB.OptionButton optMonth 
      Caption         =   "Jm 2"
      Height          =   252
      Index           =   5
      Left            =   1440
      TabIndex        =   5
      Top             =   840
      Width           =   852
   End
   Begin VB.OptionButton optMonth 
      Caption         =   "Jm 1"
      Height          =   252
      Index           =   4
      Left            =   1440
      TabIndex        =   4
      Top             =   360
      Width           =   852
   End
   Begin VB.OptionButton optMonth 
      Caption         =   "Rb 2"
      Height          =   252
      Index           =   3
      Left            =   480
      TabIndex        =   3
      Top             =   1800
      Width           =   852
   End
   Begin VB.OptionButton optMonth 
      Caption         =   "Rb 1"
      Height          =   252
      Index           =   2
      Left            =   480
      TabIndex        =   2
      Top             =   1320
      Width           =   852
   End
   Begin VB.OptionButton optMonth 
      Caption         =   "Sfr"
      Height          =   252
      Index           =   1
      Left            =   480
      TabIndex        =   1
      Top             =   840
      Width           =   852
   End
   Begin VB.OptionButton optMonth 
      Caption         =   "Muh"
      Height          =   252
      Index           =   0
      Left            =   480
      TabIndex        =   0
      Top             =   360
      Value           =   -1  'True
      Width           =   852
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
Attribute VB_Name = "frmHijMonth"
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
            AHMonth = i + 1
            Exit For
        End If
    Next i
    i = RangeCheck(txtYear, 1, 4000)
    'If i <= 0 Then
        'Exit Sub
    'End If
    Hide
    AHYear = i
    ' change mousepointer to an hourglass
    Screen.MousePointer = 11
    Call hijriMonthSchedule(AHMonth, AHYear, start, finish, tim())
    ' reset mousepointer
    Screen.MousePointer = 0
End Sub

Private Sub Form_Load()
    top = (Screen.Height - Height) / 2
    Left = (Screen.Width - Width) / 2
End Sub


