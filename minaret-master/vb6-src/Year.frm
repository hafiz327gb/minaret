VERSION 5.00
Begin VB.Form frmYear 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Year"
   ClientHeight    =   2040
   ClientLeft      =   2556
   ClientTop       =   3432
   ClientWidth     =   3072
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
   LinkTopic       =   "Form6"
   MaxButton       =   0   'False
   PaletteMode     =   1  'UseZOrder
   ScaleHeight     =   2040
   ScaleWidth      =   3072
   ShowInTaskbar   =   0   'False
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "Cancel"
      Height          =   492
      Left            =   1680
      TabIndex        =   3
      Top             =   1200
      Width           =   972
   End
   Begin VB.CommandButton cmdOK 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   492
      Left            =   360
      TabIndex        =   2
      Top             =   1200
      Width           =   972
   End
   Begin VB.TextBox txtYear 
      Height          =   372
      Left            =   1680
      TabIndex        =   1
      Top             =   360
      Width           =   852
   End
   Begin VB.Label Label1 
      Caption         =   "Year (0 for perpetual)"
      Height          =   492
      Left            =   360
      TabIndex        =   0
      Top             =   360
      Width           =   1092
   End
End
Attribute VB_Name = "frmYear"
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
    Dim start As Integer, finish As Integer
    If Val(txtYear.Text) = 0 Then
        i = 0
    Else
        i = RangeCheck(txtYear, 1901, 2200)
    End If
    If i < 0 Then
        Exit Sub
    End If
    Hide
    ADYear = i
    ' change mousepointer to an hourglass
    Screen.MousePointer = 11
    If doingQib <> 0 Then
        yearChart ADYear, start, finish, tim()
    Else
        yearSchedule ADYear, start, finish, tim()
    End If
    ' reset mousepointer
    Screen.MousePointer = 0
End Sub

Private Sub Form_Load()
    top = (Screen.Height - Height) / 2
    Left = (Screen.Width - Width) / 2
End Sub


