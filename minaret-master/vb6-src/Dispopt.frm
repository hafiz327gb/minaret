VERSION 5.00
Begin VB.Form frmDispOpt 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Additional Info on Non-perpetual Schedules"
   ClientHeight    =   3132
   ClientLeft      =   1248
   ClientTop       =   3036
   ClientWidth     =   6348
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
   ScaleHeight     =   3132
   ScaleWidth      =   6348
   ShowInTaskbar   =   0   'False
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "Cancel"
      Height          =   492
      Left            =   3720
      TabIndex        =   0
      Top             =   2160
      Width           =   972
   End
   Begin VB.CommandButton cmdOK 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   492
      Left            =   1560
      TabIndex        =   3
      Top             =   2160
      Width           =   972
   End
   Begin VB.CheckBox chkQiblaTime 
      Height          =   252
      Left            =   480
      TabIndex        =   2
      Top             =   1200
      Width           =   252
   End
   Begin VB.CheckBox chkHijriDate 
      Caption         =   "  "
      Height          =   252
      Left            =   480
      TabIndex        =   1
      Top             =   600
      Width           =   252
   End
   Begin VB.Label Label2 
      Caption         =   "Include Hijri dates.  (Remember these are only APPROXIMATE dates!)"
      Height          =   612
      Left            =   840
      TabIndex        =   5
      Top             =   480
      Width           =   5412
   End
   Begin VB.Label Label1 
      Caption         =   "Show for each day the time when the shadow points in the qibla direction or opposite to it"
      Height          =   852
      Left            =   840
      TabIndex        =   4
      Top             =   1200
      Width           =   5052
   End
End
Attribute VB_Name = "frmDispOpt"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub cmdCancel_Click()
    Hide
End Sub

Private Sub cmdOK_Click()
    addHijriDate = chkHijriDate.Value
    addQiblaTime = chkQiblaTime.Value
    Hide
End Sub

Private Sub Form_Load()
    top = (Screen.Height - Height) / 2
    Left = (Screen.Width - Width) / 2
End Sub


