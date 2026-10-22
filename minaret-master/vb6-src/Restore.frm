VERSION 5.00
Begin VB.Form frmRestore 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Restore Factory-set Gazetteer"
   ClientHeight    =   2076
   ClientLeft      =   1968
   ClientTop       =   3300
   ClientWidth     =   4272
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
   LinkTopic       =   "Form2"
   MaxButton       =   0   'False
   PaletteMode     =   1  'UseZOrder
   ScaleHeight     =   2076
   ScaleWidth      =   4272
   ShowInTaskbar   =   0   'False
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "Cancel"
      Default         =   -1  'True
      Height          =   492
      Left            =   2520
      TabIndex        =   2
      Top             =   1080
      Width           =   1212
   End
   Begin VB.CommandButton cmdOK 
      Caption         =   "OK"
      Height          =   492
      Left            =   600
      TabIndex        =   1
      Top             =   1080
      Width           =   1212
   End
   Begin VB.Label Label1 
      Caption         =   "Really throw away all changes ever made to the Gazetteer?"
      Height          =   492
      Left            =   360
      TabIndex        =   0
      Top             =   360
      Width           =   3492
   End
End
Attribute VB_Name = "frmRestore"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub cmdCancel_Click()
    Hide
End Sub

Private Sub cmdOK_Click()
    Dim Filename As String

    Open ".\minaret.ini" For Binary As #1
    Call GetGztData
    Close #1
    Call InitGazette
    Call SetCurLocInfo
    Hide
    nLocHoles = 0
    gztDirty = 0
    'rewrite stuff on gazette.dta
    Open gazetteer For Binary As #2
    Call PutGztData
    Close #2
End Sub

Private Sub Form_Load()
    top = (Screen.Height - Height) / 2
    Left = (Screen.Width - Width) / 2
End Sub


