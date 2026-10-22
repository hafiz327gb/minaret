VERSION 5.00
Begin VB.Form frmGztSave 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Gazetteer Changed!"
   ClientHeight    =   2370
   ClientLeft      =   1950
   ClientTop       =   3075
   ClientWidth     =   4890
   ControlBox      =   0   'False
   BeginProperty Font 
      Name            =   "Arial"
      Size            =   8.25
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
   ScaleHeight     =   2370
   ScaleWidth      =   4890
   ShowInTaskbar   =   0   'False
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "Cancel"
      Height          =   492
      Left            =   3480
      TabIndex        =   3
      Top             =   1560
      Width           =   972
   End
   Begin VB.CommandButton cmdNo 
      Caption         =   "No"
      Height          =   492
      Left            =   1920
      TabIndex        =   2
      Top             =   1560
      Width           =   972
   End
   Begin VB.CommandButton cmdYes 
      Caption         =   "Yes"
      Default         =   -1  'True
      Height          =   492
      Left            =   360
      TabIndex        =   1
      Top             =   1560
      Width           =   972
   End
   Begin VB.Label Label1 
      Caption         =   "You have changed the gazetteer!  Do you want to save the changes?"
      Height          =   612
      Left            =   360
      TabIndex        =   0
      Top             =   360
      Width           =   4092
   End
End
Attribute VB_Name = "frmGztSave"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub cmdCancel_Click()
    Hide
End Sub

Private Sub cmdNo_Click()
    Hide
    End
End Sub

Private Sub cmdYes_Click()
    'rewrite stuff on gazette.dta
    Open gazetteer For Binary As #2
    PutGztData
    Close #2
    Hide
    End
End Sub

Private Sub Form_Load()
    Left = (Screen.Width - Width) / 2
    top = (Screen.Height - Height) / 2
End Sub

