VERSION 5.00
Begin VB.Form frmAsr 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Determination of `Asr"
   ClientHeight    =   3060
   ClientLeft      =   2028
   ClientTop       =   2976
   ClientWidth     =   4308
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
   ForeColor       =   &H00800008&
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   PaletteMode     =   1  'UseZOrder
   ScaleHeight     =   3060
   ScaleWidth      =   4308
   ShowInTaskbar   =   0   'False
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "Cancel"
      Height          =   492
      Left            =   2400
      TabIndex        =   4
      Top             =   2280
      Width           =   972
   End
   Begin VB.CommandButton cmdOK 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   492
      Left            =   840
      TabIndex        =   3
      Top             =   2280
      Width           =   972
   End
   Begin VB.OptionButton opt 
      Caption         =   "Hanafi (shadow ration 2)"
      Height          =   252
      Index           =   1
      Left            =   600
      TabIndex        =   2
      Top             =   1440
      Width           =   3012
   End
   Begin VB.OptionButton opt 
      Caption         =   "Shafii and others (shadow ratio 1)"
      Height          =   372
      Index           =   0
      Left            =   600
      TabIndex        =   1
      Top             =   1080
      Value           =   -1  'True
      Width           =   3372
   End
   Begin VB.Label Label1 
      BackStyle       =   0  'Transparent
      Caption         =   "Fiqh to be used for 'asr (afternoon)"
      Height          =   252
      Left            =   600
      TabIndex        =   0
      Top             =   360
      Width           =   3492
   End
End
Attribute VB_Name = "frmAsr"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub cmdCancel_Click()
    Hide
End Sub

Private Sub cmdOK_Click()
    If opt(0).Value Then
        asrHanafi = 0
    Else
        asrHanafi = 1
    End If
    'SetFiqhArg ASR_HANAFI, asrHanafi
    Hide
End Sub

Private Sub Form_Load()
    top = (Screen.Height - Height) / 2
    Left = (Screen.Width - Width) / 2
End Sub


