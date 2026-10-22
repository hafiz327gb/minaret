VERSION 5.00
Begin VB.Form frmIsha 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Determination of `Isha"
   ClientHeight    =   3288
   ClientLeft      =   1212
   ClientTop       =   2928
   ClientWidth     =   6516
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
   MaxButton       =   0   'False
   PaletteMode     =   1  'UseZOrder
   ScaleHeight     =   3288
   ScaleWidth      =   6516
   ShowInTaskbar   =   0   'False
   Begin VB.OptionButton optInterval 
      Caption         =   "Interval from sunset in minutes (usually 90)"
      Height          =   252
      Left            =   600
      TabIndex        =   6
      Top             =   1680
      Width           =   4572
   End
   Begin VB.OptionButton optDepr 
      Caption         =   "Sun's depression in degrees (usually 15 or 18)"
      Height          =   252
      Left            =   600
      TabIndex        =   5
      Top             =   1200
      Value           =   -1  'True
      Width           =   4572
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "Cancel"
      Height          =   492
      Left            =   3720
      TabIndex        =   4
      Top             =   2400
      Width           =   972
   End
   Begin VB.CommandButton cmdOK 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   492
      Left            =   1560
      TabIndex        =   3
      Top             =   2400
      Width           =   972
   End
   Begin VB.TextBox txtInterval 
      Height          =   288
      Left            =   5280
      TabIndex        =   2
      Top             =   1680
      Width           =   612
   End
   Begin VB.TextBox txtDepr 
      Height          =   288
      Left            =   5280
      TabIndex        =   1
      Text            =   "15"
      Top             =   1200
      Width           =   612
   End
   Begin VB.Label Label1 
      Caption         =   "Select a method and edit the corresponding value"
      Height          =   252
      Left            =   1080
      TabIndex        =   0
      Top             =   360
      Width           =   4812
   End
End
Attribute VB_Name = "frmIsha"
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
    If optDepr.Value Then
        i = RangeCheck(txtDepr, 6, 24)
        If i <= 0 Then
            Exit Sub
        End If
        ishaByDepr = 1
        ishaDepr = i
        'SetFiqhArg ISHA_BY_DEPR, 1
        'SetFiqhArg ISHA_DEPR, i
    Else
        i = RangeCheck(txtInterval, 20, 120)
        If i <= 0 Then
            Exit Sub
        End If
        ishaByDepr = 0
        ishaInterval = i
        'SetFiqhArg ISHA_BY_DEPR, 0
        'SetFiqhArg ISHA_INTERVAL, i
    End If
    Hide
End Sub

Private Sub Form_Load()
    top = (Screen.Height - Height) / 2
    Left = (Screen.Width - Width) / 2
End Sub


