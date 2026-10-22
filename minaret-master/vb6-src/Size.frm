VERSION 5.00
Begin VB.Form frmSize 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Gazetteer Size"
   ClientHeight    =   1800
   ClientLeft      =   1776
   ClientTop       =   1608
   ClientWidth     =   4716
   ControlBox      =   0   'False
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
   LinkTopic       =   "Form3"
   MaxButton       =   0   'False
   PaletteMode     =   1  'UseZOrder
   ScaleHeight     =   1800
   ScaleWidth      =   4716
   ShowInTaskbar   =   0   'False
   Begin VB.CommandButton Command1 
      Caption         =   "Close"
      Default         =   -1  'True
      Height          =   372
      Left            =   1680
      TabIndex        =   3
      Top             =   1200
      Width           =   1212
   End
   Begin VB.Label Label1 
      Caption         =   "entries at present.  (At most 900 allowed.)"
      Height          =   252
      Left            =   360
      TabIndex        =   2
      Top             =   720
      Width           =   4092
   End
   Begin VB.Label txtSize 
      Caption         =   "0"
      Height          =   252
      Left            =   3360
      TabIndex        =   1
      Top             =   360
      Width           =   492
   End
   Begin VB.Label frmSize 
      Caption         =   "The gazetteer contains"
      Height          =   252
      Left            =   360
      TabIndex        =   0
      Top             =   360
      Width           =   2892
   End
End
Attribute VB_Name = "frmSize"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub Command1_Click()
    Hide
End Sub

Private Sub Form_Load()
    top = (Screen.Height - Height) / 2
    Left = (Screen.Width - Width) / 2
End Sub


